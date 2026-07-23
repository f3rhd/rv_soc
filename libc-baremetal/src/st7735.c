/*
 * SPDX-FileCopyrightText: 2026 f3rhd
 * SPDX-FileCopyrightText: 2026 f3rhd
 *
 * SPDX-License-Identifier: MIT
 */

#include "../include/st7735.h"
#define ST7735_DISPLAY_WIDTH 128
#define ST7735_DISPLAY_HEIGHT 160
static inline void st7735_stream_pixel(unsigned int color, int amount);
static inline void
st7735_set_rectangle(int x_start, int y_start, int x_end, int y_end);
inline void st7735_draw_pixel(unsigned int color, int x, int y) {
    st7735_set_rectangle(x, y, x, y);
    st7735_stream_pixel(color, 1);
}
inline void st7735_draw_rectangle(
    unsigned int color,
    int x_start,
    int y_start,
    int width,
    int height
) {
    int x_end = x_start + width;
    int y_end = y_start + height;
    st7735_set_rectangle(x_start, y_start, x_end - 1, y_end - 1);
    // each color data corresponds to two pixel values
    st7735_stream_pixel(color, ((x_end - x_start) * (y_end - y_start)) >> 1);
}
#define __SWAP(x, y)                                                           \
    do {                                                                       \
        int temp = x;                                                          \
        x = y;                                                                 \
        y = temp;                                                              \
    } while (0)

#define __MAX(x, y) x > y ? x : y
#define __MIN(x, y) x < y ? x : y
static void st7735_triangle_fill_span(unsigned color, int y, int xa, int xb) {
    if (y < 0 || y >= ST7735_DISPLAY_HEIGHT)
        return;
    if (xa > xb) {
        __SWAP(xa, xb);
    }
    xa = __MAX(xa, 0);
    xb = __MIN(xb, ST7735_DISPLAY_WIDTH - 1);
    st7735_draw_line(color, xa, y, xb, y);
}
inline static int
st7735_triangle_edge_x(int y, int ax, int ay, int bx, int by) {

    if (ay == by)
        return ax;
    return ax + (bx - ax) * (y - ay) / (by - ay);
}
void st7735_draw_triangle(
    unsigned int color,
    int hollow,
    int p1_x,
    int p1_y,
    int p2_x,
    int p2_y,
    int p3_x,
    int p3_y
) {

    if (hollow) {
        st7735_draw_line(color, p1_x, p1_y, p2_x, p2_y);
        st7735_draw_line(color, p1_x, p1_y, p3_x, p3_y);
        st7735_draw_line(color, p2_x, p2_y, p3_x, p3_y);
        return;
    }

    int x1 = p1_x;
    int y1 = p1_y;
    int x2 = p2_x;
    int y2 = p2_y;
    int x3 = p3_x;
    int y3 = p3_y;

    if (y1 > y2) {
        __SWAP(x1, x2);
        __SWAP(y1, y2);
    }
    if (y1 > y3) {
        __SWAP(x1, x3);
        __SWAP(y1, y3);
    }
    if (y2 > y3) {
        __SWAP(x2, x3);
        __SWAP(y2, y3);
    }
    for (int y = y1; y <= y2; ++y) {
        int xa = st7735_triangle_edge_x(y, x1, y1, x3, y3);
        int xb = st7735_triangle_edge_x(y, x1, y1, x2, y2);
        st7735_triangle_fill_span(color, y, xa, xb);
    }

    for (int y = y2; y <= y3; ++y) {
        int xa = st7735_triangle_edge_x(y, x1, y1, x3, y3);
        int xb = st7735_triangle_edge_x(y, x2, y2, x3, y3);
        st7735_triangle_fill_span(color, y, xa, xb);
    }
}
#undef __SPAN
#undef __MAX
#undef __MIN
void st7735_draw_line(
    unsigned int color,
    int x_start,
    int y_start,
    int x_end,
    int y_end
) {

    // Bresenham's line algorithm

    int x0 = (int)x_start;
    int y0 = (int)y_start;
    int x1 = (int)x_end;
    int y1 = (int)y_end;

// we dont have math lib yet so we are going to manually implement abs
#define __ABS(EXPR) (EXPR) > 0 ? (EXPR) : -(EXPR)

    int dx = __ABS(x1 - x0);
    int sx = (x0 < x1) ? 1 : -1;

    int dy = -(__ABS(y1 - y0));
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
#undef __ABS

void st7735_draw_circle(
    unsigned int color,
    int center_x,
    int center_y,
    int radius
) {
    int x = radius;
    int y = 0;
    int err = 1 - radius;

    while (x >= y) {
        st7735_draw_line(
            color,
            center_x - x,
            center_y + y,
            center_x + x,
            center_y + y
        );
        st7735_draw_line(
            color,
            center_x - x,
            center_y - y,
            center_x + x,
            center_y - y
        );
        st7735_draw_line(
            color,
            center_x - y,
            center_y + x,
            center_x + y,
            center_y + x
        );
        st7735_draw_line(
            color,
            center_x - y,
            center_y - x,
            center_x + y,
            center_y - x
        );

        y++;

        if (err < 0) {
            err += 2 * y + 1;
        } else {
            x--;
            err += 2 * (y - x) + 1;
        }
    }
}

static inline void st7735_stream_pixel(unsigned int color, int amount) {
    volatile int* data_address = (volatile int*)0xFFFFFFFF;

    for (int i = 0; i < amount; i++) {
        asm volatile("sw %0, 0(%1) \n\t"
                     :
                     : "r"(color), "r"(data_address)
                     : "memory");
    }
}

static inline void
st7735_set_rectangle(int x_start, int y_start, int x_end, int y_end) {
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