
__out_tmp.elf:     file format elf32-littleriscv


Disassembly of section .text:

00000000 <__static_end>:
   0:	00001197          	auipc	gp,0x1
   4:	80018193          	addi	gp,gp,-2048 # 800 <__global_pointer$>
   8:	00020117          	auipc	sp,0x20
   c:	ff810113          	addi	sp,sp,-8 # 20000 <__stack_top>
  10:	034000ef          	jal	44 <main>

00000014 <halt_loop>:
  14:	0000006f          	j	14 <halt_loop>

00000018 <fac>:
  18:	00100793          	li	a5,1
  1c:	00078713          	mv	a4,a5
  20:	00200693          	li	a3,2
  24:	00a77a63          	bgeu	a4,a0,38 <fac+0x20>
  28:	00d50a63          	beq	a0,a3,3c <fac+0x24>
  2c:	02a787b3          	mul	a5,a5,a0
  30:	fff50513          	addi	a0,a0,-1
  34:	ff1ff06f          	j	24 <fac+0xc>
  38:	00100513          	li	a0,1
  3c:	02f50533          	mul	a0,a0,a5
  40:	00008067          	ret

00000044 <main>:
  44:	ff010113          	addi	sp,sp,-16
  48:	00500513          	li	a0,5
  4c:	00112623          	sw	ra,12(sp)
  50:	fc9ff0ef          	jal	18 <fac>
  54:	014000ef          	jal	68 <seg_write_hex>
  58:	00c12083          	lw	ra,12(sp)
  5c:	00000513          	li	a0,0
  60:	01010113          	addi	sp,sp,16
  64:	00008067          	ret

00000068 <seg_write_hex>:
  68:	f00007b7          	lui	a5,0xf0000
  6c:	00478793          	addi	a5,a5,4 # f0000004 <__stack_top+0xeffe0004>
  70:	00a79023          	sh	a0,0(a5)
  74:	00008067          	ret
