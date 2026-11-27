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
#include <stdarg.h>
#include <stdint.h>

static char serial_read_char(void) {
    return (char)rv_soc_serial_read();
}

static void serial_skip_whitespace(void) {
    char c;

    do {
        c = serial_read_char();
    } while (c == ' ' || c == '\t' || c == '\n' || c == '\r');
}

static int serial_is_digit(char c) {
    return c >= '0' && c <= '9';
}

static int serial_digit_value(char c) {
    if (c >= '0' && c <= '9') return c - '0';
    if (c >= 'a' && c <= 'f') return c - 'a' + 10;
    if (c >= 'A' && c <= 'F') return c - 'A' + 10;
    return -1;
}

static int serial_read_integer(int base, int is_signed, int32_t* result) {
    char c;
    int negative = 0;
    int digit;
    int32_t value = 0;
    int read_any = 0;

    serial_skip_whitespace();

    c = serial_read_char();

    if (is_signed && (c == '-' || c == '+')) {
        negative = (c == '-');
        c = serial_read_char();
    }

    while ((digit = serial_digit_value(c)) >= 0 && digit < base) {
        value = value * base + digit;
        read_any = 1;
        c = serial_read_char();
    }

    if (!read_any)
        return 0;

    if (negative)
        value = -value;

    *result = value;
    return 1;
}

static int serial_read_string(char* buffer) {
    char c;
    int length = 0;

    serial_skip_whitespace();

    c = serial_read_char();

    while (c != ' ' && c != '\t' && c != '\n' && c != '\r') {
        buffer[length++] = c;
        c = serial_read_char();
    }

    buffer[length] = '\0';
    return 1;
}

int rv_soc_serial_scan_fmt(const char* fmt, ...) {
    va_list args;
    int assigned = 0;

    va_start(args, fmt);

    while (*fmt) {
        if (*fmt != '%') {
            fmt++;
            continue;
        }

        fmt++;

        switch (*fmt) {
            case 'd':
            case 'i': {
                int32_t value;

                if (!serial_read_integer(10, 1, &value))
                    goto done;

                *va_arg(args, int*) = value;
                assigned++;
                break;
            }

            case 'u': {
                int32_t value;

                if (!serial_read_integer(10, 0, &value))
                    goto done;

                *va_arg(args, unsigned int*) = (unsigned int)value;
                assigned++;
                break;
            }

            case 'x':
            case 'X': {
                int32_t value;

                if (!serial_read_integer(16, 0, &value))
                    goto done;

                *va_arg(args, unsigned int*) = (unsigned int)value;
                assigned++;
                break;
            }

            case 'c': {
                char* ptr = va_arg(args, char*);
                *ptr = serial_read_char();
                assigned++;
                break;
            }

            case 's': {
                char* ptr = va_arg(args, char*);
                serial_read_string(ptr);
                assigned++;
                break;
            }

            default:
                break;
        }

        fmt++;
    }

done:
    va_end(args);
    return assigned;
}