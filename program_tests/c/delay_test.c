#include "../../libc-baremetal/include/system.h"
#include "../../libc-baremetal/include/led.h"

int main() {
    int counter = 0;
    while (1) {
        seg_write_hex(counter++);
        delay(1000, 100'000'000);
    }
}