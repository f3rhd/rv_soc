
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
  18:	fd010113          	addi	sp,sp,-48
  1c:	00100593          	li	a1,1
  20:	00800513          	li	a0,8
  24:	02812423          	sw	s0,40(sp)
  28:	02112623          	sw	ra,44(sp)
  2c:	000f4437          	lui	s0,0xf4
  30:	03c000ef          	jal	6c <set_pin_mode>
  34:	fff00593          	li	a1,-1
  38:	23f40413          	addi	s0,s0,575 # f423f <__stack_top+0xd423f>
  3c:	fff5c593          	not	a1,a1
  40:	00800513          	li	a0,8
  44:	00b12623          	sw	a1,12(sp)
  48:	044000ef          	jal	8c <drive_pin>
  4c:	00c12583          	lw	a1,12(sp)
  50:	00012e23          	sw	zero,28(sp)
  54:	01c12783          	lw	a5,28(sp)
  58:	fef442e3          	blt	s0,a5,3c <main+0x24>
  5c:	01c12783          	lw	a5,28(sp)
  60:	00178793          	addi	a5,a5,1
  64:	00f12e23          	sw	a5,28(sp)
  68:	fedff06f          	j	54 <main+0x3c>

0000006c <set_pin_mode>:
  6c:	00151513          	slli	a0,a0,0x1
  70:	0015f593          	andi	a1,a1,1
  74:	03e57513          	andi	a0,a0,62
  78:	f00007b7          	lui	a5,0xf0000
  7c:	00b56533          	or	a0,a0,a1
  80:	01078793          	addi	a5,a5,16 # f0000010 <__stack_top+0xeffe0010>
  84:	00a7a023          	sw	a0,0(a5)
  88:	00008067          	ret

0000008c <drive_pin>:
  8c:	00151513          	slli	a0,a0,0x1
  90:	0015f593          	andi	a1,a1,1
  94:	03e57513          	andi	a0,a0,62
  98:	f00007b7          	lui	a5,0xf0000
  9c:	00b56533          	or	a0,a0,a1
  a0:	02078793          	addi	a5,a5,32 # f0000020 <__stack_top+0xeffe0020>
  a4:	00a7a023          	sw	a0,0(a5)
  a8:	00008067          	ret
