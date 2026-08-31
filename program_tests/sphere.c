#include "../../libc-baremetal/include/led.h"
#include "../../libc-baremetal/include/st7735.h"


#define SCREEN_W 128
#define SCREEN_H 160
#define CENTER_X (SCREEN_W / 2)
#define CENTER_Y (SCREEN_H / 2)

#define SPHERE_RADIUS 42
#define VIEW_DIST 150

#define LAT_MIN (-80)
#define LAT_MAX   80
#define LAT_STEP  20

#define LON_MIN    0
#define LON_MAX  340
#define LON_STEP  20

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

/* Computes a point on the sphere's surface for a given
   latitude/longitude, entirely at runtime (no tables). */
static void sphere_point(
    int lat_deg,
    int lon_deg,
    int* x,
    int* y,
    int* z
) {
    int cos_lat, sin_lat, cos_lon, sin_lon;
    int r_lat;

    cos_lat = icos1000(lat_deg);
    sin_lat = isin1000(lat_deg);
    cos_lon = icos1000(lon_deg);
    sin_lon = isin1000(lon_deg);

    r_lat = (SPHERE_RADIUS * cos_lat) / 1000;

    *x = (r_lat * cos_lon) / 1000;
    *y = (SPHERE_RADIUS * sin_lat) / 1000;
    *z = (r_lat * sin_lon) / 1000;
}

static void spinning_sphere_demo(void) {
    int angle_x;
    int angle_y;
    int lat, lon;
    int x, y, z;
    int sx, sy;
    int px, py, first;

    angle_x = 0;
    angle_y = 0;

    for (;;) {

        st7735_draw_rectangle(ST7735_BLACK, 0, 0, SCREEN_W, SCREEN_H);

        /* latitude rings, connected point-to-point around each ring */
        for (lat = LAT_MIN; lat <= LAT_MAX; lat += LAT_STEP) {
            first = 1;
            px = 0;
            py = 0;

            for (lon = LON_MIN; lon <= LON_MAX; lon += LON_STEP) {
                sphere_point(lat, lon, &x, &y, &z);
                transform_vertex(x, y, z, angle_x, angle_y, &sx, &sy);

                if (!first)
                    st7735_draw_line(ST7735_CYAN, px, py, sx, sy);

                px = sx;
                py = sy;
                first = 0;
            }
        }

        /* longitude lines, connected point-to-point pole to pole */
        for (lon = LON_MIN; lon <= LON_MAX; lon += LON_STEP) {
            first = 1;
            px = 0;
            py = 0;

            for (lat = LAT_MIN; lat <= LAT_MAX; lat += LAT_STEP) {
                sphere_point(lat, lon, &x, &y, &z);
                transform_vertex(x, y, z, angle_x, angle_y, &sx, &sy);

                if (!first)
                    st7735_draw_line(ST7735_YELLOW, px, py, sx, sy);

                px = sx;
                py = sy;
                first = 0;
            }
        }

        angle_x += 3;
        angle_y += 2;
        if (angle_x >= 360)
            angle_x -= 360;
        if (angle_y >= 360)
            angle_y -= 360;
    }
}

int main(void) {
    spinning_sphere_demo();
    return 0;
}