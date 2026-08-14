
__out_tmp.elf:     file format elf32-littleriscv


Disassembly of section .text:

00000000 <_start>:
   0:	00008137          	lui	sp,0x8
   4:	034000ef          	jal	38 <main>

00000008 <halt_loop>:
   8:	0000006f          	j	8 <halt_loop>

0000000c <fac>:
   c:	00100793          	li	a5,1
  10:	00078713          	mv	a4,a5
  14:	00200693          	li	a3,2
  18:	00a77a63          	bgeu	a4,a0,2c <fac+0x20>
  1c:	00d50a63          	beq	a0,a3,30 <fac+0x24>
  20:	02a787b3          	mul	a5,a5,a0
  24:	fff50513          	addi	a0,a0,-1
  28:	ff1ff06f          	j	18 <fac+0xc>
  2c:	00100513          	li	a0,1
  30:	02f50533          	mul	a0,a0,a5
  34:	00008067          	ret

00000038 <main>:
  38:	ff010113          	addi	sp,sp,-16 # 7ff0 <seg_write_hex+0x7f94>
  3c:	00500513          	li	a0,5
  40:	00112623          	sw	ra,12(sp)
  44:	fc9ff0ef          	jal	c <fac>
  48:	014000ef          	jal	5c <seg_write_hex>
  4c:	00c12083          	lw	ra,12(sp)
  50:	00000513          	li	a0,0
  54:	01010113          	addi	sp,sp,16
  58:	00008067          	ret

0000005c <seg_write_hex>:
  5c:	f00007b7          	lui	a5,0xf0000
  60:	00478793          	addi	a5,a5,4 # f0000004 <seg_write_hex+0xefffffa8>
  64:	00a79023          	sh	a0,0(a5)
  68:	00008067          	ret
