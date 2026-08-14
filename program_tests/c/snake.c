#include "../../libc-baremetal/include/led.h"
#include "../../libc-baremetal/include/pin.h"
#include "../../libc-baremetal/include/st7735.h"


#define SCREEN_WIDTH 128
#define SCREEN_HEIGHT 160

#define CELL_PX 8
#define GRID_W (SCREEN_WIDTH / CELL_PX)
#define GRID_H (SCREEN_HEIGHT / CELL_PX)
#define MAX_LEN (GRID_W * GRID_H)

#define PIN_UP 11
#define PIN_DOWN 19
#define PIN_LEFT 9
#define PIN_RIGHT 8

#define COLOR_BG ST7735_BLACK
#define COLOR_SNAKE ST7735_GREEN
#define COLOR_HEAD ST7735_WHITE
#define COLOR_FOOD ST7735_RED

#define WRAPAROUND_WALLS 1

typedef struct {
    signed x;
    signed y;
} vec2;

void delay(unsigned dly_amount) {
    for (volatile int i = 0; i < dly_amount; i++)
        ;
}

unsigned rand_next(unsigned* state) {
    *state = (*state * 1103515245u + 12345u);
    return (*state >> 16) & 0x7FFF;
}

void draw_cell(int gx, int gy, unsigned color) {
    st7735_draw_rectangle(color, gx * CELL_PX, gy * CELL_PX, CELL_PX, CELL_PX);
}

int is_on_snake(vec2 body[MAX_LEN], int len, int x, int y) {
    int i;
    for (i = 0; i < len; i++) {
        if (body[i].x == x && body[i].y == y)
            return 1;
    }
    return 0;
}

void place_food(vec2* food, vec2 body[MAX_LEN], int len, unsigned* seed) {

    for (;;) {
        int fx = rand_next(seed) % GRID_W;
        int fy = rand_next(seed) % GRID_H;
        if (!is_on_snake(body, len, fx, fy)) {
            food->x = fx;
            food->y = fy;
            return;
        }
    }
}

int wrap_coord(int v, int max) {
    return ((v % max) + max) % max;
}

int main() {
    set_pin_mode(PIN_UP, PIN_INPUT);
    set_pin_mode(PIN_DOWN, PIN_INPUT);
    set_pin_mode(PIN_LEFT, PIN_INPUT);
    set_pin_mode(PIN_RIGHT, PIN_INPUT);

    int prev_up = 0, prev_down = 0, prev_left = 0, prev_right = 0;

    unsigned seed = 0xC0FFEEu;

restart:;
    vec2 body[MAX_LEN];
    int length = 3;

    vec2 dir = {1, 0};
    vec2 pending_dir = {1, 0};

    int start_x = GRID_W / 2;
    int start_y = GRID_H / 2;
    int i;
    for (i = 0; i < length; i++) {
        body[i].x = start_x - i;
        body[i].y = start_y;
    }

    vec2 food;
    place_food(&food, body, length, &seed);

    unsigned score = 0;
    unsigned alive = 1;

    st7735_draw_rectangle(COLOR_BG, 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    for (i = 0; i < length; i++)
        draw_cell(body[i].x, body[i].y, COLOR_SNAKE);
    draw_cell(body[0].x, body[0].y, COLOR_HEAD);
    draw_cell(food.x, food.y, COLOR_FOOD);

    while (alive) {

        int cur_up = read_pin(PIN_UP);
        int cur_down = read_pin(PIN_DOWN);
        int cur_left = read_pin(PIN_LEFT);
        int cur_right = read_pin(PIN_RIGHT);

        if (cur_up && !prev_up && dir.y == 0) {
            pending_dir.x = 0;
            pending_dir.y = -1;
        }
        if (cur_down && !prev_down && dir.y == 0) {
            pending_dir.x = 0;
            pending_dir.y = 1;
        }
        if (cur_left && !prev_left && dir.x == 0) {
            pending_dir.x = -1;
            pending_dir.y = 0;
        }
        if (cur_right && !prev_right && dir.x == 0) {
            pending_dir.x = 1;
            pending_dir.y = 0;
        }

        prev_up = cur_up;
        prev_down = cur_down;
        prev_left = cur_left;
        prev_right = cur_right;

        dir = pending_dir;

        vec2 new_head;
        new_head.x = body[0].x + dir.x;
        new_head.y = body[0].y + dir.y;

#if WRAPAROUND_WALLS

        new_head.x = wrap_coord(new_head.x, GRID_W);
        new_head.y = wrap_coord(new_head.y, GRID_H);
#else

        if (new_head.x < 0 || new_head.x >= GRID_W || new_head.y < 0 ||
            new_head.y >= GRID_H) {
            alive = 0;
            break;
        }
#endif

        int check_len = length;
        int ate = (new_head.x == food.x && new_head.y == food.y);
        if (!ate)
            check_len = length - 1;

        if (is_on_snake(body, check_len, new_head.x, new_head.y)) {
            alive = 0;
            break;
        }

        vec2 old_tail = body[length - 1];

        int j;
        for (j = length - 1; j > 0; j--)
            body[j] = body[j - 1];
        body[0] = new_head;

        if (ate) {

            if (length < MAX_LEN) {
                body[length] = old_tail;
                length++;
            }
            score++;
            place_food(&food, body, length, &seed);
            draw_cell(food.x, food.y, COLOR_FOOD);
        } else {

            draw_cell(old_tail.x, old_tail.y, COLOR_BG);
        }

        draw_cell(body[1].x, body[1].y, COLOR_SNAKE);
        draw_cell(body[0].x, body[0].y, COLOR_HEAD);

        seg_write_hex(score);
        led_write(length);

        delay(60000 * 15);
    }

    for (i = 0; i < 6; i++) {
        st7735_draw_rectangle(ST7735_RED, 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        delay(150000);
        st7735_draw_rectangle(COLOR_BG, 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        delay(150000);
    }

    seed = seed * 2654435761u + score;
    goto restart;
}