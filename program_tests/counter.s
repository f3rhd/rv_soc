
__out_tmp.elf:     file format elf32-littleriscv


Disassembly of section .text:

00000000 <__static_end>:
   0:	00001197          	auipc	gp,0x1
   4:	80018193          	addi	gp,gp,-2048 # 800 <__global_pointer$>
   8:	00020117          	auipc	sp,0x20
   c:	ff810113          	addi	sp,sp,-8 # 20000 <__stack_top>
  10:	008000ef          	jal	18 <main>

00000014 <halt_loop>:
  14:	0000006f          	j	14 <halt_loop>

00000018 <main>:
  18:	fe010113          	addi	sp,sp,-32
  1c:	00812c23          	sw	s0,24(sp)
  20:	00010437          	lui	s0,0x10
  24:	00112e23          	sw	ra,28(sp)
  28:	00000513          	li	a0,0
  2c:	fff40413          	addi	s0,s0,-1 # ffff <__static_reserve+0xefff>
  30:	00a12623          	sw	a0,12(sp)
  34:	03c000ef          	jal	70 <led_write>
  38:	00c12503          	lw	a0,12(sp)
  3c:	044000ef          	jal	80 <seg_write_hex>
  40:	00c12503          	lw	a0,12(sp)
  44:	00150513          	addi	a0,a0,1
  48:	fe8514e3          	bne	a0,s0,30 <main+0x18>
  4c:	00a12623          	sw	a0,12(sp)
  50:	020000ef          	jal	70 <led_write>
  54:	00c12503          	lw	a0,12(sp)
  58:	028000ef          	jal	80 <seg_write_hex>
  5c:	01c12083          	lw	ra,28(sp)
  60:	01812403          	lw	s0,24(sp)
  64:	00000513          	li	a0,0
  68:	02010113          	addi	sp,sp,32
  6c:	00008067          	ret

00000070 <led_write>:
  70:	f00007b7          	lui	a5,0xf0000
  74:	00878793          	addi	a5,a5,8 # f0000008 <__stack_top+0xeffe0008>
  78:	00a79023          	sh	a0,0(a5)
  7c:	00008067          	ret

00000080 <seg_write_hex>:
  80:	f00007b7          	lui	a5,0xf0000
  84:	00478793          	addi	a5,a5,4 # f0000004 <__stack_top+0xeffe0004>
  88:	00a79023          	sh	a0,0(a5)
  8c:	00008067          	ret
