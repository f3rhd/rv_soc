_start:
    li sp,0x8000
    call main

halt_loop:
    j halt_loop

# ---- file: counter.c ----

main:
	addi	sp,sp,-16
	sw	s1,4(sp)
	li	s1,65536
	sw	s0,8(sp)
	sw	ra,12(sp)
	addi	s1,s1,-1
	li	s0,0
.L2:
	mv	a0,s0
	call	led_write
	mv	a0,s0
	addi	s0,s0,1
	call	seg_write_hex
	bne	s0,s1,.L2
	mv	a0,s0
	call	led_write
	mv	a0,s0
	call	seg_write_hex
	lw	ra,12(sp)
	lw	s0,8(sp)
	lw	s1,4(sp)
	li	a0,0
	addi	sp,sp,16
	jr	ra

# ---- file: ..\..\libc-baremetal\src\led.c ----

led_write:
	li	a5,-268435456
	addi	a5,a5,12
	sh a0, 0(a5) 
	ret
seg_write_hex:
	li	a5,-268435456
	addi	a5,a5,8
	sh a0, 0(a5) 
	ret

