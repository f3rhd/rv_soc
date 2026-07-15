_start:
    li sp,0x8000
    call main

halt_loop:
    j halt_loop

# ---- file: flag.c ----

main:
	addi	sp,sp,-32
	sw	s0,24(sp)
	sw	s1,20(sp)
	sw	ra,28(sp)
	li	a2,0
	li	s0,128
	li	s1,160
.L2:
	li	a1,0
.L3:
	li	a0,-1
	sw	a2,12(sp)
	sw	a1,8(sp)
	call	st7735_draw_pixel
	lw	a1,8(sp)
	lw	a2,12(sp)
	addi	a1,a1,1
	bne	a1,s0,.L3
	addi	a2,a2,1
	bne	a2,s1,.L2
	lw	ra,28(sp)
	lw	s0,24(sp)
	lw	s1,20(sp)
	li	a0,0
	addi	sp,sp,32
	jr	ra

# ---- file: .\libc-baremetal\src\st7735.c ----

st7735_draw_triangle:
	ret
st7735_draw_circle:
	ret
st7735_stream_pixel:
	li	a5,0
	li	a4,-1
.L4:
	bne	a5,a1,.L5
	ret
.L5:
	sw a0, 0(a4) 
	addi	a5,a5,1
	j	.L4
st7735_set_rectangle:
	li	a5,16711680
	slli	a0,a0,16
	andi	a2,a2,255
	slli	a1,a1,16
	andi	a3,a3,255
	and	a0,a0,a5
	slli	a2,a2,8
	and	a1,a1,a5
	slli	a3,a3,8
	or	a0,a0,a2
	li	a4,704643072
	or	a1,a1,a3
	li	a5,721420288
	or	a1,a1,a5
	or	a0,a0,a4
	li	a5,-16
	sw a0, 0(a5) 
	sw a1, 0(a5) 
	li	a4,738197504
	sw a4, 0(a5) 
	ret
st7735_draw_pixel:
	addi	sp,sp,-16
	sw	s0,8(sp)
	mv	s0,a0
	mv	a0,a1
	mv	a3,a2
	mv	a1,a2
	mv	a2,a0
	sw	ra,12(sp)
	call	st7735_set_rectangle
	mv	a0,s0
	lw	s0,8(sp)
	lw	ra,12(sp)
	li	a1,1
	addi	sp,sp,16
	tail	st7735_stream_pixel
st7735_draw_line:
	addi	sp,sp,-48
	sw	s0,40(sp)
	sub	s0,a3,a1
	srai	a5,s0,31
	sw	s3,28(sp)
	sw	s5,20(sp)
	xor	s0,a5,s0
	sw	ra,44(sp)
	sw	s1,36(sp)
	sw	s2,32(sp)
	sw	s4,24(sp)
	sw	s6,16(sp)
	mv	s3,a2
	sub	s0,s0,a5
	li	s5,1
	blt	a1,a3,.L10
	li	s5,-1
.L10:
	sub	s1,a4,a2
	srai	a5,s1,31
	xor	s1,a5,s1
	sub	s1,s1,a5
	neg	s6,s1
	li	s4,-1
	bge	a2,a4,.L11
	li	s4,1
.L11:
	sub	s2,s0,s1
.L12:
	mv	a2,s3
	sw	a4,12(sp)
	sw	a3,8(sp)
	sw	a1,4(sp)
	sw	a0,0(sp)
	call	st7735_draw_pixel
	lw	a1,4(sp)
	lw	a3,8(sp)
	lw	a0,0(sp)
	lw	a4,12(sp)
	bne	a1,a3,.L19
	beq	s3,a4,.L9
.L19:
	slli	a5,s2,1
	bgt	s6,a5,.L15
	sub	s2,s2,s1
	add	a1,a1,s5
	blt	s0,a5,.L12
.L15:
	add	s2,s2,s0
	add	s3,s3,s4
	j	.L12
.L9:
	lw	ra,44(sp)
	lw	s0,40(sp)
	lw	s1,36(sp)
	lw	s2,32(sp)
	lw	s3,28(sp)
	lw	s4,24(sp)
	lw	s5,20(sp)
	lw	s6,16(sp)
	addi	sp,sp,48
	jr	ra
st7735_draw_rectangle:
	addi	sp,sp,-48
	sw	ra,44(sp)
	sw	a0,28(sp)
	sw	a1,24(sp)
	sw	a2,20(sp)
	sw	a3,16(sp)
	sw	a4,12(sp)
	call	st7735_set_rectangle
	lw	a0,28(sp)
	lw	a1,24(sp)
	lw	a3,16(sp)
	lw	a2,20(sp)
	sub	a1,a1,a0
	lw	ra,44(sp)
	sub	a3,a3,a2
	mul	a1,a1,a3
	lw	a0,12(sp)
	addi	sp,sp,48
	srli	a1,a1,1
	tail	st7735_stream_pixel

