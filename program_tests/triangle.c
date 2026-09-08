#include "../libc-baremetal/include/st7735.h"

#define SCREEN_WIDTH 128
#define SCREEN_HEIGHT 160
int main() {
    st7735_draw_triangle(
        ST7735_RED,
        0,
        SCREEN_WIDTH / 2,
        SCREEN_HEIGHT/2,
        20,
        SCREEN_HEIGHT - 20,
        SCREEN_WIDTH - 20,
        SCREEN_HEIGHT - 20
    );
}