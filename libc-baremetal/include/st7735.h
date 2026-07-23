/*
 * SPDX-FileCopyrightText: 2026 f3rhd
 * SPDX-FileCopyrightText: 2026 f3rhd 
 *
 * SPDX-License-Identifier: MIT
 */

#ifndef ST7735_H
#define ST7735_H
/*
                                                                                                                 
  ▄▄▄▄▄     ▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄ ▄▄▄▄▄▄▄  ▄▄▄▄▄  ▄▄▄▄▄▄▄                                                             
 ██▀▀▀▀█▄  █▀▀██▀▀▀▀ ▀▀▀▀▀██ ▀▀▀▀▀██ ██▀▀▀██ ██▀▀▀▀▀                                                             
 ▀██▄  ▄▀     ██         ██      ██  ▀   ▄█▀ ██▄▄▄                                                               
   ▀██▄▄      ██      ▄▄██▄▄  ▄▄██▄▄   ▀▀▀█▄ ▀▀▀▀██▄                                                             
 ▄   ▀██▄     ██        ██      ██   ▄    ██ ▄   ▄██                                                             
 ▀██████▀     ▀██▄      ██      ██   ▀█████▀ ▀████▀                                                              
                                                                                                                 
                                                                                                                 
                                                                                                                 
 ▄   ▄▄▄▄    ▄▄▄▄      ▄▄▄       ▄▄▄▄      ▄▄▄▄▄▄                                                                
 ▀██████▀  ▄█▀▀████▄  ▀██▀     ▄█▀▀████▄  █▀██▀▀▀█▄                                                              
   ██      ██    ██    ██      ██    ██     ██▄▄▄█▀                                                              
   ██      ██    ██    ██      ██    ██     ██▀▀█▄                                                               
   ██      ██    ██    ██      ██    ██   ▄ ██  ██                                                               
   ▀█████   ▀████▀    ████████  ▀████▀    ▀██▀  ▀██▀                                                             
                                                                                                                 
                                                                                                                 
                                                                                                                 
  ▄▄▄▄▄▄     ▄▄▄▄▄▄▄   ▄▄▄▄▄▄▄   ▄▄▄▄▄▄   ▄▄     ▄▄▄   ▄▄▄▄▄▄  ▄▄▄▄▄▄▄    ▄▄▄▄▄▄   ▄▄▄▄     ▄▄     ▄▄▄   ▄▄▄▄▄   
 █▀██▀▀██   █▀██▀▀▀   █▀██▀▀▀   █▀ ██     ██▄   ██▀   █▀ ██   █▀▀██▀▀▀▀  █▀ ██   ▄█▀▀████▄  ██▄   ██▀   ██▀▀▀▀█▄ 
   ██   ██    ██        ██         ██     ███▄  ██       ██      ██         ██   ██    ██   ███▄  ██    ▀██▄  ▄▀ 
   ██   ██    ████      ███▀       ██     ██ ▀█▄██       ██      ██         ██   ██    ██   ██ ▀█▄██      ▀██▄▄  
 ▄ ██   ██    ██      ▄ ██         ██     ██   ▀██       ██      ██         ██   ██    ██   ██   ▀██    ▄   ▀██▄ 
 ▀██▀███▀     ▀█████  ▀██▀       ▄▄██▄▄ ▀██▀    ██     ▄▄██▄▄    ▀██▄     ▄▄██▄▄  ▀████▀  ▀██▀    ██    ▀██████▀ 
                                                                                                                 
*/
#define ST7735_BLACK       0x00000000
#define ST7735_WHITE       0xFFFFFFFF
#define ST7735_RED         0x001F001F
#define ST7735_GREEN       0x07E007E0
#define ST7735_BLUE        0xF800F800
#define ST7735_CYAN        0xFFE0FFE0
#define ST7735_MAGENTA     0xF81FF81F
#define ST7735_YELLOW      0x07FF07FF
#define ST7735_ORANGE      0x053F053F
#define ST7735_PINK        0xCDBFCDBF
#define ST7735_GRAY        0x84108410
#define ST7735_DARKGREY    0x42084208
#define ST7735_LIGHTGREY   0xD69AD69A
#define ST7735_NAVY        0x80008000
#define ST7735_DARKGREEN   0x04000400
#define ST7735_DARKCYAN    0x84008400
#define ST7735_MAROON      0x00100010
#define ST7735_PURPLE      0x80108010
#define ST7735_OLIVE       0x04100410
/*
                                                                                                
  ▄▄▄▄▄     ▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄ ▄▄▄▄▄▄▄  ▄▄▄▄▄  ▄▄▄▄▄▄▄                                            
 ██▀▀▀▀█▄  █▀▀██▀▀▀▀ ▀▀▀▀▀██ ▀▀▀▀▀██ ██▀▀▀██ ██▀▀▀▀▀                                            
 ▀██▄  ▄▀     ██         ██      ██  ▀   ▄█▀ ██▄▄▄                                              
   ▀██▄▄      ██      ▄▄██▄▄  ▄▄██▄▄   ▀▀▀█▄ ▀▀▀▀██▄                                            
 ▄   ▀██▄     ██        ██      ██   ▄    ██ ▄   ▄██                                            
 ▀██████▀     ▀██▄      ██      ██   ▀█████▀ ▀████▀                                             
                                                                                                
                                                                                                
                                                                                                
  ▄▄▄▄▄▄▄   ▄▄▄  ▄▄    ▄▄     ▄▄▄  ▄   ▄▄▄▄   ▄▄▄▄▄▄▄    ▄▄▄▄▄▄   ▄▄▄▄     ▄▄     ▄▄▄   ▄▄▄▄▄   
 █▀██▀▀▀   █▀██  ██    ██▄   ██▀   ▀██████▀  █▀▀██▀▀▀▀  █▀ ██   ▄█▀▀████▄  ██▄   ██▀   ██▀▀▀▀█▄ 
   ██        ██  ██    ███▄  ██      ██         ██         ██   ██    ██   ███▄  ██    ▀██▄  ▄▀ 
   ███▀      ██  ██    ██ ▀█▄██      ██         ██         ██   ██    ██   ██ ▀█▄██      ▀██▄▄  
 ▄ ██        ██  ██    ██   ▀██      ██         ██         ██   ██    ██   ██   ▀██    ▄   ▀██▄ 
 ▀██▀        ▀█████▄ ▀██▀    ██      ▀█████     ▀██▄     ▄▄██▄▄  ▀████▀  ▀██▀    ██    ▀██████▀ 
                                                                                                
                                                                                                
*/
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
