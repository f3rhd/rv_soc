
__out_tmp.elf:     file format elf32-littleriscv


Disassembly of section .text:

00000000 <_start>:
   0:	00001197          	auipc	gp,0x1
   4:	80018193          	addi	gp,gp,-2048 # 800 <__global_pointer$>
   8:	00020117          	auipc	sp,0x20
   c:	ff810113          	addi	sp,sp,-8 # 20000 <__stack_top>
  10:	008000ef          	jal	18 <main>

00000014 <halt_loop>:
  14:	0000006f          	j	14 <halt_loop>

00000018 <main>:
  18:	00002787          	flw	fa5,0(zero) # 0 <_start>
  1c:	fe010113          	addi	sp,sp,-32
  20:	00f12427          	fsw	fa5,8(sp)
  24:	00402787          	flw	fa5,4(zero) # 4 <_start+0x4>
  28:	00112e23          	sw	ra,28(sp)
  2c:	00f12627          	fsw	fa5,12(sp)
  30:	00812787          	flw	fa5,8(sp)
  34:	00c12707          	flw	fa4,12(sp)
  38:	10e7f7d3          	fmul.s	fa5,fa5,fa4
  3c:	c0079553          	fcvt.w.s	a0,fa5,rtz
  40:	014000ef          	jal	54 <seg_write_hex>
  44:	01c12083          	lw	ra,28(sp)
  48:	00000513          	li	a0,0
  4c:	02010113          	addi	sp,sp,32
  50:	00008067          	ret

00000054 <seg_write_hex>:
  54:	f00007b7          	lui	a5,0xf0000
  58:	00478793          	addi	a5,a5,4 # f0000004 <__stack_top+0xeffe0004>
  5c:	00a79023          	sh	a0,0(a5)
  60:	00008067          	ret
