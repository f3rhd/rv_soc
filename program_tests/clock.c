#include "../libc-baremetal/include/graphics.h"
#include "../libc-baremetal/include/led.h"
#include "../libc-baremetal/include/system.h"


#define SCREEN_WIDTH 128
#define SCREEN_HEIGHT 160

#define SYSTEM_HZ 100'000'000UL

#define CLOCK_CX (SCREEN_WIDTH / 2)
#define CLOCK_CY (SCREEN_HEIGHT / 2)
#define CLOCK_RADIUS 55

#define HOUR_HAND_LEN 28
#define MIN_HAND_LEN 42
#define SEC_HAND_LEN 48

#define TICK_OUTER CLOCK_RADIUS
#define TICK_INNER (CLOCK_RADIUS - 8)

#define COLOR_BG ST7735_BLACK
#define COLOR_FACE ST7735_WHITE
#define COLOR_HOUR ST7735_CYAN
#define COLOR_MIN ST7735_GREEN
#define COLOR_SEC ST7735_RED
#define COLOR_CENTER ST7735_YELLOW

#define PI 3.14159265f
#define TWO_PI 6.28318530f

#define START_HOUR 12
#define START_MINUTE 0
#define START_SECOND 0

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
    float x9 = x7 * x2;
    return x - (x3 / 6.0f) + (x5 / 120.0f) - (x7 / 5040.0f) + (x9 / 362880.0f);
}

float my_cosf(float x) {
    x = wrap_angle(x);
    float x2 = x * x;
    float x4 = x2 * x2;
    float x6 = x4 * x2;
    float x8 = x6 * x2;
    return 1.0f - (x2 / 2.0f) + (x4 / 24.0f) - (x6 / 720.0f) + (x8 / 40320.0f);
}
void draw_ticks(unsigned color) {
    int i;
    for (i = 0; i < 12; i++) {
        float angle = ((float)i / 12.0f) * TWO_PI - (PI / 2.0f);
        float c = my_cosf(angle);
        float s = my_sinf(angle);

        int x0 = CLOCK_CX + (int)(c * TICK_INNER);
        int y0 = CLOCK_CY + (int)(s * TICK_INNER);
        int x1 = CLOCK_CX + (int)(c * TICK_OUTER);
        int y1 = CLOCK_CY + (int)(s * TICK_OUTER);

        rv_soc_draw_line(color, x0, y0, x1, y1);
    }
}

void draw_hand(float fraction, int length, unsigned color) {
    float angle = fraction * TWO_PI - (PI / 2.0f);
    int x1 = CLOCK_CX + (int)(my_cosf(angle) * length);
    int y1 = CLOCK_CY + (int)(my_sinf(angle) * length);
    rv_soc_draw_line(color, CLOCK_CX, CLOCK_CY, x1, y1);
}

void render_clock(unsigned h, unsigned m, unsigned s) {
    rv_soc_draw_rectangle(
        COLOR_BG,
        CLOCK_CX - CLOCK_RADIUS - 1,
        CLOCK_CY - CLOCK_RADIUS - 1,
        (CLOCK_RADIUS + 1) * 2,
        (CLOCK_RADIUS + 1) * 2
    );

    rv_soc_draw_circle(COLOR_FACE, 0, CLOCK_CX, CLOCK_CY, CLOCK_RADIUS);
    draw_ticks(COLOR_FACE);

    float sec_frac = (float)s / 60.0f;
    float min_frac = ((float)m + sec_frac) / 60.0f;
    float hour_frac = (((float)(h % 12)) + min_frac) / 12.0f;

    draw_hand(hour_frac, HOUR_HAND_LEN, COLOR_HOUR);
    draw_hand(min_frac, MIN_HAND_LEN, COLOR_MIN);
    draw_hand(sec_frac, SEC_HAND_LEN, COLOR_SEC);

    rv_soc_draw_pixel(COLOR_CENTER, CLOCK_CX, CLOCK_CY);
}

int main() {
    unsigned hours = START_HOUR;
    unsigned minutes = START_MINUTE;
    unsigned seconds = START_SECOND;

    unsigned long last_ms = 0;
    unsigned long accumulated_ms = 0;

    rv_soc_draw_rectangle(COLOR_BG, 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);

    render_clock(hours, minutes, seconds);

    for (;;) {
        unsigned long now_ms = millis(SYSTEM_HZ);
        unsigned long elapsed = now_ms - last_ms;
        last_ms = now_ms;

        accumulated_ms += elapsed;

        int updated = 0;
        while (accumulated_ms >= 1000) {
            accumulated_ms -= 1000;

            seconds++;
            if (seconds >= 60) {
                seconds = 0;
                minutes++;
                if (minutes >= 60) {
                    minutes = 0;
                    hours++;
                    if (hours >= 24)
                        hours = 0;
                }
            }
            updated = 1;
        }

        if (updated) {
            render_clock(hours, minutes, seconds);

            seg_write_hex((hours << 8) | minutes);
            led_write(seconds);
        }

        delay(10, SYSTEM_HZ);
    }
}