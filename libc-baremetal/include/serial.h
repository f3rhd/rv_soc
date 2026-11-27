#ifndef UART_H
#define UART_H
#define SERIAL_READ int
#define SERIAL_READ_VALID(SERIAL_READ_RESULT) ((SERIAL_READ_RESULT >> 8) & 0x00FFFFFF)
#define SERIAL_RESULT_BYTE(SERIAL_READ_RESULT) (char)(SERIAL_READ_RESULT & 0x0000000F)
void rv_soc_serial_send(char byte);
SERIAL_READ  rv_soc_serial_read();
void rv_soc_serial_send_fmt(const char* fmt, ...);
#endif