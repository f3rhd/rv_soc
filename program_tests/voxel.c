#include "../libc-baremetal/include/led.h"
#include "../libc-baremetal/include/serial.h"
#include "../libc-baremetal/include/graphics.h"

// Pseudo-Minecraft: a small block world rendered with a voxel raycaster.
//
//   UART terminal (the laptop):
//     arrow keys   look around (left/right = yaw, up/down = pitch)
//     W A S D      walk forward / strafe left / back / strafe right
//     B (or X)     break the block you're looking at
//     P (or V)     place the selected block on the face you're looking at
//     1..6         select block: grass dirt stone sand wood leaves
//     R            generate a brand new world
//     I J K L      alternate look keys, for terminals without arrow keys

#define SCREEN_WIDTH  128
#define SCREEN_HEIGHT 160

// The 3D view is rendered at low resolution: one ray per CELL_PX x CELL_PX
// block of screen pixels. 4 -> 32x40 rays. Use 8 for a faster, chunkier view.
#define CELL_PX 4
#define GW (SCREEN_WIDTH  / CELL_PX)
#define GH (SCREEN_HEIGHT / CELL_PX)


// world size in blocks: x east, y up, z north
#define WX 32
#define WY 16
#define WZ 32
#define WATER_Y 4          // water fills empty cells up to and including this layer

// block types
#define AIR    0
#define GRASS  1
#define DIRT   2
#define STONE  3
#define SAND   4
#define WATER  5
#define WOOD   6
#define LEAVES 7

#define EYE_HEIGHT   1.62f
#define REACH        6.0f
#define FOG_DIST     26.0f
#define MAX_RAY_DIST 40.0f

#define TAN_HALF_FOV_X 0.78f
#define TAN_HALF_FOV_Y (TAN_HALF_FOV_X * GH / GW)

#define MOVE_STEP      0.35f   // blocks per W/A/S/D event

#define PI     3.14159265f
#define TWO_PI 6.28318530f
#define HALF_PI 1.57079633f

// escape-sequence parser states (arrow keys arrive as ESC [ A.. or ESC O A..)
#define ESC_NONE 0
#define ESC_GOT  1
#define ESC_CSI  2
#define ESC_SS3  3

// ---- read-only tables (a few dozen bytes of .rodata) ----
static const unsigned char BASE_RGB[8][3] = {
    {  0,   0,   0},  // AIR (unused)
    { 92, 168,  60},  // GRASS
    {134,  96,  67},  // DIRT
    {125, 125, 125},  // STONE
    {219, 207, 142},  // SAND
    { 50,  90, 200},  // WATER
    {102,  81,  49},  // WOOD
    { 50, 120,  40},  // LEAVES
};

static const unsigned char HOTBAR[6] = { GRASS, DIRT, STONE, SAND, WOOD, LEAVES };

// sky gradient: horizon colour, and the colour straight up
static const unsigned char SKY_HORIZON[3] = {178, 214, 255};
static const unsigned char SKY_ZENITH[3]  = { 90, 145, 235};

// everything mutable lives in one struct on the stack: the world alone is
// 16KB, far over the 4KB STATIC_RESERVE budget in build.sh
typedef struct {
    unsigned char  world[WY][WZ][WX];
    unsigned short frame[GH][GW];    // colours we want on screen
    unsigned short shadow[GH][GW];   // colours currently on screen
    float cx, cz;                    // player position (horizontal)
    float yaw, pitch;
    int   selected;                  // index into HOTBAR
    unsigned seed;
    int   esc_state;
} Game;

typedef struct {
    int bx, by, bz;   // the block that was hit
    int px, py, pz;   // the empty cell just before it (where a placed block goes)
    int face;         // 0 = x side, 1 = top, 2 = bottom, 3 = z side
    int block;
    float t;          // distance along the ray
    float hy;         // height within the block where the ray hit (0..1)
} Hit;

// ---- math (no libm on this target) ----

float my_fabsf(float x) { return x < 0.0f ? -x : x; }

float wrap_angle(float a) {
    while (a > PI)  a -= TWO_PI;
    while (a < -PI) a += TWO_PI;
    return a;
}

// Folds the angle into [-pi/2, pi/2] before the Taylor series, where the
// 7th-order polynomial is accurate to ~2e-4. (Taylor on the full [-pi, pi]
// range drifts by several percent near the ends, which would visibly warp
// the camera basis vectors.)
float my_sinf(float x) {
    x = wrap_angle(x);

    if (x > HALF_PI)       x = PI - x;
    else if (x < -HALF_PI) x = -PI - x;

    float x2  = x * x;
    float x3  = x2 * x;
    float x5  = x3 * x2;
    float x7  = x5 * x2;
    float x9  = x7 * x2;
    float x11 = x9 * x2;

    return x
         - (x3  / 6.0f)
         + (x5  / 120.0f)
         - (x7  / 5040.0f)
         + (x9  / 362880.0f)
         - (x11 / 39916800.0f);
}
float my_cosf(float x) { return my_sinf(x + HALF_PI); }

float clampf(float v, float lo, float hi) {
    return v < lo ? lo : (v > hi ? hi : v);
}

int clampi(int v, int lo, int hi) {
    return v < lo ? lo : (v > hi ? hi : v);
}

unsigned rand_next(unsigned *state) {
    *state = (*state * 1103515245u + 12345u);
    return (*state >> 16) & 0x7FFF;
}

// ---- colour ----

// The panel's colour macros tell us the pixel format: ST7735_RED is
// 0x001F (low 5 bits) and ST7735_BLUE is 0xF800 (high 5 bits), so this is
// BGR565 with the 16-bit value repeated in both halves of the 32-bit word.
unsigned short pack565(int r, int g, int b) {
    r = clampi(r, 0, 255);
    g = clampi(g, 0, 255);
    b = clampi(b, 0, 255);
    return (unsigned short)(((b >> 3) << 11) | ((g >> 2) << 5) | (r >> 3));
}

unsigned color32(unsigned short c) {
    return ((unsigned)c << 16) | c;
}

unsigned short sky_color(float dy) {
    int t = (int)(clampf(dy * 1.6f, 0.0f, 1.0f) * 256.0f);
    int r = SKY_HORIZON[0] + (((int)SKY_ZENITH[0] - SKY_HORIZON[0]) * t >> 8);
    int g = SKY_HORIZON[1] + (((int)SKY_ZENITH[1] - SKY_HORIZON[1]) * t >> 8);
    int b = SKY_HORIZON[2] + (((int)SKY_ZENITH[2] - SKY_HORIZON[2]) * t >> 8);
    return pack565(r, g, b);
}

unsigned hash3(int x, int y, int z, int face) {
    unsigned h = (unsigned)x * 73856093u ^ (unsigned)y * 19349663u
               ^ (unsigned)z * 83492791u ^ (unsigned)face * 2654435761u;
    h ^= h >> 13;
    h *= 0x5BD1E995u;
    h ^= h >> 15;
    return h;
}

// colour of a block face the ray landed on: base colour, per-face shading
// (top brightest, so edges read as 3D), a little per-block grain for a
// textured look, then distance fog toward the horizon colour
unsigned short shade_hit(const Hit *h) {
    int block = h->block;

    // grass blocks: green cap on top and a thin green lip on the sides,
    // dirt on the underside and below the lip
    if (block == GRASS) {
        if (h->face == 2)
            block = DIRT;
        else if ((h->face == 0 || h->face == 3) && h->hy < 0.75f)
            block = DIRT;
    }

    int shade;
    if (h->face == 1)      shade = 256;
    else if (h->face == 0) shade = 208;
    else if (h->face == 3) shade = 172;
    else                   shade = 120;

    int grain = 232 + (int)(hash3(h->bx, h->by, h->bz, h->face) & 15);
    shade = (shade * grain) >> 8;

    int r = (BASE_RGB[block][0] * shade) >> 8;
    int g = (BASE_RGB[block][1] * shade) >> 8;
    int b = (BASE_RGB[block][2] * shade) >> 8;

    int fog = (int)(clampf(h->t / FOG_DIST, 0.0f, 1.0f) * 256.0f);
    r += ((SKY_HORIZON[0] - r) * fog) >> 8;
    g += ((SKY_HORIZON[1] - g) * fog) >> 8;
    b += ((SKY_HORIZON[2] - b) * fog) >> 8;

    return pack565(r, g, b);
}

// ---- world ----

// y of the first free cell above the highest solid block in a column
// (water doesn't count as ground, so you can wade along the sea floor)
int ground_height(Game *g, int x, int z) {
    int y;
    for (y = WY - 1; y >= 0; y--) {
        unsigned char b = g->world[y][z][x];
        if (b != AIR && b != WATER)
            return y + 1;
    }
    return 0;
}

void generate_world(Game *g) {
    int x, y, z, i;
    int coarse[9][9];

    // coarse random heights every 4 blocks, bilinearly blended below -
    // that's what turns white noise into rolling hills
    for (z = 0; z < 9; z++)
        for (x = 0; x < 9; x++)
            coarse[z][x] = 3 + (int)(rand_next(&g->seed) % 7); // 3..9

    for (y = 0; y < WY; y++)
        for (z = 0; z < WZ; z++)
            for (x = 0; x < WX; x++)
                g->world[y][z][x] = AIR;

    for (z = 0; z < WZ; z++) {
        for (x = 0; x < WX; x++) {
            int fx = x / 4, fz = z / 4;
            int tx = x % 4, tz = z % 4;
            int h = (coarse[fz][fx]         * (4 - tx) * (4 - tz)
                   + coarse[fz][fx + 1]     * tx       * (4 - tz)
                   + coarse[fz + 1][fx]     * (4 - tx) * tz
                   + coarse[fz + 1][fx + 1] * tx       * tz) / 16;

            for (y = 0; y < h; y++) {
                unsigned char b;
                if (y < h - 3)       b = STONE;
                else if (y < h - 1)  b = DIRT;
                else                 b = (h <= WATER_Y + 1) ? SAND : GRASS;
                g->world[y][z][x] = b;
            }
            for (y = h; y <= WATER_Y; y++)
                g->world[y][z][x] = WATER;
        }
    }

    // a handful of trees on grass
    for (i = 0; i < 14; i++) {
        int tx = 2 + (int)(rand_next(&g->seed) % (WX - 4));
        int tz = 2 + (int)(rand_next(&g->seed) % (WZ - 4));
        int h = ground_height(g, tx, tz);
        if (h < 1 || h + 6 >= WY || g->world[h - 1][tz][tx] != GRASS)
            continue;

        int dy, dx, dz;
        for (dy = 0; dy < 4; dy++)
            g->world[h + dy][tz][tx] = WOOD;
        for (dy = 3; dy <= 5; dy++) {
            int rad = (dy == 5) ? 1 : 2;
            for (dz = -rad; dz <= rad; dz++) {
                for (dx = -rad; dx <= rad; dx++) {
                    if (rad == 2 && my_fabsf((float)dx) == 2.0f && my_fabsf((float)dz) == 2.0f)
                        continue; // knock the corners off so the canopy looks round-ish
                    if (g->world[h + dy][tz + dz][tx + dx] == AIR)
                        g->world[h + dy][tz + dz][tx + dx] = LEAVES;
                }
            }
        }
    }
}

// ---- raycasting (3D DDA: steps exactly from block boundary to block boundary) ----

int cast_ray(Game *g, float ox, float oy, float oz,
             float dx, float dy, float dz, float max_t, Hit *h) {
    int mx = (int)ox, my = (int)oy, mz = (int)oz;

    float ddx = (dx == 0.0f) ? 1e30f : my_fabsf(1.0f / dx);
    float ddy = (dy == 0.0f) ? 1e30f : my_fabsf(1.0f / dy);
    float ddz = (dz == 0.0f) ? 1e30f : my_fabsf(1.0f / dz);

    int stx, sty, stz;
    float sdx, sdy, sdz;

    if (dx < 0.0f) { stx = -1; sdx = (ox - mx) * ddx; }
    else           { stx =  1; sdx = (mx + 1.0f - ox) * ddx; }
    if (dy < 0.0f) { sty = -1; sdy = (oy - my) * ddy; }
    else           { sty =  1; sdy = (my + 1.0f - oy) * ddy; }
    if (dz < 0.0f) { stz = -1; sdz = (oz - mz) * ddz; }
    else           { stz =  1; sdz = (mz + 1.0f - oz) * ddz; }

    for (;;) {
        int px = mx, py = my, pz = mz;
        int face;
        float t;

        if (sdx < sdy && sdx < sdz) { t = sdx; sdx += ddx; mx += stx; face = 0; }
        else if (sdy < sdz)         { t = sdy; sdy += ddy; my += sty; face = (sty < 0) ? 1 : 2; }
        else                        { t = sdz; sdz += ddz; mz += stz; face = 3; }

        if (t > max_t)
            return 0;
        if (mx < 0 || mx >= WX || mz < 0 || mz >= WZ || my < 0 || my >= WY)
            return 0; // left the world: sky

        unsigned char b = g->world[my][mz][mx];
        if (b != AIR) {
            h->bx = mx; h->by = my; h->bz = mz;
            h->px = px; h->py = py; h->pz = pz;
            h->face = face;
            h->block = b;
            h->t = t;
            h->hy = oy + dy * t - (float)my;
            return 1;
        }
    }
}

// ---- player ----

float eye_y(Game *g) {
    return (float)ground_height(g, (int)g->cx, (int)g->cz) + EYE_HEIGHT;
}

// walks one axis at a time (so you slide along walls), refusing to step
// up more than one block - which also stops you walking through trees
void try_move(Game *g, float dx, float dz) {
    float nx = g->cx + dx;
    float nz = g->cz + dz;
    if (nx < 0.3f || nx > WX - 0.3f || nz < 0.3f || nz > WZ - 0.3f)
        return;

    int cur_h = ground_height(g, (int)g->cx, (int)g->cz);
    int new_h = ground_height(g, (int)nx, (int)nz);
    if (new_h > cur_h + 1)
        return;

    g->cx = nx;
    g->cz = nz;
}

void walk(Game *g, float forward, float strafe) {
    float sy = my_sinf(g->yaw);
    float cy = my_cosf(g->yaw);
    float dx = (sy * forward + cy * strafe) * MOVE_STEP;
    float dz = (cy * forward - sy * strafe) * MOVE_STEP;
    try_move(g, dx, 0.0f);
    try_move(g, 0.0f, dz);
}

void look(Game *g, float d_yaw, float d_pitch) {
    g->yaw = wrap_angle(g->yaw + d_yaw);
    g->pitch = clampf(g->pitch + d_pitch, -1.4f, 1.4f);
}

// casts straight out of the middle of the screen - what a crosshair points at
int aim_ray(Game *g, Hit *h) {
    float sy = my_sinf(g->yaw),   cy = my_cosf(g->yaw);
    float sp = my_sinf(g->pitch), cp = my_cosf(g->pitch);
    return cast_ray(g, g->cx, eye_y(g), g->cz, cp * sy, sp, cp * cy, REACH, h);
}

void break_block(Game *g) {
    Hit h;
    if (aim_ray(g, &h) && h.by > 0)
        g->world[h.by][h.bz][h.bx] = AIR;
}

void place_block(Game *g) {
    Hit h;
    if (!aim_ray(g, &h))
        return;

    unsigned char cur = g->world[h.py][h.pz][h.px];
    if (cur != AIR && cur != WATER)
        return;

    // don't entomb yourself: the two cells your body occupies are off limits
    int feet = ground_height(g, (int)g->cx, (int)g->cz);
    if (h.px == (int)g->cx && h.pz == (int)g->cz && h.py >= feet && h.py <= feet + 1)
        return;

    g->world[h.py][h.pz][h.px] = HOTBAR[g->selected];
}

// ---- rendering ----

void render_frame(Game *g) {
    int sx, sy;

    // camera basis: forward, right, up (all unit length and mutually perpendicular)
    float sny = my_sinf(g->yaw),   csy = my_cosf(g->yaw);
    float snp = my_sinf(g->pitch), csp = my_cosf(g->pitch);

    float fx = csp * sny, fy = snp,  fz = csp * csy;
    float rx = csy,       rz = -sny;
    float ux = -snp * sny, uy = csp, uz = -snp * csy;

    float ox = g->cx, oy = eye_y(g), oz = g->cz;

    float us[GW];
    for (sx = 0; sx < GW; sx++)
        us[sx] = (((float)sx + 0.5f) * 2.0f / GW - 1.0f) * TAN_HALF_FOV_X;

    for (sy = 0; sy < GH; sy++) {
        float v = (1.0f - ((float)sy + 0.5f) * 2.0f / GH) * TAN_HALF_FOV_Y;

        for (sx = 0; sx < GW; sx++) {
            float u = us[sx];
            float dx = fx + rx * u + ux * v;
            float dy = fy +          uy * v;
            float dz = fz + rz * u + uz * v;

            Hit h;
            if (cast_ray(g, ox, oy, oz, dx, dy, dz, MAX_RAY_DIST, &h))
                g->frame[sy][sx] = shade_hit(&h);
            else
                g->frame[sy][sx] = sky_color(dy);
        }
    }

    // crosshair (a plus, one ray-cell per arm) in the middle of the view
    {
        unsigned short white = pack565(255, 255, 255);
        int cxl = GW / 2, cyl = GH / 2;
        g->frame[cyl][cxl] = white;
        g->frame[cyl][cxl - 1] = white;
        g->frame[cyl][cxl + 1] = white;
        g->frame[cyl - 1][cxl] = white;
        g->frame[cyl + 1][cxl] = white;
    }

    // hotbar: the selected block's colour in the bottom-right corner
    {
        int b = HOTBAR[g->selected];
        unsigned short c = pack565(BASE_RGB[b][0], BASE_RGB[b][1], BASE_RGB[b][2]);
        g->frame[GH - 1][GW - 1] = c;
        g->frame[GH - 1][GW - 2] = c;
        g->frame[GH - 2][GW - 1] = c;
        g->frame[GH - 2][GW - 2] = c;
    }
}

// pushes only the cells that changed to the LCD, merging runs of equal
// colour in a row into one rectangle (big sky/water areas cost almost nothing)
void present_frame(Game *g) {
    int sx, sy;
    for (sy = 0; sy < GH; sy++) {
        sx = 0;
        while (sx < GW) {
            if (g->frame[sy][sx] == g->shadow[sy][sx]) {
                sx++;
                continue;
            }
            unsigned short c = g->frame[sy][sx];
            int ex = sx;
            while (ex < GW && g->frame[sy][ex] == c) {
                g->shadow[sy][ex] = c;
                ex++;
            }
            rv_soc_draw_rectangle(color32(c), sx * CELL_PX, sy * CELL_PX,
                                  (ex - sx) * CELL_PX, CELL_PX);
            sx = ex;
        }
    }

    seg_write_hex((((unsigned)g->cx & 0xFF) << 8) | ((unsigned)g->cz & 0xFF));
    led_write((unsigned)(g->selected + 1));
}

// ---- input ----

// handles the final letter of an arrow-key sequence
int handle_arrow(Game *g, unsigned char c) {
    if (c == 'A') { look(g, 0.0f, LOOK_STEP_KEY);   return 1; }  // up
    if (c == 'B') { look(g, 0.0f, -LOOK_STEP_KEY);  return 1; }  // down
    if (c == 'C') { look(g, LOOK_STEP_KEY, 0.0f);   return 1; }  // right
    if (c == 'D') { look(g, -LOOK_STEP_KEY, 0.0f);  return 1; }  // left
    return 0;
}

void new_world(Game *g) {
    generate_world(g);
    g->cx = 32.0 / 2 + 0.5f;
    g->cz = 32.0 / 2 + 0.5f;
    g->yaw = 0.0f;
    g->pitch = -0.15f;
}

// one received byte; returns 1 if the view needs re-rendering
int feed_byte(Game *g, unsigned char c) {
    if (g->esc_state == ESC_GOT) {
        if (c == '[') { g->esc_state = ESC_CSI; return 0; }
        if (c == 'O') { g->esc_state = ESC_SS3; return 0; }
        g->esc_state = ESC_NONE; // bare ESC: treat this byte as a normal key
    } else if (g->esc_state == ESC_CSI) {
        if ((c >= '0' && c <= '9') || c == ';')
            return 0;                       // parameters (modifiers etc.) - skip
        if (c >= 0x40 && c <= 0x7E) {       // final byte
            g->esc_state = ESC_NONE;
            return handle_arrow(g, c);
        }
        g->esc_state = ESC_NONE;
        return 0;
    } else if (g->esc_state == ESC_SS3) {
        g->esc_state = ESC_NONE;
        return handle_arrow(g, c);
    }

    switch (c) {
        case 0x1B: g->esc_state = ESC_GOT; return 0;

        case 'w': case 'W': walk(g,  1.0f,  0.0f); return 1;
        case 's': case 'S': walk(g, -1.0f,  0.0f); return 1;
        case 'a': case 'A': walk(g,  0.0f, -1.0f); return 1;
        case 'd': case 'D': walk(g,  0.0f,  1.0f); return 1;

        case 'i': case 'I': look(g, 0.0f,  LOOK_STEP_KEY); return 1;
        case 'k': case 'K': look(g, 0.0f, -LOOK_STEP_KEY); return 1;
        case 'j': case 'J': look(g, -LOOK_STEP_KEY, 0.0f); return 1;
        case 'l': case 'L': look(g,  LOOK_STEP_KEY, 0.0f); return 1;

        case 'b': case 'B': case 'x': case 'X': break_block(g); return 1;
        case 'p': case 'P': case 'v': case 'V': place_block(g); return 1;

        case 'r': case 'R':
            g->seed += 7919u;
            new_world(g);
            return 1;

        default:
            if (c >= '1' && c <= '6') {
                g->selected = c - '1';
                return 1;
            }
            return 0;
    }
}

int main() {
    Game g; // ~21KB on the stack, on purpose (see the struct comment)
    int sx, sy;

    g.seed = 0x1234ABCDu;
    g.selected = 0;
    g.esc_state = ESC_NONE;
    new_world(&g);

    // screen starts black, so a black shadow means "nothing to fix yet"
    rv_soc_draw_rectangle(ST7735_BLACK, 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    for (sy = 0; sy < GH; sy++)
        for (sx = 0; sx < GW; sx++)
            g.shadow[sy][sx] = 0;

    int dirty = 1; // draw the first frame

    for (;;) {

        // drain every waiting UART byte before rendering, so a burst of
        // key-repeat becomes one render instead of one per keypress
        for (;;) {
            SERIAL_READ r = rv_soc_serial_read();
            if (!SERIAL_READ_VALID(r))
                break;

            // NOTE: & 0xFF on purpose - SERIAL_RESULT_BYTE in uart.h masks
            // with 0x0F, which would mangle ASCII ('w' 0x77 -> 0x07)
            unsigned char c = (unsigned char)(r & 0xFF);
            if (feed_byte(&g, c))
                dirty = 1;
        }
        if (dirty) {
            render_frame(&g);
            present_frame(&g);
            dirty = 0;
        }

    }
}