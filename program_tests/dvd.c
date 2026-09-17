#include "../libc-baremetal/include/graphics.h"
#include "../libc-baremetal/include/led.h"

#define SCREEN_WIDTH 128
#define SCREEN_HEIGHT 160
#define SQUARE_HEIGHT 20
typedef struct {
    signed x;
    signed y;
} vec2;
void delay(unsigned dly_amount) {
    for (volatile int i = 0; i < dly_amount; i++)
        ;
}
void draw_dvd(vec2 pos, unsigned color) {

    rv_soc_draw_rectangle(color, pos.x, pos.y, SQUARE_HEIGHT, SQUARE_HEIGHT);
}
__attribute__((optimize("O0"))) void
change_color_on_collision(unsigned* dvd_color, int current_index) {
    switch (current_index) {
    case 0:
        *dvd_color = ST7735_RED;
        break;
    case 1:
        *dvd_color = ST7735_RED;
        break;
    case 2:
        *dvd_color = ST7735_GREEN;
        break;
    case 3:
        *dvd_color = ST7735_BLUE;
        break;
    case 4:
        *dvd_color = ST7735_CYAN;
        break;
    case 5:
        *dvd_color = ST7735_MAGENTA;
        break;
    case 6:
        *dvd_color = ST7735_YELLOW;
        break;
    case 7:
        *dvd_color = ST7735_ORANGE;
        break;
    case 8:
        *dvd_color = ST7735_PINK;
        break;
    default:
        *dvd_color = ST7735_BLACK;
    }
}
int main() {
    vec2 pos = {SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2};
    vec2 vel = {2, 2};

    rv_soc_draw_rectangle(ST7735_BLACK, 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);

    unsigned current_color = ST7735_MAROON;
    int color_index = 0;
    int had_collision = 0;
    int collision_counter = 0;
    while (1) {
        had_collision = 0;
        rv_soc_draw_rectangle(
            ST7735_BLACK,
            pos.x,
            pos.y,
            SQUARE_HEIGHT,
            SQUARE_HEIGHT
        );

        pos.x += vel.x;
        pos.y += vel.y;

        if (pos.x + SQUARE_HEIGHT >= SCREEN_WIDTH || pos.x <= 0) {
            had_collision = 1;
            vel.x = -vel.x;

            if (pos.x <= 0)
                pos.x = 0;
            if (pos.x + SQUARE_HEIGHT >= SCREEN_WIDTH)
                pos.x = SCREEN_WIDTH - SQUARE_HEIGHT;
        }
        if (pos.y + SQUARE_HEIGHT >= SCREEN_HEIGHT || pos.y <= 0) {
            had_collision = 1;
            vel.y = -vel.y;

            if (pos.y <= 0)
                pos.y = 0;
            if (pos.y + SQUARE_HEIGHT >= SCREEN_HEIGHT)
                pos.y = SCREEN_HEIGHT - SQUARE_HEIGHT;
        }

        if (had_collision) {

            collision_counter++;
            color_index++;
            if (color_index > 8) {
                color_index = 0;
            }
            change_color_on_collision(&current_color, color_index);
        }
                seg_write_hex(((pos.x & 0xFF) << 8) | (pos.y & 0xFF));
        draw_dvd(pos, current_color);

        delay(250'000);
    }
}