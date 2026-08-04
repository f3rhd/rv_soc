
__out_tmp.elf:     file format elf32-littleriscv


Disassembly of section .text:

00000000 <_start>:
   0:	00008137          	lui	sp,0x8
   4:	090000ef          	jal	94 <main>

00000008 <halt_loop>:
   8:	0000006f          	j	8 <halt_loop>

0000000c <delay>:
   c:	ff010113          	addi	sp,sp,-16 # 7ff0 <seg_write_hex+0x7c6c>
  10:	00012623          	sw	zero,12(sp)
  14:	00c12783          	lw	a5,12(sp)
  18:	00a7e663          	bltu	a5,a0,24 <delay+0x18>
  1c:	01010113          	addi	sp,sp,16
  20:	00008067          	ret
  24:	00c12783          	lw	a5,12(sp)
  28:	00178793          	addi	a5,a5,1
  2c:	00f12623          	sw	a5,12(sp)
  30:	fe5ff06f          	j	14 <delay+0x8>

00000034 <draw_paddle>:
  34:	01400713          	li	a4,20
  38:	00400693          	li	a3,4
  3c:	2c40006f          	j	300 <st7735_draw_rectangle>

00000040 <draw_ball>:
  40:	00400713          	li	a4,4
  44:	00070693          	mv	a3,a4
  48:	2b80006f          	j	300 <st7735_draw_rectangle>

0000004c <ai_move>:
  4c:	00052783          	lw	a5,0(a0)
  50:	00a78713          	addi	a4,a5,10
  54:	40e585b3          	sub	a1,a1,a4
  58:	00300713          	li	a4,3
  5c:	00b75c63          	bge	a4,a1,74 <ai_move+0x28>
  60:	00278793          	addi	a5,a5,2
  64:	00f52023          	sw	a5,0(a0)
  68:	0007de63          	bgez	a5,84 <ai_move+0x38>
  6c:	00052023          	sw	zero,0(a0)
  70:	00008067          	ret
  74:	ffd00713          	li	a4,-3
  78:	fee5d8e3          	bge	a1,a4,68 <ai_move+0x1c>
  7c:	ffe78793          	addi	a5,a5,-2
  80:	fe5ff06f          	j	64 <ai_move+0x18>
  84:	08c00713          	li	a4,140
  88:	00f75463          	bge	a4,a5,90 <ai_move+0x44>
  8c:	00e52023          	sw	a4,0(a0)
  90:	00008067          	ret

00000094 <main>:
  94:	fc010113          	addi	sp,sp,-64
  98:	04600793          	li	a5,70
  9c:	02812c23          	sw	s0,56(sp)
  a0:	0a000713          	li	a4,160
  a4:	08000693          	li	a3,128
  a8:	00000613          	li	a2,0
  ac:	00000593          	li	a1,0
  b0:	00000513          	li	a0,0
  b4:	00200413          	li	s0,2
  b8:	02912a23          	sw	s1,52(sp)
  bc:	03212823          	sw	s2,48(sp)
  c0:	03312623          	sw	s3,44(sp)
  c4:	03412423          	sw	s4,40(sp)
  c8:	03512223          	sw	s5,36(sp)
  cc:	03612023          	sw	s6,32(sp)
  d0:	01712e23          	sw	s7,28(sp)
  d4:	01812c23          	sw	s8,24(sp)
  d8:	01912a23          	sw	s9,20(sp)
  dc:	02112e23          	sw	ra,60(sp)
  e0:	00f12423          	sw	a5,8(sp)
  e4:	00f12623          	sw	a5,12(sp)
  e8:	00040c93          	mv	s9,s0
  ec:	214000ef          	jal	300 <st7735_draw_rectangle>
  f0:	05000493          	li	s1,80
  f4:	04000913          	li	s2,64
  f8:	00000993          	li	s3,0
  fc:	00000a13          	li	s4,0
 100:	00600a93          	li	s5,6
 104:	09b00b13          	li	s6,155
 108:	07100b93          	li	s7,113
 10c:	07a00c13          	li	s8,122
 110:	00048613          	mv	a2,s1
 114:	00090593          	mv	a1,s2
 118:	00000513          	li	a0,0
 11c:	f25ff0ef          	jal	40 <draw_ball>
 120:	00812603          	lw	a2,8(sp)
 124:	00600593          	li	a1,6
 128:	00000513          	li	a0,0
 12c:	f09ff0ef          	jal	34 <draw_paddle>
 130:	00c12603          	lw	a2,12(sp)
 134:	07600593          	li	a1,118
 138:	00000513          	li	a0,0
 13c:	ef9ff0ef          	jal	34 <draw_paddle>
 140:	00048593          	mv	a1,s1
 144:	00810513          	addi	a0,sp,8
 148:	f05ff0ef          	jal	4c <ai_move>
 14c:	00048593          	mv	a1,s1
 150:	00c10513          	addi	a0,sp,12
 154:	008484b3          	add	s1,s1,s0
 158:	ef5ff0ef          	jal	4c <ai_move>
 15c:	01990933          	add	s2,s2,s9
 160:	0a904e63          	bgtz	s1,21c <main+0x188>
 164:	40800433          	neg	s0,s0
 168:	00000493          	li	s1,0
 16c:	00812603          	lw	a2,8(sp)
 170:	0a0cde63          	bgez	s9,22c <main+0x198>
 174:	ffe90793          	addi	a5,s2,-2
 178:	00800713          	li	a4,8
 17c:	10f76063          	bltu	a4,a5,27c <main+0x1e8>
 180:	00448793          	addi	a5,s1,4
 184:	02c7ce63          	blt	a5,a2,1c0 <main+0x12c>
 188:	01460793          	addi	a5,a2,20
 18c:	0297ca63          	blt	a5,s1,1c0 <main+0x12c>
 190:	40c487b3          	sub	a5,s1,a2
 194:	ff878793          	addi	a5,a5,-8
 198:	0357c7b3          	div	a5,a5,s5
 19c:	41900cb3          	neg	s9,s9
 1a0:	00f40433          	add	s0,s0,a5
 1a4:	00400793          	li	a5,4
 1a8:	0087d463          	bge	a5,s0,1b0 <main+0x11c>
 1ac:	00078413          	mv	s0,a5
 1b0:	ffc00793          	li	a5,-4
 1b4:	00f45463          	bge	s0,a5,1bc <main+0x128>
 1b8:	00078413          	mv	s0,a5
 1bc:	00a00913          	li	s2,10
 1c0:	001f0537          	lui	a0,0x1f0
 1c4:	00600593          	li	a1,6
 1c8:	01f50513          	addi	a0,a0,31 # 1f001f <seg_write_hex+0x1efc9b>
 1cc:	e69ff0ef          	jal	34 <draw_paddle>
 1d0:	00c12603          	lw	a2,12(sp)
 1d4:	f8010537          	lui	a0,0xf8010
 1d8:	07600593          	li	a1,118
 1dc:	80050513          	addi	a0,a0,-2048 # f800f800 <seg_write_hex+0xf800f47c>
 1e0:	e55ff0ef          	jal	34 <draw_paddle>
 1e4:	00048613          	mv	a2,s1
 1e8:	00090593          	mv	a1,s2
 1ec:	fff00513          	li	a0,-1
 1f0:	e51ff0ef          	jal	40 <draw_ball>
 1f4:	008a1513          	slli	a0,s4,0x8
 1f8:	01356533          	or	a0,a0,s3
 1fc:	188000ef          	jal	384 <seg_write_hex>
 200:	00891513          	slli	a0,s2,0x8
 204:	00956533          	or	a0,a0,s1
 208:	16c000ef          	jal	374 <led_write>
 20c:	00025537          	lui	a0,0x25
 210:	9f050513          	addi	a0,a0,-1552 # 249f0 <seg_write_hex+0x2466c>
 214:	df9ff0ef          	jal	c <delay>
 218:	ef9ff06f          	j	110 <main+0x7c>
 21c:	f49b58e3          	bge	s6,s1,16c <main+0xd8>
 220:	40800433          	neg	s0,s0
 224:	09c00493          	li	s1,156
 228:	f45ff06f          	j	16c <main+0xd8>
 22c:	f92bdae3          	bge	s7,s2,1c0 <main+0x12c>
 230:	072c4463          	blt	s8,s2,298 <main+0x204>
 234:	00c12783          	lw	a5,12(sp)
 238:	00448713          	addi	a4,s1,4
 23c:	f8f742e3          	blt	a4,a5,1c0 <main+0x12c>
 240:	01478713          	addi	a4,a5,20
 244:	f6974ee3          	blt	a4,s1,1c0 <main+0x12c>
 248:	40f487b3          	sub	a5,s1,a5
 24c:	ff878793          	addi	a5,a5,-8
 250:	0357c7b3          	div	a5,a5,s5
 254:	41900cb3          	neg	s9,s9
 258:	00f40433          	add	s0,s0,a5
 25c:	00400793          	li	a5,4
 260:	0087d463          	bge	a5,s0,268 <main+0x1d4>
 264:	00078413          	mv	s0,a5
 268:	ffc00793          	li	a5,-4
 26c:	00f45463          	bge	s0,a5,274 <main+0x1e0>
 270:	00078413          	mv	s0,a5
 274:	07200913          	li	s2,114
 278:	f49ff06f          	j	1c0 <main+0x12c>
 27c:	f40952e3          	bgez	s2,1c0 <main+0x12c>
 280:	00200413          	li	s0,2
 284:	00198993          	addi	s3,s3,1
 288:	00040c93          	mv	s9,s0
 28c:	05000493          	li	s1,80
 290:	04000913          	li	s2,64
 294:	f2dff06f          	j	1c0 <main+0x12c>
 298:	07c00793          	li	a5,124
 29c:	f327d2e3          	bge	a5,s2,1c0 <main+0x12c>
 2a0:	001a0a13          	addi	s4,s4,1
 2a4:	00200413          	li	s0,2
 2a8:	ffe00c93          	li	s9,-2
 2ac:	fe1ff06f          	j	28c <main+0x1f8>

000002b0 <st7735_set_rectangle>:
 2b0:	00ff07b7          	lui	a5,0xff0
 2b4:	01059593          	slli	a1,a1,0x10
 2b8:	0ff6f693          	zext.b	a3,a3
 2bc:	00f5f5b3          	and	a1,a1,a5
 2c0:	00869693          	slli	a3,a3,0x8
 2c4:	01051513          	slli	a0,a0,0x10
 2c8:	0ff67613          	zext.b	a2,a2
 2cc:	00f57533          	and	a0,a0,a5
 2d0:	00861613          	slli	a2,a2,0x8
 2d4:	00d5e5b3          	or	a1,a1,a3
 2d8:	2b0007b7          	lui	a5,0x2b000
 2dc:	00c56533          	or	a0,a0,a2
 2e0:	2a000737          	lui	a4,0x2a000
 2e4:	00f5e5b3          	or	a1,a1,a5
 2e8:	f00007b7          	lui	a5,0xf0000
 2ec:	00e56533          	or	a0,a0,a4
 2f0:	00478793          	addi	a5,a5,4 # f0000004 <seg_write_hex+0xeffffc80>
 2f4:	00a7a023          	sw	a0,0(a5)
 2f8:	00b7a023          	sw	a1,0(a5)
 2fc:	00008067          	ret

00000300 <st7735_draw_rectangle>:
 300:	fe010113          	addi	sp,sp,-32
 304:	00812c23          	sw	s0,24(sp)
 308:	00912a23          	sw	s1,20(sp)
 30c:	00068413          	mv	s0,a3
 310:	00050493          	mv	s1,a0
 314:	00058513          	mv	a0,a1
 318:	00e606b3          	add	a3,a2,a4
 31c:	00060593          	mv	a1,a2
 320:	00850633          	add	a2,a0,s0
 324:	fff68693          	addi	a3,a3,-1
 328:	fff60613          	addi	a2,a2,-1
 32c:	00112e23          	sw	ra,28(sp)
 330:	00e12623          	sw	a4,12(sp)
 334:	f7dff0ef          	jal	2b0 <st7735_set_rectangle>
 338:	00c12703          	lw	a4,12(sp)
 33c:	2c0007b7          	lui	a5,0x2c000
 340:	02e40433          	mul	s0,s0,a4
 344:	40145413          	srai	s0,s0,0x1
 348:	00f46433          	or	s0,s0,a5
 34c:	f00007b7          	lui	a5,0xf0000
 350:	00478793          	addi	a5,a5,4 # f0000004 <seg_write_hex+0xeffffc80>
 354:	0087a023          	sw	s0,0(a5)
 358:	f00007b7          	lui	a5,0xf0000
 35c:	0097a023          	sw	s1,0(a5) # f0000000 <seg_write_hex+0xeffffc7c>
 360:	01c12083          	lw	ra,28(sp)
 364:	01812403          	lw	s0,24(sp)
 368:	01412483          	lw	s1,20(sp)
 36c:	02010113          	addi	sp,sp,32
 370:	00008067          	ret

00000374 <led_write>:
 374:	f00007b7          	lui	a5,0xf0000
 378:	00c78793          	addi	a5,a5,12 # f000000c <seg_write_hex+0xeffffc88>
 37c:	00a79023          	sh	a0,0(a5)
 380:	00008067          	ret

00000384 <seg_write_hex>:
 384:	f00007b7          	lui	a5,0xf0000
 388:	00878793          	addi	a5,a5,8 # f0000008 <seg_write_hex+0xeffffc84>
 38c:	00a79023          	sh	a0,0(a5)
 390:	00008067          	ret
