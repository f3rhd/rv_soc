#include "../libc-baremetal/include/serial.h"
#include "../libc-baremetal/include/led.h"
#include "../libc-baremetal/include/system.h"

#define SYSTEM_HZ 100'000'000UL

#define GRID_W 24
#define GRID_H 12
#define MAX_LEN (GRID_W * GRID_H)

#define TICK_MS 150   // game speed: lower = faster

// 1 = hitting a wall kills you, 0 = wrap around to the opposite side
#define WALLS_KILL 0

// screen layout (1-based terminal coords): border occupies row 1 / col 1,
// so grid cell (gx, gy) lives at terminal row gy+2, col gx+2
#define CELL_ROW(gy) ((gy) + 2)
#define CELL_COL(gx) ((gx) + 2)
#define STATUS_ROW   (GRID_H + 3)

#define CH_HEAD  '@'
#define CH_BODY  'o'
#define CH_FOOD  '*'
#define CH_EMPTY ' '
#define CH_WALL  '#'

// ---- static game state ----
static int      g_body_x[MAX_LEN];
static int      g_body_y[MAX_LEN];
static int      g_length;
static int      g_dir_x;
static int      g_dir_y;
static int      g_pending_x;
static int      g_pending_y;
static int      g_food_x;
static int      g_food_y;
static unsigned g_score;
static unsigned g_seed;


void send_str(const char *s) {
    while (*s)
        rv_soc_serial_send(*s++);
}

void send_uint(unsigned v) {
    char buf[11];
    int n = 0;
    if (v == 0) {
        rv_soc_serial_send('0');
        return;
    }
    while (v > 0) {
        buf[n++] = (char)('0' + (v % 10));
        v /= 10;
    }
    while (n > 0)
        rv_soc_serial_send(buf[--n]);
}

void move_cursor(int row, int col) {
    send_str("\x1b[");
    send_uint((unsigned)row);
    rv_soc_serial_send(';');
    send_uint((unsigned)col);
    rv_soc_serial_send('H');
}

void put_cell(int gx, int gy, char c) {
    move_cursor(CELL_ROW(gy), CELL_COL(gx));
    rv_soc_serial_send(c);
}

void draw_status(void) {
    move_cursor(STATUS_ROW, 1);
    send_str("Score: ");
    send_uint(g_score);
    send_str("   Length: ");
    send_uint((unsigned)g_length);
    send_str("   (WASD)   \x1b[K"); 
}

unsigned rand_next(unsigned *state) {
    *state = (*state * 1103515245u + 12345u);
    return (*state >> 16) & 0x7FFF;
}

int on_snake(int x, int y, int len) {
    int i;
    for (i = 0; i < len; i++)
        if (g_body_x[i] == x && g_body_y[i] == y)
            return 1;
    return 0;
}

void place_food(void) {
    for (;;) {
        int fx = rand_next(&g_seed) % GRID_W;
        int fy = rand_next(&g_seed) % GRID_H;
        if (!on_snake(fx, fy, g_length)) {
            g_food_x = fx;
            g_food_y = fy;
            return;
        }
    }
}

// ---- input ----
// drains every byte waiting in the UART and keeps the latest valid WASD.
// compares against g_dir (the direction actually applied last tick), not
// the pending one, so two quick keypresses can't sneak in a 180 reversal
void poll_input(void) {
    for (;;) {
        SERIAL_READ r = rv_soc_serial_read();
        if (!SERIAL_READ_VALID(r))
            break;

        // NOTE: using & 0xFF here, not SERIAL_RESULT_BYTE - that macro in
        // uart.h masks with 0x0F, which would turn 'w' (0x77) into 0x07
        char c = (char)(r & 0xFF);

        if ((c == 'w' || c == 'W') && g_dir_y == 0) { g_pending_x = 0;  g_pending_y = -1; }
        if ((c == 's' || c == 'S') && g_dir_y == 0) { g_pending_x = 0;  g_pending_y = 1;  }
        if ((c == 'a' || c == 'A') && g_dir_x == 0) { g_pending_x = -1; g_pending_y = 0;  }
        if ((c == 'd' || c == 'D') && g_dir_x == 0) { g_pending_x = 1;  g_pending_y = 0;  }
    }
}

// redraw the cells that change, which keeps UART traffic tiny ----
void draw_full(void) {
    int x, y;

    send_str("\x1b[2J");   // clear screen
    send_str("\x1b[?25l"); // hide cursor

    for (x = 0; x < GRID_W + 2; x++) {
        move_cursor(1, 1 + x);
        rv_soc_serial_send(CH_WALL);
        move_cursor(GRID_H + 2, 1 + x);
        rv_soc_serial_send(CH_WALL);
    }
    for (y = 0; y < GRID_H + 2; y++) {
        move_cursor(1 + y, 1);
        rv_soc_serial_send(CH_WALL);
        move_cursor(1 + y, GRID_W + 2);
        rv_soc_serial_send(CH_WALL);
    }

    for (x = 1; x < g_length; x++)
        put_cell(g_body_x[x], g_body_y[x], CH_BODY);
    put_cell(g_body_x[0], g_body_y[0], CH_HEAD);
    put_cell(g_food_x, g_food_y, CH_FOOD);
    draw_status();
}

void new_round(void) {
    int i;
    g_length = 3;
    for (i = 0; i < g_length; i++) {
        g_body_x[i] = GRID_W / 2 - i;
        g_body_y[i] = GRID_H / 2;
    }
    g_dir_x = 1;  g_dir_y = 0;
    g_pending_x = 1;  g_pending_y = 0;
    g_score = 0;
    place_food();
    draw_full();
}

// advances one tick. returns 0 if the snake died, 1 otherwise
int step(void) {
    g_dir_x = g_pending_x;
    g_dir_y = g_pending_y;

    int nx = g_body_x[0] + g_dir_x;
    int ny = g_body_y[0] + g_dir_y;

#if WALLS_KILL
    if (nx < 0 || nx >= GRID_W || ny < 0 || ny >= GRID_H)
        return 0;
#else
    nx = (nx + GRID_W) % GRID_W;
    ny = (ny + GRID_H) % GRID_H;
#endif

    int ate = (nx == g_food_x && ny == g_food_y);

    int check_len = ate ? g_length : g_length - 1;
    if (on_snake(nx, ny, check_len))
        return 0;

    int tail_x = g_body_x[g_length - 1];
    int tail_y = g_body_y[g_length - 1];

    int i;
    for (i = g_length - 1; i > 0; i--) {
        g_body_x[i] = g_body_x[i - 1];
        g_body_y[i] = g_body_y[i - 1];
    }
    g_body_x[0] = nx;
    g_body_y[0] = ny;

    if (ate) {
        if (g_length < MAX_LEN) {
            g_body_x[g_length] = tail_x;
            g_body_y[g_length] = tail_y;
            g_length++;
        }
        g_score++;
        place_food();
        put_cell(g_food_x, g_food_y, CH_FOOD);
        draw_status();
    } else {
        put_cell(tail_x, tail_y, CH_EMPTY);
    }

    put_cell(g_body_x[1], g_body_y[1], CH_BODY);
    put_cell(g_body_x[0], g_body_y[0], CH_HEAD);

    seg_write_hex(g_score);
    led_write((unsigned)g_length);
    return 1;
}

void wait_for_key(void) {
    // flush anything already queued, then block for a fresh keypress
    for (;;) {
        SERIAL_READ r = rv_soc_serial_read();
        if (!SERIAL_READ_VALID(r))
            break;
    }
    for (;;) {
        SERIAL_READ r = rv_soc_serial_read();
        if (SERIAL_READ_VALID(r))
            return;
    }
}

int main() {
    g_seed = (unsigned)millis(SYSTEM_HZ) ^ 0xC0FFEEu;

    for (;;) {
        new_round();

        unsigned long last_tick = millis(SYSTEM_HZ);
        int alive = 1;

        while (alive) {
            poll_input();

            unsigned long now = millis(SYSTEM_HZ);
            if (now - last_tick >= TICK_MS) {
                last_tick = now;
                alive = step();
            }
        }

        move_cursor(STATUS_ROW + 1, 1);
        send_str("GAME OVER - score ");
        send_uint(g_score);
        send_str(" - press any key to restart");

        g_seed ^= (unsigned)millis(SYSTEM_HZ); 
        wait_for_key();
    }
}