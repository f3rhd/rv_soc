/*
 * SPDX-FileCopyrightText: 2026 f3rhd
 * SPDX-FileCopyrightText: 2026 f3rhd 
 *
 * SPDX-License-Identifier: MIT
 */

#ifndef ST7735_H
#define ST7735_H
#include "st7735_colors.h"
void st7735_draw_pixel(unsigned color, int x, int y);
void st7735_draw_rectangle(
    unsigned color,
    int x_start,
    int y_start,
    int width,
    int height
);
void st7735_draw_triangle(
    unsigned color,
    int hollow,
    int p1_x,
    int p1_y,
    int p2_x,
    int p2_y,
    int p3_x,
    int p3_y
);
void st7735_draw_line(
    unsigned color,
    int x_start,
    int y_start,
    int x_end,
    int y_end
);
void st7735_draw_circle(
    unsigned color,
    int center_x,
    int center_y,
    int radius
);

#endif
