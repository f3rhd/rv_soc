#include "../include/pin.h"
void set_pin_mode(int pin_id, int pin_mode) {
    volatile int* pin_mode_addr = (volatile int*)0xF0000010;

    int value = ((pin_id & 0x1f) << 1) | (pin_mode & 0x01);

    __asm__ volatile("sw %0, 0(%1)\n\t"
                     :
                     : "r"(value), "r"(pin_mode_addr)
                     : "memory");
}
void drive_pin(int pin_id, int high) {
    volatile int* pin_drive_addr = (volatile int*)0xF0000020;
    int value = ((pin_id & 0x1f) << 1) | (high & 0x01);

    __asm__ volatile("sw %0, 0(%1)\n\t"
                     :
                     : "r"(value), "r"(pin_drive_addr)
                     : "memory");
}

int read_pin(int pin_id) {
    volatile int* addr_val = (volatile int*) ((0xF0000000) | ((int)(pin_id & 0x1F) << 8) | 0x40);

    volatile int* pin_read_addr = (volatile int*)addr_val;

    return (*(volatile int*)pin_read_addr) & 1; 
}