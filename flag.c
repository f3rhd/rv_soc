#include "libc-baremetal/include/st7735.h"
#include "libc-baremetal/include/st7735_colors.h"

int main() {

    //st7735_set_rectangle(0, 0,128 ,160);
    //st7735_stream_pixel(ST7735_WHITE, 64*30 );
    //st7735_stream_pixel(ST7735_YELLOW, 64*30 );
    //st7735_stream_pixel(ST7735_GREEN, 64*30 );
    //st7735_stream_pixel(ST7735_RED, 64*30 );
    //st7735_draw_line(ST7735_BLACK, 64, 0, 64, 160);
    //st7735_draw_line(ST7735_BLACK, 0, 23, 64, 160);
    for (unsigned y = 0; y < 160; y++) {
        for (unsigned x = 0; x < 128; x++) {
            st7735_draw_pixel(ST7735_WHITE, x, y);
        }
    }
}
