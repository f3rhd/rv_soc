#ifndef ST7735_H
#define ST7735_H
void st7735_stream_pixel(unsigned int color, unsigned int amount);
void st7735_set_rectangle(int x_start, int x_end, int y_start, int y_end);
#endif
