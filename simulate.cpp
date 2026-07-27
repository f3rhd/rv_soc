#include <iostream>
#include <fstream>
#include <format>
std::ofstream simulate("simulate1.txt");
std::ofstream simulate2("simulate2.txt");
static inline void
st7735_set_rectangle(int x_start, int y_start, int x_end, int y_end) {
    volatile int* command_address = (volatile int*)0xF0000004;
    int col_value =
        (0x2A << 24) | ((x_start & 0xFF) << 16) | ((x_end & 0xFF) << 8);
    int row_value =
        (0x2B << 24) | ((y_start & 0xFF) << 16) | ((y_end & 0xFF) << 8);


    simulate << std::format("DCache[0x{:08x}] <- {:08x}\n", 0xF0000004, col_value);
    simulate << std::format("DCache[0x{:08x}] <- {:08x}\n", 0xF0000004, row_value);
    simulate2 << std::format("Graphics Instruction : 0x{:08x} complete\n",col_value);
    simulate2 << std::format("Graphics Instruction : 0x{:08x} complete\n",row_value);
}
static inline void st7735_stream_pixel(unsigned int color, int amount) {
    volatile int* data_address = (volatile int*)0xF0000000;
    volatile int* command_address = (volatile int*)0xF0000004;

    int stream_cmd = (0x2C << 24) | (amount & 0x00FFFFFFFF);
    simulate << std::format("DCache[0x{:08x}] <- {:08x}\n", 0xF0000004, stream_cmd);
    simulate << std::format("DCache[0x{:08x}] <- {:08x}\n", 0xF0000000, color);
    simulate2 << std::format("Graphics Instruction : 0x{:08x} complete\n",stream_cmd);
    simulate2 << std::format("Graphics Instruction : 0x{:08x} complete\n",color);
}
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
    st7735_stream_pixel(color, (width * height) >> 1);
}
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
#define __ABS(EXPR) (((EXPR) > 0) ? (EXPR) : -(EXPR))

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
#define SCREEN_WIDTH 128
#define SCREEN_HEIGHT 160
#define RADIUS 5
typedef struct {
    signed x;
    signed y;
} vec2;
int main() {
    vec2 pos = {SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2};
    vec2 vel = {2, 2};

    st7735_draw_rectangle(0x00000000, 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    unsigned current_color = 0x001f001f;
    int i;
    for (i = 0; i < 32; i++) {
        st7735_draw_rectangle(
            0x00000000,
            pos.x - RADIUS,
            pos.y - RADIUS,
            RADIUS * 2,
            RADIUS * 2
        );

        pos.x += vel.x;
        pos.y += vel.y;

        if (pos.x + RADIUS >= SCREEN_WIDTH || pos.x - RADIUS <= 0) {
            vel.x = -vel.x;

            if (pos.x - RADIUS <= 0)
                pos.x = RADIUS;
            if (pos.x + RADIUS >= SCREEN_WIDTH)
                pos.x = SCREEN_WIDTH - RADIUS;
        }

        if (pos.y + RADIUS >= SCREEN_HEIGHT || pos.y - RADIUS <= 0) {
            vel.y = -vel.y;

            if (pos.y - RADIUS <= 0)
                pos.y = RADIUS;
            if (pos.y + RADIUS >= SCREEN_HEIGHT)
                pos.y = SCREEN_HEIGHT - RADIUS;
        }

        if (i == 31) {
            simulate << "----------------------LAST FRAME-----------------------\n";
        }
        st7735_draw_circle(current_color, pos.x, pos.y, RADIUS);
    }
}