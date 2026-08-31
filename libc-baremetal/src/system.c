#include "../include/system.h"
void delay(unsigned long ms, unsigned long system_hz) {
    volatile unsigned int* system_counter_low_addr  = (volatile unsigned int*)0xF0000080;
    volatile unsigned int* system_counter_high_addr = (volatile unsigned int*)0xF0000100;

    unsigned int high1, low, high2;
    do {
        high1 = *system_counter_high_addr;
        low   = *system_counter_low_addr;
        high2 = *system_counter_high_addr;
    } while (high1 != high2);

    unsigned long long start_ticks = ((unsigned long long)high1 << 32) | low;

    unsigned long long ticks_needed = (unsigned long long)ms * (system_hz / 1000ULL);
    unsigned long long target_ticks = start_ticks + ticks_needed;

    while (1) {
        do {
            high1 = *system_counter_high_addr;
            low   = *system_counter_low_addr;
            high2 = *system_counter_high_addr;
        } while (high1 != high2);

        unsigned long long current_ticks = ((unsigned long long)high1 << 32) | low;

        if (current_ticks >= target_ticks) {
            break;
        }
    }
}
unsigned long millis(unsigned long system_hz) {
    volatile unsigned int* system_counter_low_addr  = (volatile unsigned int*)0xF0000080;
    volatile unsigned int* system_counter_high_addr = (volatile unsigned int*)0xF0000100;

    unsigned int high1, low, high2;
    do {
        high1 = *system_counter_high_addr;
        low   = *system_counter_low_addr;
        high2 = *system_counter_high_addr;
    } while (high1 != high2);

    unsigned long long current_ticks = ((unsigned long long)high1 << 32) | low;

    // Convert total clock ticks into milliseconds
    return (unsigned long)((current_ticks * 1000ULL) / system_hz);
}