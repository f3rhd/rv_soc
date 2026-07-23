_start:
    li sp,0x8000
    call main

halt_loop:
    j halt_loop

# ---- file: triangle.c ----

main:
	addi	sp,sp,-16
	sw	ra,12(sp)
	sw	s0,8(sp)
	addi	s0,sp,16
	li	a7,140
	li	a6,108
	li	a5,140
	li	a4,20
	li	a3,80
	li	a2,64
	li	a1,0
	li	a0,2031616
	addi	a0,a0,31
	call	st7735_draw_triangle
	li	a5,0
	mv	a0,a5
	lw	ra,12(sp)
	lw	s0,8(sp)
	addi	sp,sp,16
	jr	ra

# ---- file: ..\..\libc-baremetal\src\st7735.c ----

st7735_draw_pixel:
	addi	sp,sp,-32
	sw	ra,28(sp)
	sw	s0,24(sp)
	addi	s0,sp,32
	sw	a0,-20(s0)
	sw	a1,-24(s0)
	sw	a2,-28(s0)
	lw	a3,-28(s0)
	lw	a2,-24(s0)
	lw	a1,-28(s0)
	lw	a0,-24(s0)
	call	st7735_set_rectangle
	li	a1,1
	lw	a0,-20(s0)
	call	st7735_stream_pixel
	nop
	lw	ra,28(sp)
	lw	s0,24(sp)
	addi	sp,sp,32
	jr	ra
st7735_draw_rectangle:
	addi	sp,sp,-64
	sw	ra,60(sp)
	sw	s0,56(sp)
	addi	s0,sp,64
	sw	a0,-36(s0)
	sw	a1,-40(s0)
	sw	a2,-44(s0)
	sw	a3,-48(s0)
	sw	a4,-52(s0)
	lw	a4,-40(s0)
	lw	a5,-48(s0)
	add	a5,a4,a5
	sw	a5,-20(s0)
	lw	a4,-44(s0)
	lw	a5,-52(s0)
	add	a5,a4,a5
	sw	a5,-24(s0)
	lw	a5,-20(s0)
	addi	a4,a5,-1
	lw	a5,-24(s0)
	addi	a5,a5,-1
	mv	a3,a5
	mv	a2,a4
	lw	a1,-44(s0)
	lw	a0,-40(s0)
	call	st7735_set_rectangle
	lw	a4,-20(s0)
	lw	a5,-40(s0)
	sub	a4,a4,a5
	lw	a3,-24(s0)
	lw	a5,-44(s0)
	sub	a5,a3,a5
	mul	a5,a4,a5
	srai	a5,a5,1
	mv	a1,a5
	lw	a0,-36(s0)
	call	st7735_stream_pixel
	nop
	lw	ra,60(sp)
	lw	s0,56(sp)
	addi	sp,sp,64
	jr	ra
st7735_triangle_fill_span:
	addi	sp,sp,-48
	sw	ra,44(sp)
	sw	s0,40(sp)
	addi	s0,sp,48
	sw	a0,-36(s0)
	sw	a1,-40(s0)
	sw	a2,-44(s0)
	sw	a3,-48(s0)
	lw	a5,-40(s0)
	blt	a5,zero,.L10
	lw	a4,-40(s0)
	li	a5,159
	bgt	a4,a5,.L10
	lw	a4,-44(s0)
	lw	a5,-48(s0)
	ble	a4,a5,.L7
	lw	a5,-44(s0)
	sw	a5,-20(s0)
	lw	a5,-48(s0)
	sw	a5,-44(s0)
	lw	a5,-20(s0)
	sw	a5,-48(s0)
.L7:
	lw	a5,-44(s0)
	bge	a5,zero,.L8
	li	a5,0
.L8:
	sw	a5,-44(s0)
	lw	a5,-48(s0)
	li	a4,127
	ble	a5,a4,.L9
	li	a5,127
.L9:
	sw	a5,-48(s0)
	lw	a4,-40(s0)
	lw	a3,-48(s0)
	lw	a2,-40(s0)
	lw	a1,-44(s0)
	lw	a0,-36(s0)
	call	st7735_draw_line
	j	.L3
.L10:
	nop
.L3:
	lw	ra,44(sp)
	lw	s0,40(sp)
	addi	sp,sp,48
	jr	ra
st7735_triangle_edge_x:
	addi	sp,sp,-48
	sw	ra,44(sp)
	sw	s0,40(sp)
	addi	s0,sp,48
	sw	a0,-20(s0)
	sw	a1,-24(s0)
	sw	a2,-28(s0)
	sw	a3,-32(s0)
	sw	a4,-36(s0)
	lw	a4,-28(s0)
	lw	a5,-36(s0)
	bne	a4,a5,.L12
	lw	a5,-24(s0)
	j	.L13
.L12:
	lw	a4,-32(s0)
	lw	a5,-24(s0)
	sub	a4,a4,a5
	lw	a3,-20(s0)
	lw	a5,-28(s0)
	sub	a5,a3,a5
	mul	a4,a4,a5
	lw	a3,-36(s0)
	lw	a5,-28(s0)
	sub	a5,a3,a5
	div	a4,a4,a5
	lw	a5,-24(s0)
	add	a5,a4,a5
.L13:
	mv	a0,a5
	lw	ra,44(sp)
	lw	s0,40(sp)
	addi	sp,sp,48
	jr	ra
st7735_draw_triangle:
	addi	sp,sp,-128
	sw	ra,124(sp)
	sw	s0,120(sp)
	addi	s0,sp,128
	sw	a0,-100(s0)
	sw	a1,-104(s0)
	sw	a2,-108(s0)
	sw	a3,-112(s0)
	sw	a4,-116(s0)
	sw	a5,-120(s0)
	sw	a6,-124(s0)
	sw	a7,-128(s0)
	lw	a5,-104(s0)
	beq	a5,zero,.L15
	lw	a4,-120(s0)
	lw	a3,-116(s0)
	lw	a2,-112(s0)
	lw	a1,-108(s0)
	lw	a0,-100(s0)
	call	st7735_draw_line
	lw	a4,-128(s0)
	lw	a3,-124(s0)
	lw	a2,-112(s0)
	lw	a1,-108(s0)
	lw	a0,-100(s0)
	call	st7735_draw_line
	lw	a4,-128(s0)
	lw	a3,-124(s0)
	lw	a2,-120(s0)
	lw	a1,-116(s0)
	lw	a0,-100(s0)
	call	st7735_draw_line
	j	.L14
.L15:
	lw	a5,-108(s0)
	sw	a5,-20(s0)
	lw	a5,-112(s0)
	sw	a5,-24(s0)
	lw	a5,-116(s0)
	sw	a5,-28(s0)
	lw	a5,-120(s0)
	sw	a5,-32(s0)
	lw	a5,-124(s0)
	sw	a5,-36(s0)
	lw	a5,-128(s0)
	sw	a5,-40(s0)
	lw	a4,-24(s0)
	lw	a5,-32(s0)
	ble	a4,a5,.L17
	lw	a5,-20(s0)
	sw	a5,-52(s0)
	lw	a5,-28(s0)
	sw	a5,-20(s0)
	lw	a5,-52(s0)
	sw	a5,-28(s0)
	lw	a5,-24(s0)
	sw	a5,-56(s0)
	lw	a5,-32(s0)
	sw	a5,-24(s0)
	lw	a5,-56(s0)
	sw	a5,-32(s0)
.L17:
	lw	a4,-24(s0)
	lw	a5,-40(s0)
	ble	a4,a5,.L18
	lw	a5,-20(s0)
	sw	a5,-60(s0)
	lw	a5,-36(s0)
	sw	a5,-20(s0)
	lw	a5,-60(s0)
	sw	a5,-36(s0)
	lw	a5,-24(s0)
	sw	a5,-64(s0)
	lw	a5,-40(s0)
	sw	a5,-24(s0)
	lw	a5,-64(s0)
	sw	a5,-40(s0)
.L18:
	lw	a4,-32(s0)
	lw	a5,-40(s0)
	ble	a4,a5,.L19
	lw	a5,-28(s0)
	sw	a5,-68(s0)
	lw	a5,-36(s0)
	sw	a5,-28(s0)
	lw	a5,-68(s0)
	sw	a5,-36(s0)
	lw	a5,-32(s0)
	sw	a5,-72(s0)
	lw	a5,-40(s0)
	sw	a5,-32(s0)
	lw	a5,-72(s0)
	sw	a5,-40(s0)
.L19:
	lw	a5,-24(s0)
	sw	a5,-44(s0)
	j	.L20
.L21:
	lw	a4,-40(s0)
	lw	a3,-36(s0)
	lw	a2,-24(s0)
	lw	a1,-20(s0)
	lw	a0,-44(s0)
	call	st7735_triangle_edge_x
	sw	a0,-84(s0)
	lw	a4,-32(s0)
	lw	a3,-28(s0)
	lw	a2,-24(s0)
	lw	a1,-20(s0)
	lw	a0,-44(s0)
	call	st7735_triangle_edge_x
	sw	a0,-88(s0)
	lw	a3,-88(s0)
	lw	a2,-84(s0)
	lw	a1,-44(s0)
	lw	a0,-100(s0)
	call	st7735_triangle_fill_span
	lw	a5,-44(s0)
	addi	a5,a5,1
	sw	a5,-44(s0)
.L20:
	lw	a4,-44(s0)
	lw	a5,-32(s0)
	ble	a4,a5,.L21
	lw	a5,-32(s0)
	sw	a5,-48(s0)
	j	.L22
.L23:
	lw	a4,-40(s0)
	lw	a3,-36(s0)
	lw	a2,-24(s0)
	lw	a1,-20(s0)
	lw	a0,-48(s0)
	call	st7735_triangle_edge_x
	sw	a0,-76(s0)
	lw	a4,-40(s0)
	lw	a3,-36(s0)
	lw	a2,-32(s0)
	lw	a1,-28(s0)
	lw	a0,-48(s0)
	call	st7735_triangle_edge_x
	sw	a0,-80(s0)
	lw	a3,-80(s0)
	lw	a2,-76(s0)
	lw	a1,-48(s0)
	lw	a0,-100(s0)
	call	st7735_triangle_fill_span
	lw	a5,-48(s0)
	addi	a5,a5,1
	sw	a5,-48(s0)
.L22:
	lw	a4,-48(s0)
	lw	a5,-40(s0)
	ble	a4,a5,.L23
.L14:
	lw	ra,124(sp)
	lw	s0,120(sp)
	addi	sp,sp,128
	jr	ra
st7735_draw_line:
	addi	sp,sp,-96
	sw	ra,92(sp)
	sw	s0,88(sp)
	addi	s0,sp,96
	sw	a0,-68(s0)
	sw	a1,-72(s0)
	sw	a2,-76(s0)
	sw	a3,-80(s0)
	sw	a4,-84(s0)
	lw	a5,-72(s0)
	sw	a5,-20(s0)
	lw	a5,-76(s0)
	sw	a5,-24(s0)
	lw	a5,-80(s0)
	sw	a5,-40(s0)
	lw	a5,-84(s0)
	sw	a5,-44(s0)
	lw	a4,-40(s0)
	lw	a5,-20(s0)
	sub	a4,a4,a5
	srai	a5,a4,31
	xor	a4,a5,a4
	sub	a5,a4,a5
	sw	a5,-48(s0)
	lw	a4,-20(s0)
	lw	a5,-40(s0)
	bge	a4,a5,.L25
	li	a5,1
	sw	a5,-28(s0)
	j	.L26
.L25:
	li	a5,-1
	sw	a5,-28(s0)
.L26:
	lw	a4,-44(s0)
	lw	a5,-24(s0)
	sub	a5,a4,a5
	srai	a4,a5,31
	xor	a5,a4,a5
	sub	a5,a5,a4
	neg	a5,a5
	sw	a5,-52(s0)
	lw	a4,-24(s0)
	lw	a5,-44(s0)
	bge	a4,a5,.L27
	li	a5,1
	sw	a5,-32(s0)
	j	.L28
.L27:
	li	a5,-1
	sw	a5,-32(s0)
.L28:
	lw	a4,-48(s0)
	lw	a5,-52(s0)
	add	a5,a4,a5
	sw	a5,-36(s0)
.L33:
	lw	a2,-24(s0)
	lw	a1,-20(s0)
	lw	a0,-68(s0)
	call	st7735_draw_pixel
	lw	a4,-20(s0)
	lw	a5,-40(s0)
	bne	a4,a5,.L29
	lw	a4,-24(s0)
	lw	a5,-44(s0)
	beq	a4,a5,.L35
.L29:
	lw	a5,-36(s0)
	slli	a5,a5,1
	sw	a5,-56(s0)
	lw	a4,-56(s0)
	lw	a5,-52(s0)
	blt	a4,a5,.L31
	lw	a4,-36(s0)
	lw	a5,-52(s0)
	add	a5,a4,a5
	sw	a5,-36(s0)
	lw	a4,-20(s0)
	lw	a5,-28(s0)
	add	a5,a4,a5
	sw	a5,-20(s0)
.L31:
	lw	a4,-56(s0)
	lw	a5,-48(s0)
	bgt	a4,a5,.L33
	lw	a4,-36(s0)
	lw	a5,-48(s0)
	add	a5,a4,a5
	sw	a5,-36(s0)
	lw	a4,-24(s0)
	lw	a5,-32(s0)
	add	a5,a4,a5
	sw	a5,-24(s0)
	j	.L33
.L35:
	nop
	nop
	lw	ra,92(sp)
	lw	s0,88(sp)
	addi	sp,sp,96
	jr	ra
st7735_draw_circle:
	addi	sp,sp,-48
	sw	ra,44(sp)
	sw	s0,40(sp)
	addi	s0,sp,48
	sw	a0,-36(s0)
	sw	a1,-40(s0)
	sw	a2,-44(s0)
	sw	a3,-48(s0)
	lw	a5,-48(s0)
	sw	a5,-20(s0)
	sw	zero,-24(s0)
	li	a4,1
	lw	a5,-48(s0)
	sub	a5,a4,a5
	sw	a5,-28(s0)
	j	.L37
.L39:
	lw	a4,-40(s0)
	lw	a5,-20(s0)
	sub	a1,a4,a5
	lw	a4,-44(s0)
	lw	a5,-24(s0)
	add	a2,a4,a5
	lw	a4,-40(s0)
	lw	a5,-20(s0)
	add	a3,a4,a5
	lw	a4,-44(s0)
	lw	a5,-24(s0)
	add	a5,a4,a5
	mv	a4,a5
	lw	a0,-36(s0)
	call	st7735_draw_line
	lw	a4,-40(s0)
	lw	a5,-20(s0)
	sub	a1,a4,a5
	lw	a4,-44(s0)
	lw	a5,-24(s0)
	sub	a2,a4,a5
	lw	a4,-40(s0)
	lw	a5,-20(s0)
	add	a3,a4,a5
	lw	a4,-44(s0)
	lw	a5,-24(s0)
	sub	a5,a4,a5
	mv	a4,a5
	lw	a0,-36(s0)
	call	st7735_draw_line
	lw	a4,-40(s0)
	lw	a5,-24(s0)
	sub	a1,a4,a5
	lw	a4,-44(s0)
	lw	a5,-20(s0)
	add	a2,a4,a5
	lw	a4,-40(s0)
	lw	a5,-24(s0)
	add	a3,a4,a5
	lw	a4,-44(s0)
	lw	a5,-20(s0)
	add	a5,a4,a5
	mv	a4,a5
	lw	a0,-36(s0)
	call	st7735_draw_line
	lw	a4,-40(s0)
	lw	a5,-24(s0)
	sub	a1,a4,a5
	lw	a4,-44(s0)
	lw	a5,-20(s0)
	sub	a2,a4,a5
	lw	a4,-40(s0)
	lw	a5,-24(s0)
	add	a3,a4,a5
	lw	a4,-44(s0)
	lw	a5,-20(s0)
	sub	a5,a4,a5
	mv	a4,a5
	lw	a0,-36(s0)
	call	st7735_draw_line
	lw	a5,-24(s0)
	addi	a5,a5,1
	sw	a5,-24(s0)
	lw	a5,-28(s0)
	bge	a5,zero,.L38
	lw	a5,-24(s0)
	slli	a5,a5,1
	addi	a5,a5,1
	lw	a4,-28(s0)
	add	a5,a4,a5
	sw	a5,-28(s0)
	j	.L37
.L38:
	lw	a5,-20(s0)
	addi	a5,a5,-1
	sw	a5,-20(s0)
	lw	a4,-24(s0)
	lw	a5,-20(s0)
	sub	a5,a4,a5
	slli	a5,a5,1
	addi	a5,a5,1
	lw	a4,-28(s0)
	add	a5,a4,a5
	sw	a5,-28(s0)
.L37:
	lw	a4,-20(s0)
	lw	a5,-24(s0)
	bge	a4,a5,.L39
	nop
	nop
	lw	ra,44(sp)
	lw	s0,40(sp)
	addi	sp,sp,48
	jr	ra
st7735_stream_pixel:
	addi	sp,sp,-48
	sw	ra,44(sp)
	sw	s0,40(sp)
	addi	s0,sp,48
	sw	a0,-36(s0)
	sw	a1,-40(s0)
	li	a5,-1
	sw	a5,-24(s0)
	sw	zero,-20(s0)
	j	.L41
.L42:
	lw	a5,-36(s0)
	lw	a4,-24(s0)
	sw a5, 0(a4) 
	lw	a5,-20(s0)
	addi	a5,a5,1
	sw	a5,-20(s0)
.L41:
	lw	a4,-20(s0)
	lw	a5,-40(s0)
	blt	a4,a5,.L42
	nop
	nop
	lw	ra,44(sp)
	lw	s0,40(sp)
	addi	sp,sp,48
	jr	ra
st7735_set_rectangle:
	addi	sp,sp,-48
	sw	ra,44(sp)
	sw	s0,40(sp)
	addi	s0,sp,48
	sw	a0,-36(s0)
	sw	a1,-40(s0)
	sw	a2,-44(s0)
	sw	a3,-48(s0)
	li	a5,-16
	sw	a5,-20(s0)
	li	a5,738197504
	sw	a5,-24(s0)
	lw	a5,-36(s0)
	slli	a4,a5,16
	li	a5,16711680
	and	a4,a4,a5
	li	a5,704643072
	or	a4,a4,a5
	lw	a5,-44(s0)
	slli	a5,a5,8
	slli	a5,a5,16
	srli	a5,a5,16
	or	a5,a4,a5
	sw	a5,-28(s0)
	lw	a5,-40(s0)
	slli	a4,a5,16
	li	a5,16711680
	and	a4,a4,a5
	li	a5,721420288
	or	a4,a4,a5
	lw	a5,-48(s0)
	slli	a5,a5,8
	slli	a5,a5,16
	srli	a5,a5,16
	or	a5,a4,a5
	sw	a5,-32(s0)
	lw	a5,-28(s0)
	lw	a4,-32(s0)
	lw	a3,-20(s0)
	sw a5, 0(a3) 
	sw a4, 0(a3) 
	lw	a5,-24(s0)
	lw	a4,-20(s0)
	sw a5, 0(a4) 
	nop
	lw	ra,44(sp)
	lw	s0,40(sp)
	addi	sp,sp,48
	jr	ra

