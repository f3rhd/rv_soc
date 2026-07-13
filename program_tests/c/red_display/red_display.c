#include "../../../libc-baremetal/include/st7735.h"
#pragma GCC push_options
#pragma GCC optimize ("O0")
int main() {
    int screen_size = 128*160;
    while(1) {
        st7735_set_rectangle(0,128,0,160 );
        st7735_stream_pixel(0x001F001F, screen_size / 2);        
    }
    return 0;
}
#pragma GCC pop_options