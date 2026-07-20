_start:
    li sp,0x8000
    call main

halt_loop:
    j halt_loop

# ---- file: dvd.c ----

change_color_on_collision:
	addi	sp,sp,-32
	sw	ra,28(sp)
	sw	s0,24(sp)
	addi	s0,sp,32
	sw	a0,-20(s0)
	sw	a1,-24(s0)
	lw	a4,-24(s0)
	li	a5,8
	beq	a4,a5,.L2
	lw	a4,-24(s0)
	li	a5,8
	bgt	a4,a5,.L3
	lw	a4,-24(s0)
	li	a5,7
	beq	a4,a5,.L4
	lw	a4,-24(s0)
	li	a5,7
	bgt	a4,a5,.L3
	lw	a4,-24(s0)
	li	a5,6
	beq	a4,a5,.L5
	lw	a4,-24(s0)
	li	a5,6
	bgt	a4,a5,.L3
	lw	a4,-24(s0)
	li	a5,5
	beq	a4,a5,.L6
	lw	a4,-24(s0)
	li	a5,5
	bgt	a4,a5,.L3
	lw	a4,-24(s0)
	li	a5,4
	beq	a4,a5,.L7
	lw	a4,-24(s0)
	li	a5,4
	bgt	a4,a5,.L3
	lw	a4,-24(s0)
	li	a5,3
	beq	a4,a5,.L8
	lw	a4,-24(s0)
	li	a5,3
	bgt	a4,a5,.L3
	lw	a4,-24(s0)
	li	a5,2
	beq	a4,a5,.L9
	lw	a4,-24(s0)
	li	a5,2
	bgt	a4,a5,.L3
	lw	a5,-24(s0)
	beq	a5,zero,.L10
	lw	a4,-24(s0)
	li	a5,1
	beq	a4,a5,.L11
	j	.L3
.L10:
	lw	a5,-20(s0)
	li	a4,-1
	sw	a4,0(a5)
	j	.L12
.L11:
	lw	a5,-20(s0)
	li	a4,2031616
	addi	a4,a4,31
	sw	a4,0(a5)
	j	.L12
.L9:
	lw	a5,-20(s0)
	li	a4,132120576
	addi	a4,a4,2016
	sw	a4,0(a5)
	j	.L12
.L8:
	lw	a5,-20(s0)
	li	a4,-134152192
	addi	a4,a4,-2048
	sw	a4,0(a5)
	j	.L12
.L7:
	lw	a5,-20(s0)
	li	a4,-2031616
	addi	a4,a4,-32
	sw	a4,0(a5)
	j	.L12
.L6:
	lw	a5,-20(s0)
	li	a4,-132120576
	addi	a4,a4,-2017
	sw	a4,0(a5)
	j	.L12
.L5:
	lw	a5,-20(s0)
	li	a4,134152192
	addi	a4,a4,2047
	sw	a4,0(a5)
	j	.L12
.L4:
	lw	a5,-20(s0)
	li	a4,88014848
	addi	a4,a4,1343
	sw	a4,0(a5)
	j	.L12
.L2:
	lw	a5,-20(s0)
	li	a4,-843067392
	addi	a4,a4,-577
	sw	a4,0(a5)
	j	.L12
.L3:
	lw	a5,-20(s0)
	sw	zero,0(a5)
	nop
.L12:
	nop
	lw	ra,28(sp)
	lw	s0,24(sp)
	addi	sp,sp,32
	jr	ra
delay:
	addi	sp,sp,-16
	sw	zero,12(sp)
.L14:
	lw	a5,12(sp)
	bltu	a5,a0,.L15
	addi	sp,sp,16
	jr	ra
.L15:
	lw	a5,12(sp)
	addi	a5,a5,1
	sw	a5,12(sp)
	j	.L14
draw_dvd:
	addi	sp,sp,-32
	sw	s1,24(sp)
	addi	a3,a1,19
	mv	s1,a2
	addi	a2,a0,19
	sw	ra,28(sp)
	call	st7735_set_rectangle
	lw	ra,28(sp)
	mv	a0,s1
	lw	s1,24(sp)
	li	a1,200
	addi	sp,sp,32
	tail	st7735_stream_pixel
main:
	addi	sp,sp,-64
	li	a3,160
	li	a2,128
	li	a1,0
	li	a0,0
	sw	ra,60(sp)
	sw	s1,56(sp)
	sw	s2,52(sp)
	sw	s3,48(sp)
	sw	s4,44(sp)
	sw	s6,36(sp)
	sw	s7,32(sp)
	sw	s8,28(sp)
	sw	s9,24(sp)
	sw	s5,40(sp)
	call	st7735_set_rectangle
	li	a1,12288
	li	a0,1048576
	addi	a1,a1,-2048
	addi	a0,a0,16
	li	s3,2
	call	st7735_stream_pixel
	mv	s4,s3
	li	s2,80
	li	s1,64
	li	s6,106
	li	s8,107
	li	s7,138
	li	s9,139
.L22:
	addi	a3,s2,20
	addi	a2,s1,20
	mv	a1,s2
	mv	a0,s1
	call	st7735_set_rectangle
	li	a0,1048576
	li	a1,200
	addi	a0,a0,16
	call	st7735_stream_pixel
	add	s1,s1,s4
	addi	a5,s1,-1
	add	s2,s2,s3
	bleu	a5,s6,.L20
	sgt	s1,s1,s8
	neg	s1,s1
	neg	s4,s4
	andi	s1,s1,108
.L20:
	addi	a5,s2,-1
	neg	s5,s3
	bleu	a5,s7,.L24
	ble	s2,s9,.L25
	li	s2,140
.L21:
	li	a2,-1
	mv	a0,s1
	mv	a1,s2
	call	draw_dvd
	li	a0,98304
	addi	a0,a0,1696
	call	delay
	mv	s3,s5
	j	.L22
.L24:
	mv	s5,s3
	j	.L21
.L25:
	li	s2,0
	j	.L21

# ---- file: ..\..\libc-baremetal\src\st7735.c ----

st7735_draw_triangle:
	ret
st7735_draw_circle:
	ret
st7735_stream_pixel:
	li	a5,0
	li	a4,-1
.L4:
	blt	a5,a1,.L5
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
	addi	sp,sp,-64
	sw	s0,56(sp)
	sub	s0,a3,a1
	srai	a5,s0,31
	sw	s4,40(sp)
	xor	s0,a5,s0
	sw	ra,60(sp)
	sw	s1,52(sp)
	sw	s2,48(sp)
	sw	s3,44(sp)
	sw	s5,36(sp)
	sub	s0,s0,a5
	li	s4,1
	blt	a1,a3,.L10
	li	s4,-1
.L10:
	sub	s1,a4,a2
	srai	a5,s1,31
	xor	s1,a5,s1
	sub	s1,s1,a5
	neg	s5,s1
	li	s3,-1
	bge	a2,a4,.L11
	li	s3,1
.L11:
	sub	s2,s0,s1
.L12:
	sw	a4,28(sp)
	sw	a3,24(sp)
	sw	a2,20(sp)
	sw	a1,16(sp)
	sw	a0,12(sp)
	call	st7735_draw_pixel
	lw	a1,16(sp)
	lw	a3,24(sp)
	lw	a0,12(sp)
	lw	a2,20(sp)
	lw	a4,28(sp)
	bne	a1,a3,.L19
	beq	a2,a4,.L9
.L19:
	slli	a5,s2,1
	bgt	s5,a5,.L15
	sub	s2,s2,s1
	add	a1,a1,s4
	blt	s0,a5,.L12
.L15:
	add	s2,s2,s0
	add	a2,a2,s3
	j	.L12
.L9:
	lw	ra,60(sp)
	lw	s0,56(sp)
	lw	s1,52(sp)
	lw	s2,48(sp)
	lw	s3,44(sp)
	lw	s4,40(sp)
	lw	s5,36(sp)
	addi	sp,sp,64
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
	srai	a1,a1,1
	tail	st7735_stream_pixel

