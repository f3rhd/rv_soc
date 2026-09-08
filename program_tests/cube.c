#include "../libc-baremetal/include/led.h"
#include "../libc-baremetal/include/st7735.h"


#define SCREEN_W 128
#define SCREEN_H 160
#define CENTER_X (SCREEN_W / 2)
#define CENTER_Y (SCREEN_H / 2)

#define CUBE_HALF 30
#define VIEW_DIST 150

static int isin1000(int deg) {
    int sign;
    int reduced;
    int prod;
    int num;
    int den;

    reduced = deg;
    while (reduced < 0)
        reduced += 360;
    while (reduced >= 360)
        reduced -= 360;

    sign = 1;
    if (reduced > 180) {
        reduced -= 180;
        sign = -1;
    }

    prod = reduced * (180 - reduced);
    num = 4 * prod;
    den = 40500 - prod;

    return sign * ((1000 * num) / den);
}

static int icos1000(int deg) {
    return isin1000(deg + 90);
}
static void transform_vertex(
    int x,
    int y,
    int z,
    int angle_x,
    int angle_y,
    int* sx,
    int* sy
) {
    int cy, sy_, cx, sx_;
    int x1, y1, z1;
    int x2, y2, z2;
    int scale;

    cy = icos1000(angle_y);
    sy_ = isin1000(angle_y);
    x1 = (x * cy - z * sy_) / 1000;
    z1 = (x * sy_ + z * cy) / 1000;
    y1 = y;

    cx = icos1000(angle_x);
    sx_ = isin1000(angle_x);
    y2 = (y1 * cx - z1 * sx_) / 1000;
    z2 = (y1 * sx_ + z1 * cx) / 1000;
    x2 = x1;

    /* perspective projection */
    scale = (VIEW_DIST * 256) / (z2 + VIEW_DIST);

    *sx = CENTER_X + (x2 * scale) / 256;
    *sy = CENTER_Y + (y2 * scale) / 256;
}

static void spinning_cube_demo(void) {
    int angle_x;
    int angle_y;

    int px0, py0, px1, py1, px2, py2, px3, py3;
    int px4, py4, px5, py5, px6, py6, px7, py7;

    angle_x = 0;
    angle_y = 0;

    for (;;) {

        transform_vertex(
            -CUBE_HALF,
            -CUBE_HALF,
            -CUBE_HALF,
            angle_x,
            angle_y,
            &px0,
            &py0
        );
        transform_vertex(
            CUBE_HALF,
            -CUBE_HALF,
            -CUBE_HALF,
            angle_x,
            angle_y,
            &px1,
            &py1
        );
        transform_vertex(
            CUBE_HALF,
            CUBE_HALF,
            -CUBE_HALF,
            angle_x,
            angle_y,
            &px2,
            &py2
        );
        transform_vertex(
            -CUBE_HALF,
            CUBE_HALF,
            -CUBE_HALF,
            angle_x,
            angle_y,
            &px3,
            &py3
        );
        transform_vertex(
            -CUBE_HALF,
            -CUBE_HALF,
            CUBE_HALF,
            angle_x,
            angle_y,
            &px4,
            &py4
        );
        transform_vertex(
            CUBE_HALF,
            -CUBE_HALF,
            CUBE_HALF,
            angle_x,
            angle_y,
            &px5,
            &py5
        );
        transform_vertex(
            CUBE_HALF,
            CUBE_HALF,
            CUBE_HALF,
            angle_x,
            angle_y,
            &px6,
            &py6
        );
        transform_vertex(
            -CUBE_HALF,
            CUBE_HALF,
            CUBE_HALF,
            angle_x,
            angle_y,
            &px7,
            &py7
        );

        st7735_draw_rectangle(ST7735_BLACK, 0, 0, SCREEN_W, SCREEN_H);

        st7735_draw_line(ST7735_CYAN, px0, py0, px1, py1);
        st7735_draw_line(ST7735_CYAN, px1, py1, px2, py2);
        st7735_draw_line(ST7735_CYAN, px2, py2, px3, py3);
        st7735_draw_line(ST7735_CYAN, px3, py3, px0, py0);
    
        st7735_draw_line(ST7735_YELLOW, px4, py4, px5, py5);
        st7735_draw_line(ST7735_YELLOW, px5, py5, px6, py6);
        st7735_draw_line(ST7735_YELLOW, px6, py6, px7, py7);
        st7735_draw_line(ST7735_YELLOW, px7, py7, px4, py4);
    
        st7735_draw_line(ST7735_WHITE, px0, py0, px4, py4);
        st7735_draw_line(ST7735_WHITE, px1, py1, px5, py5);
        st7735_draw_line(ST7735_WHITE, px2, py2, px6, py6);
        st7735_draw_line(ST7735_WHITE, px3, py3, px7, py7);

        angle_x += 3;
        angle_y += 2;
        if (angle_x >= 360)
            angle_x -= 360;
        if (angle_y >= 360)
            angle_y -= 360;
    }
}

int main(void) {
    spinning_cube_demo();
    return 0;
}