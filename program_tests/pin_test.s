
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
  18:	ff010113          	addi	sp,sp,-16
  1c:	00000593          	li	a1,0
  20:	00000513          	li	a0,0
  24:	00812423          	sw	s0,8(sp)
  28:	00912223          	sw	s1,4(sp)
  2c:	00112623          	sw	ra,12(sp)
  30:	01212023          	sw	s2,0(sp)
  34:	00000413          	li	s0,0
  38:	040000ef          	jal	78 <set_pin_mode>
  3c:	00000493          	li	s1,0
  40:	00000513          	li	a0,0
  44:	054000ef          	jal	98 <read_pin>
  48:	00a037b3          	snez	a5,a0
  4c:	00143413          	seqz	s0,s0
  50:	00f47433          	and	s0,s0,a5
  54:	008484b3          	add	s1,s1,s0
  58:	00050413          	mv	s0,a0
  5c:	00048513          	mv	a0,s1
  60:	008000ef          	jal	68 <seg_write_hex>
  64:	fddff06f          	j	40 <main+0x28>

00000068 <seg_write_hex>:
  68:	f00007b7          	lui	a5,0xf0000
  6c:	00478793          	addi	a5,a5,4 # f0000004 <__stack_top+0xeffe0004>
  70:	00a79023          	sh	a0,0(a5)
  74:	00008067          	ret

00000078 <set_pin_mode>:
  78:	00151513          	slli	a0,a0,0x1
  7c:	0015f593          	andi	a1,a1,1
  80:	03e57513          	andi	a0,a0,62
  84:	f00007b7          	lui	a5,0xf0000
  88:	00b56533          	or	a0,a0,a1
  8c:	01078793          	addi	a5,a5,16 # f0000010 <__stack_top+0xeffe0010>
  90:	00a7a023          	sw	a0,0(a5)
  94:	00008067          	ret

00000098 <read_pin>:
  98:	01f57513          	andi	a0,a0,31
  9c:	f00007b7          	lui	a5,0xf0000
  a0:	04078793          	addi	a5,a5,64 # f0000040 <__stack_top+0xeffe0040>
  a4:	00851513          	slli	a0,a0,0x8
  a8:	00f56533          	or	a0,a0,a5
  ac:	00052503          	lw	a0,0(a0)
  b0:	00157513          	andi	a0,a0,1
  b4:	00008067          	ret
