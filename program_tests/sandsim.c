#include "../libc-baremetal/include/led.h"
#include "../libc-baremetal/include/st7735.h"
#include "../libc-baremetal/include/pin.h"

#define SCREEN_WIDTH  128
#define SCREEN_HEIGHT 160

#define CELL_PX 4
#define GRID_W (SCREEN_WIDTH / CELL_PX)   
#define GRID_H (SCREEN_HEIGHT / CELL_PX)  

#define PIN_POUR  8   
#define PIN_CLEAR 9   
#define PIN_LEFT  10  
#define PIN_RIGHT 11  

#define MOVE_COOLDOWN_TICKS 4   
#define POUR_COOLDOWN_TICKS 2   

#define COLOR_BG      ST7735_BLACK
#define COLOR_SAND    ST7735_YELLOW
#define COLOR_CURSOR  ST7735_RED

#define EMPTY 0
#define SAND  1

void delay(unsigned dly_amount) {
    for (volatile int i = 0; i < dly_amount; i++)
        ;
}


unsigned rand_next(unsigned *state) {
    *state = (*state * 1103515245u + 12345u);
    return (*state >> 16) & 0x7FFF;
}

void draw_cell(int gx, int gy, unsigned color) {
    st7735_draw_rectangle(color, gx * CELL_PX, gy * CELL_PX, CELL_PX, CELL_PX);
}

void clear_grid(unsigned char grid[GRID_H][GRID_W]) {
    int x, y;
    for (y = 0; y < GRID_H; y++)
        for (x = 0; x < GRID_W; x++)
            grid[y][x] = EMPTY;
    st7735_draw_rectangle(COLOR_BG, 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
}




void simulate_step(unsigned char grid[GRID_H][GRID_W], unsigned *seed) {
    int x, y;
    for (y = GRID_H - 2; y >= 0; y--) {
        for (x = 0; x < GRID_W; x++) {
            if (grid[y][x] != SAND)
                continue;

            
            if (grid[y + 1][x] == EMPTY) {
                grid[y][x] = EMPTY;
                grid[y + 1][x] = SAND;
                draw_cell(x, y, COLOR_BG);
                draw_cell(x, y + 1, COLOR_SAND);
                continue;
            }

            
            
            int try_left_first = rand_next(seed) & 1;
            int dx1 = try_left_first ? -1 : 1;
            int dx2 = -dx1;

            int nx1 = x + dx1;
            int nx2 = x + dx2;

            if (nx1 >= 0 && nx1 < GRID_W && grid[y + 1][nx1] == EMPTY) {
                grid[y][x] = EMPTY;
                grid[y + 1][nx1] = SAND;
                draw_cell(x, y, COLOR_BG);
                draw_cell(nx1, y + 1, COLOR_SAND);
            } else if (nx2 >= 0 && nx2 < GRID_W && grid[y + 1][nx2] == EMPTY) {
                grid[y][x] = EMPTY;
                grid[y + 1][nx2] = SAND;
                draw_cell(x, y, COLOR_BG);
                draw_cell(nx2, y + 1, COLOR_SAND);
            }
            
        }
    }
}

int main() {
    set_pin_mode(PIN_POUR, PIN_INPUT);
    set_pin_mode(PIN_CLEAR, PIN_INPUT);
    set_pin_mode(PIN_LEFT, PIN_INPUT);
    set_pin_mode(PIN_RIGHT, PIN_INPUT);

    unsigned char grid[GRID_H][GRID_W]; 
    unsigned seed = 0x5A5Du;            

    int spawner_x = GRID_W / 2;
    int prev_clear = 0;

    unsigned move_cooldown = 0;
    unsigned pour_cooldown = 0;

    clear_grid(grid);

    for (;;) {
        int cur_pour  = read_pin(PIN_POUR);
        int cur_clear = read_pin(PIN_CLEAR);
        int cur_left  = read_pin(PIN_LEFT);
        int cur_right = read_pin(PIN_RIGHT);

        
        if (cur_clear && !prev_clear) {
            clear_grid(grid);
        }
        prev_clear = cur_clear;

        
        
        if (move_cooldown > 0)
            move_cooldown--;

        
        if (grid[0][spawner_x] == EMPTY)
            draw_cell(spawner_x, 0, COLOR_BG);

        if (move_cooldown == 0 && (cur_left || cur_right)) {
            if (cur_left && spawner_x > 0)
                spawner_x--;
            if (cur_right && spawner_x < GRID_W - 1)
                spawner_x++;
            move_cooldown = MOVE_COOLDOWN_TICKS;
        }

        
        
        if (pour_cooldown > 0)
            pour_cooldown--;

        if (cur_pour && pour_cooldown == 0) {
            if (grid[0][spawner_x] == EMPTY) {
                grid[0][spawner_x] = SAND;
                draw_cell(spawner_x, 0, COLOR_SAND);
            }
            pour_cooldown = POUR_COOLDOWN_TICKS;
        }

        
        simulate_step(grid, &seed);

        
        
        if (grid[0][spawner_x] == EMPTY)
            draw_cell(spawner_x, 0, COLOR_CURSOR);

        
        unsigned grain_count = 0;
        int x, y;
        for (y = 0; y < GRID_H; y++)
            for (x = 0; x < GRID_W; x++)
                if (grid[y][x] == SAND)
                    grain_count++;

        seg_write_hex(grain_count);
        led_write(spawner_x);

        delay(20000);
    }
}