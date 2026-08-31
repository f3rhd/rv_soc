#include "../../libc-baremetal/include/led.h"
#include "../../libc-baremetal/include/st7735.h"

#define SCREEN_WIDTH  128
#define SCREEN_HEIGHT 160

#define PADDLE_WIDTH  4
#define PADDLE_HEIGHT 20
#define PADDLE_MARGIN 6   

#define BALL_SIZE 4

#define PADDLE_SPEED 2
#define AI_REACTION_DEADZONE 3  

typedef struct {
    signed x;
    signed y;
} vec2;

void delay(unsigned dly_amount) {
    for (volatile int i = 0; i < dly_amount; i++)
        ;
}

void draw_paddle(unsigned color, signed px, signed py) {
    st7735_draw_rectangle(color, px, py, PADDLE_WIDTH, PADDLE_HEIGHT);
}

void draw_ball(unsigned color, signed bx, signed by) {
    st7735_draw_rectangle(color, bx, by, BALL_SIZE, BALL_SIZE);
}


void ai_move(signed *paddle_y, signed ball_y) {
    signed paddle_center = *paddle_y + PADDLE_HEIGHT / 2;
    signed diff = ball_y - paddle_center;

    if (diff > AI_REACTION_DEADZONE)
        *paddle_y += PADDLE_SPEED;
    else if (diff < -AI_REACTION_DEADZONE)
        *paddle_y -= PADDLE_SPEED;

    
    if (*paddle_y < 0)
        *paddle_y = 0;
    if (*paddle_y + PADDLE_HEIGHT > SCREEN_HEIGHT)
        *paddle_y = SCREEN_HEIGHT - PADDLE_HEIGHT;
}

int main() {
    
    vec2 ball_pos = {SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2};
    vec2 ball_vel = {2, 2};

    
    signed left_paddle_x  = PADDLE_MARGIN;
    signed right_paddle_x = SCREEN_WIDTH - PADDLE_MARGIN - PADDLE_WIDTH;

    signed left_paddle_y  = SCREEN_HEIGHT / 2 - PADDLE_HEIGHT / 2;
    signed right_paddle_y = SCREEN_HEIGHT / 2 - PADDLE_HEIGHT / 2;

    unsigned left_score = 0;
    unsigned right_score = 0;

    
    st7735_draw_rectangle(ST7735_BLACK, 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);

    for (;;) {
        
        draw_ball(ST7735_BLACK, ball_pos.x, ball_pos.y);
        draw_paddle(ST7735_BLACK, left_paddle_x, left_paddle_y);
        draw_paddle(ST7735_BLACK, right_paddle_x, right_paddle_y);

        
        ai_move(&left_paddle_y, ball_pos.y);
        ai_move(&right_paddle_y, ball_pos.y);

        
        ball_pos.x += ball_vel.x;
        ball_pos.y += ball_vel.y;

        
        if (ball_pos.y <= 0) {
            ball_pos.y = 0;
            ball_vel.y = -ball_vel.y;
        }
        if (ball_pos.y + BALL_SIZE >= SCREEN_HEIGHT) {
            ball_pos.y = SCREEN_HEIGHT - BALL_SIZE;
            ball_vel.y = -ball_vel.y;
        }

        
        
        if (ball_vel.x < 0 &&
            ball_pos.x <= left_paddle_x + PADDLE_WIDTH &&
            ball_pos.x + BALL_SIZE >= left_paddle_x &&
            ball_pos.y + BALL_SIZE >= left_paddle_y &&
            ball_pos.y <= left_paddle_y + PADDLE_HEIGHT) {

            ball_pos.x = left_paddle_x + PADDLE_WIDTH; 
            ball_vel.x = -ball_vel.x;

            
            signed hit_offset = (ball_pos.y + BALL_SIZE / 2) - (left_paddle_y + PADDLE_HEIGHT / 2);
            ball_vel.y += hit_offset / 6;

            
            if (ball_vel.y > 4) ball_vel.y = 4;
            if (ball_vel.y < -4) ball_vel.y = -4;
        }

        
        if (ball_vel.x > 0 &&
            ball_pos.x + BALL_SIZE >= right_paddle_x &&
            ball_pos.x <= right_paddle_x + PADDLE_WIDTH &&
            ball_pos.y + BALL_SIZE >= right_paddle_y &&
            ball_pos.y <= right_paddle_y + PADDLE_HEIGHT) {

            ball_pos.x = right_paddle_x - BALL_SIZE; 
            ball_vel.x = -ball_vel.x;

            signed hit_offset = (ball_pos.y + BALL_SIZE / 2) - (right_paddle_y + PADDLE_HEIGHT / 2);
            ball_vel.y += hit_offset / 6;

            if (ball_vel.y > 4) ball_vel.y = 4;
            if (ball_vel.y < -4) ball_vel.y = -4;
        }

        
        if (ball_pos.x < 0) {
            right_score++;
            ball_pos.x = SCREEN_WIDTH / 2;
            ball_pos.y = SCREEN_HEIGHT / 2;
            ball_vel.x = 2;  
            ball_vel.y = 2;
        }
        if (ball_pos.x + BALL_SIZE > SCREEN_WIDTH) {
            left_score++;
            ball_pos.x = SCREEN_WIDTH / 2;
            ball_pos.y = SCREEN_HEIGHT / 2;
            ball_vel.x = -2; 
            ball_vel.y = 2;
        }

        
        draw_paddle(ST7735_RED, left_paddle_x, left_paddle_y);
        draw_paddle(ST7735_BLUE, right_paddle_x, right_paddle_y);
        draw_ball(ST7735_WHITE, ball_pos.x, ball_pos.y);

        
        
        seg_write_hex((left_score << 8) | right_score);
        
        led_write(((ball_pos.x & 0xFF) << 8) | (ball_pos.y & 0xFF));

        delay(15000 * 10);
    }
}