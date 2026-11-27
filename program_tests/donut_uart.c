#include "../libc-baremetal/include/led.h"
#include "../libc-baremetal/include/serial.h"

#define W 80
#define H 22

#define R1 1.0f
#define R2 2.0f
#define K2 5.0f
#define K1 (W * K2 * 3.0f / (8.0f * (R1 + R2)))

#define THETA_STEPS 90
#define PHI_STEPS 200

#define SPIN_A 0.07f
#define SPIN_B 0.03f

#define PI 3.14159265f
#define TWO_PI 6.28318530f

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

void send_str(const char* s) {
    while (*s)
        rv_soc_serial_send(*s++);
}

int main() {

    char out[W * H];
    float zbuf[W * H];

    const char* shades = ".,-~:;=!*#$@";

    float A = 0.0f;
    float B = 0.0f;
    unsigned frame = 0;

    float sd_theta = my_sinf(TWO_PI / THETA_STEPS);
    float cd_theta = my_cosf(TWO_PI / THETA_STEPS);
    float sd_phi = my_sinf(TWO_PI / PHI_STEPS);
    float cd_phi = my_cosf(TWO_PI / PHI_STEPS);

    send_str("\x1b[2J");
    send_str("\x1b[?25l");

    for (;;) {
        int k;
        for (k = 0; k < W * H; k++) {
            out[k] = ' ';
            zbuf[k] = 0.0f;
        }

        float sinA = my_sinf(A), cosA = my_cosf(A);
        float sinB = my_sinf(B), cosB = my_cosf(B);

        int j, i;
        float sint = 0.0f, cost = 1.0f;
        for (j = 0; j < THETA_STEPS; j++) {
            float circlex = R2 + R1 * cost;
            float circley = R1 * sint;

            float sinp = 0.0f, cosp = 1.0f;
            for (i = 0; i < PHI_STEPS; i++) {

                float x = circlex * (cosB * cosp + sinA * sinB * sinp) -
                          circley * cosA * sinB;
                float y = circlex * (sinB * cosp - sinA * cosB * sinp) +
                          circley * cosA * cosB;
                float z = K2 + cosA * circlex * sinp + circley * sinA;

                float ooz = 1.0f / z;

                int xp = (int)(W / 2 + K1 * ooz * x);
                int yp = (int)(H / 2 - K1 * 0.5f * ooz * y);

                float L = cosp * cost * sinB - cosA * cost * sinp -
                          sinA * sint +
                          cosB * (cosA * sint - cost * sinA * sinp);

                if (L > 0.0f && xp >= 0 && xp < W && yp >= 0 && yp < H) {
                    int idx = xp + yp * W;

                    if (ooz > zbuf[idx]) {
                        zbuf[idx] = ooz;
                        int s = (int)(L * 8.0f);
                        if (s > 11)
                            s = 11;
                        out[idx] = shades[s];
                    }
                }

                float ns = sinp * cd_phi + cosp * sd_phi;
                float nc = cosp * cd_phi - sinp * sd_phi;
                sinp = ns;
                cosp = nc;
            }

            float ns = sint * cd_theta + cost * sd_theta;
            float nc = cost * cd_theta - sint * sd_theta;
            sint = ns;
            cost = nc;
        }

        send_str("\x1b[H");
        for (k = 0; k < W * H; k++) {
            rv_soc_serial_send(out[k]);
            if (k % W == W - 1 && k != W * H - 1) {
                rv_soc_serial_send('\r');
                rv_soc_serial_send('\n');
            }
        }

        A = wrap_angle(A + SPIN_A);
        B = wrap_angle(B + SPIN_B);

        frame++;
        seg_write_hex(frame);
    }
}