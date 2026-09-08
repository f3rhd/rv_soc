#include "../libc-baremetal/include/led.h"
#include "../libc-baremetal/include/st7735.h"

#define SCREEN_WIDTH  128
#define SCREEN_HEIGHT 160

#define CELL_PX 3
#define MAZE_W (SCREEN_WIDTH / CELL_PX)   
#define MAZE_H (SCREEN_HEIGHT / CELL_PX)  


#define WALL_N 1
#define WALL_E 2
#define WALL_S 4
#define WALL_W 8
#define ALL_WALLS (WALL_N | WALL_E | WALL_S | WALL_W)

#define COLOR_WALL      ST7735_BLACK
#define COLOR_PATH      ST7735_WHITE
#define COLOR_VISITING  ST7735_YELLOW
#define COLOR_SOLUTION  ST7735_RED
#define COLOR_START     ST7735_GREEN
#define COLOR_END       ST7735_BLUE

typedef struct {
    signed x;
    signed y;
} vec2;

void delay(unsigned dly_amount) {
    for (volatile int i = 0; i < dly_amount; i++)
        ;
}


unsigned rand_next(unsigned *state) {
    *state = (*state * 1103515245u + 12345u);
    return (*state >> 16) & 0x7FFF;
}


int dir_dx(int d) { return (d == 1) ? 1 : (d == 3) ? -1 : 0; }
int dir_dy(int d) { return (d == 0) ? -1 : (d == 2) ? 1 : 0; }
int dir_bit(int d) { return 1 << d; }
int opposite_bit(int d) { return 1 << ((d + 2) % 4); }


void draw_cell(unsigned char wall_mask, int cx, int cy, unsigned floor_color) {
    int px = cx * CELL_PX;
    int py = cy * CELL_PX;

    st7735_draw_rectangle(floor_color, px, py, CELL_PX, CELL_PX);

    if (wall_mask & WALL_N)
        st7735_draw_rectangle(COLOR_WALL, px, py, CELL_PX, 1);
    if (wall_mask & WALL_S)
        st7735_draw_rectangle(COLOR_WALL, px, py + CELL_PX - 1, CELL_PX, 1);
    if (wall_mask & WALL_W)
        st7735_draw_rectangle(COLOR_WALL, px, py, 1, CELL_PX);
    if (wall_mask & WALL_E)
        st7735_draw_rectangle(COLOR_WALL, px + CELL_PX - 1, py, 1, CELL_PX);
}




void generate_maze(unsigned char walls[MAZE_H][MAZE_W], unsigned *seed) {
    unsigned char visited[MAZE_H][MAZE_W];
    vec2 stack[MAZE_W * MAZE_H];
    int sp = 0; 

    int x, y;
    for (y = 0; y < MAZE_H; y++) {
        for (x = 0; x < MAZE_W; x++) {
            walls[y][x] = ALL_WALLS;
            visited[y][x] = 0;
        }
    }

    vec2 start = {0, 0};
    visited[start.y][start.x] = 1;
    stack[sp++] = start;
    draw_cell(walls[start.y][start.x], start.x, start.y, COLOR_VISITING);

    while (sp > 0) {
        vec2 cur = stack[sp - 1];

        
        int valid_dirs[4];
        int valid_count = 0;
        int d;
        for (d = 0; d < 4; d++) {
            int nx = cur.x + dir_dx(d);
            int ny = cur.y + dir_dy(d);
            if (nx >= 0 && nx < MAZE_W && ny >= 0 && ny < MAZE_H && !visited[ny][nx]) {
                valid_dirs[valid_count++] = d;
            }
        }

        if (valid_count == 0) {
            
            draw_cell(walls[cur.y][cur.x], cur.x, cur.y, COLOR_PATH);
            sp--;
            continue;
        }

        int chosen = valid_dirs[rand_next(seed) % valid_count];
        int nx = cur.x + dir_dx(chosen);
        int ny = cur.y + dir_dy(chosen);

        
        walls[cur.y][cur.x] &= ~dir_bit(chosen);
        walls[ny][nx] &= ~opposite_bit(chosen);

        visited[ny][nx] = 1;
        stack[sp++] = (vec2){nx, ny};

        draw_cell(walls[cur.y][cur.x], cur.x, cur.y, COLOR_VISITING);
        draw_cell(walls[ny][nx], nx, ny, COLOR_VISITING);

        seg_write_hex(sp);
        delay(4000);
    }

    
    for (y = 0; y < MAZE_H; y++)
        for (x = 0; x < MAZE_W; x++)
            draw_cell(walls[y][x], x, y, COLOR_PATH);
}



void solve_maze(unsigned char walls[MAZE_H][MAZE_W]) {
    unsigned char visited[MAZE_H][MAZE_W];
    signed parent[MAZE_H][MAZE_W]; 
    vec2 queue[MAZE_W * MAZE_H];
    int qhead = 0, qtail = 0;

    int x, y;
    for (y = 0; y < MAZE_H; y++) {
        for (x = 0; x < MAZE_W; x++) {
            visited[y][x] = 0;
            parent[y][x] = -1;
        }
    }

    vec2 start = {0, 0};
    vec2 end = {MAZE_W - 1, MAZE_H - 1};

    visited[start.y][start.x] = 1;
    queue[qtail++] = start;

    unsigned steps = 0;

    while (qhead < qtail) {
        vec2 cur = queue[qhead++];

        if (cur.x == end.x && cur.y == end.y)
            break;

        int d;
        for (d = 0; d < 4; d++) {
            
            if (walls[cur.y][cur.x] & dir_bit(d))
                continue;

            int nx = cur.x + dir_dx(d);
            int ny = cur.y + dir_dy(d);
            if (nx < 0 || nx >= MAZE_W || ny < 0 || ny >= MAZE_H)
                continue;
            if (visited[ny][nx])
                continue;

            visited[ny][nx] = 1;
            parent[ny][nx] = cur.y * MAZE_W + cur.x;
            queue[qtail++] = (vec2){nx, ny};

            
            draw_cell(walls[ny][nx], nx, ny, COLOR_VISITING);
            steps++;
            seg_write_hex(steps);
            delay(3000);
        }
    }

    
    signed idx = end.y * MAZE_W + end.x;
    unsigned path_len = 0;
    while (idx != -1) {
        int cx = idx % MAZE_W;
        int cy = idx / MAZE_W;
        draw_cell(walls[cy][cx], cx, cy, COLOR_SOLUTION);
        idx = parent[cy][cx];
        path_len++;
        led_write(path_len);
        delay(15000);
    }

    draw_cell(walls[start.y][start.x], start.x, start.y, COLOR_START);
    draw_cell(walls[end.y][end.x], end.x, end.y, COLOR_END);
}

int main() {
    unsigned seed = 0xBEEFu; 
    unsigned char maze[MAZE_H][MAZE_W]; 

    st7735_draw_rectangle(ST7735_BLACK, 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);

    for (;;) {
        generate_maze(maze, &seed);
        delay(200000); 
        solve_maze(maze);
        delay(600000); 

        seed = seed * 2654435761u + 12345u;
        st7735_draw_rectangle(ST7735_BLACK, 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    }
}