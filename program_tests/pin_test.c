#include "../libc-baremetal/include/led.h"
#include "../libc-baremetal/include/pin.h"


int main() {

    set_pin_mode(0, PIN_INPUT);
    int counter = 0;
    int prev_val = 0;
    while (1) {

        int current_val = read_pin(0) ;
        if (current_val && !prev_val) {
            counter++;
        }
        prev_val = current_val;
        seg_write_hex(counter);
    }
}