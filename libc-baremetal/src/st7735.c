#include "../include/st7735.h"
inline void st7735_stream_pixel(unsigned int color, int amount);
inline void st7735_set_rectangle(
    int x_start,
    int y_start,
    int x_end,
    int y_end
);
inline void st7735_draw_pixel(unsigned int color, int x, int y) {
    st7735_set_rectangle(x, y, x, y);
    st7735_stream_pixel(color, 1);
}
inline void st7735_draw_rectangle(
    int x_start,
    int x_end,
    int y_start,
    int y_end,
    unsigned int color
) {
    st7735_set_rectangle(x_start, x_end, y_start, y_end);
    // each color data corresponds to two pixel values
    st7735_stream_pixel(color, (x_end - x_start) * (y_end - y_start) >> 1);
}
// TODO
void st7735_draw_triangle(
    unsigned int color,
    int p1_x,
    int p1_y,
    int p2_x,
    int p2_y,
    int p3_x,
    int p3_y
) {

}
void st7735_draw_line(
    unsigned int color,
    int x_start,
    int y_start,
    int x_end,
    int y_end
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
        st7735_draw_pixel(color, (int)x0, (int)y0);

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
    int center_x,
    int center_y,
    int radius
) {}

inline void st7735_stream_pixel(unsigned int color, int amount) {
    volatile int* data_address = (volatile int*)0xFFFFFFFF;

    for (int i = 0; i < amount; i++) {
        asm volatile("sw %0, 0(%1) \n\t"
                     :
                     : "r"(color), "r"(data_address)
                     : "memory");
    }
}

inline void st7735_set_rectangle(
    int x_start,
    int y_start,
    int x_end,
    int y_end
) {
    volatile int* command_address = (volatile int*)0xFFFFFFF0;
    int stream_cmd = 0x2C000000;

    int col_value =
        (0x2A << 24) | ((x_start & 0xFF) << 16) | ((x_end & 0xFF) << 8);
    int row_value =
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