#include "../libc-baremetal/include/led.h"
#include "../libc-baremetal/include/serial.h"
#include "../libc-baremetal/include/pin.h"
#include "../libc-baremetal/include/graphics.h"
#include "../libc-baremetal/include/system.h"

// TODO: set this to your core's actual clock frequency in Hz
#define SYSTEM_HZ 50000000UL

#define SCREEN_WIDTH  128
#define SCREEN_HEIGHT 160

#define PIN_FLAP 8          // button on GPIO 8 = flap (space / W over UART also flaps)

#define TICK_MS 33          // ~30 game steps per second

// ---- world layout ----
#define GROUND_Y 148        // top of the ground strip; playfield is y < GROUND_Y
#define BIRD_X   30
#define BIRD_W   7          // collision box (the beak sticks out 2px past this)
#define BIRD_H   7
#define BIRD_DRAW_W 9       // body + beak

#define NUM_PIPES     3
#define PIPE_W        18
#define PIPE_GAP      46    // vertical opening between top and bottom pipe
#define PIPE_SPACING  72    // distance between consecutive pipes' left edges
#define SCROLL        2     // pixels the world moves left per step
#define GAP_MARGIN    16    // keep the opening at least this far from ceiling/ground

// ---- physics (per step) ----
#define GRAVITY   0.5f
#define FLAP_VEL  (-4.6f)   // peak rise = v^2 / (2g), about 21px
#define MAX_FALL  6.5f

#define COLOR_SKY         ST7735_CYAN
#define COLOR_PIPE        ST7735_GREEN
#define COLOR_GROUND      ST7735_ORANGE
#define COLOR_GROUND_TOP  ST7735_DARKGREEN
#define COLOR_BIRD        ST7735_YELLOW
#define COLOR_BEAK        ST7735_ORANGE
#define COLOR_EYE         ST7735_WHITE

// ---- game state (static, tiny) ----
static int   g_pipe_x[NUM_PIPES];
static int   g_pipe_gap[NUM_PIPES];     // y of the top edge of the opening
static int   g_pipe_scored[NUM_PIPES];

static float g_bird_y;
static float g_bird_vel;

static unsigned g_score;
static unsigned g_best;
static unsigned g_seed;
static int      g_prev_pin;

// ---- small helpers ----

unsigned rand_next(unsigned *state) {
    *state = (*state * 1103515245u + 12345u);
    return (*state >> 16) & 0x7FFF;
}

int imin(int a, int b) { return a < b ? a : b; }
int imax(int a, int b) { return a > b ? a : b; }

// rectangle fill that clips to the screen, so pipes can slide in and out
// past the left/right edges without drawing garbage
void fill_rect(unsigned color, int x, int y, int w, int h) {
    if (x < 0) { w += x; x = 0; }
    if (y < 0) { h += y; y = 0; }
    if (x + w > SCREEN_WIDTH)  w = SCREEN_WIDTH - x;
    if (y + h > SCREEN_HEIGHT) h = SCREEN_HEIGHT - y;
    if (w <= 0 || h <= 0)
        return;
    rv_soc_draw_rectangle(color, x, y, w, h);
}

// ---- drawing ----

// paints a vertical slice (x, width w) of a pipe: the top section and the
// bottom section, leaving the gap open
void draw_pipe_cols(unsigned color, int x, int w, int gap_y) {
    fill_rect(color, x, 0, w, gap_y);
    fill_rect(color, x, gap_y + PIPE_GAP, w, GROUND_Y - (gap_y + PIPE_GAP));
}

// repaints a rectangle of the playfield from the world model: sky first,
// then any pipe pixels that overlap it. this is how the bird is erased
// without punching a hole in a pipe it was flying in front of
void restore_rect(int x, int y, int w, int h) {
    int i;
    if (y + h > GROUND_Y)
        h = GROUND_Y - y;
    if (h <= 0)
        return;

    fill_rect(COLOR_SKY, x, y, w, h);

    for (i = 0; i < NUM_PIPES; i++) {
        int ix0 = imax(x, g_pipe_x[i]);
        int ix1 = imin(x + w, g_pipe_x[i] + PIPE_W);
        if (ix1 <= ix0)
            continue;

        int gy = g_pipe_gap[i];

        int y0 = imax(y, 0);
        int y1 = imin(y + h, gy);
        if (y1 > y0)
            fill_rect(COLOR_PIPE, ix0, y0, ix1 - ix0, y1 - y0);

        y0 = imax(y, gy + PIPE_GAP);
        y1 = imin(y + h, GROUND_Y);
        if (y1 > y0)
            fill_rect(COLOR_PIPE, ix0, y0, ix1 - ix0, y1 - y0);
    }
}

void draw_bird(int y) {
    fill_rect(COLOR_BIRD, BIRD_X, y, BIRD_W, BIRD_H);
    fill_rect(COLOR_BEAK, BIRD_X + BIRD_W, y + 3, 2, 2);
    fill_rect(COLOR_EYE,  BIRD_X + 4, y + 1, 2, 2);
}

void draw_ground(void) {
    fill_rect(COLOR_GROUND, 0, GROUND_Y, SCREEN_WIDTH, SCREEN_HEIGHT - GROUND_Y);
    fill_rect(COLOR_GROUND_TOP, 0, GROUND_Y, SCREEN_WIDTH, 2);
}

// full repaint from the model (used on new game and after the death flash)
void draw_scene(void) {
    int i;
    fill_rect(COLOR_SKY, 0, 0, SCREEN_WIDTH, GROUND_Y);
    for (i = 0; i < NUM_PIPES; i++)
        draw_pipe_cols(COLOR_PIPE, g_pipe_x[i], PIPE_W, g_pipe_gap[i]);
    draw_ground();
    draw_bird((int)g_bird_y);
}

// ---- game logic ----

int random_gap(void) {
    int lo = GAP_MARGIN;
    int hi = GROUND_Y - PIPE_GAP - GAP_MARGIN;
    return lo + (int)(rand_next(&g_seed) % (unsigned)(hi - lo + 1));
}

void new_game(void) {
    int i;
    g_score = 0;
    g_bird_y = 70.0f;
    g_bird_vel = 0.0f;

    // pipes start just off the right edge and scroll in
    for (i = 0; i < NUM_PIPES; i++) {
        g_pipe_x[i] = SCREEN_WIDTH + 24 + i * PIPE_SPACING;
        g_pipe_gap[i] = random_gap();
        g_pipe_scored[i] = 0;
    }

    draw_scene();
    seg_write_hex(g_score);
    led_write(g_best);
}

// scrolls one pipe left by SCROLL pixels, touching only the two thin
// strips that actually change (erase trailing edge, paint leading edge) -
// way cheaper than redrawing whole pipes every step
void scroll_pipe(int i) {
    g_pipe_x[i] -= SCROLL;
    int x = g_pipe_x[i];
    draw_pipe_cols(COLOR_SKY,  x + PIPE_W, SCROLL, g_pipe_gap[i]); // trailing strip
    draw_pipe_cols(COLOR_PIPE, x,          SCROLL, g_pipe_gap[i]); // leading strip
}

// a pipe that has fully left the screen jumps to the back of the line
void recycle_pipe(int i) {
    int j, rightmost = g_pipe_x[0];
    for (j = 1; j < NUM_PIPES; j++)
        if (g_pipe_x[j] > rightmost)
            rightmost = g_pipe_x[j];

    g_pipe_x[i] = rightmost + PIPE_SPACING;
    g_pipe_gap[i] = random_gap();
    g_pipe_scored[i] = 0;
}

// one physics+draw step. returns 1 if the bird died
int game_tick(int flap) {
    int i;
    int dead = 0;

    if (flap)
        g_bird_vel = FLAP_VEL;

    g_bird_vel += GRAVITY;
    if (g_bird_vel > MAX_FALL)
        g_bird_vel = MAX_FALL;

    int old_y = (int)g_bird_y;
    g_bird_y += g_bird_vel;

    // bonking the ceiling just stops you; the ground is what kills
    if (g_bird_y < 0.0f) {
        g_bird_y = 0.0f;
        g_bird_vel = 0.0f;
    }
    if (g_bird_y + BIRD_H >= (float)GROUND_Y) {
        g_bird_y = (float)(GROUND_Y - BIRD_H);
        dead = 1;
    }

    // world scrolls
    for (i = 0; i < NUM_PIPES; i++) {
        scroll_pipe(i);
        if (g_pipe_x[i] + PIPE_W <= 0)
            recycle_pipe(i);
    }

    int by = (int)g_bird_y;

    for (i = 0; i < NUM_PIPES; i++) {
        int px = g_pipe_x[i];

        // horizontal overlap with the bird's collision box?
        if (BIRD_X + BIRD_W > px && BIRD_X < px + PIPE_W) {
            if (by < g_pipe_gap[i] || by + BIRD_H > g_pipe_gap[i] + PIPE_GAP)
                dead = 1;
        }

        // point scored the moment the bird clears the pipe's right edge
        if (!g_pipe_scored[i] && px + PIPE_W < BIRD_X) {
            g_pipe_scored[i] = 1;
            g_score++;
            if (g_score > g_best)
                g_best = g_score;
            seg_write_hex(g_score);
            led_write(g_best);
        }
    }

    // erase the bird where it was (restoring any pipe behind it), draw it where it is
    restore_rect(BIRD_X, old_y, BIRD_DRAW_W, BIRD_H);
    draw_bird(by);

    return dead;
}

// ---- input: GPIO button (rising edge) or space/W over UART ----

int poll_flap(void) {
    int flap = 0;

    int cur = read_pin(PIN_FLAP);
    if (cur && !g_prev_pin)
        flap = 1;
    g_prev_pin = cur;

    for (;;) {
        SERIAL_READ r = rv_soc_serial_read();
        if (!SERIAL_READ_VALID(r))
            break;

        // NOTE: & 0xFF on purpose - SERIAL_RESULT_BYTE in uart.h masks
        // with 0x0F, which would mangle ASCII (' ' 0x20 -> 0x00)
        char c = (char)(r & 0xFF);
        if (c == ' ' || c == 'w' || c == 'W')
            flap = 1;
    }
    return flap;
}

void wait_for_flap(void) {
    poll_flap(); // flush stale presses first
    while (!poll_flap())
        ;
}

int main() {
    set_pin_mode(PIN_FLAP, PIN_INPUT);
    g_prev_pin = 0;
    g_best = 0;
    g_seed = (unsigned)millis(SYSTEM_HZ) ^ 0xF1A9u;

    for (;;) {
        new_game();
        wait_for_flap();          // bird hovers until your first flap

        int pending_flap = 1;     // the press that started the game counts
        unsigned long last_tick = millis(SYSTEM_HZ);
        int dead = 0;

        while (!dead) {
            // poll constantly so a quick tap between steps is never lost
            if (poll_flap())
                pending_flap = 1;

            unsigned long now = millis(SYSTEM_HZ);
            if (now - last_tick >= TICK_MS) {
                last_tick = now;
                dead = game_tick(pending_flap);
                pending_flap = 0;
            }
        }

        // death: white flash, repaint the frozen scene, wait to retry
        fill_rect(ST7735_WHITE, 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        delay(90, SYSTEM_HZ);
        draw_scene();
        delay(500, SYSTEM_HZ);    // short lockout so a panic-tap doesn't instantly restart
        g_seed ^= (unsigned)millis(SYSTEM_HZ);
        wait_for_flap();
    }
}