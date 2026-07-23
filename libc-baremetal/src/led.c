#include "../include/led.h"

void led_write(int value) {

    volatile int* data_address = (volatile int*)0xF000000C;

        asm volatile("sh %0, 0(%1) \n\t"
                     :
                     : "r"(value), "r"(data_address)
                     : "memory");
}
void seg_write_hex(int value) {
    volatile int* data_address = (volatile int*)0xF0000008;

        asm volatile("sh %0, 0(%1) \n\t"
                     :
                     : "r"(value), "r"(data_address)
                     : "memory");

}