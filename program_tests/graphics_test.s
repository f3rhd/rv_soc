# ══ 0. Setup ══════════════════════════════════════════
li   t0, 0xFFFFFFFF     # pixel data address
li   t1, 0xFFFFFFF0     # command address
li   t4, 20480          # 128 x 160 pixels

li   a2, 0x07E007E0     # start with green (BGR565)

# ══ 1. Main color loop ════════════════════════════════
color_loop:
    # -- re-issue display window commands every frame --
    li   t5, 0x2A007F00
    sw   t5, 0(t1)
    li   t5, 0x2B009F00
    sw   t5, 0(t1)
    li   t5, 0x2C000000
    sw   t5, 0(t1)

    mv   t6, t4              # reset pixel counter

pixel_loop:
    sw   a2, 0(t0)           # write BGR pixel
    addi t6, t6, -1
    bnez t6, pixel_loop

    # ══ 2. Delay (~0.5s @ 100MHz) ═════════════════════
    li   t6, 25000000
delay_loop:
    addi t6, t6, -1
    bnez t6, delay_loop

    # ══ 3. Pick next color ════════════════════════════
    li   t5, 0x07E007E0     # green in BGR
    beq  a2, t5, set_red
    li   t5, 0x001F001F     # red in BGR
    beq  a2, t5, set_blue
    # default (currently blue) -> green
set_green:
    li   a2, 0x07E007E0
    j    color_loop
set_red:
    li   a2, 0x001F001F
    j    color_loop
set_blue:
    li   a2, 0xF800F800
    j    color_loop