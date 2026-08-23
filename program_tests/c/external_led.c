#include "../../libc-baremetal/include/pin.h"

int main() {
    set_pin_mode(8, PIN_OUTPUT);
    int pin_val = 0xFFFFFFFF;
    while (1) {
        pin_val = ~pin_val;
        drive_pin(8, pin_val);
        for(volatile int i = 0 ; i<1'000'000;i++) {}
    }
}