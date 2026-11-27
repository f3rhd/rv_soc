#include "../libc-baremetal/include/led.h"
#include "../libc-baremetal/include/serial.h"
#include "../libc-baremetal/include/graphics.h"

// Text editor: keystrokes come in over UART from the laptop terminal,
// the document is drawn on the 128x160 SPI display with a built-in 5x7
// bitmap font (graphics.h only has shapes, no text, so we draw glyphs
// ourselves out of rectangles).

#define SCREEN_WIDTH  128
#define SCREEN_HEIGHT 160

// each character cell is 6x8: a 5x7 glyph plus 1px of spacing
#define CELL_W 6
#define CELL_H 8

#define VIEW_W    (SCREEN_WIDTH / CELL_W)       // 21 columns
#define TEXT_ROWS (SCREEN_HEIGHT / CELL_H - 1)  // 19 text rows, last row is the status bar

#define BUF_SIZE  4096
#define TAB_WIDTH 4

#define COLOR_FG ST7735_WHITE
#define COLOR_BG ST7735_BLACK

// escape-sequence parser states (arrow keys etc. arrive as ESC [ A ...)
#define ESC_NONE    0
#define ESC_GOT_ESC 1
#define ESC_CSI     2
#define ESC_SS3     3

#define INVERSE 0x80 // bit 7 of a cell value = draw inverted (cursor, status bar)

// ---- classic 5x7 font, ASCII 32..126. each glyph is 5 column bytes,
// bit 0 = top pixel row, bit 6 = bottom. read-only, lives in .rodata ----
static const unsigned char FONT_5X7[95][5] = {
    {0x00,0x00,0x00,0x00,0x00}, // ' '
    {0x00,0x00,0x5F,0x00,0x00}, // !
    {0x00,0x07,0x00,0x07,0x00}, // "
    {0x14,0x7F,0x14,0x7F,0x14}, // #
    {0x24,0x2A,0x7F,0x2A,0x12}, // $
    {0x23,0x13,0x08,0x64,0x62}, // %
    {0x36,0x49,0x55,0x22,0x50}, // &
    {0x00,0x05,0x03,0x00,0x00}, // '
    {0x00,0x1C,0x22,0x41,0x00}, // (
    {0x00,0x41,0x22,0x1C,0x00}, // )
    {0x14,0x08,0x3E,0x08,0x14}, // *
    {0x08,0x08,0x3E,0x08,0x08}, // +
    {0x00,0x50,0x30,0x00,0x00}, // ,
    {0x08,0x08,0x08,0x08,0x08}, // -
    {0x00,0x60,0x60,0x00,0x00}, // .
    {0x20,0x10,0x08,0x04,0x02}, // /
    {0x3E,0x51,0x49,0x45,0x3E}, // 0
    {0x00,0x42,0x7F,0x40,0x00}, // 1
    {0x42,0x61,0x51,0x49,0x46}, // 2
    {0x21,0x41,0x45,0x4B,0x31}, // 3
    {0x18,0x14,0x12,0x7F,0x10}, // 4
    {0x27,0x45,0x45,0x45,0x39}, // 5
    {0x3C,0x4A,0x49,0x49,0x30}, // 6
    {0x01,0x71,0x09,0x05,0x03}, // 7
    {0x36,0x49,0x49,0x49,0x36}, // 8
    {0x06,0x49,0x49,0x29,0x1E}, // 9
    {0x00,0x36,0x36,0x00,0x00}, // :
    {0x00,0x56,0x36,0x00,0x00}, // ;
    {0x08,0x14,0x22,0x41,0x00}, // <
    {0x14,0x14,0x14,0x14,0x14}, // =
    {0x00,0x41,0x22,0x14,0x08}, // >
    {0x02,0x01,0x51,0x09,0x06}, // ?
    {0x32,0x49,0x79,0x41,0x3E}, // @
    {0x7E,0x11,0x11,0x11,0x7E}, // A
    {0x7F,0x49,0x49,0x49,0x36}, // B
    {0x3E,0x41,0x41,0x41,0x22}, // C
    {0x7F,0x41,0x41,0x22,0x1C}, // D
    {0x7F,0x49,0x49,0x49,0x41}, // E
    {0x7F,0x09,0x09,0x09,0x01}, // F
    {0x3E,0x41,0x49,0x49,0x7A}, // G
    {0x7F,0x08,0x08,0x08,0x7F}, // H
    {0x00,0x41,0x7F,0x41,0x00}, // I
    {0x20,0x40,0x41,0x3F,0x01}, // J
    {0x7F,0x08,0x14,0x22,0x41}, // K
    {0x7F,0x40,0x40,0x40,0x40}, // L
    {0x7F,0x02,0x0C,0x02,0x7F}, // M
    {0x7F,0x04,0x08,0x10,0x7F}, // N
    {0x3E,0x41,0x41,0x41,0x3E}, // O
    {0x7F,0x09,0x09,0x09,0x06}, // P
    {0x3E,0x41,0x51,0x21,0x5E}, // Q
    {0x7F,0x09,0x19,0x29,0x46}, // R
    {0x46,0x49,0x49,0x49,0x31}, // S
    {0x01,0x01,0x7F,0x01,0x01}, // T
    {0x3F,0x40,0x40,0x40,0x3F}, // U
    {0x1F,0x20,0x40,0x20,0x1F}, // V
    {0x3F,0x40,0x38,0x40,0x3F}, // W
    {0x63,0x14,0x08,0x14,0x63}, // X
    {0x07,0x08,0x70,0x08,0x07}, // Y
    {0x61,0x51,0x49,0x45,0x43}, // Z
    {0x00,0x7F,0x41,0x41,0x00}, // [
    {0x02,0x04,0x08,0x10,0x20}, // backslash
    {0x00,0x41,0x41,0x7F,0x00}, // ]
    {0x04,0x02,0x01,0x02,0x04}, // ^
    {0x40,0x40,0x40,0x40,0x40}, // _
    {0x00,0x01,0x02,0x04,0x00}, // `
    {0x20,0x54,0x54,0x54,0x78}, // a
    {0x7F,0x48,0x44,0x44,0x38}, // b
    {0x38,0x44,0x44,0x44,0x20}, // c
    {0x38,0x44,0x44,0x48,0x7F}, // d
    {0x38,0x54,0x54,0x54,0x18}, // e
    {0x08,0x7E,0x09,0x01,0x02}, // f
    {0x0C,0x52,0x52,0x52,0x3E}, // g
    {0x7F,0x08,0x04,0x04,0x78}, // h
    {0x00,0x44,0x7D,0x40,0x00}, // i
    {0x20,0x40,0x44,0x3D,0x00}, // j
    {0x7F,0x10,0x28,0x44,0x00}, // k
    {0x00,0x41,0x7F,0x40,0x00}, // l
    {0x7C,0x04,0x18,0x04,0x78}, // m
    {0x7C,0x08,0x04,0x04,0x78}, // n
    {0x38,0x44,0x44,0x44,0x38}, // o
    {0x7C,0x14,0x14,0x14,0x08}, // p
    {0x08,0x14,0x14,0x18,0x7C}, // q
    {0x7C,0x08,0x04,0x04,0x08}, // r
    {0x48,0x54,0x54,0x54,0x20}, // s
    {0x04,0x3F,0x44,0x40,0x20}, // t
    {0x3C,0x40,0x40,0x20,0x7C}, // u
    {0x1C,0x20,0x40,0x20,0x1C}, // v
    {0x3C,0x40,0x30,0x40,0x3C}, // w
    {0x44,0x28,0x10,0x28,0x44}, // x
    {0x0C,0x50,0x50,0x50,0x3C}, // y
    {0x44,0x64,0x54,0x4C,0x44}, // z
    {0x00,0x08,0x36,0x41,0x00}, // {
    {0x00,0x00,0x7F,0x00,0x00}, // |
    {0x00,0x41,0x36,0x08,0x00}, // }
    {0x10,0x08,0x08,0x10,0x08}, // ~
};

// Everything lives in one struct that main() puts on the stack, so the
// 4KB document buffer doesn't eat into the 4KB STATIC_RESERVE in build.sh.
typedef struct {
    char buf[BUF_SIZE];
    int  len;
    int  cursor;                              // index into buf, 0..len
    int  top_row;                             // first visible *screen row* (after wrapping)
    int  goal_col;                            // remembered column for up/down, -1 = unset
    int  esc_state;
    int  esc_param;
    int  prev_cr;
    unsigned char shadow[TEXT_ROWS + 1][VIEW_W]; // what the LCD currently shows
} Editor;

// ---- drawing ----

// draws one character cell. v = ASCII in the low 7 bits, INVERSE flag in bit 7
void draw_cell(int col, int row, unsigned char v) {
    char ch = (char)(v & 0x7F);
    int inv = v & INVERSE;
    unsigned fg = inv ? COLOR_BG : COLOR_FG;
    unsigned bg = inv ? COLOR_FG : COLOR_BG;

    int px = col * CELL_W;
    int py = row * CELL_H;

    rv_soc_draw_rectangle(bg, px, py, CELL_W, CELL_H);

    if (ch <= ' ' || ch > '~')
        return;

    const unsigned char *g = FONT_5X7[ch - 32];
    int x, y;
    for (x = 0; x < 5; x++) {
        unsigned char bits = g[x];
        y = 0;
        // merge consecutive lit pixels in a column into one rectangle -
        // far fewer draw calls than plotting pixel by pixel
        while (y < 7) {
            if (bits & (1 << y)) {
                int start = y;
                while (y < 7 && (bits & (1 << y)))
                    y++;
                rv_soc_draw_rectangle(fg, px + x, py + 1 + start, 1, y - start);
            } else {
                y++;
            }
        }
    }
}

// ---- buffer primitives ----

int line_start(Editor *ed, int pos) {
    while (pos > 0 && ed->buf[pos - 1] != '\n')
        pos--;
    return pos;
}

int line_end(Editor *ed, int pos) {
    while (pos < ed->len && ed->buf[pos] != '\n')
        pos++;
    return pos;
}

void insert_char(Editor *ed, char c) {
    if (ed->len >= BUF_SIZE)
        return;
    int i;
    for (i = ed->len; i > ed->cursor; i--)
        ed->buf[i] = ed->buf[i - 1];
    ed->buf[ed->cursor++] = c;
    ed->len++;
}

void delete_at(Editor *ed, int pos) {
    if (pos < 0 || pos >= ed->len)
        return;
    int i;
    for (i = pos; i < ed->len - 1; i++)
        ed->buf[i] = ed->buf[i + 1];
    ed->len--;
}

// ---- cursor movement ----
// Lines longer than VIEW_W wrap onto extra screen rows. A line of length n
// occupies n / VIEW_W + 1 rows (the +1 guarantees a spot for the cursor
// even when the line exactly fills a row, and for empty lines).

// highest column the cursor can sit on within wrapped row `row` of a line
int row_max_col(int line_len, int row) {
    if (row == line_len / VIEW_W)
        return line_len - row * VIEW_W;
    return VIEW_W - 1;
}

int imin(int a, int b) { return a < b ? a : b; }

void move_left(Editor *ed)  { if (ed->cursor > 0)       ed->cursor--; }
void move_right(Editor *ed) { if (ed->cursor < ed->len) ed->cursor++; }
void move_home(Editor *ed)  { ed->cursor = line_start(ed, ed->cursor); }
void move_end(Editor *ed)   { ed->cursor = line_end(ed, ed->cursor); }

// up/down move by *screen row* and remember the starting column
void move_up(Editor *ed) {
    int ls  = line_start(ed, ed->cursor);
    int col = ed->cursor - ls;
    int vrow = col / VIEW_W;
    if (ed->goal_col < 0)
        ed->goal_col = col % VIEW_W;

    if (vrow > 0) {                      // previous wrapped row of the same line
        ed->cursor = ls + (vrow - 1) * VIEW_W + ed->goal_col;
        return;
    }
    if (ls == 0)
        return;                          // already at the very top

    int prev_end   = ls - 1;
    int prev_start = line_start(ed, prev_end);
    int plen = prev_end - prev_start;
    int prow = plen / VIEW_W;            // land on the last wrapped row
    ed->cursor = prev_start + prow * VIEW_W + imin(ed->goal_col, row_max_col(plen, prow));
}

void move_down(Editor *ed) {
    int ls  = line_start(ed, ed->cursor);
    int le  = line_end(ed, ed->cursor);
    int llen = le - ls;
    int col = ed->cursor - ls;
    int vrow = col / VIEW_W;
    if (ed->goal_col < 0)
        ed->goal_col = col % VIEW_W;

    if (vrow < llen / VIEW_W) {          // next wrapped row of the same line
        int nr = vrow + 1;
        ed->cursor = ls + nr * VIEW_W + imin(ed->goal_col, row_max_col(llen, nr));
        return;
    }
    if (le >= ed->len)
        return;                          // already at the very bottom

    int next_start = le + 1;
    int nlen = line_end(ed, next_start) - next_start;
    ed->cursor = next_start + imin(ed->goal_col, row_max_col(nlen, 0));
}

// ---- editing commands ----

void do_backspace(Editor *ed) {
    if (ed->cursor > 0) {
        delete_at(ed, ed->cursor - 1);
        ed->cursor--;
    }
}

void do_delete(Editor *ed) {
    delete_at(ed, ed->cursor);
}

// Ctrl-K: delete to end of line; at the end of a line, joins with the next one
void do_kill_line(Editor *ed) {
    if (ed->cursor >= ed->len)
        return;
    if (ed->buf[ed->cursor] == '\n') {
        delete_at(ed, ed->cursor);
        return;
    }
    int le = line_end(ed, ed->cursor);
    while (ed->cursor < le) {
        delete_at(ed, ed->cursor);
        le--;
    }
}

// ---- UART input parsing ----

// returns 1 if the key was a vertical move (so goal_col must be kept)
int dispatch_key(Editor *ed, char final, int param) {
    int i;
    switch (final) {
        case 'A': move_up(ed);    return 1;
        case 'B': move_down(ed);  return 1;
        case 'C': move_right(ed); return 0;
        case 'D': move_left(ed);  return 0;
        case 'H': move_home(ed);  return 0;
        case 'F': move_end(ed);   return 0;
        case '~':
            if (param == 1 || param == 7) { move_home(ed); return 0; }
            if (param == 4 || param == 8) { move_end(ed);  return 0; }
            if (param == 3)               { do_delete(ed); return 0; }
            if (param == 5) { for (i = 0; i < TEXT_ROWS; i++) move_up(ed);   return 1; }
            if (param == 6) { for (i = 0; i < TEXT_ROWS; i++) move_down(ed); return 1; }
            return 0;
        default:
            return 0;
    }
}

// feeds one received byte through the key parser; returns 1 if a redraw is needed
int feed_byte(Editor *ed, unsigned char c, int *force_clear) {
    int vertical = 0;

    if (ed->esc_state == ESC_GOT_ESC) {
        if (c == '[') { ed->esc_state = ESC_CSI; ed->esc_param = 0; return 0; }
        if (c == 'O') { ed->esc_state = ESC_SS3; ed->esc_param = 0; return 0; }
        ed->esc_state = ESC_NONE; // bare ESC then something else: treat as a normal key
    } else if (ed->esc_state == ESC_CSI) {
        if (c >= '0' && c <= '9') {
            ed->esc_param = ed->esc_param * 10 + (c - '0');
            return 0;
        }
        if (c == ';')
            return 0;
        if (c >= 0x40 && c <= 0x7E) {
            vertical = dispatch_key(ed, (char)c, ed->esc_param);
            ed->esc_state = ESC_NONE;
            if (!vertical) ed->goal_col = -1;
            return 1;
        }
        ed->esc_state = ESC_NONE;
        return 0;
    } else if (ed->esc_state == ESC_SS3) {
        vertical = dispatch_key(ed, (char)c, 0);
        ed->esc_state = ESC_NONE;
        if (!vertical) ed->goal_col = -1;
        return 1;
    }

    int was_cr = ed->prev_cr;
    ed->prev_cr = 0;

    if (c == 0x1B) {
        ed->esc_state = ESC_GOT_ESC;
        return 0;
    }

    if (c == '\r') {
        insert_char(ed, '\n');
        ed->prev_cr = 1;
    } else if (c == '\n') {
        if (was_cr)
            return 0;               // second half of CR+LF
        insert_char(ed, '\n');
    } else if (c == 0x7F || c == 0x08) {
        do_backspace(ed);
    } else if (c == '\t') {
        int i;
        for (i = 0; i < TAB_WIDTH; i++)
            insert_char(ed, ' ');
    } else if (c == 0x0B) {         // Ctrl-K
        do_kill_line(ed);
    } else if (c == 0x01) {         // Ctrl-A
        move_home(ed);
    } else if (c == 0x05) {         // Ctrl-E
        move_end(ed);
    } else if (c == 0x0C) {         // Ctrl-L: wipe and repaint the whole LCD
        *force_clear = 1;
    } else if (c >= 32 && c <= 126) {
        insert_char(ed, (char)c);
    } else {
        return 0;
    }

    ed->goal_col = -1;
    return 1;
}

// ---- rendering ----

int put_str(unsigned char *dst, int pos, const char *s) {
    while (*s && pos < VIEW_W)
        dst[pos++] = (unsigned char)*s++;
    return pos;
}

int put_uint(unsigned char *dst, int pos, unsigned v) {
    char tmp[11];
    int n = 0;
    if (v == 0)
        tmp[n++] = '0';
    while (v > 0) {
        tmp[n++] = (char)('0' + (v % 10));
        v /= 10;
    }
    while (n > 0 && pos < VIEW_W)
        dst[pos++] = (unsigned char)tmp[--n];
    return pos;
}

void render(Editor *ed, int force_clear) {
    int r, c, i;

    if (force_clear) {
        rv_soc_draw_rectangle(COLOR_BG, 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        for (r = 0; r <= TEXT_ROWS; r++)
            for (c = 0; c < VIEW_W; c++)
                ed->shadow[r][c] = ' ';
    }

    // 1) find the cursor's position in wrapped screen rows
    int cur_vrow = 0;
    int cur_vcol = 0;
    int cur_line = 0;
    int cur_col  = 0;
    {
        int p = 0;
        for (;;) {
            int e = line_end(ed, p);
            if (ed->cursor <= e) {
                cur_col  = ed->cursor - p;
                cur_vrow += cur_col / VIEW_W;
                cur_vcol  = cur_col % VIEW_W;
                break;
            }
            cur_vrow += (e - p) / VIEW_W + 1;
            cur_line++;
            p = e + 1;
        }
    }

    // 2) scroll just enough to keep the cursor row on screen
    if (cur_vrow < ed->top_row)
        ed->top_row = cur_vrow;
    if (cur_vrow >= ed->top_row + TEXT_ROWS)
        ed->top_row = cur_vrow - TEXT_ROWS + 1;

    // 3) build the frame we *want* to show
    unsigned char frame[TEXT_ROWS + 1][VIEW_W];
    for (r = 0; r <= TEXT_ROWS; r++)
        for (c = 0; c < VIEW_W; c++)
            frame[r][c] = ' ';

    {
        int p = 0;
        int vr = 0; // screen row where the current logical line starts
        for (;;) {
            int e = line_end(ed, p);
            int rows = (e - p) / VIEW_W + 1;
            int k;
            for (k = 0; k < rows; k++) {
                int row = vr + k - ed->top_row;
                if (row < 0)
                    continue;
                if (row >= TEXT_ROWS)
                    break;
                int seg_start = p + k * VIEW_W;
                int seg_end = imin(e, seg_start + VIEW_W);
                for (i = seg_start; i < seg_end; i++)
                    frame[row][i - seg_start] = (unsigned char)ed->buf[i];
            }
            vr += rows;
            if (e >= ed->len || vr >= ed->top_row + TEXT_ROWS)
                break;
            p = e + 1;
        }
    }

    // cursor = inverted cell (works on blanks too, so it's always visible)
    frame[cur_vrow - ed->top_row][cur_vcol] |= INVERSE;

    // status bar, drawn inverted across the full bottom row
    {
        int pos = 0;
        pos = put_str(frame[TEXT_ROWS], pos, "L");
        pos = put_uint(frame[TEXT_ROWS], pos, (unsigned)(cur_line + 1));
        pos = put_str(frame[TEXT_ROWS], pos, " C");
        pos = put_uint(frame[TEXT_ROWS], pos, (unsigned)(cur_col + 1));
        pos = put_str(frame[TEXT_ROWS], pos, " ");
        pos = put_uint(frame[TEXT_ROWS], pos, (unsigned)ed->len);
        pos = put_str(frame[TEXT_ROWS], pos, "/");
        pos = put_uint(frame[TEXT_ROWS], pos, (unsigned)BUF_SIZE);
        for (c = 0; c < VIEW_W; c++)
            frame[TEXT_ROWS][c] |= INVERSE;
    }

    // 4) redraw only the cells that actually changed
    for (r = 0; r <= TEXT_ROWS; r++) {
        for (c = 0; c < VIEW_W; c++) {
            if (frame[r][c] != ed->shadow[r][c]) {
                draw_cell(c, r, frame[r][c]);
                ed->shadow[r][c] = frame[r][c];
            }
        }
    }

    // telemetry: seg display = document size, led = current line number
    seg_write_hex((unsigned)ed->len);
    led_write((unsigned)(cur_line + 1));
}

void editor_init(Editor *ed) {
    int r, c;
    ed->len = 0;
    ed->cursor = 0;
    ed->top_row = 0;
    ed->goal_col = -1;
    ed->esc_state = ESC_NONE;
    ed->esc_param = 0;
    ed->prev_cr = 0;
    for (r = 0; r <= TEXT_ROWS; r++)
        for (c = 0; c < VIEW_W; c++)
            ed->shadow[r][c] = ' ';
}

int main() {
    Editor ed; // ~4.4KB on the stack, on purpose (see the struct comment)
    editor_init(&ed);

    rv_soc_draw_rectangle(COLOR_BG, 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    render(&ed, 0);

    for (;;) {
        int dirty = 0;
        int force_clear = 0;

        // drain everything waiting before redrawing, so a pasted block
        // costs one repaint instead of one per character
        for (;;) {
            SERIAL_READ r = rv_soc_serial_read();
            if (!SERIAL_READ_VALID(r))
                break;

            // NOTE: & 0xFF on purpose - SERIAL_RESULT_BYTE in uart.h masks
            // with 0x0F, which would mangle ASCII ('a' 0x61 -> 0x01)
            unsigned char c = (unsigned char)(r & 0xFF);
            if (feed_byte(&ed, c, &force_clear))
                dirty = 1;
        }

        if (dirty || force_clear)
            render(&ed, force_clear);
    }
}