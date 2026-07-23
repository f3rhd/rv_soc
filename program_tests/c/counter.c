#include "../../libc-baremetal/include/led.h"
int main() {
    int val = 0;
    while (1) {

        if (val >= 65535) {
            led_write(val);
            seg_write_hex(val);
            break;
        }
        led_write(val);
        seg_write_hex(val);
        val++;
    }
}