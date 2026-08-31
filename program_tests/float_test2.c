#include "libc-baremetal/include/led.h"
int main() {
    volatile float x = 2.5;
    volatile float y = 3.2;
    seg_write_hex(x*y);
}