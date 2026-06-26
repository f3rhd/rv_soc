li t0, 0xFFFFFFFF; # data address
li t1, 0xFFFFFFF0; # command address
li t2,128 # width
li t3,160 # height
mul t4,t2,t3 # 20480 pixels

color_loop:
  li t5,0x2A007F00
  sw t5,0(t1)

  li t5,0x2B009F00
  sw t5,0(t1)

  li t5,0x2C000000
  sw t5,0(t1)

  mv t6,t4 
  j init
pixel_loop:
    sw   a2, 0(t0)            # write BGR pixel
    addi t6, t6, -1
    bnez t6, pixel_loop

    # ══ 5. Delay ══════════════════════════════════════
    li   t6, 2000000
delay_loop:
    addi t6, t6, -1
    bnez t6, delay_loop

    # ══ 6. Advance color ══════════════════════════════
    # Cycle: green(0x00FF00) -> red(0x0000FF) -> blue(0xFF0000) -> repeat
    # (BGR order: green=0x00FF00, red=0x0000FF, blue=0xFF0000)

    li   t5, 0x00FF00         # green in BGR
    beq  a2, t5, set_red

    li   t5, 0x0000FF         # red in BGR
    beq  a2, t5, set_blue

    # default / blue -> green
set_green:
    li   a2, 0x00FF00
    j    color_loop

set_red:
    li   a2, 0x0000FF
    j    color_loop

set_blue:
    li   a2, 0xFF0000
    j    color_loop

init:
    li   a2, 0x00FF00         # start with green
    j    color_loop


