/*
 * SPDX-FileCopyrightText: 2026 f3rhd
 *
 * SPDX-License-Identifier: Apache-2.0
 */
#include "../include/graphics.h"
#include <stdint.h>
#define NEW_GRAPHICS_ENCODING
#define ST7735_DISPLAY_WIDTH 128
#define ST7735_DISPLAY_HEIGHT 160
inline void rv_soc_draw_pixel(unsigned int color, int x, int y) {
    uint32_t px = (uint32_t)x;
    uint32_t py = (uint32_t)y;
    
    rv_soc_draw_triangle(color, 0, px, py, px, py, px, py);
}
inline void rv_soc_draw_rectangle(
    unsigned int color,
    int x_start,
    int y_start,
    int width,
    int height
) {
    if (width <= 0 || height <= 0) return;

    uint32_t x1 = (uint32_t)x_start;
    uint32_t y1 = (uint32_t)y_start;
    uint32_t x2 = (uint32_t)(x_start + width - 1);
    uint32_t y2 = (uint32_t)(y_start + height - 1);

    rv_soc_draw_triangle(color, 0, x1, y1, x2, y1, x2, y2);
    
    rv_soc_draw_triangle(color, 0, x1, y1, x2, y2, x1, y2);
}
#define MMIO_ADDR 0xF0000001
static inline void mmio_write32(uint32_t addr, uint32_t val) {
    __asm__ volatile (
        "sw %[value], 0(%[address])\n\t"
        :
        : [value] "r" (val), [address] "r" (addr)
        : "memory"
    );
}

void rv_soc_draw_triangle(
    unsigned color,
    int hollow,
    int p1_x,
    int p1_y,
    int p2_x,
    int p2_y,
    int p3_x,
    int p3_y
) {
    uint32_t word_p1 = ((hollow & 0x1u) << 31) | (0x0u << 29) | (((p1_x & 0x3FFF) << 14) | (p1_y & 0x3FFF));
    uint32_t word_p2 = ((hollow & 0x1u) << 31) | (0x1u << 29) | (((p2_x & 0x3FFF) << 14) | (p2_y & 0x3FFF));
    uint32_t word_p3 = ((hollow & 0x1u) << 31) | (0x2u << 29) | (((p3_x & 0x3FFF) << 14) | (p3_y & 0x3FFF));

    uint32_t word_color = ((hollow & 0x1u) << 31) | (0x3u << 29) | (color & 0xFFFFFFu);

    mmio_write32(MMIO_ADDR, word_p1);
    mmio_write32(MMIO_ADDR, word_p2);
    mmio_write32(MMIO_ADDR, word_p3);
    mmio_write32(MMIO_ADDR, word_color);
}
#undef MMIO_ADDR
void rv_soc_draw_line(
    unsigned int color,
    int x_start,
    int y_start,
    int x_end,
    int y_end
) {
    uint32_t x1 = (uint32_t)x_start;
    uint32_t y1 = (uint32_t)y_start;
    uint32_t x2 = (uint32_t)x_end;
    uint32_t y2 = (uint32_t)y_end;

    rv_soc_draw_triangle(color, 1, x1, y1, x2, y2, x2, y2);
}

static float my_sinf(float x) {
    const float PI = 3.14159265f;
    while (x > PI) x -= 2.0f * PI;
    while (x < -PI) x += 2.0f * PI;

    float x2 = x * x;
    float x3 = x2 * x;
    float x5 = x3 * x2;
    float x7 = x5 * x2;
    
    return x - (x3 / 6.0f) + (x5 / 120.0f) - (x7 / 5040.0f);
}

static float my_cosf(float x) {
    return my_sinf(x + 1.57079632f); 
}

void rv_soc_draw_circle(
    unsigned int color,
    int center_x,
    int center_y,
    int radius
) {
    if (radius <= 0) return;

    int segments = 32;
    for (int i = 0; i < segments; i++) {
        float angle1 = (float)i * 2.0f * 3.14159265f / (float)segments;
        float angle2 = (float)(i + 1) * 2.0f * 3.14159265f / (float)segments;

        uint32_t x1 = (uint32_t)(center_x + (int)(radius * my_cosf(angle1)));
        uint32_t y1 = (uint32_t)(center_y + (int)(radius * my_sinf(angle1)));
        uint32_t x2 = (uint32_t)(center_x + (int)(radius * my_cosf(angle2)));
        uint32_t y2 = (uint32_t)(center_y + (int)(radius * my_sinf(angle2)));

        rv_soc_draw_triangle(
            color, 
            0, 
            (uint32_t)center_x, (uint32_t)center_y, 
            x1, y1, 
            x2, y2
        );
    }
}