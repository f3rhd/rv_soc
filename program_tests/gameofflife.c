#include "../../libc-baremetal/include/led.h"
#include "../../libc-baremetal/include/st7735.h"

#define SCREEN_WIDTH 128
#define SCREEN_HEIGHT 160
#define CELL_SIZE 4
#define GRID_W (SCREEN_WIDTH / CELL_SIZE)   // 32
#define GRID_H (SCREEN_HEIGHT / CELL_SIZE)  // 40

#define ALIVE_COLOR ST7735_GREEN
#define DEAD_COLOR  ST7735_BLACK
#define EXTINCTION_THRESHOLD 50

void delay(unsigned dly_amount) {
    for (volatile int i = 0; i < dly_amount; i++)
        ;
}

unsigned rand_next(unsigned *state) {
    *state = (*state * 1103515245u + 12345u);
    return (*state >> 16) & 0x7FFF;
}

void draw_cell(int gx, int gy, unsigned color) {
    st7735_draw_rectangle(
        color,
        gx * CELL_SIZE,
        gy * CELL_SIZE,
        CELL_SIZE,
        CELL_SIZE
    );
}

unsigned count_neighbors(unsigned char grid[GRID_H][GRID_W], int x, int y) {
    unsigned count = 0;
    int dx, dy;
    for (dy = -1; dy <= 1; dy++) {
        for (dx = -1; dx <= 1; dx++) {
            if (dx == 0 && dy == 0)
                continue;
            int nx = (x + dx + GRID_W) % GRID_W;
            int ny = (y + dy + GRID_H) % GRID_H;
            count += grid[ny][nx];
        }
    }
    return count;
}

void seed_grid(unsigned char grid[GRID_H][GRID_W], unsigned *seed) {
    int x, y;
    for (y = 0; y < GRID_H; y++) {
        for (x = 0; x < GRID_W; x++) {
            unsigned char alive = (rand_next(seed) & 1) ? 1 : 0;
            grid[y][x] = alive;
            draw_cell(x, y, alive ? ALIVE_COLOR : DEAD_COLOR);
        }
    }
}

int main() {
    // both generations live entirely on the stack, uninitialized until
    // we fill them at runtime - nothing here goes in .data/.bss
    unsigned char grid_a[GRID_H][GRID_W];
    unsigned char grid_b[GRID_H][GRID_W];

    unsigned char (*cur)[GRID_W] = grid_a;
    unsigned char (*nxt)[GRID_W] = grid_b;

    unsigned seed = 0xACE1u; // arbitrary runtime seed, lives on the stack
    int x, y;
    unsigned generation = 0;

    st7735_draw_rectangle(ST7735_BLACK, 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    seed_grid(cur, &seed);

    for (;;) {
        unsigned alive_count = 0;

        for (y = 0; y < GRID_H; y++) {
            for (x = 0; x < GRID_W; x++) {
                unsigned n = count_neighbors(cur, x, y);
                unsigned char was_alive = cur[y][x];
                unsigned char will_live;

                if (was_alive)
                    will_live = (n == 2 || n == 3) ? 1 : 0;
                else
                    will_live = (n == 3) ? 1 : 0;

                nxt[y][x] = will_live;

                if (will_live != was_alive) {
                    draw_cell(x, y, will_live ? ALIVE_COLOR : DEAD_COLOR);
                }

                if (will_live)
                    alive_count++;
            }
        }

        unsigned char (*tmp)[GRID_W] = cur;
        cur = nxt;
        nxt = tmp;

        generation++;
        seg_write_hex(generation);
        led_write(alive_count);

        if (alive_count < EXTINCTION_THRESHOLD) {
            seed = seed * 2654435761u + generation; 
            seed_grid(cur, &seed);
            generation = 0;
        }

        delay(80000);
    }
}