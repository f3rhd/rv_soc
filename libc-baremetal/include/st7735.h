#ifndef ST7735_H
#define ST7735_H
#include "st7735_colors.h"
void st7735_stream_pixel(unsigned color, unsigned amount);
void st7735_set_rectangle(
    unsigned x_start,
    unsigned y_start,
    unsigned x_end,
    unsigned y_end
);
void st7735_draw_pixel(unsigned color, unsigned x, unsigned y);
void st7735_draw_rectangle(
    unsigned color,
    unsigned x_start,
    unsigned y_start,
    unsigned x_end,
    unsigned y_end
);
void st7735_draw_triangle(
    unsigned color,
    unsigned p1_x,
    unsigned p1_y,
    unsigned p2_x,
    unsigned p2_y,
    unsigned p3_x,
    unsigned p3_y
);
void st7735_draw_line(
    unsigned color,
    unsigned x_start,
    unsigned y_start,
    unsigned x_end,
    unsigned y_end
);
void st7735_draw_circle(
    unsigned color,
    unsigned center_x,
    unsigned center_y,
    unsigned radius
);

#endif
