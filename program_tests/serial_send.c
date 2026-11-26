#include "../libc-baremetal/include/serial.h"
#include "../libc-baremetal/include/led.h"
int main() {
    char msg [] = "Hello World!\n";

    int j = 0;
    while (1) {
        for (int i = 0; i < sizeof(msg) / sizeof(msg[0]); i++) {
            rv_soc_serial_send(msg[i]);
        }
        led_write(j++);

    }
}