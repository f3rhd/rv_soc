
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
  14:	ff010113          	addi	sp,sp,-16 # 7ff0 <st7735_draw_triangle+0x7e30>
  18:	01f50513          	addi	a0,a0,31 # 1f001f <st7735_draw_triangle+0x1efe5f>
  1c:	06c00813          	li	a6,108
  20:	00088793          	mv	a5,a7
  24:	01400713          	li	a4,20
  28:	05000693          	li	a3,80
  2c:	04000613          	li	a2,64
  30:	00000593          	li	a1,0
  34:	00112623          	sw	ra,12(sp)
  38:	188000ef          	jal	1c0 <st7735_draw_triangle>
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
  8c:	00478793          	addi	a5,a5,4 # f0000004 <st7735_draw_triangle+0xeffffe44>
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
  c0:	f00007b7          	lui	a5,0xf0000
  c4:	2c000737          	lui	a4,0x2c000
  c8:	00478793          	addi	a5,a5,4 # f0000004 <st7735_draw_triangle+0xeffffe44>
  cc:	00e7a023          	sw	a4,0(a5)
  d0:	f00007b7          	lui	a5,0xf0000
  d4:	0087a023          	sw	s0,0(a5) # f0000000 <st7735_draw_triangle+0xeffffe40>
  d8:	00c12083          	lw	ra,12(sp)
  dc:	00812403          	lw	s0,8(sp)
  e0:	01010113          	addi	sp,sp,16
  e4:	00008067          	ret

000000e8 <st7735_draw_line>:
  e8:	fc010113          	addi	sp,sp,-64
  ec:	02812c23          	sw	s0,56(sp)
  f0:	40b68433          	sub	s0,a3,a1
  f4:	41f45793          	srai	a5,s0,0x1f
  f8:	03412423          	sw	s4,40(sp)
  fc:	0087c433          	xor	s0,a5,s0
 100:	02112e23          	sw	ra,60(sp)
 104:	02912a23          	sw	s1,52(sp)
 108:	03212823          	sw	s2,48(sp)
 10c:	03312623          	sw	s3,44(sp)
 110:	03512223          	sw	s5,36(sp)
 114:	40f40433          	sub	s0,s0,a5
 118:	00100a13          	li	s4,1
 11c:	00d5c463          	blt	a1,a3,124 <st7735_draw_line+0x3c>
 120:	fff00a13          	li	s4,-1
 124:	40c704b3          	sub	s1,a4,a2
 128:	41f4d793          	srai	a5,s1,0x1f
 12c:	0097c4b3          	xor	s1,a5,s1
 130:	40f484b3          	sub	s1,s1,a5
 134:	40900ab3          	neg	s5,s1
 138:	fff00993          	li	s3,-1
 13c:	00e65463          	bge	a2,a4,144 <st7735_draw_line+0x5c>
 140:	00100993          	li	s3,1
 144:	40940933          	sub	s2,s0,s1
 148:	00e12e23          	sw	a4,28(sp)
 14c:	00d12c23          	sw	a3,24(sp)
 150:	00c12a23          	sw	a2,20(sp)
 154:	00b12823          	sw	a1,16(sp)
 158:	00a12623          	sw	a0,12(sp)
 15c:	f41ff0ef          	jal	9c <st7735_draw_pixel>
 160:	01012583          	lw	a1,16(sp)
 164:	01812683          	lw	a3,24(sp)
 168:	00c12503          	lw	a0,12(sp)
 16c:	01412603          	lw	a2,20(sp)
 170:	01c12703          	lw	a4,28(sp)
 174:	00d59463          	bne	a1,a3,17c <st7735_draw_line+0x94>
 178:	02e60263          	beq	a2,a4,19c <st7735_draw_line+0xb4>
 17c:	00191793          	slli	a5,s2,0x1
 180:	0157c863          	blt	a5,s5,190 <st7735_draw_line+0xa8>
 184:	40990933          	sub	s2,s2,s1
 188:	014585b3          	add	a1,a1,s4
 18c:	faf44ee3          	blt	s0,a5,148 <st7735_draw_line+0x60>
 190:	00890933          	add	s2,s2,s0
 194:	01360633          	add	a2,a2,s3
 198:	fb1ff06f          	j	148 <st7735_draw_line+0x60>
 19c:	03c12083          	lw	ra,60(sp)
 1a0:	03812403          	lw	s0,56(sp)
 1a4:	03412483          	lw	s1,52(sp)
 1a8:	03012903          	lw	s2,48(sp)
 1ac:	02c12983          	lw	s3,44(sp)
 1b0:	02812a03          	lw	s4,40(sp)
 1b4:	02412a83          	lw	s5,36(sp)
 1b8:	04010113          	addi	sp,sp,64
 1bc:	00008067          	ret

000001c0 <st7735_draw_triangle>:
 1c0:	fb010113          	addi	sp,sp,-80
 1c4:	04812423          	sw	s0,72(sp)
 1c8:	04912223          	sw	s1,68(sp)
 1cc:	05212023          	sw	s2,64(sp)
 1d0:	03312e23          	sw	s3,60(sp)
 1d4:	03412c23          	sw	s4,56(sp)
 1d8:	03512a23          	sw	s5,52(sp)
 1dc:	04112623          	sw	ra,76(sp)
 1e0:	03612823          	sw	s6,48(sp)
 1e4:	03712623          	sw	s7,44(sp)
 1e8:	03812423          	sw	s8,40(sp)
 1ec:	03912223          	sw	s9,36(sp)
 1f0:	03a12023          	sw	s10,32(sp)
 1f4:	01b12e23          	sw	s11,28(sp)
 1f8:	00a12423          	sw	a0,8(sp)
 1fc:	00060993          	mv	s3,a2
 200:	00068493          	mv	s1,a3
 204:	00070a13          	mv	s4,a4
 208:	00078413          	mv	s0,a5
 20c:	00080a93          	mv	s5,a6
 210:	00088913          	mv	s2,a7
 214:	08058063          	beqz	a1,294 <st7735_draw_triangle+0xd4>
 218:	00078713          	mv	a4,a5
 21c:	000a0693          	mv	a3,s4
 220:	00048613          	mv	a2,s1
 224:	00098593          	mv	a1,s3
 228:	ec1ff0ef          	jal	e8 <st7735_draw_line>
 22c:	00812503          	lw	a0,8(sp)
 230:	00090713          	mv	a4,s2
 234:	000a8693          	mv	a3,s5
 238:	00048613          	mv	a2,s1
 23c:	00098593          	mv	a1,s3
 240:	ea9ff0ef          	jal	e8 <st7735_draw_line>
 244:	00040613          	mv	a2,s0
 248:	04812403          	lw	s0,72(sp)
 24c:	00812503          	lw	a0,8(sp)
 250:	04c12083          	lw	ra,76(sp)
 254:	04412483          	lw	s1,68(sp)
 258:	03c12983          	lw	s3,60(sp)
 25c:	03012b03          	lw	s6,48(sp)
 260:	02c12b83          	lw	s7,44(sp)
 264:	02812c03          	lw	s8,40(sp)
 268:	02412c83          	lw	s9,36(sp)
 26c:	02012d03          	lw	s10,32(sp)
 270:	01c12d83          	lw	s11,28(sp)
 274:	00090713          	mv	a4,s2
 278:	000a8693          	mv	a3,s5
 27c:	04012903          	lw	s2,64(sp)
 280:	03412a83          	lw	s5,52(sp)
 284:	000a0593          	mv	a1,s4
 288:	03812a03          	lw	s4,56(sp)
 28c:	05010113          	addi	sp,sp,80
 290:	e59ff06f          	j	e8 <st7735_draw_line>
 294:	1cd7c463          	blt	a5,a3,45c <st7735_draw_triangle+0x29c>
 298:	00d8da63          	bge	a7,a3,2ac <st7735_draw_triangle+0xec>
 29c:	00088493          	mv	s1,a7
 2a0:	00068913          	mv	s2,a3
 2a4:	00080993          	mv	s3,a6
 2a8:	00060a93          	mv	s5,a2
 2ac:	00894e63          	blt	s2,s0,2c8 <st7735_draw_triangle+0x108>
 2b0:	00090793          	mv	a5,s2
 2b4:	00040913          	mv	s2,s0
 2b8:	00078413          	mv	s0,a5
 2bc:	000a8793          	mv	a5,s5
 2c0:	000a0a93          	mv	s5,s4
 2c4:	00078a13          	mv	s4,a5
 2c8:	413a8cb3          	sub	s9,s5,s3
 2cc:	413a0c33          	sub	s8,s4,s3
 2d0:	00048713          	mv	a4,s1
 2d4:	00000b93          	li	s7,0
 2d8:	00000b13          	li	s6,0
 2dc:	40940d33          	sub	s10,s0,s1
 2e0:	40990db3          	sub	s11,s2,s1
 2e4:	09f00813          	li	a6,159
 2e8:	07f00893          	li	a7,127
 2ec:	08e95663          	bge	s2,a4,378 <st7735_draw_triangle+0x1b8>
 2f0:	40990b33          	sub	s6,s2,s1
 2f4:	038b0b33          	mul	s6,s6,s8
 2f8:	415a0cb3          	sub	s9,s4,s5
 2fc:	00000b93          	li	s7,0
 300:	00090a13          	mv	s4,s2
 304:	40940d33          	sub	s10,s0,s1
 308:	41240db3          	sub	s11,s0,s2
 30c:	09f00813          	li	a6,159
 310:	07f00893          	li	a7,127
 314:	0d445c63          	bge	s0,s4,3ec <st7735_draw_triangle+0x22c>
 318:	04c12083          	lw	ra,76(sp)
 31c:	04812403          	lw	s0,72(sp)
 320:	04412483          	lw	s1,68(sp)
 324:	04012903          	lw	s2,64(sp)
 328:	03c12983          	lw	s3,60(sp)
 32c:	03812a03          	lw	s4,56(sp)
 330:	03412a83          	lw	s5,52(sp)
 334:	03012b03          	lw	s6,48(sp)
 338:	02c12b83          	lw	s7,44(sp)
 33c:	02812c03          	lw	s8,40(sp)
 340:	02412c83          	lw	s9,36(sp)
 344:	02012d03          	lw	s10,32(sp)
 348:	01c12d83          	lw	s11,28(sp)
 34c:	05010113          	addi	sp,sp,80
 350:	00008067          	ret
 354:	00090793          	mv	a5,s2
 358:	00040913          	mv	s2,s0
 35c:	00048413          	mv	s0,s1
 360:	00078493          	mv	s1,a5
 364:	000a8793          	mv	a5,s5
 368:	000a0a93          	mv	s5,s4
 36c:	00098a13          	mv	s4,s3
 370:	00078993          	mv	s3,a5
 374:	f55ff06f          	j	2c8 <st7735_draw_triangle+0x108>
 378:	00098693          	mv	a3,s3
 37c:	00940663          	beq	s0,s1,388 <st7735_draw_triangle+0x1c8>
 380:	03abc6b3          	div	a3,s7,s10
 384:	013686b3          	add	a3,a3,s3
 388:	00098793          	mv	a5,s3
 38c:	00990663          	beq	s2,s1,398 <st7735_draw_triangle+0x1d8>
 390:	03bb47b3          	div	a5,s6,s11
 394:	013787b3          	add	a5,a5,s3
 398:	04e86263          	bltu	a6,a4,3dc <st7735_draw_triangle+0x21c>
 39c:	00d7c863          	blt	a5,a3,3ac <st7735_draw_triangle+0x1ec>
 3a0:	00078613          	mv	a2,a5
 3a4:	00068793          	mv	a5,a3
 3a8:	00060693          	mv	a3,a2
 3ac:	00d8d463          	bge	a7,a3,3b4 <st7735_draw_triangle+0x1f4>
 3b0:	07f00693          	li	a3,127
 3b4:	fff7c593          	not	a1,a5
 3b8:	00812503          	lw	a0,8(sp)
 3bc:	41f5d593          	srai	a1,a1,0x1f
 3c0:	00070613          	mv	a2,a4
 3c4:	00b7f5b3          	and	a1,a5,a1
 3c8:	00e12623          	sw	a4,12(sp)
 3cc:	d1dff0ef          	jal	e8 <st7735_draw_line>
 3d0:	00c12703          	lw	a4,12(sp)
 3d4:	07f00893          	li	a7,127
 3d8:	09f00813          	li	a6,159
 3dc:	00170713          	addi	a4,a4,1 # 2c000001 <st7735_draw_triangle+0x2bfffe41>
 3e0:	019b0b33          	add	s6,s6,s9
 3e4:	018b8bb3          	add	s7,s7,s8
 3e8:	f05ff06f          	j	2ec <st7735_draw_triangle+0x12c>
 3ec:	00098693          	mv	a3,s3
 3f0:	00940663          	beq	s0,s1,3fc <st7735_draw_triangle+0x23c>
 3f4:	03ab46b3          	div	a3,s6,s10
 3f8:	013686b3          	add	a3,a3,s3
 3fc:	000a8793          	mv	a5,s5
 400:	00890663          	beq	s2,s0,40c <st7735_draw_triangle+0x24c>
 404:	03bbc7b3          	div	a5,s7,s11
 408:	015787b3          	add	a5,a5,s5
 40c:	05486063          	bltu	a6,s4,44c <st7735_draw_triangle+0x28c>
 410:	00d7c863          	blt	a5,a3,420 <st7735_draw_triangle+0x260>
 414:	00078713          	mv	a4,a5
 418:	00068793          	mv	a5,a3
 41c:	00070693          	mv	a3,a4
 420:	00d8d463          	bge	a7,a3,428 <st7735_draw_triangle+0x268>
 424:	07f00693          	li	a3,127
 428:	fff7c593          	not	a1,a5
 42c:	00812503          	lw	a0,8(sp)
 430:	41f5d593          	srai	a1,a1,0x1f
 434:	000a0713          	mv	a4,s4
 438:	000a0613          	mv	a2,s4
 43c:	00b7f5b3          	and	a1,a5,a1
 440:	ca9ff0ef          	jal	e8 <st7735_draw_line>
 444:	07f00893          	li	a7,127
 448:	09f00813          	li	a6,159
 44c:	001a0a13          	addi	s4,s4,1
 450:	019b8bb3          	add	s7,s7,s9
 454:	018b0b33          	add	s6,s6,s8
 458:	ebdff06f          	j	314 <st7735_draw_triangle+0x154>
 45c:	eef8cce3          	blt	a7,a5,354 <st7735_draw_triangle+0x194>
 460:	00040493          	mv	s1,s0
 464:	00070993          	mv	s3,a4
 468:	00068413          	mv	s0,a3
 46c:	00060a13          	mv	s4,a2
 470:	e3dff06f          	j	2ac <st7735_draw_triangle+0xec>
