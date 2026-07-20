_start:
    li sp,0x8000
    call main

halt_loop:
    j halt_loop

# ---- file: dvd/dvd.c ----

delay:
	ret
draw_dvd:
	addi	sp,sp,-32
	addi	a3,a1,20
	addi	a2,a0,20
	sw	ra,28(sp)
	call	st7735_set_rectangle
	lw	ra,28(sp)
	li	a0,2031616
	li	a1,400
	addi	a0,a0,31
	addi	sp,sp,32
	tail	st7735_stream_pixel
main:
	addi	sp,sp,-64
	li	a3,160
	li	a2,128
	li	a1,0
	li	a0,0
	sw	ra,60(sp)
	sw	s0,56(sp)
	sw	s1,52(sp)
	sw	s2,48(sp)
	sw	s3,44(sp)
	sw	s4,40(sp)
	sw	s5,36(sp)
	sw	s6,32(sp)
	sw	s7,28(sp)
	sw	s8,24(sp)
	call	st7735_set_rectangle
	li	a1,20480
	li	a0,0
	call	st7735_stream_pixel
	li	a0,64
	li	a1,80
	li	s2,2
	call	draw_dvd
	mv	s3,s2
	li	s0,80
	li	s1,64
	li	s4,106
	li	s6,107
	li	s5,138
	li	s7,139
.L7:
	li	a3,160
	li	a2,128
	li	a1,0
	li	a0,0
	call	st7735_set_rectangle
	li	a1,20480
	li	a0,0
	call	st7735_stream_pixel
	add	s1,s1,s3
	addi	a5,s1,-1
	add	s0,s0,s2
	bleu	a5,s4,.L5
	sgt	s1,s1,s6
	neg	s1,s1
	neg	s3,s3
	andi	s1,s1,108
.L5:
	addi	a5,s0,-1
	neg	s8,s2
	bleu	a5,s5,.L9
	sgt	s0,s0,s7
	neg	s0,s0
	andi	s0,s0,140
.L6:
	mv	a0,s1
	mv	a1,s0
	call	draw_dvd
	mv	s2,s8
	j	.L7
.L9:
	mv	s8,s2
	j	.L6

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

