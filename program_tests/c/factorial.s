
__out_tmp.elf:     file format elf32-littleriscv


Disassembly of section .text:

00000000 <_start>:
   0:	00008137          	lui	sp,0x8
   4:	008000ef          	jal	c <main>

00000008 <halt_loop>:
   8:	0000006f          	j	8 <halt_loop>

0000000c <main>:
   c:	ff010113          	addi	sp,sp,-16 # 7ff0 <seg_write_hex+0x7fc4>
  10:	07800513          	li	a0,120
  14:	00112623          	sw	ra,12(sp)
  18:	014000ef          	jal	2c <seg_write_hex>
  1c:	00c12083          	lw	ra,12(sp)
  20:	00000513          	li	a0,0
  24:	01010113          	addi	sp,sp,16
  28:	00008067          	ret

0000002c <seg_write_hex>:
  2c:	f00007b7          	lui	a5,0xf0000
  30:	00878793          	addi	a5,a5,8 # f0000008 <seg_write_hex+0xefffffdc>
  34:	00a79023          	sh	a0,0(a5)
  38:	00008067          	ret
