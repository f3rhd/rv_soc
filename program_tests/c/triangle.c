#include "../../libc-baremetal/include/st7735.h"

#define SCREEN_WIDTH 128
#define SCREEN_HEIGHT 160
int main() {
    st7735_draw_rectangle(ST7735_BLACK, 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    st7735_draw_triangle(
        ST7735_RED,
        0,
        SCREEN_WIDTH / 2,
        0,
        0,
        SCREEN_HEIGHT - 20,
        SCREEN_WIDTH,
        SCREEN_HEIGHT - 20
    );
}