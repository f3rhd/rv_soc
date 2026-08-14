
__out_tmp.elf:     file format elf32-littleriscv


Disassembly of section .text:

00000000 <_start>:
   0:	00008137          	lui	sp,0x8
   4:	030000ef          	jal	34 <main>

00000008 <halt_loop>:
   8:	0000006f          	j	8 <halt_loop>

0000000c <delay>:
   c:	ff010113          	addi	sp,sp,-16 # 7ff0 <seg_write_hex+0x7bd4>
  10:	00012623          	sw	zero,12(sp)
  14:	00c12783          	lw	a5,12(sp)
  18:	00a7e663          	bltu	a5,a0,24 <delay+0x18>
  1c:	01010113          	addi	sp,sp,16
  20:	00008067          	ret
  24:	00c12783          	lw	a5,12(sp)
  28:	00178793          	addi	a5,a5,1
  2c:	00f12623          	sw	a5,12(sp)
  30:	fe5ff06f          	j	14 <delay+0x8>

00000034 <main>:
  34:	fd010113          	addi	sp,sp,-48
  38:	03212023          	sw	s2,32(sp)
  3c:	0a000713          	li	a4,160
  40:	08000693          	li	a3,128
  44:	00000613          	li	a2,0
  48:	00000593          	li	a1,0
  4c:	00000513          	li	a0,0
  50:	00200913          	li	s2,2
  54:	02812423          	sw	s0,40(sp)
  58:	02912223          	sw	s1,36(sp)
  5c:	01312e23          	sw	s3,28(sp)
  60:	01412c23          	sw	s4,24(sp)
  64:	01512a23          	sw	s5,20(sp)
  68:	01612823          	sw	s6,16(sp)
  6c:	01712623          	sw	s7,12(sp)
  70:	02112623          	sw	ra,44(sp)
  74:	01812423          	sw	s8,8(sp)
  78:	00090993          	mv	s3,s2
  7c:	158000ef          	jal	1d4 <st7735_draw_rectangle>
  80:	05000413          	li	s0,80
  84:	04000493          	li	s1,64
  88:	07400a13          	li	s4,116
  8c:	07a00b13          	li	s6,122
  90:	09400a93          	li	s5,148
  94:	09a00b93          	li	s7,154
  98:	00b00713          	li	a4,11
  9c:	ffb40613          	addi	a2,s0,-5
  a0:	ffb48593          	addi	a1,s1,-5
  a4:	00070693          	mv	a3,a4
  a8:	00000513          	li	a0,0
  ac:	128000ef          	jal	1d4 <st7735_draw_rectangle>
  b0:	013484b3          	add	s1,s1,s3
  b4:	ffa48793          	addi	a5,s1,-6
  b8:	01240433          	add	s0,s0,s2
  bc:	00fa7c63          	bgeu	s4,a5,d4 <main+0xa0>
  c0:	009b24b3          	slt	s1,s6,s1
  c4:	409004b3          	neg	s1,s1
  c8:	0764f493          	andi	s1,s1,118
  cc:	413009b3          	neg	s3,s3
  d0:	00548493          	addi	s1,s1,5
  d4:	ffa40793          	addi	a5,s0,-6
  d8:	41200c33          	neg	s8,s2
  dc:	04faf663          	bgeu	s5,a5,128 <main+0xf4>
  e0:	008ba433          	slt	s0,s7,s0
  e4:	40800433          	neg	s0,s0
  e8:	09647413          	andi	s0,s0,150
  ec:	00540413          	addi	s0,s0,5
  f0:	001f0537          	lui	a0,0x1f0
  f4:	00500693          	li	a3,5
  f8:	00040613          	mv	a2,s0
  fc:	00048593          	mv	a1,s1
 100:	01f50513          	addi	a0,a0,31 # 1f001f <seg_write_hex+0x1efc03>
 104:	220000ef          	jal	324 <st7735_draw_circle>
 108:	00849513          	slli	a0,s1,0x8
 10c:	00856533          	or	a0,a0,s0
 110:	30c000ef          	jal	41c <seg_write_hex>
 114:	0000c537          	lui	a0,0xc
 118:	35050513          	addi	a0,a0,848 # c350 <seg_write_hex+0xbf34>
 11c:	ef1ff0ef          	jal	c <delay>
 120:	000c0913          	mv	s2,s8
 124:	f75ff06f          	j	98 <main+0x64>
 128:	00090c13          	mv	s8,s2
 12c:	fc5ff06f          	j	f0 <main+0xbc>

00000130 <st7735_set_rectangle>:
 130:	00ff07b7          	lui	a5,0xff0
 134:	01059593          	slli	a1,a1,0x10
 138:	0ff6f693          	zext.b	a3,a3
 13c:	00f5f5b3          	and	a1,a1,a5
 140:	00869693          	slli	a3,a3,0x8
 144:	01051513          	slli	a0,a0,0x10
 148:	0ff67613          	zext.b	a2,a2
 14c:	00f57533          	and	a0,a0,a5
 150:	00861613          	slli	a2,a2,0x8
 154:	00d5e5b3          	or	a1,a1,a3
 158:	2b0007b7          	lui	a5,0x2b000
 15c:	00c56533          	or	a0,a0,a2
 160:	2a000737          	lui	a4,0x2a000
 164:	00f5e5b3          	or	a1,a1,a5
 168:	f00007b7          	lui	a5,0xf0000
 16c:	00e56533          	or	a0,a0,a4
 170:	00278793          	addi	a5,a5,2 # f0000002 <seg_write_hex+0xeffffbe6>
 174:	00a7a023          	sw	a0,0(a5)
 178:	00b7a023          	sw	a1,0(a5)
 17c:	00008067          	ret

00000180 <st7735_draw_pixel>:
 180:	ff010113          	addi	sp,sp,-16
 184:	00812423          	sw	s0,8(sp)
 188:	00050413          	mv	s0,a0
 18c:	00058513          	mv	a0,a1
 190:	00060693          	mv	a3,a2
 194:	00060593          	mv	a1,a2
 198:	00050613          	mv	a2,a0
 19c:	00112623          	sw	ra,12(sp)
 1a0:	f91ff0ef          	jal	130 <st7735_set_rectangle>
 1a4:	2c0007b7          	lui	a5,0x2c000
 1a8:	f0000737          	lui	a4,0xf0000
 1ac:	00178793          	addi	a5,a5,1 # 2c000001 <seg_write_hex+0x2bfffbe5>
 1b0:	00270713          	addi	a4,a4,2 # f0000002 <seg_write_hex+0xeffffbe6>
 1b4:	00f72023          	sw	a5,0(a4)
 1b8:	f00007b7          	lui	a5,0xf0000
 1bc:	00178793          	addi	a5,a5,1 # f0000001 <seg_write_hex+0xeffffbe5>
 1c0:	0087a023          	sw	s0,0(a5)
 1c4:	00c12083          	lw	ra,12(sp)
 1c8:	00812403          	lw	s0,8(sp)
 1cc:	01010113          	addi	sp,sp,16
 1d0:	00008067          	ret

000001d4 <st7735_draw_rectangle>:
 1d4:	fe010113          	addi	sp,sp,-32
 1d8:	00812c23          	sw	s0,24(sp)
 1dc:	00912a23          	sw	s1,20(sp)
 1e0:	00068413          	mv	s0,a3
 1e4:	00050493          	mv	s1,a0
 1e8:	00058513          	mv	a0,a1
 1ec:	00e606b3          	add	a3,a2,a4
 1f0:	00060593          	mv	a1,a2
 1f4:	00850633          	add	a2,a0,s0
 1f8:	fff68693          	addi	a3,a3,-1
 1fc:	fff60613          	addi	a2,a2,-1
 200:	00112e23          	sw	ra,28(sp)
 204:	00e12623          	sw	a4,12(sp)
 208:	f29ff0ef          	jal	130 <st7735_set_rectangle>
 20c:	00c12703          	lw	a4,12(sp)
 210:	2c0007b7          	lui	a5,0x2c000
 214:	02e40433          	mul	s0,s0,a4
 218:	40145413          	srai	s0,s0,0x1
 21c:	00f46433          	or	s0,s0,a5
 220:	f00007b7          	lui	a5,0xf0000
 224:	00278793          	addi	a5,a5,2 # f0000002 <seg_write_hex+0xeffffbe6>
 228:	0087a023          	sw	s0,0(a5)
 22c:	f00007b7          	lui	a5,0xf0000
 230:	00178793          	addi	a5,a5,1 # f0000001 <seg_write_hex+0xeffffbe5>
 234:	0097a023          	sw	s1,0(a5)
 238:	01c12083          	lw	ra,28(sp)
 23c:	01812403          	lw	s0,24(sp)
 240:	01412483          	lw	s1,20(sp)
 244:	02010113          	addi	sp,sp,32
 248:	00008067          	ret

0000024c <st7735_draw_line>:
 24c:	fc010113          	addi	sp,sp,-64
 250:	02812c23          	sw	s0,56(sp)
 254:	40b68433          	sub	s0,a3,a1
 258:	41f45793          	srai	a5,s0,0x1f
 25c:	03412423          	sw	s4,40(sp)
 260:	0087c433          	xor	s0,a5,s0
 264:	02112e23          	sw	ra,60(sp)
 268:	02912a23          	sw	s1,52(sp)
 26c:	03212823          	sw	s2,48(sp)
 270:	03312623          	sw	s3,44(sp)
 274:	03512223          	sw	s5,36(sp)
 278:	40f40433          	sub	s0,s0,a5
 27c:	00100a13          	li	s4,1
 280:	00d5c463          	blt	a1,a3,288 <st7735_draw_line+0x3c>
 284:	fff00a13          	li	s4,-1
 288:	40c704b3          	sub	s1,a4,a2
 28c:	41f4d793          	srai	a5,s1,0x1f
 290:	0097c4b3          	xor	s1,a5,s1
 294:	40f484b3          	sub	s1,s1,a5
 298:	40900ab3          	neg	s5,s1
 29c:	fff00993          	li	s3,-1
 2a0:	00e65463          	bge	a2,a4,2a8 <st7735_draw_line+0x5c>
 2a4:	00100993          	li	s3,1
 2a8:	40940933          	sub	s2,s0,s1
 2ac:	00e12e23          	sw	a4,28(sp)
 2b0:	00d12c23          	sw	a3,24(sp)
 2b4:	00c12a23          	sw	a2,20(sp)
 2b8:	00b12823          	sw	a1,16(sp)
 2bc:	00a12623          	sw	a0,12(sp)
 2c0:	ec1ff0ef          	jal	180 <st7735_draw_pixel>
 2c4:	01012583          	lw	a1,16(sp)
 2c8:	01812683          	lw	a3,24(sp)
 2cc:	00c12503          	lw	a0,12(sp)
 2d0:	01412603          	lw	a2,20(sp)
 2d4:	01c12703          	lw	a4,28(sp)
 2d8:	00d59463          	bne	a1,a3,2e0 <st7735_draw_line+0x94>
 2dc:	02e60263          	beq	a2,a4,300 <st7735_draw_line+0xb4>
 2e0:	00191793          	slli	a5,s2,0x1
 2e4:	0157c863          	blt	a5,s5,2f4 <st7735_draw_line+0xa8>
 2e8:	40990933          	sub	s2,s2,s1
 2ec:	014585b3          	add	a1,a1,s4
 2f0:	faf44ee3          	blt	s0,a5,2ac <st7735_draw_line+0x60>
 2f4:	00890933          	add	s2,s2,s0
 2f8:	01360633          	add	a2,a2,s3
 2fc:	fb1ff06f          	j	2ac <st7735_draw_line+0x60>
 300:	03c12083          	lw	ra,60(sp)
 304:	03812403          	lw	s0,56(sp)
 308:	03412483          	lw	s1,52(sp)
 30c:	03012903          	lw	s2,48(sp)
 310:	02c12983          	lw	s3,44(sp)
 314:	02812a03          	lw	s4,40(sp)
 318:	02412a83          	lw	s5,36(sp)
 31c:	04010113          	addi	sp,sp,64
 320:	00008067          	ret

00000324 <st7735_draw_circle>:
 324:	fd010113          	addi	sp,sp,-48
 328:	03212023          	sw	s2,32(sp)
 32c:	00100913          	li	s2,1
 330:	02812423          	sw	s0,40(sp)
 334:	02912223          	sw	s1,36(sp)
 338:	01312e23          	sw	s3,28(sp)
 33c:	01412c23          	sw	s4,24(sp)
 340:	01512a23          	sw	s5,20(sp)
 344:	02112623          	sw	ra,44(sp)
 348:	00050a93          	mv	s5,a0
 34c:	00058993          	mv	s3,a1
 350:	00060a13          	mv	s4,a2
 354:	00068413          	mv	s0,a3
 358:	40d90933          	sub	s2,s2,a3
 35c:	00000493          	li	s1,0
 360:	02945463          	bge	s0,s1,388 <st7735_draw_circle+0x64>
 364:	02c12083          	lw	ra,44(sp)
 368:	02812403          	lw	s0,40(sp)
 36c:	02412483          	lw	s1,36(sp)
 370:	02012903          	lw	s2,32(sp)
 374:	01c12983          	lw	s3,28(sp)
 378:	01812a03          	lw	s4,24(sp)
 37c:	01412a83          	lw	s5,20(sp)
 380:	03010113          	addi	sp,sp,48
 384:	00008067          	ret
 388:	009a0733          	add	a4,s4,s1
 38c:	408985b3          	sub	a1,s3,s0
 390:	013406b3          	add	a3,s0,s3
 394:	00070613          	mv	a2,a4
 398:	000a8513          	mv	a0,s5
 39c:	00d12623          	sw	a3,12(sp)
 3a0:	00b12423          	sw	a1,8(sp)
 3a4:	ea9ff0ef          	jal	24c <st7735_draw_line>
 3a8:	00c12683          	lw	a3,12(sp)
 3ac:	00812583          	lw	a1,8(sp)
 3b0:	409a0733          	sub	a4,s4,s1
 3b4:	00070613          	mv	a2,a4
 3b8:	000a8513          	mv	a0,s5
 3bc:	e91ff0ef          	jal	24c <st7735_draw_line>
 3c0:	01440733          	add	a4,s0,s4
 3c4:	409985b3          	sub	a1,s3,s1
 3c8:	013486b3          	add	a3,s1,s3
 3cc:	00070613          	mv	a2,a4
 3d0:	000a8513          	mv	a0,s5
 3d4:	00d12623          	sw	a3,12(sp)
 3d8:	00b12423          	sw	a1,8(sp)
 3dc:	e71ff0ef          	jal	24c <st7735_draw_line>
 3e0:	00c12683          	lw	a3,12(sp)
 3e4:	00812583          	lw	a1,8(sp)
 3e8:	408a0733          	sub	a4,s4,s0
 3ec:	00070613          	mv	a2,a4
 3f0:	000a8513          	mv	a0,s5
 3f4:	e59ff0ef          	jal	24c <st7735_draw_line>
 3f8:	00148493          	addi	s1,s1,1
 3fc:	00149793          	slli	a5,s1,0x1
 400:	00094863          	bltz	s2,410 <st7735_draw_circle+0xec>
 404:	fff40413          	addi	s0,s0,-1
 408:	408487b3          	sub	a5,s1,s0
 40c:	00179793          	slli	a5,a5,0x1
 410:	00178793          	addi	a5,a5,1
 414:	00f90933          	add	s2,s2,a5
 418:	f49ff06f          	j	360 <st7735_draw_circle+0x3c>

0000041c <seg_write_hex>:
 41c:	f00007b7          	lui	a5,0xf0000
 420:	00478793          	addi	a5,a5,4 # f0000004 <seg_write_hex+0xeffffbe8>
 424:	00a79023          	sh	a0,0(a5)
 428:	00008067          	ret
