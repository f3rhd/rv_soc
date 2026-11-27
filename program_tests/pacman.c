#include "../libc-baremetal/include/led.h"
#include "../libc-baremetal/include/serial.h"
#include "../libc-baremetal/include/graphics.h"
#include "../libc-baremetal/include/system.h"

// TODO: set this to your core's actual clock frequency in Hz
#define SYSTEM_HZ 100'000'000UL

#define SCREEN_WIDTH  128
#define SCREEN_HEIGHT 160

// 8px tiles -> 16x20 maze, which fills the whole 128x160 screen exactly
#define TILE  8
#define MAP_W (SCREEN_WIDTH / TILE)
#define MAP_H (SCREEN_HEIGHT / TILE)

#define NUM_GHOSTS    4
#define START_LIVES   3

#define BASE_TICK_MS  200   // one game step; shrinks each level
#define MIN_TICK_MS   110
#define FRIGHT_TICKS  40    // how long a power pellet lasts
#define FLASH_TICKS   10    // frightened ghosts blink white for the last N ticks
#define RESPAWN_DELAY 8     // ticks an eaten ghost waits before leaving home

#define C_WALL  '#'
#define C_DOT   '.'
#define C_POWER 'o'
#define C_EMPTY ' '

#define COLOR_BG     ST7735_BLACK
#define COLOR_WALL   ST7735_NAVY
#define COLOR_DOT    ST7735_LIGHTGREY
#define COLOR_PAC    ST7735_YELLOW
#define COLOR_SCARED ST7735_BLUE

// ---- maze template (read-only). '#' wall, '.' pellet, 'o' power pellet,
// ' ' empty. the two blank tiles in row 7 are where ghosts start ----
static const char MAP_TEMPLATE[MAP_H][MAP_W + 1] = {
    "################",
    "#..............#",
    "#.####.##.####.#",
    "#o............o#",
    "#.####.##.####.#",
    "#......##......#",
    "######.##.######",
    "######.  .######",
    "######.##.######",
    "#..............#",
    "#.####.##.####.#",
    "#...#......#...#",
    "#.#.#.####.#.#.#",
    "#.#..........#.#",
    "#.#.#.####.#.#.#",
    "#...#......#...#",
    "#.####.##.####.#",
    "#..............#",
    "#o............o#",
    "################",
};

static const unsigned GHOST_COLOR[NUM_GHOSTS] = {
    ST7735_RED, ST7735_PINK, ST7735_CYAN, ST7735_ORANGE
};

// direction tables: 0=up 1=left 2=down 3=right (also the tie-break order)
static const int DIR_DX[4] = { 0, -1, 0, 1 };
static const int DIR_DY[4] = { -1, 0, 1, 0 };

// ---- game state (all static, well under the 4KB static budget) ----
static char g_cells[MAP_H][MAP_W];   // live copy of the maze (pellets get eaten)
static int  g_pellets;

static int g_px, g_py;               // pacman tile position
static int g_pdx, g_pdy;             // current movement direction
static int g_want_dx, g_want_dy;     // direction the player asked for via UART
static int g_face_dx, g_face_dy;     // last direction actually moved (for the mouth)

static int g_gx[NUM_GHOSTS], g_gy[NUM_GHOSTS];
static int g_gdx[NUM_GHOSTS], g_gdy[NUM_GHOSTS];
static int g_gdelay[NUM_GHOSTS];     // ticks left before this ghost leaves home
static int g_gscared[NUM_GHOSTS];

static int      g_fright;            // ticks of frightened mode remaining
static unsigned g_tick;
static unsigned g_score;
static unsigned g_lives;
static unsigned g_level;
static unsigned g_seed;

unsigned rand_next(unsigned *state) {
    *state = (*state * 1103515245u + 12345u);
    return (*state >> 16) & 0x7FFF;
}

int is_wall(int x, int y) {
    if (x < 0 || x >= MAP_W || y < 0 || y >= MAP_H)
        return 1;
    return g_cells[y][x] == C_WALL;
}

// ---- drawing ----

// redraws one tile from the live maze state (wall / empty / pellet)
void draw_tile(int x, int y) {
    int px = x * TILE;
    int py = y * TILE;
    char c = g_cells[y][x];

    if (c == C_WALL) {
        rv_soc_draw_rectangle(COLOR_WALL, px, py, TILE, TILE);
        return;
    }
    rv_soc_draw_rectangle(COLOR_BG, px, py, TILE, TILE);
    if (c == C_DOT)
        rv_soc_draw_rectangle(COLOR_DOT, px + 3, py + 3, 2, 2);
    else if (c == C_POWER)
        rv_soc_draw_rectangle(COLOR_DOT, px + 2, py + 2, 4, 4);
}

void draw_all(void) {
    int x, y;
    for (y = 0; y < MAP_H; y++)
        for (x = 0; x < MAP_W; x++)
            draw_tile(x, y);
}

void draw_pacman(void) {
    int cx = g_px * TILE + 4;
    int cy = g_py * TILE + 4;

    // concentric circles fill the disc regardless of whether
    // rv_soc_draw_circle draws an outline or a filled shape
    rv_soc_draw_pixel(COLOR_PAC, cx, cy);
    rv_soc_draw_circle(COLOR_PAC, 1,cx, cy, 1);
    rv_soc_draw_circle(COLOR_PAC, 1,cx, cy, 2);
    rv_soc_draw_circle(COLOR_PAC, 1,cx, cy, 3);

    // mouth: a black wedge pointing the way we're facing, open on odd ticks
    if (g_tick & 1) {
        int fx = g_face_dx, fy = g_face_dy;
        if (fx == 1)
            rv_soc_draw_triangle(COLOR_BG, 0, cx, cy, cx + 3, cy - 3, cx + 3, cy + 3);
        else if (fx == -1)
            rv_soc_draw_triangle(COLOR_BG, 0, cx, cy, cx - 3, cy - 3, cx - 3, cy + 3);
        else if (fy == -1)
            rv_soc_draw_triangle(COLOR_BG, 0, cx, cy, cx - 3, cy - 3, cx + 3, cy - 3);
        else
            rv_soc_draw_triangle(COLOR_BG, 0, cx, cy, cx - 3, cy + 3, cx + 3, cy + 3);
    }
}

void draw_ghost(int i) {
    int px = g_gx[i] * TILE;
    int py = g_gy[i] * TILE;
    unsigned color = GHOST_COLOR[i];

    if (g_gscared[i]) {
        color = COLOR_SCARED;
        // blink white near the end so the player knows it's about to wear off
        if (g_fright <= FLASH_TICKS && (g_tick & 1))
            color = ST7735_WHITE;
    }

    rv_soc_draw_rectangle(color, px + 1, py + 1, 6, 6);
    rv_soc_draw_pixel(ST7735_WHITE, px + 2, py + 2);
    rv_soc_draw_pixel(ST7735_WHITE, px + 5, py + 2);
}

// ---- setup ----

void load_map(void) {
    int x, y;
    g_pellets = 0;
    for (y = 0; y < MAP_H; y++) {
        for (x = 0; x < MAP_W; x++) {
            g_cells[y][x] = MAP_TEMPLATE[y][x];
            if (g_cells[y][x] == C_DOT || g_cells[y][x] == C_POWER)
                g_pellets++;
        }
    }
    draw_all();
}

void respawn_ghost(int i, int delay_ticks) {
    g_gx[i] = 7 + (i & 1);   // the two blank tiles in row 7
    g_gy[i] = 7;
    g_gdx[i] = 0;
    g_gdy[i] = 0;
    g_gdelay[i] = delay_ticks;
    g_gscared[i] = 0;
}

void reset_positions(void) {
    int i;
    g_px = 7;
    g_py = 17;
    g_pdx = -1;  g_pdy = 0;
    g_want_dx = -1;  g_want_dy = 0;
    g_face_dx = -1;  g_face_dy = 0;

    // staggered release so they don't all pile onto you at once
    for (i = 0; i < NUM_GHOSTS; i++)
        respawn_ghost(i, i * 6);

    g_fright = 0;
}

// ---- input (UART, WASD) ----

void poll_input(void) {
    for (;;) {
        SERIAL_READ r = rv_soc_serial_read();
        if (!SERIAL_READ_VALID(r))
            break;

        // NOTE: & 0xFF on purpose - SERIAL_RESULT_BYTE in uart.h masks
        // with 0x0F, which would mangle ASCII ('w' 0x77 -> 0x07)
        char c = (char)(r & 0xFF);

        if (c == 'w' || c == 'W') { g_want_dx = 0;  g_want_dy = -1; }
        if (c == 's' || c == 'S') { g_want_dx = 0;  g_want_dy = 1;  }
        if (c == 'a' || c == 'A') { g_want_dx = -1; g_want_dy = 0;  }
        if (c == 'd' || c == 'D') { g_want_dx = 1;  g_want_dy = 0;  }
    }
}

void drain_input(void) {
    for (;;) {
        SERIAL_READ r = rv_soc_serial_read();
        if (!SERIAL_READ_VALID(r))
            break;
    }
}

// ---- game logic ----

void pacman_step(void) {
    // take the requested turn as soon as the way is clear, otherwise
    // keep going straight (classic pac-man cornering)
    if ((g_want_dx || g_want_dy) && !is_wall(g_px + g_want_dx, g_py + g_want_dy)) {
        g_pdx = g_want_dx;
        g_pdy = g_want_dy;
    }

    if (!g_pdx && !g_pdy)
        return;

    int nx = g_px + g_pdx;
    int ny = g_py + g_pdy;
    if (is_wall(nx, ny))
        return;

    g_px = nx;
    g_py = ny;
    g_face_dx = g_pdx;
    g_face_dy = g_pdy;

    char c = g_cells[ny][nx];
    if (c == C_DOT) {
        g_cells[ny][nx] = C_EMPTY;
        g_score += 10;
        g_pellets--;
    } else if (c == C_POWER) {
        g_cells[ny][nx] = C_EMPTY;
        g_score += 50;
        g_pellets--;
        g_fright = FRIGHT_TICKS;

        int i;
        for (i = 0; i < NUM_GHOSTS; i++) {
            g_gscared[i] = 1;
            // classic: ghosts turn around when frightened
            g_gdx[i] = -g_gdx[i];
            g_gdy[i] = -g_gdy[i];
        }
    }
}

// picks the next direction for ghost i and moves it one tile
void ghost_step(int i) {
    int tx = g_px, ty = g_py;

    // each ghost chases a different target so they don't clump
    if (i == 1) {                       // pink: aims ahead of pacman
        tx = g_px + 4 * g_pdx;
        ty = g_py + 4 * g_pdy;
    } else if (i == 2) {                // cyan: flanks relative to red
        int ax = g_px + 2 * g_pdx;
        int ay = g_py + 2 * g_pdy;
        tx = 2 * ax - g_gx[0];
        ty = 2 * ay - g_gy[0];
    } else if (i == 3) {                // orange: chases, but retreats when close
        int dx = g_gx[3] - g_px;
        int dy = g_gy[3] - g_py;
        if (dx * dx + dy * dy < 64) {
            tx = 1;
            ty = MAP_H - 2;
        }
    }

    int has_dir = (g_gdx[i] != 0 || g_gdy[i] != 0);
    int cand[4];
    int cn = 0;
    int best = -1;
    int best_dist = 0x7FFFFFFF;
    int d;

    for (d = 0; d < 4; d++) {
        int nx = g_gx[i] + DIR_DX[d];
        int ny = g_gy[i] + DIR_DY[d];
        if (is_wall(nx, ny))
            continue;
        // ghosts never reverse unless boxed into a dead end
        if (has_dir && DIR_DX[d] == -g_gdx[i] && DIR_DY[d] == -g_gdy[i])
            continue;

        cand[cn++] = d;
        int ddx = nx - tx;
        int ddy = ny - ty;
        int dist = ddx * ddx + ddy * ddy;
        if (dist < best_dist) {   // strict < keeps up/left/down/right priority
            best_dist = dist;
            best = d;
        }
    }

    if (cn == 0) {
        // dead end: only option is to turn back
        g_gdx[i] = -g_gdx[i];
        g_gdy[i] = -g_gdy[i];
    } else {
        if (g_gscared[i])
            best = cand[rand_next(&g_seed) % cn]; // frightened: wander randomly
        g_gdx[i] = DIR_DX[best];
        g_gdy[i] = DIR_DY[best];
    }

    int mx = g_gx[i] + g_gdx[i];
    int my = g_gy[i] + g_gdy[i];
    if (!is_wall(mx, my)) {
        g_gx[i] = mx;
        g_gy[i] = my;
    }
}

// returns 1 if pacman was killed by ghost i; eats the ghost if it's scared
int resolve_ghost_hit(int i) {
    if (g_gx[i] != g_px || g_gy[i] != g_py)
        return 0;

    if (g_gscared[i]) {
        g_score += 200;
        respawn_ghost(i, RESPAWN_DELAY);
        return 0;
    }
    return 1;
}

// one full game step. returns 0 = normal, 1 = pacman died, 2 = level cleared
int game_tick(void) {
    int i;
    int old_px = g_px, old_py = g_py;
    int old_gx[NUM_GHOSTS], old_gy[NUM_GHOSTS];
    for (i = 0; i < NUM_GHOSTS; i++) {
        old_gx[i] = g_gx[i];
        old_gy[i] = g_gy[i];
    }

    int died = 0;
    int won = 0;

    pacman_step();
    if (g_pellets == 0)
        won = 1;

    // checking right after pacman moves AND right after each ghost moves
    // also covers the "swap places" case with no extra bookkeeping
    for (i = 0; i < NUM_GHOSTS; i++) {
        if (resolve_ghost_hit(i)) {
            died = 1;
            break;
        }
    }

    if (!died) {
        for (i = 0; i < NUM_GHOSTS; i++) {
            if (g_gdelay[i] > 0) {
                g_gdelay[i]--;
                continue;
            }

            // ghosts are a bit slower than pacman (and scared ones slower still)
            int skip = g_gscared[i] ? ((g_tick & 1) != 0) : ((g_tick & 3) == 3);
            if (skip)
                continue;

            ghost_step(i);
            if (resolve_ghost_hit(i)) {
                died = 1;
                break;
            }
        }
    }

    if (g_fright > 0) {
        g_fright--;
        if (g_fright == 0)
            for (i = 0; i < NUM_GHOSTS; i++)
                g_gscared[i] = 0;
    }
    g_tick++;

    if (died)
        return 1; // caller redraws everything

    // restore every tile an entity touched (clears eaten pellets too),
    // then draw ghosts and finally pacman on top
    draw_tile(old_px, old_py);
    draw_tile(g_px, g_py);
    for (i = 0; i < NUM_GHOSTS; i++) {
        draw_tile(old_gx[i], old_gy[i]);
        draw_tile(g_gx[i], g_gy[i]);
    }
    for (i = 0; i < NUM_GHOSTS; i++)
        draw_ghost(i);
    draw_pacman();

    seg_write_hex(g_score);
    led_write(g_lives);

    return won ? 2 : 0;
}

void draw_entities(void) {
    int i;
    for (i = 0; i < NUM_GHOSTS; i++)
        draw_ghost(i);
    draw_pacman();
}

void start_level(void) {
    load_map();
    reset_positions();
    draw_entities();
    drain_input();
    seg_write_hex(g_score);
    led_write(g_lives);
}

void game_over_flash(void) {
    int i;
    for (i = 0; i < 4; i++) {
        rv_soc_draw_rectangle(ST7735_RED, 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        delay(250, SYSTEM_HZ);
        rv_soc_draw_rectangle(COLOR_BG, 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        delay(250, SYSTEM_HZ);
    }
}

int main() {
    g_seed = (unsigned)millis(SYSTEM_HZ) ^ 0xBADC0DEu;
    g_score = 0;
    g_lives = START_LIVES;
    g_level = 1;

    start_level();

    unsigned long last_tick = millis(SYSTEM_HZ);

    for (;;) {
        // poll constantly so no keypress is lost between game steps
        poll_input();

        unsigned long tick_ms = BASE_TICK_MS - 10 * (g_level - 1);
        if (tick_ms < MIN_TICK_MS)
            tick_ms = MIN_TICK_MS;

        unsigned long now = millis(SYSTEM_HZ);
        if (now - last_tick < tick_ms)
            continue;
        last_tick = now;

        int result = game_tick();

        if (result == 1) {
            // caught by a ghost
            g_lives--;
            led_write(g_lives);
            delay(700, SYSTEM_HZ);

            if (g_lives == 0) {
                game_over_flash();
                g_score = 0;
                g_lives = START_LIVES;
                g_level = 1;
                start_level();
            } else {
                draw_all();          // pellets stay eaten, entities reset
                reset_positions();
                draw_entities();
                drain_input();
            }
            last_tick = millis(SYSTEM_HZ);
        } else if (result == 2) {
            // every pellet eaten: next level, a bit faster
            delay(700, SYSTEM_HZ);
            g_level++;
            start_level();
            last_tick = millis(SYSTEM_HZ);
        }
    }
}
