#include "../libc-baremetal/include/led.h"
#include "../libc-baremetal/include/graphics.h"

#define SCREEN_WIDTH 128
#define SCREEN_HEIGHT 160

#define MAP_W 12
#define MAP_H 12

#define MOVE_SPEED 0.035f
#define TURN_SPEED 0.045f
#define COLLIDE_RADIUS 0.20f

#define COLOR_CEIL ST7735_BLUE
#define COLOR_FLOOR ST7735_BLACK

#define PI 3.14159265f
#define TWO_PI 6.28318530f

float my_fabsf(float x) {
    return (x < 0.0f) ? -x : x;
}

float wrap_angle(float a) {
    while (a > PI)
        a -= TWO_PI;
    while (a < -PI)
        a += TWO_PI;
    return a;
}

float my_sinf(float x) {
    x = wrap_angle(x);
    float x2 = x * x;
    float x3 = x2 * x;
    float x5 = x3 * x2;
    float x7 = x5 * x2;
    return x - (x3 / 6.0f) + (x5 / 120.0f) - (x7 / 5040.0f);
}

float my_cosf(float x) {
    x = wrap_angle(x);
    float x2 = x * x;
    float x4 = x2 * x2;
    float x6 = x4 * x2;
    return 1.0f - (x2 / 2.0f) + (x4 / 24.0f) - (x6 / 720.0f);
}

static const unsigned char MAP[MAP_H][MAP_W] = {
    {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
    {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
    {1, 0, 1, 1, 1, 0, 1, 1, 1, 1, 0, 1},
    {1, 0, 1, 0, 0, 0, 1, 0, 0, 1, 0, 1},
    {1, 0, 1, 0, 2, 2, 1, 0, 2, 1, 0, 1},
    {1, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 1},
    {1, 0, 1, 1, 1, 1, 1, 1, 0, 1, 0, 1},
    {1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1},
    {1, 2, 2, 1, 0, 2, 0, 1, 1, 1, 0, 1},
    {1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1},
    {1, 0, 0, 0, 0, 1, 1, 1, 1, 1, 0, 1},
    {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
};

static const unsigned WALL_COLOR[3] = {ST7735_BLACK, ST7735_RED, ST7735_GREEN};
static const unsigned WALL_COLOR_DARK[3] = {
    ST7735_BLACK,
    ST7735_MAGENTA,
    ST7735_CYAN
};

static float g_pos_x;
static float g_pos_y;
static float g_dir_x;
static float g_dir_y;
static float g_plane_x;
static float g_plane_y;
static float g_angle;
static unsigned g_turn_bias;

/* Per-column results from the DDA pass, cached so the row pass can
 * look up "what does column x show at height y" without re-raycasting. */
static int g_draw_start[SCREEN_WIDTH];
static int g_draw_end[SCREEN_WIDTH];
static unsigned g_col_color[SCREEN_WIDTH];

int map_is_wall(int mx, int my) {
    if (mx < 0 || mx >= MAP_W || my < 0 || my >= MAP_H)
        return 1;
    return MAP[my][mx] != 0;
}

int would_collide(float x, float y) {
    if (map_is_wall((int)(x - COLLIDE_RADIUS), (int)(y - COLLIDE_RADIUS)))
        return 1;
    if (map_is_wall((int)(x + COLLIDE_RADIUS), (int)(y - COLLIDE_RADIUS)))
        return 1;
    if (map_is_wall((int)(x - COLLIDE_RADIUS), (int)(y + COLLIDE_RADIUS)))
        return 1;
    if (map_is_wall((int)(x + COLLIDE_RADIUS), (int)(y + COLLIDE_RADIUS)))
        return 1;
    return 0;
}

void recompute_direction_vectors(void) {
    g_dir_x = my_cosf(g_angle);
    g_dir_y = my_sinf(g_angle);
    g_plane_x = -g_dir_y * 0.66f;
    g_plane_y = g_dir_x * 0.66f;
}

void auto_move(void) {
    float next_x = g_pos_x + g_dir_x * MOVE_SPEED;
    float next_y = g_pos_y + g_dir_y * MOVE_SPEED;

    if (!would_collide(next_x, next_y)) {
        g_pos_x = next_x;
        g_pos_y = next_y;
    } else {
        float turn = (g_turn_bias) ? TURN_SPEED : -TURN_SPEED;
        g_angle += turn;
        recompute_direction_vectors();
    }
}

/* Casts the ray for column x and stores the hit info instead of drawing.
 * This is the same DDA as before; only the "draw now" step moved out. */
void compute_column(int x) {
    float camera_x = 2.0f * x / (float)SCREEN_WIDTH - 1.0f;
    float ray_dir_x = g_dir_x + g_plane_x * camera_x;
    float ray_dir_y = g_dir_y + g_plane_y * camera_x;

    int map_x = (int)g_pos_x;
    int map_y = (int)g_pos_y;

    float delta_dist_x =
        (ray_dir_x == 0.0f) ? 1e30f : my_fabsf(1.0f / ray_dir_x);
    float delta_dist_y =
        (ray_dir_y == 0.0f) ? 1e30f : my_fabsf(1.0f / ray_dir_y);

    int step_x, step_y;
    float side_dist_x, side_dist_y;

    if (ray_dir_x < 0.0f) {
        step_x = -1;
        side_dist_x = (g_pos_x - map_x) * delta_dist_x;
    } else {
        step_x = 1;
        side_dist_x = (map_x + 1.0f - g_pos_x) * delta_dist_x;
    }
    if (ray_dir_y < 0.0f) {
        step_y = -1;
        side_dist_y = (g_pos_y - map_y) * delta_dist_y;
    } else {
        step_y = 1;
        side_dist_y = (map_y + 1.0f - g_pos_y) * delta_dist_y;
    }

    int hit = 0;
    int side = 0;
    int wall_type = 1;

    while (!hit) {
        if (side_dist_x < side_dist_y) {
            side_dist_x += delta_dist_x;
            map_x += step_x;
            side = 0;
        } else {
            side_dist_y += delta_dist_y;
            map_y += step_y;
            side = 1;
        }

        if (map_x < 0 || map_x >= MAP_W || map_y < 0 || map_y >= MAP_H) {
            hit = 1;
            wall_type = 1;
            break;
        }
        if (MAP[map_y][map_x] != 0) {
            hit = 1;
            wall_type = MAP[map_y][map_x];
        }
    }

    float perp_dist = (side == 0) ? (side_dist_x - delta_dist_x)
                                  : (side_dist_y - delta_dist_y);
    if (perp_dist < 0.05f)
        perp_dist = 0.05f;

    int line_height = (int)(SCREEN_HEIGHT / perp_dist);
    int draw_start = -line_height / 2 + SCREEN_HEIGHT / 2;
    int draw_end = line_height / 2 + SCREEN_HEIGHT / 2;
    if (draw_start < 0)
        draw_start = 0;
    if (draw_end >= SCREEN_HEIGHT)
        draw_end = SCREEN_HEIGHT - 1;

    g_draw_start[x] = draw_start;
    g_draw_end[x] = draw_end;
    g_col_color[x] = (side == 1) ? WALL_COLOR_DARK[wall_type] : WALL_COLOR[wall_type];
}

static unsigned pixel_color(int x, int y) {
    if (y < g_draw_start[x])
        return COLOR_CEIL;
    if (y > g_draw_end[x])
        return COLOR_FLOOR;
    return g_col_color[x];
}

void render_row(int y) {
    int run_start = 0;
    unsigned run_color = pixel_color(0, y);

    for (int x = 1; x < SCREEN_WIDTH; x++) {
        unsigned c = pixel_color(x, y);
        if (c != run_color) {
            rv_soc_draw_rectangle(run_color, run_start, y, x - run_start, 1);
            run_start = x;
            run_color = c;
        }
    }
    rv_soc_draw_rectangle(run_color, run_start, y, SCREEN_WIDTH - run_start, 1);
}

void render_frame(void) {
    int x, y;

    for (x = 0; x < SCREEN_WIDTH; x++) {
        compute_column(x);
    }

    for (y = 0; y < SCREEN_HEIGHT; y++) {
        render_row(y);
    }
}

int main() {
    g_pos_x = 1.5f;
    g_pos_y = 1.5f;
    g_angle = 0.0f;
    g_turn_bias = 1;

    recompute_direction_vectors();

    unsigned frame = 0;

    for (;;) {
        render_frame();
        auto_move();

        frame++;
        seg_write_hex(frame);
        led_write(
            ((unsigned)(g_pos_x * 10.0f) << 8) | (unsigned)(g_pos_y * 10.0f)
        );
    }
}