#include "../libc-baremetal/include/led.h"
#include "../libc-baremetal/include/graphics.h"
#include "../libc-baremetal/include/system.h"

#define SCREEN_WIDTH 128
#define SCREEN_HEIGHT 160

#define CELL_PX 2
#define GRID_W (SCREEN_WIDTH / CELL_PX)
#define GRID_H (SCREEN_HEIGHT / CELL_PX)

#define MAX_ITER 60

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

/* A handful of well-known "interesting" locations to zoom into. Feel free
 * to add more coordinates here; the traversal will cycle through all of
 * them in order, forever. */
typedef struct {
    float cx;
    float cy;
} poi_t;

static const poi_t POIS[] = {
    { -0.745428f,  0.112720f },  /* seahorse valley */
    { -0.159200f,  1.031700f },  /* mini spiral */
    { -1.250660f,  0.020120f },  /* period-3 bulb */
    { -0.775684f,  0.136467f },  /* double spiral */
    {  0.286932f,  0.014287f },  /* near the elephant valley */
    { -0.101f,     0.956f    },  /* triple spiral */
};
#define NUM_POIS (int)(sizeof(POIS) / sizeof(POIS[0]))

#define HOME_CX     -0.5f
#define HOME_CY      0.0f
#define HOME_WIDTH   3.0f
#define MIN_WIDTH    3e-5f
#define ZOOM_IN_RATE   0.965f   /* view_width *= this each tick while zooming in  */
#define ZOOM_OUT_RATE  0.90f    /* view_width /= this each tick while zooming out */
#define EASE_RATE      0.05f    /* how fast view_cx/cy chase the target center    */

typedef enum {
    PHASE_ZOOM_IN,
    PHASE_ZOOM_OUT
} phase_t;

int main() {
    static float view_cx;
    static float view_cy;
    static float view_width;

    static int poi_index = 0;
    static phase_t phase = PHASE_ZOOM_IN;
    unsigned zoom_level = 0;

    view_cx = HOME_CX;
    view_cy = HOME_CY;
    view_width = HOME_WIDTH;

    for (;;) {
        poi_t target = POIS[poi_index];

        if (phase == PHASE_ZOOM_IN) {
            view_cx += (target.cx - view_cx) * EASE_RATE;
            view_cy += (target.cy - view_cy) * EASE_RATE;
            view_width *= ZOOM_IN_RATE;
            zoom_level++;

            if (view_width < MIN_WIDTH) {
                phase = PHASE_ZOOM_OUT;
            }
        } else { /* PHASE_ZOOM_OUT */
            view_width /= ZOOM_OUT_RATE;
            if (zoom_level > 0)
                zoom_level--;

            if (view_width > HOME_WIDTH) {
                view_width = HOME_WIDTH;
                view_cx = HOME_CX;
                view_cy = HOME_CY;
                zoom_level = 0;

                poi_index++;
                if (poi_index >= NUM_POIS)
                    poi_index = 0;

                phase = PHASE_ZOOM_IN;
            }
        }

        render(view_cx, view_cy, view_width);

        seg_write_hex(zoom_level);

        int cx_scaled = (int)(view_cx * 1000.0f);
        int cy_scaled = (int)(view_cy * 1000.0f);
        led_write(((cx_scaled & 0xFF) << 8) | (cy_scaled & 0xFF));

        delay(10,100'000'000);
    }
}