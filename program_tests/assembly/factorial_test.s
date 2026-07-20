li sp,1024
call main
fac:
    addi    sp,sp,-32
    sw      ra,28(sp)
    sw      s0,24(sp)
    addi    s0,sp,32
    sw      a0,-20(s0)
    lw      a5,-20(s0)
    bne     a5,zero,.L2
    li      a5,1
    j       .L3
.L2:
    lw      a4,-20(s0)
    li      a5,1
    bne     a4,a5,.L4
    li      a5,1
    j       .L3
.L4:
    lw      a4,-20(s0)
    li      a5,2
    bne     a4,a5,.L5
    li      a5,2
    j       .L3
.L5:
    lw      a5,-20(s0)
    addi    a5,a5,-1
    mv      a0,a5
    call    fac
    mv      a4,a0
    lw      a5,-20(s0)
    mul     a5,a4,a5
.L3:
    mv      a0,a5
    lw      ra,28(sp)
    lw      s0,24(sp)
    addi    sp,sp,32
    jr      ra
main:
    addi    sp,sp,-32
    sw      ra,28(sp)
    sw      s0,24(sp)
    addi    s0,sp,32
    li      a0,5
    call    fac
    sw      a0,-20(s0)
    lw      a4,-20(s0)
    li      a5,120
    bne     a4,a5,.L7
.L8:
    li t0,3169
    j       .L8
.L7:
    nop