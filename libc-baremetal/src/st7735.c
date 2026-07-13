#include "../include/st7735.h"
void st7735_stream_pixel(unsigned int color, unsigned int amount) {
    volatile unsigned int *data_address = (volatile unsigned int *)0xFFFFFFFF;

    for (int i = 0; i < amount; i++) {
        asm volatile (
            "sw %0, 0(%1) \n\t"
            :
            : "r" (color), "r" (data_address)
            : "memory"
        );
    }
}

void st7735_set_rectangle(int x_start, int x_end, int y_start, int y_end ) {
    volatile unsigned int *command_address = (volatile unsigned int *)0xFFFFFFF0; 
    unsigned int stream_cmd = 0x2C000000;

    unsigned int col_value = (0x2A << 24) | ((x_start & 0xFF) << 16) | ((x_end & 0xFF) << 8);
    unsigned int row_value = (0x2B << 24) | ((y_start & 0xFF) << 16) | ((y_end & 0xFF) << 8);

    asm volatile (
        "sw %0, 0(%2) \n\t" 
        "sw %1, 0(%2) \n\t"  
        : 
        : "r" (col_value), "r" (row_value), "r" (command_address) 
        : "memory" 
    );
    asm volatile (
        "sw %0, 0(%1) \n\t"
        :
        : "r" (stream_cmd), "r" (command_address)
        : "memory"
    );
}