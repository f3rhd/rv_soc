_start:
    li sp,0x8000
    call main

halt_loop:
    j halt_loop

# ---- file: .\program_tests\c\red_display\red_display.c ----

main:
	addi	sp,sp,-32
	sw	ra,28(sp)
	sw	s0,24(sp)
	addi	s0,sp,32
	li	a5,20480
	sw	a5,-20(s0)
.L2:
	li	a3,160
	li	a2,0
	li	a1,128
	li	a0,0
	call	st7735_set_rectangle
	lw	a5,-20(s0)
	srli	a4,a5,31
	add	a5,a4,a5
	srai	a5,a5,1
	mv	a1,a5
	li	a5,2031616
	addi	a0,a5,31
	call	st7735_stream_pixel
	j	.L2

# ---- file: .\libc-baremetal\src\st7735.c ----

st7735_stream_pixel:
	beq	a1,zero,.L1
	li	a5,0
	li	a4,-1
.L3:
	sw a0, 0(a4) 
	addi	a5,a5,1
	bne	a1,a5,.L3
.L1:
	ret
st7735_set_rectangle:
	li	a5,16711680
	slli	a0,a0,16
	andi	a1,a1,255
	slli	a2,a2,16
	andi	a3,a3,255
	slli	a1,a1,8
	slli	a3,a3,8
	and	a0,a0,a5
	and	a2,a2,a5
	or	a0,a0,a1
	or	a2,a2,a3
	li	a4,704643072
	li	a5,721420288
	or	a2,a2,a5
	or	a0,a0,a4
	li	a5,-16
	sw a0, 0(a5) 
	sw a2, 0(a5) 
	li	a4,738197504
	sw a4, 0(a5) 
	ret

