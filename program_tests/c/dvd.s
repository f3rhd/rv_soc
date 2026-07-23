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
	li	a4,2031616
	addi	a4,a4,31
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
	lw	a5,12(sp)
	bleu	a0,a5,.L13
.L15:
	lw	a5,12(sp)
	addi	a5,a5,1
	sw	a5,12(sp)
	lw	a5,12(sp)
	bltu	a5,a0,.L15
.L13:
	addi	sp,sp,16
	jr	ra
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
	sw	s5,40(sp)
	sw	s6,36(sp)
	sw	s7,32(sp)
	sw	s8,28(sp)
	sw	s9,24(sp)
	sw	s10,20(sp)
	sw	s11,16(sp)
	call	st7735_set_rectangle
	li	a1,12288
	addi	a1,a1,-2048
	li	a0,0
	call	st7735_stream_pixel
	li	a5,1048576
	addi	a5,a5,16
	li	s3,2
	sw	a5,8(sp)
	mv	s4,s3
	li	s9,80
	li	s8,64
	li	s2,0
	li	s1,0
	li	s5,106
	li	s6,8
	li	s7,139
.L30:
	addi	a3,s9,20
	addi	a2,s8,20
	mv	a1,s9
	mv	a0,s8
	call	st7735_set_rectangle
	li	a1,200
	li	a0,0
	call	st7735_stream_pixel
	add	s8,s8,s4
	add	s9,s9,s3
	addi	a5,s8,-1
	addi	a4,s9,-1
	bgtu	a5,s5,.L22
	li	a5,138
	addi	s10,s8,19
	addi	s11,s9,19
	bleu	a4,a5,.L24
.L23:
	neg	s3,s3
	ble	s9,s7,.L34
	li	s11,159
	li	s9,140
.L26:
	addi	s1,s1,1
	addi	s2,s2,1
	ble	s1,s6,.L27
	li	s1,0
.L27:
	mv t0, s2
	mv	a1,s1
	addi	a0,sp,8
	call	change_color_on_collision
.L24:
	mv	a2,s10
	lw	s10,8(sp)
	mv	a3,s11
	mv	a1,s9
	mv	a0,s8
	call	st7735_set_rectangle
	mv	a0,s10
	li	a1,200
	call	st7735_stream_pixel
	lw	a5,8(sp)
	beq	a5,zero,.L28
	sw	zero,12(sp)
	lw	a5,12(sp)
	li	a4,249856
	addi	a4,a4,143
	bgtu	a5,a4,.L30
.L29:
	lw	a5,12(sp)
	addi	a5,a5,1
	sw	a5,12(sp)
	lw	a5,12(sp)
	bleu	a5,a4,.L29
	j	.L30
.L22:
	li	a5,107
	neg	s4,s4
	ble	s8,a5,.L25
	li	a5,138
	bgtu	a4,a5,.L32
	addi	s11,s9,19
	li	s10,127
	li	s8,108
	j	.L26
.L34:
	li	s11,19
	li	s9,0
	j	.L26
.L25:
	li	a5,138
	bgtu	a4,a5,.L33
	addi	s11,s9,19
	li	s10,19
	li	s8,0
	j	.L26
.L32:
	li	s10,127
	li	s8,108
	j	.L23
.L33:
	li	s10,19
	li	s8,0
	j	.L23
.L28:
	lw	ra,60(sp)
	lw	s1,56(sp)
	lw	s2,52(sp)
	lw	s3,48(sp)
	lw	s4,44(sp)
	lw	s5,40(sp)
	lw	s6,36(sp)
	lw	s7,32(sp)
	lw	s8,28(sp)
	lw	s9,24(sp)
	lw	s10,20(sp)
	lw	s11,16(sp)
	li	a0,0
	addi	sp,sp,64
	jr	ra

# ---- file: ..\..\libc-baremetal\src\st7735.c ----

st7735_draw_pixel:
	li	a3,16711680
	slli	a5,a1,16
	slli	a4,a2,16
	andi	a1,a1,255
	andi	a2,a2,255
	slli	a1,a1,8
	and	a5,a5,a3
	and	a4,a4,a3
	slli	a2,a2,8
	or	a5,a5,a1
	or	a4,a4,a2
	li	a1,704643072
	li	a3,721420288
	or	a4,a4,a3
	or	a5,a5,a1
	li	a3,-16
	sw a5, 0(a3) 
	sw a4, 0(a3) 
	li	a5,738197504
	sw a5, 0(a3) 
	li	a5,-1
	sw a0, 0(a5) 
	ret
st7735_draw_rectangle:
	li	t3,16711680
	slli	a5,a0,16
	andi	t1,a2,255
	slli	a6,a1,16
	andi	a7,a3,255
	and	a5,a5,t3
	slli	t1,t1,8
	and	a6,a6,t3
	slli	a7,a7,8
	or	a5,a5,t1
	or	a6,a6,a7
	li	t1,704643072
	li	a7,721420288
	or	a6,a6,a7
	or	a5,a5,t1
	li	a7,-16
	sw a5, 0(a7) 
	sw a6, 0(a7) 
	li	a5,738197504
	sw a5, 0(a7) 
	sub	a3,a3,a2
	sub	a1,a1,a0
	mul	a1,a1,a3
	srai	a3,a1,1
	ble	a3,zero,.L3
	li	a5,0
	li	a2,-1
.L5:
	sw a4, 0(a2) 
	addi	a5,a5,1
	bne	a3,a5,.L5
.L3:
	ret
st7735_draw_triangle:
	ret
st7735_draw_line:
	sub	t4,a3,a1
	addi	sp,sp,-48
	srai	a5,t4,31
	sw	s5,24(sp)
	sw	s6,20(sp)
	sw	s7,16(sp)
	mv	s5,a3
	xor	t4,a5,t4
	sw	s0,44(sp)
	sw	s1,40(sp)
	sw	s2,36(sp)
	sw	s3,32(sp)
	sw	s4,28(sp)
	sw	s8,12(sp)
	sw	s9,8(sp)
	mv	a3,a0
	mv	s6,a4
	sub	t4,t4,a5
	li	s7,1
	blt	a1,s5,.L9
	li	s7,-1
.L9:
	sub	a4,s6,a2
	srai	a5,a4,31
	xor	a4,a5,a4
	sub	a4,a4,a5
	neg	s4,a4
	li	s8,-1
	bge	a2,s6,.L10
	li	s8,1
.L10:
	sub	a7,t4,a4
	slli	t0,a1,16
	slli	t6,a1,8
	slli	a0,a2,16
	slli	t2,a2,8
	sub	t5,a1,s5
	li	t3,16711680
	li	s3,704643072
	li	s2,721420288
	li	t1,-16
	li	s1,738197504
	li	s0,-1
.L11:
	slli	a6,t6,16
	srli	a6,a6,16
	slli	s9,t2,16
	and	a5,t0,t3
	srli	s9,s9,16
	or	a5,a5,a6
	and	a6,a0,t3
	or	a6,a6,s9
	or	a5,a5,s3
	or	a6,a6,s2
	sw a5, 0(t1) 
	sw a6, 0(t1) 
	sw s1, 0(t1) 
	sw a3, 0(s0) 
	slli	a5,a7,1
	bne	t5,zero,.L18
	beq	a2,s6,.L8
.L18:
	bgt	s4,a5,.L14
	add	a1,a1,s7
	sub	a7,a7,a4
	slli	t0,a1,16
	slli	t6,a1,8
	sub	t5,a1,s5
	blt	t4,a5,.L11
.L14:
	add	a2,a2,s8
	add	a7,a7,t4
	slli	a0,a2,16
	slli	t2,a2,8
	j	.L11
.L8:
	lw	s0,44(sp)
	lw	s1,40(sp)
	lw	s2,36(sp)
	lw	s3,32(sp)
	lw	s4,28(sp)
	lw	s5,24(sp)
	lw	s6,20(sp)
	lw	s7,16(sp)
	lw	s8,12(sp)
	lw	s9,8(sp)
	addi	sp,sp,48
	jr	ra
st7735_draw_circle:
	ret
st7735_stream_pixel:
	ble	a1,zero,.L27
	li	a5,0
	li	a4,-1
.L29:
	sw a0, 0(a4) 
	addi	a5,a5,1
	bne	a1,a5,.L29
.L27:
	ret
st7735_set_rectangle:
	li	a5,16711680
	slli	a0,a0,16
	slli	a1,a1,16
	andi	a2,a2,255
	andi	a3,a3,255
	slli	a2,a2,8
	slli	a3,a3,8
	and	a0,a0,a5
	and	a1,a1,a5
	or	a0,a0,a2
	or	a1,a1,a3
	li	a4,704643072
	li	a5,721420288
	or	a1,a1,a5
	or	a0,a0,a4
	li	a5,-16
	sw a0, 0(a5) 
	sw a1, 0(a5) 
	li	a4,738197504
	sw a4, 0(a5) 
	ret

