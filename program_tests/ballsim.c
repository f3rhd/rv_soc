#include "../libc-baremetal/include/led.h"
#include "../libc-baremetal/include/graphics.h"

#define SCREEN_WIDTH 128
#define SCREEN_HEIGHT 160
#define RADIUS 5

typedef struct {
    signed x;
    signed y;
} vec2;

void delay(unsigned dly_amount) {
    for (volatile int i = 0; i < dly_amount; i++)
        ;
}

unsigned isqrt(unsigned n) {
    unsigned res = 0;
    unsigned bit = 1u << 30;
    while (bit > n) bit >>= 2;
    while (bit != 0) {
        if (n >= res + bit) {
            n -= res + bit;
            res = (res >> 1) + bit;
        } else {
            res >>= 1;
        }
        bit >>= 2;
    }
    return res;
}

void wall_bounce(vec2 *pos, vec2 *vel) {
    if (pos->x + RADIUS >= SCREEN_WIDTH || pos->x - RADIUS <= 0) {
        vel->x = -vel->x;
        if (pos->x - RADIUS <= 0)
            pos->x = RADIUS;
        if (pos->x + RADIUS >= SCREEN_WIDTH)
            pos->x = SCREEN_WIDTH - RADIUS;
    }
    if (pos->y + RADIUS >= SCREEN_HEIGHT || pos->y - RADIUS <= 0) {
        vel->y = -vel->y;
        if (pos->y - RADIUS <= 0)
            pos->y = RADIUS;
        if (pos->y + RADIUS >= SCREEN_HEIGHT)
            pos->y = SCREEN_HEIGHT - RADIUS;
    }
}

int main() {
    vec2 pos_r = {SCREEN_WIDTH / 4, SCREEN_HEIGHT / 2};
    vec2 vel_r = {2, 3};

    vec2 pos_b = {(SCREEN_WIDTH * 3) / 4, SCREEN_HEIGHT / 2};
    vec2 vel_b = {-2, -2};

    rv_soc_draw_rectangle(ST7735_BLACK, 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);

    for (;;) {
        rv_soc_draw_rectangle(
            ST7735_BLACK,
            pos_r.x - RADIUS, pos_r.y - RADIUS,
            RADIUS * 2 + 1, RADIUS * 2 + 1
        );
        rv_soc_draw_rectangle(
            ST7735_BLACK,
            pos_b.x - RADIUS, pos_b.y - RADIUS,
            RADIUS * 2 + 1, RADIUS * 2 + 1
        );

        pos_r.x += vel_r.x;
        pos_r.y += vel_r.y;
        pos_b.x += vel_b.x;
        pos_b.y += vel_b.y;

        wall_bounce(&pos_r, &vel_r);
        wall_bounce(&pos_b, &vel_b);

        signed dx = pos_b.x - pos_r.x;
        signed dy = pos_b.y - pos_r.y;
        unsigned dist_sq = (unsigned)(dx * dx + dy * dy);
        unsigned min_dist = RADIUS * 2;

        if (dist_sq <= min_dist * min_dist && dist_sq > 0) {
            unsigned dist = isqrt(dist_sq);
            if (dist == 0) dist = 1;

            signed nx = dx;
            signed ny = dy;

            signed rvx = vel_r.x - vel_b.x;
            signed rvy = vel_r.y - vel_b.y;

            signed vel_along_normal = rvx * nx + rvy * ny;

            if (vel_along_normal > 0) {
                vec2 tmp = vel_r;
                vel_r = vel_b;
                vel_b = tmp;
            }

            signed overlap = (signed)min_dist - (signed)dist;
            if (overlap > 0) {
                signed push_x = (nx * overlap) / (signed)(2 * dist);
                signed push_y = (ny * overlap) / (signed)(2 * dist);
                pos_r.x -= push_x;
                pos_r.y -= push_y;
                pos_b.x += push_x;
                pos_b.y += push_y;
            }
        }

        rv_soc_draw_circle(ST7735_RED, 1,pos_r.x, pos_r.y, RADIUS);
        rv_soc_draw_circle(ST7735_BLUE,1, pos_b.x, pos_b.y, RADIUS);

        seg_write_hex(((pos_r.x & 0xFF) << 8) | (pos_r.y & 0xFF));
        led_write(((pos_b.x & 0xFF) << 8) | (pos_b.y & 0xFF));

        delay(150'000);
    }
}