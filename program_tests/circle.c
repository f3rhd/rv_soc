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

int main() {
    vec2 pos = {SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2};
    vec2 vel = {2, 2};

    rv_soc_draw_rectangle(ST7735_BLACK, 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    unsigned current_color = ST7735_RED;
    int i;
    for (;;) {
        rv_soc_draw_rectangle(
            ST7735_BLACK,
            pos.x - RADIUS,
            pos.y - RADIUS,
            RADIUS * 2 + 1,
            RADIUS * 2 + 1
        );

        pos.x += vel.x;
        pos.y += vel.y;

        if (pos.x + RADIUS >= SCREEN_WIDTH || pos.x - RADIUS <= 0) {
            vel.x = -vel.x;

            if (pos.x - RADIUS <= 0)
                pos.x = RADIUS;
            if (pos.x + RADIUS >= SCREEN_WIDTH)
                pos.x = SCREEN_WIDTH - RADIUS;
        }

        if (pos.y + RADIUS >= SCREEN_HEIGHT || pos.y - RADIUS <= 0) {
            vel.y = -vel.y;

            if (pos.y - RADIUS <= 0)
                pos.y = RADIUS;
            if (pos.y + RADIUS >= SCREEN_HEIGHT)
                pos.y = SCREEN_HEIGHT - RADIUS;
        }

        rv_soc_draw_circle(current_color,1, pos.x, pos.y, RADIUS);
        seg_write_hex(((pos.x & 0xFF) << 8) | (pos.y & 0xFF));
        delay(50'000);
    }
}