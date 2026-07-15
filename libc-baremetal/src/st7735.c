#include "../include/st7735.h"
inline void st7735_stream_pixel(unsigned color, unsigned amount);
inline void st7735_set_rectangle(
    unsigned x_start,
    unsigned y_start,
    unsigned x_end,
    unsigned y_end
);
inline void st7735_draw_pixel(unsigned color, unsigned x, unsigned y) {
    st7735_set_rectangle(x, y, x, y);
    st7735_stream_pixel(color, 1);
}
inline void st7735_draw_rectangle(
    unsigned x_start,
    unsigned x_end,
    unsigned y_start,
    unsigned y_end,
    unsigned color
) {
    st7735_set_rectangle(x_start, x_end, y_start, y_end);
    // each color data corresponds to two pixel values
    st7735_stream_pixel(color, (x_end - x_start) * (y_end - y_start) >> 1);
}
// TODO 
void st7735_draw_triangle(
    unsigned color,
    unsigned p1_x,
    unsigned p1_y,
    unsigned p2_x,
    unsigned p2_y,
    unsigned p3_x,
    unsigned p3_y
) {}
void st7735_draw_line(
    unsigned color,
    unsigned x_start,
    unsigned y_start,
    unsigned x_end,
    unsigned y_end
) {

    //Bresenham's line algorithm

    int x0 = (int)x_start;
    int y0 = (int)y_start;
    int x1 = (int)x_end;
    int y1 = (int)y_end;

    // we dont have math lib yet so we are going to manually implement abs
    #define _ABS(EXPR) (EXPR) > 0 ? (EXPR) : -(EXPR)

    int dx = _ABS(x1 - x0);
    int sx = (x0 < x1) ? 1 : -1;

    int dy = -(_ABS(y1 - y0));
    int sy = (y0 < y1) ? 1 : -1;

    int err = dx + dy;

    while (1) {
        st7735_draw_pixel(color, (unsigned)x0, (unsigned)y0);

        if (x0 == x1 && y0 == y1)
            break;

        int e2 = err << 1;

        if (e2 >= dy) {
            err += dy;
            x0 += sx;
        }

        if (e2 <= dx) {
            err += dx;
            y0 += sy;
        }
    }
}

// TODO 
void st7735_draw_circle(
    unsigned int color,
    unsigned int center_x,
    unsigned int center_y,
    unsigned int radius
) {}

inline void st7735_stream_pixel(unsigned color, unsigned amount) {
    volatile unsigned* data_address = (volatile unsigned*)0xFFFFFFFF;

    for (int i = 0; i < amount; i++) {
        asm volatile("sw %0, 0(%1) \n\t"
                     :
                     : "r"(color), "r"(data_address)
                     : "memory");
    }
}

inline void st7735_set_rectangle(
    unsigned x_start,
    unsigned y_start,
    unsigned x_end,
    unsigned y_end
) {
    volatile unsigned* command_address = (volatile unsigned*)0xFFFFFFF0;
    unsigned stream_cmd = 0x2C000000;

    unsigned col_value =
        (0x2A << 24) | ((x_start & 0xFF) << 16) | ((x_end & 0xFF) << 8);
    unsigned row_value =
        (0x2B << 24) | ((y_start & 0xFF) << 16) | ((y_end & 0xFF) << 8);

    asm volatile("sw %0, 0(%2) \n\t"
                 "sw %1, 0(%2) \n\t"
                 :
                 : "r"(col_value), "r"(row_value), "r"(command_address)
                 : "memory");
    asm volatile("sw %0, 0(%1) \n\t"
                 :
                 : "r"(stream_cmd), "r"(command_address)
                 : "memory");
}