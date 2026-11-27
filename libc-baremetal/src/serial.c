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
#include <stdarg.h>
#include <stdint.h>

static void serial_send_string(const char* str) {
    while (*str) {
        rv_soc_serial_send(*str++);
    }
}

static void serial_send_unsigned(uint32_t value, uint32_t base) {
    char buffer[32];
    int i = 0;

    const char* digits = "0123456789abcdef";

    if (value == 0) {
        rv_soc_serial_send('0');
        return;
    }

    while (value > 0) {
        buffer[i++] = digits[value % base];
        value /= base;
    }

    while (i > 0) {
        rv_soc_serial_send(buffer[--i]);
    }
}

static void serial_send_signed(int32_t value) {
    if (value < 0) {
        rv_soc_serial_send('-');
        serial_send_unsigned((uint32_t)(-(int64_t)value), 10);
    } else {
        serial_send_unsigned((uint32_t)value, 10);
    }
}

void rv_soc_serial_send_fmt(const char* fmt, ...) {
    va_list args;
    va_start(args, fmt);

    while (*fmt) {
        if (*fmt != '%') {
            rv_soc_serial_send(*fmt++);
            continue;
        }

        fmt++;

        switch (*fmt) {
            case 'c': {
                char c = (char)va_arg(args, int);
                rv_soc_serial_send(c);
                break;
            }

            case 's': {
                const char* str = va_arg(args, const char*);
                serial_send_string(str ? str : "(null)");
                break;
            }

            case 'd':
            case 'i': {
                int32_t value = va_arg(args, int);
                serial_send_signed(value);
                break;
            }

            case 'u': {
                uint32_t value = va_arg(args, unsigned int);
                serial_send_unsigned(value, 10);
                break;
            }

            case 'x':
            case 'X': {
                uint32_t value = va_arg(args, unsigned int);
                serial_send_unsigned(value, 16);
                break;
            }

            case 'b': {
                uint32_t value = va_arg(args, unsigned int);
                serial_send_unsigned(value, 2);
                break;
            }

            case 'p': {
                uintptr_t value = (uintptr_t)va_arg(args, void*);
                serial_send_string("0x");
                serial_send_unsigned((uint32_t)value, 16);
                break;
            }

            case '%':
                rv_soc_serial_send('%');
                break;

            default:
                rv_soc_serial_send('%');
                rv_soc_serial_send(*fmt);
                break;
        }

        fmt++;
    }

    va_end(args);
}