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
	addi	sp,sp,-16
	mv	a5,a2
	li	a4,20
	mv	a2,a1
	mv	a1,a0
	mv	a3,a4
	mv	a0,a5
	addi	sp,sp,16
	tail	st7735_draw_rectangle
main:
	addi	sp,sp,-64
	li	a4,160
	li	a3,128
	li	a2,0
	li	a1,0
	li	a0,0
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
	sw	ra,60(sp)
	call	st7735_draw_rectangle
	li	a5,1048576
	addi	a5,a5,16
	li	s2,2
	sw	a5,8(sp)
	mv	s3,s2
	li	s10,80
	li	s9,64
	li	s1,0
	li	s4,106
	li	s6,8
	li	s8,139
	li	s7,107
	li	s5,138
.L30:
	addi	a4,s10,20
	addi	a3,s9,20
	mv	a2,s10
	mv	a1,s9
	li	a0,0
	call	st7735_draw_rectangle
	add	s9,s9,s3
	add	s10,s10,s2
	addi	a5,s9,-1
	addi	a4,s10,-1
	bgtu	a5,s4,.L22
	bleu	a4,s5,.L24
.L23:
	neg	s2,s2
	ble	s10,s8,.L34
.L40:
	li	s10,140
.L26:
	addi	s1,s1,1
	ble	s1,s6,.L27
	li	s1,0
.L27:
	mv	a1,s1
	addi	a0,sp,8
	call	change_color_on_collision
.L24:
	lw	a0,8(sp)
	li	a4,20
	mv	a3,a4
	mv	a2,s10
	mv	a1,s9
	call	st7735_draw_rectangle
	lw	a5,8(sp)
	beq	a5,zero,.L28
	sw	zero,12(sp)
	lw	a5,12(sp)
	li	a4,499712
	addi	a4,a4,287
	bgtu	a5,a4,.L30
.L29:
	lw	a5,12(sp)
	addi	a5,a5,1
	sw	a5,12(sp)
	lw	a5,12(sp)
	bleu	a5,a4,.L29
	j	.L30
.L22:
	neg	s3,s3
	ble	s9,s7,.L25
	li	s9,108
	bleu	a4,s5,.L26
	neg	s2,s2
	bgt	s10,s8,.L40
.L34:
	li	s10,0
	j	.L26
.L25:
	li	s9,0
	bleu	a4,s5,.L26
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
	add	a5,a1,a3
	add	a6,a2,a4
	addi	a5,a5,-1
	addi	a6,a6,-1
	li	a7,16711680
	andi	a5,a5,255
	slli	a1,a1,16
	slli	a2,a2,16
	andi	a6,a6,255
	and	a1,a1,a7
	and	a2,a2,a7
	slli	a5,a5,8
	slli	a6,a6,8
	or	a5,a5,a1
	or	a6,a6,a2
	li	a1,704643072
	li	a2,721420288
	or	a6,a6,a2
	or	a5,a5,a1
	li	a2,-16
	sw a5, 0(a2) 
	sw a6, 0(a2) 
	li	a5,738197504
	sw a5, 0(a2) 
	mul	a3,a3,a4
	srai	a3,a3,1
	ble	a3,zero,.L3
	li	a5,0
	li	a4,-1
.L5:
	sw a0, 0(a4) 
	addi	a5,a5,1
	bne	a3,a5,.L5
.L3:
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
	blt	a1,s5,.L8
	li	s7,-1
.L8:
	sub	a4,s6,a2
	srai	a5,a4,31
	xor	a4,a5,a4
	sub	a4,a4,a5
	neg	s4,a4
	li	s8,-1
	bge	a2,s6,.L9
	li	s8,1
.L9:
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
.L10:
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
	bne	t5,zero,.L17
	beq	a2,s6,.L7
.L17:
	bgt	s4,a5,.L13
	add	a1,a1,s7
	sub	a7,a7,a4
	slli	t0,a1,16
	slli	t6,a1,8
	sub	t5,a1,s5
	blt	t4,a5,.L10
.L13:
	add	a2,a2,s8
	add	a7,a7,t4
	slli	a0,a2,16
	slli	t2,a2,8
	j	.L10
.L7:
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
st7735_draw_triangle:
	addi	sp,sp,-80
	sw	s0,72(sp)
	sw	s1,68(sp)
	sw	s2,64(sp)
	sw	s3,60(sp)
	sw	s5,52(sp)
	sw	s7,44(sp)
	sw	s10,32(sp)
	sw	ra,76(sp)
	mv	s7,a2
	mv	s5,a3
	mv	s3,a4
	mv	s0,a5
	mv	s1,a6
	mv	s10,a7
	mv	s2,a0
	bne	a1,zero,.L95
	sw	s4,56(sp)
	sw	s6,48(sp)
	sw	s8,40(sp)
	sw	s9,36(sp)
	sw	s11,28(sp)
	ble	a3,a5,.L27
	bgt	a5,a7,.L28
	mv	a4,a5
	mv	a5,s3
	bgt	a3,a7,.L78
	mv	s0,a3
	mv	s3,a2
	mv	s5,a7
	mv	s7,a6
	mv	s10,a4
	mv	s1,a5
.L28:
	beq	s5,s10,.L96
.L29:
	beq	s0,s10,.L32
	sub	t1,s7,s1
	sub	a7,s3,s1
	mv	s4,s10
	li	s8,0
	li	s6,0
	sub	s9,s5,s10
	sub	a6,s0,s10
	li	t3,127
	li	s11,159
.L39:
	div	a2,s6,s9
	div	a5,s8,a6
	add	a4,a2,s1
	mv	a3,a4
	add	a1,a5,s1
	bgt	a2,a5,.L33
	xor	a3,a4,a1
	bgt	a3,t3,.L90
.L35:
	slli	a4,s4,2
	not	a5,a1
	add	a4,a4,s4
	slli	a4,a4,5
	srai	a5,a5,31
	mv	a2,a4
	and	a1,a1,a5
	mv	a0,s2
	bgtu	s4,s11,.L37
	sw	a6,12(sp)
	sw	a7,8(sp)
	sw	t1,4(sp)
	call	st7735_draw_line
	lw	a6,12(sp)
	lw	a7,8(sp)
	lw	t1,4(sp)
	li	t3,127
.L37:
	addi	s4,s4,1
	add	s6,s6,t1
	add	s8,s8,a7
	ble	s4,s0,.L39
.L55:
	bgt	s0,s5,.L25
	beq	s0,s5,.L58
	beq	s5,s10,.L59
	sub	s11,s7,s1
	sub	s6,s0,s10
	mul	s6,s6,s11
	sub	s9,s5,s10
	sub	s7,s7,s3
	sub	s10,s5,s0
	li	s8,0
	li	s4,159
.L64:
	slli	a4,s0,2
	add	a4,a4,s0
	slli	a4,a4,5
	mv	a0,s2
	div	a5,s8,s10
	mv	a2,a4
	div	a3,s6,s9
	add	a5,a5,s3
	not	a1,a5
	srai	a1,a1,31
	and	a1,a5,a1
	add	a3,a3,s1
	bgt	a3,a5,.L60
	xor	a3,a3,a5
.L60:
	bgtu	s0,s4,.L61
	li	a5,127
	ble	a3,a5,.L62
	mv	a3,a5
.L62:
	call	st7735_draw_line
.L61:
	addi	s0,s0,1
	add	s6,s6,s11
	add	s8,s8,s7
	ble	s0,s5,.L64
.L25:
	lw	ra,76(sp)
	lw	s0,72(sp)
	lw	s4,56(sp)
	lw	s6,48(sp)
	lw	s8,40(sp)
	lw	s9,36(sp)
	lw	s11,28(sp)
	lw	s1,68(sp)
	lw	s2,64(sp)
	lw	s3,60(sp)
	lw	s5,52(sp)
	lw	s7,44(sp)
	lw	s10,32(sp)
	addi	sp,sp,80
	jr	ra
.L27:
	ble	a3,a7,.L97
	bge	a3,a5,.L29
	mv	a4,a5
	mv	s5,a4
	mv	a5,s3
	mv	s0,a3
	mv	s3,a2
	mv	s7,a5
	bne	s5,s10,.L29
	j	.L96
.L33:
	ble	a4,t3,.L35
.L90:
	li	a3,127
	j	.L35
.L95:
	mv	a4,a5
	mv	a3,s3
	mv	a2,s5
	mv	a1,s7
	call	st7735_draw_line
	mv	a4,s10
	mv	a3,s1
	mv	a2,s5
	mv	a1,s7
	mv	a0,s2
	call	st7735_draw_line
	mv	a2,s0
	lw	s0,72(sp)
	lw	ra,76(sp)
	lw	s5,52(sp)
	lw	s7,44(sp)
	mv	a4,s10
	mv	a3,s1
	lw	s10,32(sp)
	lw	s1,68(sp)
	mv	a1,s3
	mv	a0,s2
	lw	s3,60(sp)
	lw	s2,64(sp)
	addi	sp,sp,80
	tail	st7735_draw_line
.L97:
	bgt	a5,a7,.L98
	mv	s5,a7
	mv	s10,a3
	mv	s7,a6
	mv	s1,a2
	bne	s5,s10,.L29
.L96:
	sub	s9,s3,s1
	mv	s4,s5
	li	s6,0
	sub	a6,s0,s5
	li	s11,127
	li	s8,159
	beq	s0,s10,.L80
.L99:
	div	a5,s6,a6
	mv	a3,s1
	add	a5,a5,s1
	blt	a5,s1,.L49
	xor	a3,a5,s1
	bgt	a3,s11,.L93
.L48:
	slli	a4,s4,2
	add	a4,a4,s4
	not	a1,a5
	slli	a4,a4,5
	srai	a1,a1,31
	mv	a2,a4
	and	a1,a5,a1
	mv	a0,s2
	bgtu	s4,s8,.L52
	sw	a6,4(sp)
	call	st7735_draw_line
	lw	a6,4(sp)
.L52:
	addi	s4,s4,1
	add	s6,s6,s9
	bgt	s4,s0,.L55
	bne	s0,s10,.L99
.L80:
	li	a3,0
	mv	a5,s1
	j	.L48
.L49:
	ble	s1,s11,.L48
.L93:
	li	a3,127
	j	.L48
.L58:
	sub	s7,s7,s1
	sub	s8,s0,s10
	mul	s9,s8,s7
	slli	s4,s0,2
	not	s6,s3
	add	s4,s4,s0
	srai	s6,s6,31
	slli	s4,s4,5
	and	s6,s3,s6
	li	s11,159
.L76:
	mv	a4,s4
	mv	a2,s4
	mv	a1,s6
	mv	a0,s2
	mv	a3,s1
	beq	s5,s10,.L71
	div	a3,s9,s8
	add	a3,a3,s1
.L71:
	bgt	a3,s3,.L72
	xor	a3,a3,s3
.L72:
	bgtu	s0,s11,.L73
	li	a5,127
	ble	a3,a5,.L74
	mv	a3,a5
.L74:
	call	st7735_draw_line
.L73:
	addi	s0,s0,1
	addi	s4,s4,160
	add	s9,s9,s7
	ble	s0,s5,.L76
	j	.L25
.L32:
	not	s6,s1
	srai	s6,s6,31
	slli	s4,s0,2
	and	a5,s1,s6
	add	s4,s4,s0
	slli	s4,s4,5
	sw	a5,4(sp)
	sub	a7,s7,s1
	mv	s8,s0
	li	s11,0
	sub	s9,s5,s0
	li	t1,127
	li	s6,159
.L47:
	div	a5,s11,s9
	add	a5,a5,s1
	mv	a3,a5
	bgt	a5,s1,.L92
	xor	a3,a5,s1
.L92:
	ble	a3,t1,.L43
	li	a3,127
.L43:
	lw	a1,4(sp)
	mv	a4,s4
	mv	a2,s4
	mv	a0,s2
	bgtu	s8,s6,.L45
	sw	a7,8(sp)
	call	st7735_draw_line
	lw	a7,8(sp)
	li	t1,127
.L45:
	addi	s8,s8,1
	add	s11,s11,a7
	addi	s4,s4,160
	ble	s8,s0,.L47
	j	.L55
.L59:
	slli	s4,s0,2
	add	s4,s4,s0
	sub	s7,s7,s3
	slli	s4,s4,5
	sub	s10,s5,s0
	li	s8,0
	li	s9,159
	li	s6,127
.L70:
	div	a5,s8,s10
	mv	a4,s4
	mv	a2,s4
	mv	a0,s2
	mv	a3,s1
	add	a5,a5,s3
	not	a1,a5
	srai	a1,a1,31
	and	a1,a5,a1
	blt	a5,s1,.L66
	xor	a3,a5,s1
.L66:
	bgtu	s0,s9,.L67
	ble	a3,s6,.L68
	li	a3,127
.L68:
	call	st7735_draw_line
.L67:
	addi	s0,s0,1
	add	s8,s8,s7
	addi	s4,s4,160
	ble	s0,s5,.L70
	j	.L25
.L78:
	mv	s0,a7
	mv	s3,a6
	mv	s10,a4
	mv	s1,a5
	j	.L29
.L98:
	mv	a4,a5
	mv	s10,a3
	mv	a5,s3
	mv	s5,a4
	mv	s0,a7
	mv	s3,a6
	mv	s1,a2
	mv	s7,a5
	bne	s5,s10,.L29
	j	.L96
st7735_draw_circle:
	ret

