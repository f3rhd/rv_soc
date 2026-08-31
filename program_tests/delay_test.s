
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
  1c:	00812423          	sw	s0,8(sp)
  20:	00112623          	sw	ra,12(sp)
  24:	00000413          	li	s0,0
  28:	00040513          	mv	a0,s0
  2c:	01c000ef          	jal	48 <seg_write_hex>
  30:	05f5e5b7          	lui	a1,0x5f5e
  34:	10058593          	addi	a1,a1,256 # 5f5e100 <__stack_top+0x5f3e100>
  38:	3e800513          	li	a0,1000
  3c:	01c000ef          	jal	58 <delay>
  40:	00140413          	addi	s0,s0,1
  44:	fe5ff06f          	j	28 <main+0x10>

00000048 <seg_write_hex>:
  48:	f00007b7          	lui	a5,0xf0000
  4c:	00478793          	addi	a5,a5,4 # f0000004 <__stack_top+0xeffe0004>
  50:	00a79023          	sh	a0,0(a5)
  54:	00008067          	ret

00000058 <delay>:
  58:	f0000737          	lui	a4,0xf0000
  5c:	f0000637          	lui	a2,0xf0000
  60:	10070713          	addi	a4,a4,256 # f0000100 <__stack_top+0xeffe0100>
  64:	08060613          	addi	a2,a2,128 # f0000080 <__stack_top+0xeffe0080>
  68:	00072683          	lw	a3,0(a4)
  6c:	00062783          	lw	a5,0(a2)
  70:	00072803          	lw	a6,0(a4)
  74:	ff069ae3          	bne	a3,a6,68 <delay+0x10>
  78:	3e800713          	li	a4,1000
  7c:	02e5d5b3          	divu	a1,a1,a4
  80:	f0000637          	lui	a2,0xf0000
  84:	08060613          	addi	a2,a2,128 # f0000080 <__stack_top+0xeffe0080>
  88:	02a58733          	mul	a4,a1,a0
  8c:	02a5b5b3          	mulhu	a1,a1,a0
  90:	00e78733          	add	a4,a5,a4
  94:	00f737b3          	sltu	a5,a4,a5
  98:	00b686b3          	add	a3,a3,a1
  9c:	00d787b3          	add	a5,a5,a3
  a0:	f00006b7          	lui	a3,0xf0000
  a4:	10068693          	addi	a3,a3,256 # f0000100 <__stack_top+0xeffe0100>
  a8:	0006a583          	lw	a1,0(a3)
  ac:	00062503          	lw	a0,0(a2)
  b0:	0006a803          	lw	a6,0(a3)
  b4:	ff059ae3          	bne	a1,a6,a8 <delay+0x50>
  b8:	fef5e8e3          	bltu	a1,a5,a8 <delay+0x50>
  bc:	00b79463          	bne	a5,a1,c4 <delay+0x6c>
  c0:	fee564e3          	bltu	a0,a4,a8 <delay+0x50>
  c4:	00008067          	ret
