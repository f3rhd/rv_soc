
__out_tmp.elf:     file format elf32-littleriscv


Disassembly of section .text:

00000000 <__static_end>:
   0:	00001197          	auipc	gp,0x1
   4:	80018193          	addi	gp,gp,-2048 # 800 <__global_pointer$>
   8:	00020117          	auipc	sp,0x20
   c:	ff810113          	addi	sp,sp,-8 # 20000 <__stack_top>
  10:	090000ef          	jal	a0 <main>

00000014 <halt_loop>:
  14:	0000006f          	j	14 <halt_loop>

00000018 <delay>:
  18:	ff010113          	addi	sp,sp,-16
  1c:	00012623          	sw	zero,12(sp)
  20:	00c12783          	lw	a5,12(sp)
  24:	00a7e663          	bltu	a5,a0,30 <delay+0x18>
  28:	01010113          	addi	sp,sp,16
  2c:	00008067          	ret
  30:	00c12783          	lw	a5,12(sp)
  34:	00178793          	addi	a5,a5,1
  38:	00f12623          	sw	a5,12(sp)
  3c:	fe5ff06f          	j	20 <delay+0x8>

00000040 <draw_paddle>:
  40:	01400713          	li	a4,20
  44:	00400693          	li	a3,4
  48:	2e40006f          	j	32c <st7735_draw_rectangle>

0000004c <draw_ball>:
  4c:	00400713          	li	a4,4
  50:	00070693          	mv	a3,a4
  54:	2d80006f          	j	32c <st7735_draw_rectangle>

00000058 <ai_move>:
  58:	00052783          	lw	a5,0(a0)
  5c:	00a78713          	addi	a4,a5,10
  60:	40e585b3          	sub	a1,a1,a4
  64:	00300713          	li	a4,3
  68:	00b75c63          	bge	a4,a1,80 <ai_move+0x28>
  6c:	00278793          	addi	a5,a5,2
  70:	00f52023          	sw	a5,0(a0)
  74:	0007de63          	bgez	a5,90 <ai_move+0x38>
  78:	00052023          	sw	zero,0(a0)
  7c:	00008067          	ret
  80:	ffd00713          	li	a4,-3
  84:	fee5d8e3          	bge	a1,a4,74 <ai_move+0x1c>
  88:	ffe78793          	addi	a5,a5,-2
  8c:	fe5ff06f          	j	70 <ai_move+0x18>
  90:	08c00713          	li	a4,140
  94:	00f75463          	bge	a4,a5,9c <ai_move+0x44>
  98:	00e52023          	sw	a4,0(a0)
  9c:	00008067          	ret

000000a0 <main>:
  a0:	fc010113          	addi	sp,sp,-64
  a4:	04600793          	li	a5,70
  a8:	02812c23          	sw	s0,56(sp)
  ac:	0a000713          	li	a4,160
  b0:	08000693          	li	a3,128
  b4:	00000613          	li	a2,0
  b8:	00000593          	li	a1,0
  bc:	00000513          	li	a0,0
  c0:	00200413          	li	s0,2
  c4:	02912a23          	sw	s1,52(sp)
  c8:	03212823          	sw	s2,48(sp)
  cc:	03312623          	sw	s3,44(sp)
  d0:	03412423          	sw	s4,40(sp)
  d4:	03512223          	sw	s5,36(sp)
  d8:	03612023          	sw	s6,32(sp)
  dc:	01712e23          	sw	s7,28(sp)
  e0:	01812c23          	sw	s8,24(sp)
  e4:	01912a23          	sw	s9,20(sp)
  e8:	02112e23          	sw	ra,60(sp)
  ec:	00f12423          	sw	a5,8(sp)
  f0:	00f12623          	sw	a5,12(sp)
  f4:	00040c93          	mv	s9,s0
  f8:	234000ef          	jal	32c <st7735_draw_rectangle>
  fc:	05000493          	li	s1,80
 100:	04000913          	li	s2,64
 104:	00000993          	li	s3,0
 108:	00000a13          	li	s4,0
 10c:	00600a93          	li	s5,6
 110:	09b00b13          	li	s6,155
 114:	07100b93          	li	s7,113
 118:	07a00c13          	li	s8,122
 11c:	00048613          	mv	a2,s1
 120:	00090593          	mv	a1,s2
 124:	00000513          	li	a0,0
 128:	f25ff0ef          	jal	4c <draw_ball>
 12c:	00812603          	lw	a2,8(sp)
 130:	00600593          	li	a1,6
 134:	00000513          	li	a0,0
 138:	f09ff0ef          	jal	40 <draw_paddle>
 13c:	00c12603          	lw	a2,12(sp)
 140:	07600593          	li	a1,118
 144:	00000513          	li	a0,0
 148:	ef9ff0ef          	jal	40 <draw_paddle>
 14c:	00048593          	mv	a1,s1
 150:	00810513          	addi	a0,sp,8
 154:	f05ff0ef          	jal	58 <ai_move>
 158:	00048593          	mv	a1,s1
 15c:	00c10513          	addi	a0,sp,12
 160:	008484b3          	add	s1,s1,s0
 164:	ef5ff0ef          	jal	58 <ai_move>
 168:	01990933          	add	s2,s2,s9
 16c:	0a904e63          	bgtz	s1,228 <main+0x188>
 170:	40800433          	neg	s0,s0
 174:	00000493          	li	s1,0
 178:	00812603          	lw	a2,8(sp)
 17c:	0a0cde63          	bgez	s9,238 <main+0x198>
 180:	ffe90793          	addi	a5,s2,-2
 184:	00800713          	li	a4,8
 188:	10f76063          	bltu	a4,a5,288 <main+0x1e8>
 18c:	00448793          	addi	a5,s1,4
 190:	02c7ce63          	blt	a5,a2,1cc <main+0x12c>
 194:	01460793          	addi	a5,a2,20
 198:	0297ca63          	blt	a5,s1,1cc <main+0x12c>
 19c:	40c487b3          	sub	a5,s1,a2
 1a0:	ff878793          	addi	a5,a5,-8
 1a4:	0357c7b3          	div	a5,a5,s5
 1a8:	41900cb3          	neg	s9,s9
 1ac:	00f40433          	add	s0,s0,a5
 1b0:	00400793          	li	a5,4
 1b4:	0087d463          	bge	a5,s0,1bc <main+0x11c>
 1b8:	00078413          	mv	s0,a5
 1bc:	ffc00793          	li	a5,-4
 1c0:	00f45463          	bge	s0,a5,1c8 <main+0x128>
 1c4:	00078413          	mv	s0,a5
 1c8:	00a00913          	li	s2,10
 1cc:	001f0537          	lui	a0,0x1f0
 1d0:	00600593          	li	a1,6
 1d4:	01f50513          	addi	a0,a0,31 # 1f001f <__stack_top+0x1d001f>
 1d8:	e69ff0ef          	jal	40 <draw_paddle>
 1dc:	00c12603          	lw	a2,12(sp)
 1e0:	f8010537          	lui	a0,0xf8010
 1e4:	07600593          	li	a1,118
 1e8:	80050513          	addi	a0,a0,-2048 # f800f800 <__stack_top+0xf7fef800>
 1ec:	e55ff0ef          	jal	40 <draw_paddle>
 1f0:	00048613          	mv	a2,s1
 1f4:	00090593          	mv	a1,s2
 1f8:	fff00513          	li	a0,-1
 1fc:	e51ff0ef          	jal	4c <draw_ball>
 200:	008a1513          	slli	a0,s4,0x8
 204:	01356533          	or	a0,a0,s3
 208:	0c4000ef          	jal	2cc <seg_write_hex>
 20c:	00891513          	slli	a0,s2,0x8
 210:	00956533          	or	a0,a0,s1
 214:	0a8000ef          	jal	2bc <led_write>
 218:	00025537          	lui	a0,0x25
 21c:	9f050513          	addi	a0,a0,-1552 # 249f0 <__stack_top+0x49f0>
 220:	df9ff0ef          	jal	18 <delay>
 224:	ef9ff06f          	j	11c <main+0x7c>
 228:	f49b58e3          	bge	s6,s1,178 <main+0xd8>
 22c:	40800433          	neg	s0,s0
 230:	09c00493          	li	s1,156
 234:	f45ff06f          	j	178 <main+0xd8>
 238:	f92bdae3          	bge	s7,s2,1cc <main+0x12c>
 23c:	072c4463          	blt	s8,s2,2a4 <main+0x204>
 240:	00c12783          	lw	a5,12(sp)
 244:	00448713          	addi	a4,s1,4
 248:	f8f742e3          	blt	a4,a5,1cc <main+0x12c>
 24c:	01478713          	addi	a4,a5,20
 250:	f6974ee3          	blt	a4,s1,1cc <main+0x12c>
 254:	40f487b3          	sub	a5,s1,a5
 258:	ff878793          	addi	a5,a5,-8
 25c:	0357c7b3          	div	a5,a5,s5
 260:	41900cb3          	neg	s9,s9
 264:	00f40433          	add	s0,s0,a5
 268:	00400793          	li	a5,4
 26c:	0087d463          	bge	a5,s0,274 <main+0x1d4>
 270:	00078413          	mv	s0,a5
 274:	ffc00793          	li	a5,-4
 278:	00f45463          	bge	s0,a5,280 <main+0x1e0>
 27c:	00078413          	mv	s0,a5
 280:	07200913          	li	s2,114
 284:	f49ff06f          	j	1cc <main+0x12c>
 288:	f40952e3          	bgez	s2,1cc <main+0x12c>
 28c:	00200413          	li	s0,2
 290:	00198993          	addi	s3,s3,1
 294:	00040c93          	mv	s9,s0
 298:	05000493          	li	s1,80
 29c:	04000913          	li	s2,64
 2a0:	f2dff06f          	j	1cc <main+0x12c>
 2a4:	07c00793          	li	a5,124
 2a8:	f327d2e3          	bge	a5,s2,1cc <main+0x12c>
 2ac:	001a0a13          	addi	s4,s4,1
 2b0:	00200413          	li	s0,2
 2b4:	ffe00c93          	li	s9,-2
 2b8:	fe1ff06f          	j	298 <main+0x1f8>

000002bc <led_write>:
 2bc:	f00007b7          	lui	a5,0xf0000
 2c0:	00878793          	addi	a5,a5,8 # f0000008 <__stack_top+0xeffe0008>
 2c4:	00a79023          	sh	a0,0(a5)
 2c8:	00008067          	ret

000002cc <seg_write_hex>:
 2cc:	f00007b7          	lui	a5,0xf0000
 2d0:	00478793          	addi	a5,a5,4 # f0000004 <__stack_top+0xeffe0004>
 2d4:	00a79023          	sh	a0,0(a5)
 2d8:	00008067          	ret

000002dc <st7735_set_rectangle>:
 2dc:	00ff07b7          	lui	a5,0xff0
 2e0:	01059593          	slli	a1,a1,0x10
 2e4:	0ff6f693          	zext.b	a3,a3
 2e8:	00f5f5b3          	and	a1,a1,a5
 2ec:	00869693          	slli	a3,a3,0x8
 2f0:	01051513          	slli	a0,a0,0x10
 2f4:	0ff67613          	zext.b	a2,a2
 2f8:	00f57533          	and	a0,a0,a5
 2fc:	00861613          	slli	a2,a2,0x8
 300:	00d5e5b3          	or	a1,a1,a3
 304:	2b0007b7          	lui	a5,0x2b000
 308:	00c56533          	or	a0,a0,a2
 30c:	2a000737          	lui	a4,0x2a000
 310:	00f5e5b3          	or	a1,a1,a5
 314:	f00007b7          	lui	a5,0xf0000
 318:	00e56533          	or	a0,a0,a4
 31c:	00278793          	addi	a5,a5,2 # f0000002 <__stack_top+0xeffe0002>
 320:	00a7a023          	sw	a0,0(a5)
 324:	00b7a023          	sw	a1,0(a5)
 328:	00008067          	ret

0000032c <st7735_draw_rectangle>:
 32c:	fe010113          	addi	sp,sp,-32
 330:	00812c23          	sw	s0,24(sp)
 334:	00912a23          	sw	s1,20(sp)
 338:	00068413          	mv	s0,a3
 33c:	00050493          	mv	s1,a0
 340:	00058513          	mv	a0,a1
 344:	00e606b3          	add	a3,a2,a4
 348:	00060593          	mv	a1,a2
 34c:	00850633          	add	a2,a0,s0
 350:	fff68693          	addi	a3,a3,-1
 354:	fff60613          	addi	a2,a2,-1
 358:	00112e23          	sw	ra,28(sp)
 35c:	00e12623          	sw	a4,12(sp)
 360:	f7dff0ef          	jal	2dc <st7735_set_rectangle>
 364:	00c12703          	lw	a4,12(sp)
 368:	2c0007b7          	lui	a5,0x2c000
 36c:	02e40433          	mul	s0,s0,a4
 370:	40145413          	srai	s0,s0,0x1
 374:	00f46433          	or	s0,s0,a5
 378:	f00007b7          	lui	a5,0xf0000
 37c:	00278793          	addi	a5,a5,2 # f0000002 <__stack_top+0xeffe0002>
 380:	0087a023          	sw	s0,0(a5)
 384:	f00007b7          	lui	a5,0xf0000
 388:	00178793          	addi	a5,a5,1 # f0000001 <__stack_top+0xeffe0001>
 38c:	0097a023          	sw	s1,0(a5)
 390:	01c12083          	lw	ra,28(sp)
 394:	01812403          	lw	s0,24(sp)
 398:	01412483          	lw	s1,20(sp)
 39c:	02010113          	addi	sp,sp,32
 3a0:	00008067          	ret
