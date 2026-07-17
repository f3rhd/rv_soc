/*
 * SPDX-FileCopyrightText: 2026 f3rhd
 * SPDX-FileCopyrightText: 2026 f3rhd 
 *
 * SPDX-License-Identifier: MIT
 */

#include "../../../libc-baremetal/include/st7735.h"

#define SCREEN_WIDTH 128
#define SCREEN_HEIGHT 160
#define SQUARE_HEIGHT 20
typedef struct  {
    signed x;
    signed y;
} vec2;
void delay(unsigned dly_amount) {
    for (int i = 0; i < dly_amount; i++);
}
void draw_dvd(vec2 pos) {

    st7735_set_rectangle(pos.x,pos.y, pos.x + SQUARE_HEIGHT, pos.y+SQUARE_HEIGHT);
    st7735_stream_pixel(ST7735_RED, SQUARE_HEIGHT*SQUARE_HEIGHT);
}
int main() {
    vec2 pos = {SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2};
    vec2 vel = {2, 2}; 

    
    st7735_set_rectangle(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    st7735_stream_pixel(ST7735_BLACK, SCREEN_HEIGHT * SCREEN_WIDTH);

    draw_dvd(pos);
    while (1) {
        st7735_set_rectangle(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        st7735_stream_pixel(ST7735_BLACK, SCREEN_WIDTH * SCREEN_HEIGHT);

        pos.x += vel.x;
        pos.y += vel.y;

        
        if (pos.x + SQUARE_HEIGHT >= SCREEN_WIDTH || pos.x <= 0) {
            vel.x = -vel.x;
            
            if (pos.x <= 0) pos.x = 0;
            if (pos.x + SQUARE_HEIGHT >= SCREEN_WIDTH) pos.x = SCREEN_WIDTH - SQUARE_HEIGHT;
        }
        if (pos.y + SQUARE_HEIGHT >= SCREEN_HEIGHT || pos.y <= 0) {
            vel.y = -vel.y;
            
            if (pos.y <= 0) pos.y = 0;
            if (pos.y + SQUARE_HEIGHT >= SCREEN_HEIGHT) pos.y = SCREEN_HEIGHT - SQUARE_HEIGHT;
        }

        
        draw_dvd(pos);

        
        delay(50000); 
    }
}