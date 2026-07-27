
__out_tmp.elf:     file format elf32-littleriscv


Disassembly of section .text:

00000000 <_start>:
   0:	00008137          	lui	sp,0x8
   4:	1a0000ef          	jal	1a4 <main>

00000008 <halt_loop>:
   8:	0000006f          	j	8 <halt_loop>

0000000c <change_color_on_collision>:
   c:	ff010113          	addi	sp,sp,-16 # 7ff0 <seg_write_hex+0x7c4c>
  10:	00a12623          	sw	a0,12(sp)
  14:	00b12423          	sw	a1,8(sp)
  18:	00812703          	lw	a4,8(sp)
  1c:	00800793          	li	a5,8
  20:	14f70c63          	beq	a4,a5,178 <change_color_on_collision+0x16c>
  24:	00812703          	lw	a4,8(sp)
  28:	00800793          	li	a5,8
  2c:	16e7c063          	blt	a5,a4,18c <change_color_on_collision+0x180>
  30:	00812703          	lw	a4,8(sp)
  34:	00700793          	li	a5,7
  38:	12f70663          	beq	a4,a5,164 <change_color_on_collision+0x158>
  3c:	00812703          	lw	a4,8(sp)
  40:	00700793          	li	a5,7
  44:	14e7c463          	blt	a5,a4,18c <change_color_on_collision+0x180>
  48:	00812703          	lw	a4,8(sp)
  4c:	00600793          	li	a5,6
  50:	10f70063          	beq	a4,a5,150 <change_color_on_collision+0x144>
  54:	00812703          	lw	a4,8(sp)
  58:	00600793          	li	a5,6
  5c:	12e7c863          	blt	a5,a4,18c <change_color_on_collision+0x180>
  60:	00812703          	lw	a4,8(sp)
  64:	00500793          	li	a5,5
  68:	0cf70a63          	beq	a4,a5,13c <change_color_on_collision+0x130>
  6c:	00812703          	lw	a4,8(sp)
  70:	00500793          	li	a5,5
  74:	10e7cc63          	blt	a5,a4,18c <change_color_on_collision+0x180>
  78:	00812703          	lw	a4,8(sp)
  7c:	00400793          	li	a5,4
  80:	0af70463          	beq	a4,a5,128 <change_color_on_collision+0x11c>
  84:	00812703          	lw	a4,8(sp)
  88:	00400793          	li	a5,4
  8c:	10e7c063          	blt	a5,a4,18c <change_color_on_collision+0x180>
  90:	00812703          	lw	a4,8(sp)
  94:	00300793          	li	a5,3
  98:	06f70e63          	beq	a4,a5,114 <change_color_on_collision+0x108>
  9c:	00812703          	lw	a4,8(sp)
  a0:	00300793          	li	a5,3
  a4:	0ee7c463          	blt	a5,a4,18c <change_color_on_collision+0x180>
  a8:	00812703          	lw	a4,8(sp)
  ac:	00200793          	li	a5,2
  b0:	04f70863          	beq	a4,a5,100 <change_color_on_collision+0xf4>
  b4:	00812703          	lw	a4,8(sp)
  b8:	00200793          	li	a5,2
  bc:	0ce7c863          	blt	a5,a4,18c <change_color_on_collision+0x180>
  c0:	00812783          	lw	a5,8(sp)
  c4:	00078a63          	beqz	a5,d8 <change_color_on_collision+0xcc>
  c8:	00812703          	lw	a4,8(sp)
  cc:	00100793          	li	a5,1
  d0:	00f70e63          	beq	a4,a5,ec <change_color_on_collision+0xe0>
  d4:	0b80006f          	j	18c <change_color_on_collision+0x180>
  d8:	00c12783          	lw	a5,12(sp)
  dc:	001f0737          	lui	a4,0x1f0
  e0:	01f70713          	addi	a4,a4,31 # 1f001f <seg_write_hex+0x1efc7b>
  e4:	00e7a023          	sw	a4,0(a5)
  e8:	0b00006f          	j	198 <change_color_on_collision+0x18c>
  ec:	00c12783          	lw	a5,12(sp)
  f0:	001f0737          	lui	a4,0x1f0
  f4:	01f70713          	addi	a4,a4,31 # 1f001f <seg_write_hex+0x1efc7b>
  f8:	00e7a023          	sw	a4,0(a5)
  fc:	09c0006f          	j	198 <change_color_on_collision+0x18c>
 100:	00c12783          	lw	a5,12(sp)
 104:	07e00737          	lui	a4,0x7e00
 108:	7e070713          	addi	a4,a4,2016 # 7e007e0 <seg_write_hex+0x7e0043c>
 10c:	00e7a023          	sw	a4,0(a5)
 110:	0880006f          	j	198 <change_color_on_collision+0x18c>
 114:	00c12783          	lw	a5,12(sp)
 118:	f8010737          	lui	a4,0xf8010
 11c:	80070713          	addi	a4,a4,-2048 # f800f800 <seg_write_hex+0xf800f45c>
 120:	00e7a023          	sw	a4,0(a5)
 124:	0740006f          	j	198 <change_color_on_collision+0x18c>
 128:	00c12783          	lw	a5,12(sp)
 12c:	ffe10737          	lui	a4,0xffe10
 130:	fe070713          	addi	a4,a4,-32 # ffe0ffe0 <seg_write_hex+0xffe0fc3c>
 134:	00e7a023          	sw	a4,0(a5)
 138:	0600006f          	j	198 <change_color_on_collision+0x18c>
 13c:	00c12783          	lw	a5,12(sp)
 140:	f8200737          	lui	a4,0xf8200
 144:	81f70713          	addi	a4,a4,-2017 # f81ff81f <seg_write_hex+0xf81ff47b>
 148:	00e7a023          	sw	a4,0(a5)
 14c:	04c0006f          	j	198 <change_color_on_collision+0x18c>
 150:	00c12783          	lw	a5,12(sp)
 154:	07ff0737          	lui	a4,0x7ff0
 158:	7ff70713          	addi	a4,a4,2047 # 7ff07ff <seg_write_hex+0x7ff045b>
 15c:	00e7a023          	sw	a4,0(a5)
 160:	0380006f          	j	198 <change_color_on_collision+0x18c>
 164:	00c12783          	lw	a5,12(sp)
 168:	053f0737          	lui	a4,0x53f0
 16c:	53f70713          	addi	a4,a4,1343 # 53f053f <seg_write_hex+0x53f019b>
 170:	00e7a023          	sw	a4,0(a5)
 174:	0240006f          	j	198 <change_color_on_collision+0x18c>
 178:	00c12783          	lw	a5,12(sp)
 17c:	cdbfd737          	lui	a4,0xcdbfd
 180:	dbf70713          	addi	a4,a4,-577 # cdbfcdbf <seg_write_hex+0xcdbfca1b>
 184:	00e7a023          	sw	a4,0(a5)
 188:	0100006f          	j	198 <change_color_on_collision+0x18c>
 18c:	00c12783          	lw	a5,12(sp)
 190:	0007a023          	sw	zero,0(a5)
 194:	00000013          	nop
 198:	00000013          	nop
 19c:	01010113          	addi	sp,sp,16
 1a0:	00008067          	ret

000001a4 <main>:
 1a4:	fb010113          	addi	sp,sp,-80
 1a8:	0a000713          	li	a4,160
 1ac:	08000693          	li	a3,128
 1b0:	00000613          	li	a2,0
 1b4:	00000593          	li	a1,0
 1b8:	00000513          	li	a0,0
 1bc:	04812423          	sw	s0,72(sp)
 1c0:	04912223          	sw	s1,68(sp)
 1c4:	05212023          	sw	s2,64(sp)
 1c8:	03312e23          	sw	s3,60(sp)
 1cc:	03412c23          	sw	s4,56(sp)
 1d0:	03512a23          	sw	s5,52(sp)
 1d4:	03612823          	sw	s6,48(sp)
 1d8:	03712623          	sw	s7,44(sp)
 1dc:	03812423          	sw	s8,40(sp)
 1e0:	03912223          	sw	s9,36(sp)
 1e4:	03a12023          	sw	s10,32(sp)
 1e8:	04112623          	sw	ra,76(sp)
 1ec:	01b12e23          	sw	s11,28(sp)
 1f0:	138000ef          	jal	328 <st7735_draw_rectangle>
 1f4:	001007b7          	lui	a5,0x100
 1f8:	01078793          	addi	a5,a5,16 # 100010 <seg_write_hex+0xffc6c>
 1fc:	00200993          	li	s3,2
 200:	00007d37          	lui	s10,0x7
 204:	00f12423          	sw	a5,8(sp)
 208:	00098a13          	mv	s4,s3
 20c:	c00d0d13          	addi	s10,s10,-1024 # 6c00 <seg_write_hex+0x685c>
 210:	05000493          	li	s1,80
 214:	04000413          	li	s0,64
 218:	00000913          	li	s2,0
 21c:	06a00a93          	li	s5,106
 220:	00800b93          	li	s7,8
 224:	08b00c93          	li	s9,139
 228:	06b00c13          	li	s8,107
 22c:	08a00b13          	li	s6,138
 230:	01400713          	li	a4,20
 234:	00070693          	mv	a3,a4
 238:	00048613          	mv	a2,s1
 23c:	00040593          	mv	a1,s0
 240:	00000513          	li	a0,0
 244:	0e4000ef          	jal	328 <st7735_draw_rectangle>
 248:	01440433          	add	s0,s0,s4
 24c:	013484b3          	add	s1,s1,s3
 250:	fff40793          	addi	a5,s0,-1
 254:	fff48713          	addi	a4,s1,-1
 258:	04faee63          	bltu	s5,a5,2b4 <main+0x110>
 25c:	00841d93          	slli	s11,s0,0x8
 260:	08eb6863          	bltu	s6,a4,2f0 <main+0x14c>
 264:	009dedb3          	or	s11,s11,s1
 268:	000d8513          	mv	a0,s11
 26c:	138000ef          	jal	3a4 <seg_write_hex>
 270:	00812503          	lw	a0,8(sp)
 274:	01400713          	li	a4,20
 278:	00070693          	mv	a3,a4
 27c:	00048613          	mv	a2,s1
 280:	00040593          	mv	a1,s0
 284:	0a4000ef          	jal	328 <st7735_draw_rectangle>
 288:	00012623          	sw	zero,12(sp)
 28c:	00c12783          	lw	a5,12(sp)
 290:	0003d737          	lui	a4,0x3d
 294:	08f70713          	addi	a4,a4,143 # 3d08f <seg_write_hex+0x3cceb>
 298:	f8f76ce3          	bltu	a4,a5,230 <main+0x8c>
 29c:	00c12783          	lw	a5,12(sp)
 2a0:	00178793          	addi	a5,a5,1
 2a4:	00f12623          	sw	a5,12(sp)
 2a8:	00c12783          	lw	a5,12(sp)
 2ac:	fef778e3          	bgeu	a4,a5,29c <main+0xf8>
 2b0:	f81ff06f          	j	230 <main+0x8c>
 2b4:	41400a33          	neg	s4,s4
 2b8:	028c5663          	bge	s8,s0,2e4 <main+0x140>
 2bc:	04eb6863          	bltu	s6,a4,30c <main+0x168>
 2c0:	01a4edb3          	or	s11,s1,s10
 2c4:	06c00413          	li	s0,108
 2c8:	00190913          	addi	s2,s2,1
 2cc:	012bd463          	bge	s7,s2,2d4 <main+0x130>
 2d0:	00000913          	li	s2,0
 2d4:	00090593          	mv	a1,s2
 2d8:	00810513          	addi	a0,sp,8
 2dc:	d31ff0ef          	jal	c <change_color_on_collision>
 2e0:	f89ff06f          	j	268 <main+0xc4>
 2e4:	02eb7c63          	bgeu	s6,a4,31c <main+0x178>
 2e8:	00000d93          	li	s11,0
 2ec:	00000413          	li	s0,0
 2f0:	413009b3          	neg	s3,s3
 2f4:	009cd863          	bge	s9,s1,304 <main+0x160>
 2f8:	08cded93          	ori	s11,s11,140
 2fc:	08c00493          	li	s1,140
 300:	fc9ff06f          	j	2c8 <main+0x124>
 304:	00000493          	li	s1,0
 308:	fc1ff06f          	j	2c8 <main+0x124>
 30c:	00007db7          	lui	s11,0x7
 310:	c00d8d93          	addi	s11,s11,-1024 # 6c00 <seg_write_hex+0x685c>
 314:	06c00413          	li	s0,108
 318:	fd9ff06f          	j	2f0 <main+0x14c>
 31c:	00048d93          	mv	s11,s1
 320:	00000413          	li	s0,0
 324:	fa5ff06f          	j	2c8 <main+0x124>

00000328 <st7735_draw_rectangle>:
 328:	00e60833          	add	a6,a2,a4
 32c:	00d587b3          	add	a5,a1,a3
 330:	fff80813          	addi	a6,a6,-1
 334:	00ff08b7          	lui	a7,0xff0
 338:	fff78793          	addi	a5,a5,-1
 33c:	01061613          	slli	a2,a2,0x10
 340:	0ff87813          	zext.b	a6,a6
 344:	01167633          	and	a2,a2,a7
 348:	0ff7f793          	zext.b	a5,a5
 34c:	01059593          	slli	a1,a1,0x10
 350:	00881813          	slli	a6,a6,0x8
 354:	0115f5b3          	and	a1,a1,a7
 358:	00c86833          	or	a6,a6,a2
 35c:	00879793          	slli	a5,a5,0x8
 360:	2b000637          	lui	a2,0x2b000
 364:	00b7e7b3          	or	a5,a5,a1
 368:	00c86833          	or	a6,a6,a2
 36c:	2a0005b7          	lui	a1,0x2a000
 370:	f0000637          	lui	a2,0xf0000
 374:	00b7e7b3          	or	a5,a5,a1
 378:	00460613          	addi	a2,a2,4 # f0000004 <seg_write_hex+0xeffffc60>
 37c:	f00005b7          	lui	a1,0xf0000
 380:	00f62023          	sw	a5,0(a2)
 384:	01062023          	sw	a6,0(a2)
 388:	02e686b3          	mul	a3,a3,a4
 38c:	2c0007b7          	lui	a5,0x2c000
 390:	4016d693          	srai	a3,a3,0x1
 394:	00f6e6b3          	or	a3,a3,a5
 398:	00d62023          	sw	a3,0(a2)
 39c:	00a5a023          	sw	a0,0(a1) # f0000000 <seg_write_hex+0xeffffc5c>
 3a0:	00008067          	ret

000003a4 <seg_write_hex>:
 3a4:	f00007b7          	lui	a5,0xf0000
 3a8:	00878793          	addi	a5,a5,8 # f0000008 <seg_write_hex+0xeffffc64>
 3ac:	00a79023          	sh	a0,0(a5)
 3b0:	00008067          	ret
