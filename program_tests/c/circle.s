_start:
    li sp,0x8000
    call main

halt_loop:
    j halt_loop

# ---- file: circle.c ----

delay:
	addi	sp,sp,-16
	sw	zero,12(sp)
.L2:
	lw	a5,12(sp)
	bltu	a5,a0,.L3
	addi	sp,sp,16
	jr	ra
.L3:
	lw	a5,12(sp)
	addi	a5,a5,1
	sw	a5,12(sp)
	j	.L2
main:
	addi	sp,sp,-48
	sw	s2,32(sp)
	li	a4,160
	li	a3,128
	li	a2,0
	li	a1,0
	li	a0,0
	li	s2,2
	sw	s0,40(sp)
	sw	s1,36(sp)
	sw	s3,28(sp)
	sw	s4,24(sp)
	sw	s5,20(sp)
	sw	s6,16(sp)
	sw	s7,12(sp)
	sw	ra,44(sp)
	mv	s3,s2
	call	st7735_draw_rectangle
	li	s1,80
	li	s0,64
	li	s4,86
	li	s6,107
	li	s5,118
	li	s7,140
.L10:
	mv	a2,s1
	mv	a1,s0
	li	a3,20
	li	a0,0
	call	st7735_draw_circle
	add	s0,s0,s3
	addi	a5,s0,-21
	add	s1,s1,s2
	bleu	a5,s4,.L6
	sgt	s0,s0,s6
	neg	s0,s0
	andi	s0,s0,88
	neg	s3,s3
	addi	s0,s0,20
.L6:
	addi	a4,s1,-21
	neg	a5,s2
	bleu	a4,s5,.L7
	bne	s1,zero,.L8
	li	s1,20
.L8:
	ble	s1,s7,.L9
	li	s1,140
.L9:
	mv	s2,a5
.L7:
	li	a0,1048576
	li	a3,20
	mv	a2,s1
	mv	a1,s0
	addi	a0,a0,16
	call	st7735_draw_circle
	li	a0,249856
	addi	a0,a0,144
	call	delay
	j	.L10

# ---- file: ..\..\libc-baremetal\src\st7735.c ----

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
	li	a5,-1
	sw s0, 0(a5) 
	lw	ra,12(sp)
	lw	s0,8(sp)
	addi	sp,sp,16
	jr	ra
st7735_draw_rectangle:
	addi	sp,sp,-32
	sw	s0,24(sp)
	sw	s1,20(sp)
	mv	s0,a3
	mv	s1,a0
	mv	a0,a1
	add	a3,a2,a4
	mv	a1,a2
	add	a2,a0,s0
	addi	a3,a3,-1
	addi	a2,a2,-1
	sw	a4,12(sp)
	sw	ra,28(sp)
	call	st7735_set_rectangle
	lw	a4,12(sp)
	li	a5,0
	mul	s0,s0,a4
	li	a4,-1
	srai	s0,s0,1
.L5:
	bgt	s0,a5,.L6
	lw	ra,28(sp)
	lw	s0,24(sp)
	lw	s1,20(sp)
	addi	sp,sp,32
	jr	ra
.L6:
	sw s1, 0(a4) 
	addi	a5,a5,1
	j	.L5
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
	blt	a1,a3,.L9
	li	s4,-1
.L9:
	sub	s1,a4,a2
	srai	a5,s1,31
	xor	s1,a5,s1
	sub	s1,s1,a5
	neg	s5,s1
	li	s3,-1
	bge	a2,a4,.L10
	li	s3,1
.L10:
	sub	s2,s0,s1
.L11:
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
	bne	a1,a3,.L18
	beq	a2,a4,.L8
.L18:
	slli	a5,s2,1
	bgt	s5,a5,.L14
	sub	s2,s2,s1
	add	a1,a1,s4
	blt	s0,a5,.L11
.L14:
	add	s2,s2,s0
	add	a2,a2,s3
	j	.L11
.L8:
	lw	ra,60(sp)
	lw	s0,56(sp)
	lw	s1,52(sp)
	lw	s2,48(sp)
	lw	s3,44(sp)
	lw	s4,40(sp)
	lw	s5,36(sp)
	addi	sp,sp,64
	jr	ra
st7735_triangle_fill_span:
	mv	a5,a3
	ble	a2,a3,.L25
	xor	a2,a2,a3
.L25:
	li	a4,159
	bgtu	a1,a4,.L24
	li	a4,160
	xor	a3,a2,a5
	li	a2,127
	mul	a4,a1,a4
	ble	a3,a2,.L27
	mv	a3,a2
.L27:
	not	a1,a5
	srai	a1,a1,31
	mv	a2,a4
	and	a1,a5,a1
	tail	st7735_draw_line
.L24:
	ret
st7735_draw_triangle:
	addi	sp,sp,-80
	sw	s0,72(sp)
	sw	s1,68(sp)
	sw	s2,64(sp)
	sw	s3,60(sp)
	sw	s4,56(sp)
	sw	s5,52(sp)
	sw	ra,76(sp)
	sw	s6,48(sp)
	sw	s7,44(sp)
	sw	s8,40(sp)
	sw	s9,36(sp)
	sw	s10,32(sp)
	sw	s11,28(sp)
	sw	a0,8(sp)
	mv	s3,a2
	mv	s1,a3
	mv	s4,a4
	mv	s0,a5
	mv	s5,a6
	mv	s2,a7
	beq	a1,zero,.L30
	mv	a4,a5
	mv	a3,s4
	mv	a2,s1
	mv	a1,s3
	call	st7735_draw_line
	lw	a0,8(sp)
	mv	a4,s2
	mv	a3,s5
	mv	a2,s1
	mv	a1,s3
	call	st7735_draw_line
	mv	a2,s0
	lw	s0,72(sp)
	lw	a0,8(sp)
	lw	ra,76(sp)
	lw	s1,68(sp)
	lw	s3,60(sp)
	lw	s6,48(sp)
	lw	s7,44(sp)
	lw	s8,40(sp)
	lw	s9,36(sp)
	lw	s10,32(sp)
	lw	s11,28(sp)
	mv	a4,s2
	mv	a3,s5
	lw	s2,64(sp)
	lw	s5,52(sp)
	mv	a1,s4
	lw	s4,56(sp)
	addi	sp,sp,80
	tail	st7735_draw_line
.L30:
	bgt	a3,a5,.L31
	ble	a3,a7,.L32
	mv	s1,a7
	mv	s2,a3
	mv	s3,a6
	mv	s5,a2
.L32:
	blt	s2,s0,.L33
	mv	a5,s2
	mv	s2,s0
	mv	s0,a5
	mv	a5,s5
	mv	s5,s4
	mv	s4,a5
.L33:
	sub	s9,s5,s3
	sub	s7,s4,s3
	mv	a1,s1
	li	s8,0
	li	s6,0
	sub	s10,s0,s1
	sub	s11,s2,s1
.L34:
	bge	s2,a1,.L37
	sub	a5,s2,s1
	sub	s8,s4,s5
	mul	s4,a5,s7
	mv	s11,s2
	li	s6,0
	sub	s9,s0,s1
	sub	s10,s0,s2
.L38:
	bge	s0,s11,.L41
	lw	ra,76(sp)
	lw	s0,72(sp)
	lw	s1,68(sp)
	lw	s2,64(sp)
	lw	s3,60(sp)
	lw	s4,56(sp)
	lw	s5,52(sp)
	lw	s6,48(sp)
	lw	s7,44(sp)
	lw	s8,40(sp)
	lw	s9,36(sp)
	lw	s10,32(sp)
	lw	s11,28(sp)
	addi	sp,sp,80
	jr	ra
.L47:
	mv	a5,s2
	mv	s2,s0
	mv	s0,s1
	mv	s1,a5
	mv	a5,s5
	mv	s5,s4
	mv	s4,s3
	mv	s3,a5
	j	.L33
.L37:
	mv	a2,s3
	beq	s0,s1,.L35
	div	a2,s8,s10
	add	a2,a2,s3
.L35:
	mv	a3,s3
	beq	s2,s1,.L36
	div	a3,s6,s11
	add	a3,a3,s3
.L36:
	lw	a0,8(sp)
	sw	a1,12(sp)
	add	s6,s6,s9
	call	st7735_triangle_fill_span
	lw	a1,12(sp)
	add	s8,s8,s7
	addi	a1,a1,1
	j	.L34
.L41:
	mv	a2,s3
	beq	s0,s1,.L39
	div	a2,s4,s9
	add	a2,a2,s3
.L39:
	mv	a3,s5
	beq	s2,s0,.L40
	div	a3,s6,s10
	add	a3,a3,s5
.L40:
	lw	a0,8(sp)
	mv	a1,s11
	add	s6,s6,s8
	call	st7735_triangle_fill_span
	addi	s11,s11,1
	add	s4,s4,s7
	j	.L38
.L31:
	bgt	a5,a7,.L47
	mv	s1,s0
	mv	s3,a4
	mv	s0,a3
	mv	s4,a2
	j	.L32
st7735_draw_circle:
	addi	sp,sp,-48
	sw	s2,32(sp)
	li	s2,1
	sw	s0,40(sp)
	sw	s1,36(sp)
	sw	s3,28(sp)
	sw	s4,24(sp)
	sw	s5,20(sp)
	sw	ra,44(sp)
	mv	s5,a0
	mv	s3,a1
	mv	s4,a2
	mv	s0,a3
	sub	s2,s2,a3
	li	s1,0
.L51:
	bge	s0,s1,.L54
	lw	ra,44(sp)
	lw	s0,40(sp)
	lw	s1,36(sp)
	lw	s2,32(sp)
	lw	s3,28(sp)
	lw	s4,24(sp)
	lw	s5,20(sp)
	addi	sp,sp,48
	jr	ra
.L54:
	add	a4,s4,s1
	sub	a1,s3,s0
	add	a3,s0,s3
	mv	a2,a4
	mv	a0,s5
	sw	a3,12(sp)
	sw	a1,8(sp)
	call	st7735_draw_line
	lw	a3,12(sp)
	lw	a1,8(sp)
	sub	a4,s4,s1
	mv	a2,a4
	mv	a0,s5
	call	st7735_draw_line
	add	a4,s0,s4
	sub	a1,s3,s1
	add	a3,s1,s3
	mv	a2,a4
	mv	a0,s5
	sw	a3,12(sp)
	sw	a1,8(sp)
	call	st7735_draw_line
	lw	a3,12(sp)
	lw	a1,8(sp)
	sub	a4,s4,s0
	mv	a2,a4
	mv	a0,s5
	call	st7735_draw_line
	addi	s1,s1,1
	slli	a5,s1,1
	blt	s2,zero,.L56
	addi	s0,s0,-1
	sub	a5,s1,s0
	slli	a5,a5,1
.L56:
	addi	a5,a5,1
	add	s2,s2,a5
	j	.L51

