
__out_tmp.elf:     file format elf32-littleriscv


Disassembly of section .text:

00000000 <_start>:
   0:	00008137          	lui	sp,0x8
   4:	008000ef          	jal	c <main>

00000008 <halt_loop>:
   8:	0000006f          	j	8 <halt_loop>

0000000c <main>:
   c:	fe010113          	addi	sp,sp,-32 # 7fe0 <seg_write_hex+0x7f6c>
  10:	00812c23          	sw	s0,24(sp)
  14:	00010437          	lui	s0,0x10
  18:	00112e23          	sw	ra,28(sp)
  1c:	00000513          	li	a0,0
  20:	fff40413          	addi	s0,s0,-1 # ffff <seg_write_hex+0xff8b>
  24:	00a12623          	sw	a0,12(sp)
  28:	03c000ef          	jal	64 <led_write>
  2c:	00c12503          	lw	a0,12(sp)
  30:	044000ef          	jal	74 <seg_write_hex>
  34:	00c12503          	lw	a0,12(sp)
  38:	00150513          	addi	a0,a0,1
  3c:	fe8514e3          	bne	a0,s0,24 <main+0x18>
  40:	00a12623          	sw	a0,12(sp)
  44:	020000ef          	jal	64 <led_write>
  48:	00c12503          	lw	a0,12(sp)
  4c:	028000ef          	jal	74 <seg_write_hex>
  50:	01c12083          	lw	ra,28(sp)
  54:	01812403          	lw	s0,24(sp)
  58:	00000513          	li	a0,0
  5c:	02010113          	addi	sp,sp,32
  60:	00008067          	ret

00000064 <led_write>:
  64:	f00007b7          	lui	a5,0xf0000
  68:	00878793          	addi	a5,a5,8 # f0000008 <seg_write_hex+0xefffff94>
  6c:	00a79023          	sh	a0,0(a5)
  70:	00008067          	ret

00000074 <seg_write_hex>:
  74:	f00007b7          	lui	a5,0xf0000
  78:	00478793          	addi	a5,a5,4 # f0000004 <seg_write_hex+0xefffff90>
  7c:	00a79023          	sh	a0,0(a5)
  80:	00008067          	ret
