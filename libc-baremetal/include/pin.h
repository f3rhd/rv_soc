#ifndef PIN_H
#define PIN_H
#define PIN_INPUT 0
#define PIN_OUTPUT 1
#define HIGH 1
#define LOW 0
void set_pin_mode(int pin_id,int pin_mode);
void drive_pin(int pin_id, int high);
int read_pin(int pin_id);
#endif