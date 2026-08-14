
__out_tmp.elf:     file format elf32-littleriscv


Disassembly of section .text:

00000000 <_start>:
   0:	00008137          	lui	sp,0x8
   4:	008000ef          	jal	c <main>

00000008 <halt_loop>:
   8:	0000006f          	j	8 <halt_loop>

0000000c <main>:
   c:	08c00893          	li	a7,140
  10:	001f0537          	lui	a0,0x1f0
  14:	ff010113          	addi	sp,sp,-16 # 7ff0 <st7735_draw_triangle+0x7e28>
  18:	01f50513          	addi	a0,a0,31 # 1f001f <st7735_draw_triangle+0x1efe57>
  1c:	06c00813          	li	a6,108
  20:	00088793          	mv	a5,a7
  24:	01400713          	li	a4,20
  28:	05000693          	li	a3,80
  2c:	04000613          	li	a2,64
  30:	00000593          	li	a1,0
  34:	00112623          	sw	ra,12(sp)
  38:	190000ef          	jal	1c8 <st7735_draw_triangle>
  3c:	00c12083          	lw	ra,12(sp)
  40:	00000513          	li	a0,0
  44:	01010113          	addi	sp,sp,16
  48:	00008067          	ret

0000004c <st7735_set_rectangle>:
  4c:	00ff07b7          	lui	a5,0xff0
  50:	01059593          	slli	a1,a1,0x10
  54:	0ff6f693          	zext.b	a3,a3
  58:	00f5f5b3          	and	a1,a1,a5
  5c:	00869693          	slli	a3,a3,0x8
  60:	01051513          	slli	a0,a0,0x10
  64:	0ff67613          	zext.b	a2,a2
  68:	00f57533          	and	a0,a0,a5
  6c:	00861613          	slli	a2,a2,0x8
  70:	00d5e5b3          	or	a1,a1,a3
  74:	2b0007b7          	lui	a5,0x2b000
  78:	00c56533          	or	a0,a0,a2
  7c:	2a000737          	lui	a4,0x2a000
  80:	00f5e5b3          	or	a1,a1,a5
  84:	f00007b7          	lui	a5,0xf0000
  88:	00e56533          	or	a0,a0,a4
  8c:	00278793          	addi	a5,a5,2 # f0000002 <st7735_draw_triangle+0xeffffe3a>
  90:	00a7a023          	sw	a0,0(a5)
  94:	00b7a023          	sw	a1,0(a5)
  98:	00008067          	ret

0000009c <st7735_draw_pixel>:
  9c:	ff010113          	addi	sp,sp,-16
  a0:	00812423          	sw	s0,8(sp)
  a4:	00050413          	mv	s0,a0
  a8:	00058513          	mv	a0,a1
  ac:	00060693          	mv	a3,a2
  b0:	00060593          	mv	a1,a2
  b4:	00050613          	mv	a2,a0
  b8:	00112623          	sw	ra,12(sp)
  bc:	f91ff0ef          	jal	4c <st7735_set_rectangle>
  c0:	2c0007b7          	lui	a5,0x2c000
  c4:	f0000737          	lui	a4,0xf0000
  c8:	00178793          	addi	a5,a5,1 # 2c000001 <st7735_draw_triangle+0x2bfffe39>
  cc:	00270713          	addi	a4,a4,2 # f0000002 <st7735_draw_triangle+0xeffffe3a>
  d0:	00f72023          	sw	a5,0(a4)
  d4:	f00007b7          	lui	a5,0xf0000
  d8:	00178793          	addi	a5,a5,1 # f0000001 <st7735_draw_triangle+0xeffffe39>
  dc:	0087a023          	sw	s0,0(a5)
  e0:	00c12083          	lw	ra,12(sp)
  e4:	00812403          	lw	s0,8(sp)
  e8:	01010113          	addi	sp,sp,16
  ec:	00008067          	ret

000000f0 <st7735_draw_line>:
  f0:	fc010113          	addi	sp,sp,-64
  f4:	02812c23          	sw	s0,56(sp)
  f8:	40b68433          	sub	s0,a3,a1
  fc:	41f45793          	srai	a5,s0,0x1f
 100:	03412423          	sw	s4,40(sp)
 104:	0087c433          	xor	s0,a5,s0
 108:	02112e23          	sw	ra,60(sp)
 10c:	02912a23          	sw	s1,52(sp)
 110:	03212823          	sw	s2,48(sp)
 114:	03312623          	sw	s3,44(sp)
 118:	03512223          	sw	s5,36(sp)
 11c:	40f40433          	sub	s0,s0,a5
 120:	00100a13          	li	s4,1
 124:	00d5c463          	blt	a1,a3,12c <st7735_draw_line+0x3c>
 128:	fff00a13          	li	s4,-1
 12c:	40c704b3          	sub	s1,a4,a2
 130:	41f4d793          	srai	a5,s1,0x1f
 134:	0097c4b3          	xor	s1,a5,s1
 138:	40f484b3          	sub	s1,s1,a5
 13c:	40900ab3          	neg	s5,s1
 140:	fff00993          	li	s3,-1
 144:	00e65463          	bge	a2,a4,14c <st7735_draw_line+0x5c>
 148:	00100993          	li	s3,1
 14c:	40940933          	sub	s2,s0,s1
 150:	00e12e23          	sw	a4,28(sp)
 154:	00d12c23          	sw	a3,24(sp)
 158:	00c12a23          	sw	a2,20(sp)
 15c:	00b12823          	sw	a1,16(sp)
 160:	00a12623          	sw	a0,12(sp)
 164:	f39ff0ef          	jal	9c <st7735_draw_pixel>
 168:	01012583          	lw	a1,16(sp)
 16c:	01812683          	lw	a3,24(sp)
 170:	00c12503          	lw	a0,12(sp)
 174:	01412603          	lw	a2,20(sp)
 178:	01c12703          	lw	a4,28(sp)
 17c:	00d59463          	bne	a1,a3,184 <st7735_draw_line+0x94>
 180:	02e60263          	beq	a2,a4,1a4 <st7735_draw_line+0xb4>
 184:	00191793          	slli	a5,s2,0x1
 188:	0157c863          	blt	a5,s5,198 <st7735_draw_line+0xa8>
 18c:	40990933          	sub	s2,s2,s1
 190:	014585b3          	add	a1,a1,s4
 194:	faf44ee3          	blt	s0,a5,150 <st7735_draw_line+0x60>
 198:	00890933          	add	s2,s2,s0
 19c:	01360633          	add	a2,a2,s3
 1a0:	fb1ff06f          	j	150 <st7735_draw_line+0x60>
 1a4:	03c12083          	lw	ra,60(sp)
 1a8:	03812403          	lw	s0,56(sp)
 1ac:	03412483          	lw	s1,52(sp)
 1b0:	03012903          	lw	s2,48(sp)
 1b4:	02c12983          	lw	s3,44(sp)
 1b8:	02812a03          	lw	s4,40(sp)
 1bc:	02412a83          	lw	s5,36(sp)
 1c0:	04010113          	addi	sp,sp,64
 1c4:	00008067          	ret

000001c8 <st7735_draw_triangle>:
 1c8:	fb010113          	addi	sp,sp,-80
 1cc:	04812423          	sw	s0,72(sp)
 1d0:	04912223          	sw	s1,68(sp)
 1d4:	05212023          	sw	s2,64(sp)
 1d8:	03312e23          	sw	s3,60(sp)
 1dc:	03412c23          	sw	s4,56(sp)
 1e0:	03512a23          	sw	s5,52(sp)
 1e4:	04112623          	sw	ra,76(sp)
 1e8:	03612823          	sw	s6,48(sp)
 1ec:	03712623          	sw	s7,44(sp)
 1f0:	03812423          	sw	s8,40(sp)
 1f4:	03912223          	sw	s9,36(sp)
 1f8:	03a12023          	sw	s10,32(sp)
 1fc:	01b12e23          	sw	s11,28(sp)
 200:	00a12423          	sw	a0,8(sp)
 204:	00060993          	mv	s3,a2
 208:	00068493          	mv	s1,a3
 20c:	00070a13          	mv	s4,a4
 210:	00078413          	mv	s0,a5
 214:	00080a93          	mv	s5,a6
 218:	00088913          	mv	s2,a7
 21c:	08058063          	beqz	a1,29c <st7735_draw_triangle+0xd4>
 220:	00078713          	mv	a4,a5
 224:	000a0693          	mv	a3,s4
 228:	00048613          	mv	a2,s1
 22c:	00098593          	mv	a1,s3
 230:	ec1ff0ef          	jal	f0 <st7735_draw_line>
 234:	00812503          	lw	a0,8(sp)
 238:	00090713          	mv	a4,s2
 23c:	000a8693          	mv	a3,s5
 240:	00048613          	mv	a2,s1
 244:	00098593          	mv	a1,s3
 248:	ea9ff0ef          	jal	f0 <st7735_draw_line>
 24c:	00040613          	mv	a2,s0
 250:	04812403          	lw	s0,72(sp)
 254:	00812503          	lw	a0,8(sp)
 258:	04c12083          	lw	ra,76(sp)
 25c:	04412483          	lw	s1,68(sp)
 260:	03c12983          	lw	s3,60(sp)
 264:	03012b03          	lw	s6,48(sp)
 268:	02c12b83          	lw	s7,44(sp)
 26c:	02812c03          	lw	s8,40(sp)
 270:	02412c83          	lw	s9,36(sp)
 274:	02012d03          	lw	s10,32(sp)
 278:	01c12d83          	lw	s11,28(sp)
 27c:	00090713          	mv	a4,s2
 280:	000a8693          	mv	a3,s5
 284:	04012903          	lw	s2,64(sp)
 288:	03412a83          	lw	s5,52(sp)
 28c:	000a0593          	mv	a1,s4
 290:	03812a03          	lw	s4,56(sp)
 294:	05010113          	addi	sp,sp,80
 298:	e59ff06f          	j	f0 <st7735_draw_line>
 29c:	1cd7c463          	blt	a5,a3,464 <st7735_draw_triangle+0x29c>
 2a0:	00d8da63          	bge	a7,a3,2b4 <st7735_draw_triangle+0xec>
 2a4:	00088493          	mv	s1,a7
 2a8:	00068913          	mv	s2,a3
 2ac:	00080993          	mv	s3,a6
 2b0:	00060a93          	mv	s5,a2
 2b4:	00894e63          	blt	s2,s0,2d0 <st7735_draw_triangle+0x108>
 2b8:	00090793          	mv	a5,s2
 2bc:	00040913          	mv	s2,s0
 2c0:	00078413          	mv	s0,a5
 2c4:	000a8793          	mv	a5,s5
 2c8:	000a0a93          	mv	s5,s4
 2cc:	00078a13          	mv	s4,a5
 2d0:	413a8cb3          	sub	s9,s5,s3
 2d4:	413a0c33          	sub	s8,s4,s3
 2d8:	00048713          	mv	a4,s1
 2dc:	00000b93          	li	s7,0
 2e0:	00000b13          	li	s6,0
 2e4:	40940d33          	sub	s10,s0,s1
 2e8:	40990db3          	sub	s11,s2,s1
 2ec:	09f00813          	li	a6,159
 2f0:	07f00893          	li	a7,127
 2f4:	08e95663          	bge	s2,a4,380 <st7735_draw_triangle+0x1b8>
 2f8:	40990b33          	sub	s6,s2,s1
 2fc:	038b0b33          	mul	s6,s6,s8
 300:	415a0cb3          	sub	s9,s4,s5
 304:	00000b93          	li	s7,0
 308:	00090a13          	mv	s4,s2
 30c:	40940d33          	sub	s10,s0,s1
 310:	41240db3          	sub	s11,s0,s2
 314:	09f00813          	li	a6,159
 318:	07f00893          	li	a7,127
 31c:	0d445c63          	bge	s0,s4,3f4 <st7735_draw_triangle+0x22c>
 320:	04c12083          	lw	ra,76(sp)
 324:	04812403          	lw	s0,72(sp)
 328:	04412483          	lw	s1,68(sp)
 32c:	04012903          	lw	s2,64(sp)
 330:	03c12983          	lw	s3,60(sp)
 334:	03812a03          	lw	s4,56(sp)
 338:	03412a83          	lw	s5,52(sp)
 33c:	03012b03          	lw	s6,48(sp)
 340:	02c12b83          	lw	s7,44(sp)
 344:	02812c03          	lw	s8,40(sp)
 348:	02412c83          	lw	s9,36(sp)
 34c:	02012d03          	lw	s10,32(sp)
 350:	01c12d83          	lw	s11,28(sp)
 354:	05010113          	addi	sp,sp,80
 358:	00008067          	ret
 35c:	00090793          	mv	a5,s2
 360:	00040913          	mv	s2,s0
 364:	00048413          	mv	s0,s1
 368:	00078493          	mv	s1,a5
 36c:	000a8793          	mv	a5,s5
 370:	000a0a93          	mv	s5,s4
 374:	00098a13          	mv	s4,s3
 378:	00078993          	mv	s3,a5
 37c:	f55ff06f          	j	2d0 <st7735_draw_triangle+0x108>
 380:	00098693          	mv	a3,s3
 384:	00940663          	beq	s0,s1,390 <st7735_draw_triangle+0x1c8>
 388:	03abc6b3          	div	a3,s7,s10
 38c:	013686b3          	add	a3,a3,s3
 390:	00098793          	mv	a5,s3
 394:	00990663          	beq	s2,s1,3a0 <st7735_draw_triangle+0x1d8>
 398:	03bb47b3          	div	a5,s6,s11
 39c:	013787b3          	add	a5,a5,s3
 3a0:	04e86263          	bltu	a6,a4,3e4 <st7735_draw_triangle+0x21c>
 3a4:	00d7c863          	blt	a5,a3,3b4 <st7735_draw_triangle+0x1ec>
 3a8:	00078613          	mv	a2,a5
 3ac:	00068793          	mv	a5,a3
 3b0:	00060693          	mv	a3,a2
 3b4:	00d8d463          	bge	a7,a3,3bc <st7735_draw_triangle+0x1f4>
 3b8:	07f00693          	li	a3,127
 3bc:	fff7c593          	not	a1,a5
 3c0:	00812503          	lw	a0,8(sp)
 3c4:	41f5d593          	srai	a1,a1,0x1f
 3c8:	00070613          	mv	a2,a4
 3cc:	00b7f5b3          	and	a1,a5,a1
 3d0:	00e12623          	sw	a4,12(sp)
 3d4:	d1dff0ef          	jal	f0 <st7735_draw_line>
 3d8:	00c12703          	lw	a4,12(sp)
 3dc:	07f00893          	li	a7,127
 3e0:	09f00813          	li	a6,159
 3e4:	00170713          	addi	a4,a4,1
 3e8:	019b0b33          	add	s6,s6,s9
 3ec:	018b8bb3          	add	s7,s7,s8
 3f0:	f05ff06f          	j	2f4 <st7735_draw_triangle+0x12c>
 3f4:	00098693          	mv	a3,s3
 3f8:	00940663          	beq	s0,s1,404 <st7735_draw_triangle+0x23c>
 3fc:	03ab46b3          	div	a3,s6,s10
 400:	013686b3          	add	a3,a3,s3
 404:	000a8793          	mv	a5,s5
 408:	00890663          	beq	s2,s0,414 <st7735_draw_triangle+0x24c>
 40c:	03bbc7b3          	div	a5,s7,s11
 410:	015787b3          	add	a5,a5,s5
 414:	05486063          	bltu	a6,s4,454 <st7735_draw_triangle+0x28c>
 418:	00d7c863          	blt	a5,a3,428 <st7735_draw_triangle+0x260>
 41c:	00078713          	mv	a4,a5
 420:	00068793          	mv	a5,a3
 424:	00070693          	mv	a3,a4
 428:	00d8d463          	bge	a7,a3,430 <st7735_draw_triangle+0x268>
 42c:	07f00693          	li	a3,127
 430:	fff7c593          	not	a1,a5
 434:	00812503          	lw	a0,8(sp)
 438:	41f5d593          	srai	a1,a1,0x1f
 43c:	000a0713          	mv	a4,s4
 440:	000a0613          	mv	a2,s4
 444:	00b7f5b3          	and	a1,a5,a1
 448:	ca9ff0ef          	jal	f0 <st7735_draw_line>
 44c:	07f00893          	li	a7,127
 450:	09f00813          	li	a6,159
 454:	001a0a13          	addi	s4,s4,1
 458:	019b8bb3          	add	s7,s7,s9
 45c:	018b0b33          	add	s6,s6,s8
 460:	ebdff06f          	j	31c <st7735_draw_triangle+0x154>
 464:	eef8cce3          	blt	a7,a5,35c <st7735_draw_triangle+0x194>
 468:	00040493          	mv	s1,s0
 46c:	00070993          	mv	s3,a4
 470:	00068413          	mv	s0,a3
 474:	00060a13          	mv	s4,a2
 478:	e3dff06f          	j	2b4 <st7735_draw_triangle+0xec>
