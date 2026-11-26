#include "../libc-baremetal/include/serial.h"
#include "../libc-baremetal/include/led.h"

int main() {
    while (1) {
        SERIAL_READ read = rv_soc_serial_read();
        if (SERIAL_READ_VALID(read)) {
            led_write(read);
            rv_soc_serial_send(read);
        }
    }
}