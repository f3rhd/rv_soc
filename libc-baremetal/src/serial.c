#include "../include/serial.h"
#define UART_WRITE_ADDR 0xF0000200
#define UART_READ_ADDR 0xF0000400
void rv_soc_serial_send(char byte) {
    volatile char* addr = (volatile char*)UART_WRITE_ADDR;
    *addr = byte;
}
SERIAL_READ rv_soc_serial_read() {
    volatile int* addr = (volatile int*)UART_READ_ADDR;
    return *addr;
}