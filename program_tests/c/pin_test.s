
__out_tmp.elf:     file format elf32-littleriscv


Disassembly of section .text:

00000000 <_start>:
   0:	00008137          	lui	sp,0x8
   4:	008000ef          	jal	c <main>

00000008 <halt_loop>:
   8:	0000006f          	j	8 <halt_loop>

0000000c <main>:
   c:	ff010113          	addi	sp,sp,-16 # 7ff0 <read_pin+0x7f64>
  10:	00000593          	li	a1,0
  14:	00000513          	li	a0,0
  18:	00812423          	sw	s0,8(sp)
  1c:	00912223          	sw	s1,4(sp)
  20:	00112623          	sw	ra,12(sp)
  24:	01212023          	sw	s2,0(sp)
  28:	00000413          	li	s0,0
  2c:	040000ef          	jal	6c <set_pin_mode>
  30:	00000493          	li	s1,0
  34:	00000513          	li	a0,0
  38:	054000ef          	jal	8c <read_pin>
  3c:	00a037b3          	snez	a5,a0
  40:	00143413          	seqz	s0,s0
  44:	00f47433          	and	s0,s0,a5
  48:	008484b3          	add	s1,s1,s0
  4c:	00050413          	mv	s0,a0
  50:	00048513          	mv	a0,s1
  54:	008000ef          	jal	5c <seg_write_hex>
  58:	fddff06f          	j	34 <main+0x28>

0000005c <seg_write_hex>:
  5c:	f00007b7          	lui	a5,0xf0000
  60:	00478793          	addi	a5,a5,4 # f0000004 <read_pin+0xefffff78>
  64:	00a79023          	sh	a0,0(a5)
  68:	00008067          	ret

0000006c <set_pin_mode>:
  6c:	00151513          	slli	a0,a0,0x1
  70:	0015f593          	andi	a1,a1,1
  74:	03e57513          	andi	a0,a0,62
  78:	f00007b7          	lui	a5,0xf0000
  7c:	00b56533          	or	a0,a0,a1
  80:	01078793          	addi	a5,a5,16 # f0000010 <read_pin+0xefffff84>
  84:	00a7a023          	sw	a0,0(a5)
  88:	00008067          	ret

0000008c <read_pin>:
  8c:	01f57513          	andi	a0,a0,31
  90:	f00007b7          	lui	a5,0xf0000
  94:	04078793          	addi	a5,a5,64 # f0000040 <read_pin+0xefffffb4>
  98:	00851513          	slli	a0,a0,0x8
  9c:	00f56533          	or	a0,a0,a5
  a0:	00052503          	lw	a0,0(a0)
  a4:	00157513          	andi	a0,a0,1
  a8:	00008067          	ret
