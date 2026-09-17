#include "../libc-baremetal/include/led.h"
#include "../libc-baremetal/include/pin.h"
#include "../libc-baremetal/include/graphics.h"

#define SCREEN_WIDTH 128
#define SCREEN_HEIGHT 160

#define CELL_PX 2
#define GRID_W (SCREEN_WIDTH / CELL_PX)
#define GRID_H (SCREEN_HEIGHT / CELL_PX)

#define PIN_UP 8
#define PIN_DOWN 9
#define PIN_LEFT 10
#define PIN_RIGHT 11

#define MAX_ITER 60
#define PAN_COOLDOWN_TICKS 3

void delay(unsigned dly_amount) {
    for (volatile int i = 0; i < dly_amount; i++)
        ;
}

void draw_cell(int gx, int gy, unsigned color) {
    rv_soc_draw_rectangle(color, gx * CELL_PX, gy * CELL_PX, CELL_PX, CELL_PX);
}

static const unsigned PALETTE[8] = {
    ST7735_BLUE,
    ST7735_CYAN,
    ST7735_GREEN,
    ST7735_YELLOW,
    ST7735_RED,
    ST7735_MAGENTA,
    ST7735_WHITE,
    ST7735_BLACK
};
#define PALETTE_SIZE 8

int mandel_iter(float cre, float cim) {
    float zr = 0.0f, zi = 0.0f;
    int i;
    for (i = 0; i < MAX_ITER; i++) {
        float zr2 = zr * zr;
        float zi2 = zi * zi;

        if (zr2 + zi2 > 4.0f)
            return i;

        float new_zi = 2.0f * zr * zi + cim;
        float new_zr = zr2 - zi2 + cre;

        zr = new_zr;
        zi = new_zi;
    }
    return MAX_ITER;
}

void render(float view_cx, float view_cy, float view_width) {
    float step = view_width / GRID_W;

    int px, py;
    for (py = 0; py < GRID_H; py++) {
        for (px = 0; px < GRID_W; px++) {
            float cre = view_cx + (px - GRID_W / 2) * step;
            float cim = view_cy + (GRID_H / 2 - py) * step;

            int iter = mandel_iter(cre, cim);
            unsigned color = (iter >= MAX_ITER) ? ST7735_BLACK
                                                : PALETTE[iter % PALETTE_SIZE];

            draw_cell(px, py, color);
        }
    }
}

int main() {
    set_pin_mode(PIN_UP, PIN_INPUT);
    set_pin_mode(PIN_DOWN, PIN_INPUT);
    set_pin_mode(PIN_LEFT, PIN_INPUT);
    set_pin_mode(PIN_RIGHT, PIN_INPUT);

    static float view_cx;
    static float view_cy;
    static float view_width;

    static int prev_zoom_in;
    static int prev_zoom_out;
    static int prev_reset;

    unsigned move_cooldown = 0;
    unsigned zoom_level = 0;

    view_cx = -0.5f;
    view_cy = 0.0f;
    view_width = 3.0f;

    int dirty = 1;

    for (;;) {
        int cur_up = read_pin(PIN_UP);
        int cur_down = read_pin(PIN_DOWN);
        int cur_left = read_pin(PIN_LEFT);
        int cur_right = read_pin(PIN_RIGHT);

        int cur_reset = (cur_up && cur_down && cur_left && cur_right);
        int cur_zoom_in = (cur_up && cur_down && !cur_reset);
        int cur_zoom_out = (cur_left && cur_right && !cur_reset);

        int pan_up = cur_up && !cur_zoom_in && !cur_reset;
        int pan_down = cur_down && !cur_zoom_in && !cur_reset;
        int pan_left = cur_left && !cur_zoom_out && !cur_reset;
        int pan_right = cur_right && !cur_zoom_out && !cur_reset;

        if (move_cooldown > 0)
            move_cooldown--;

        if (move_cooldown == 0 &&
            (pan_up || pan_down || pan_left || pan_right)) {
            float pan_step = view_width * 0.125f;

            if (pan_up)
                view_cy += pan_step;
            if (pan_down)
                view_cy -= pan_step;
            if (pan_left)
                view_cx -= pan_step;
            if (pan_right)
                view_cx += pan_step;

            move_cooldown = PAN_COOLDOWN_TICKS;
            dirty = 1;
        }

        if (cur_zoom_in && !prev_zoom_in) {
            float new_width = view_width * 0.75f;
            float min_width = 1e-5f;
            if (new_width > min_width) {
                view_width = new_width;
                zoom_level++;
                dirty = 1;
            }
        }
        prev_zoom_in = cur_zoom_in;

        if (cur_zoom_out && !prev_zoom_out) {
            float new_width = view_width / 0.75f;
            float max_width = 8.0f;
            if (new_width < max_width) {
                view_width = new_width;
                if (zoom_level > 0)
                    zoom_level--;
                dirty = 1;
            }
        }
        prev_zoom_out = cur_zoom_out;

        if (cur_reset && !prev_reset) {
            view_cx = -0.5f;
            view_cy = 0.0f;
            view_width = 3.0f;
            zoom_level = 0;
            dirty = 1;
        }
        prev_reset = cur_reset;

        if (dirty) {
            render(view_cx, view_cy, view_width);
            dirty = 0;

            seg_write_hex(zoom_level);

            int cx_scaled = (int)(view_cx * 1000.0f);
            int cy_scaled = (int)(view_cy * 1000.0f);
            led_write(((cx_scaled & 0xFF) << 8) | (cy_scaled & 0xFF));
        }

        delay(5000);
    }
}