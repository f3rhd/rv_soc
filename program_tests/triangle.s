
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
  18:	08c00893          	li	a7,140
  1c:	001f0537          	lui	a0,0x1f0
  20:	ff010113          	addi	sp,sp,-16
  24:	01f50513          	addi	a0,a0,31 # 1f001f <__stack_top+0x1d001f>
  28:	06c00813          	li	a6,108
  2c:	00088793          	mv	a5,a7
  30:	01400713          	li	a4,20
  34:	05000693          	li	a3,80
  38:	04000613          	li	a2,64
  3c:	00000593          	li	a1,0
  40:	00112623          	sw	ra,12(sp)
  44:	190000ef          	jal	1d4 <st7735_draw_triangle>
  48:	00c12083          	lw	ra,12(sp)
  4c:	00000513          	li	a0,0
  50:	01010113          	addi	sp,sp,16
  54:	00008067          	ret

00000058 <st7735_set_rectangle>:
  58:	00ff07b7          	lui	a5,0xff0
  5c:	01059593          	slli	a1,a1,0x10
  60:	0ff6f693          	zext.b	a3,a3
  64:	00f5f5b3          	and	a1,a1,a5
  68:	00869693          	slli	a3,a3,0x8
  6c:	01051513          	slli	a0,a0,0x10
  70:	0ff67613          	zext.b	a2,a2
  74:	00f57533          	and	a0,a0,a5
  78:	00861613          	slli	a2,a2,0x8
  7c:	00d5e5b3          	or	a1,a1,a3
  80:	2b0007b7          	lui	a5,0x2b000
  84:	00c56533          	or	a0,a0,a2
  88:	2a000737          	lui	a4,0x2a000
  8c:	00f5e5b3          	or	a1,a1,a5
  90:	f00007b7          	lui	a5,0xf0000
  94:	00e56533          	or	a0,a0,a4
  98:	00278793          	addi	a5,a5,2 # f0000002 <__stack_top+0xeffe0002>
  9c:	00a7a023          	sw	a0,0(a5)
  a0:	00b7a023          	sw	a1,0(a5)
  a4:	00008067          	ret

000000a8 <st7735_draw_pixel>:
  a8:	ff010113          	addi	sp,sp,-16
  ac:	00812423          	sw	s0,8(sp)
  b0:	00050413          	mv	s0,a0
  b4:	00058513          	mv	a0,a1
  b8:	00060693          	mv	a3,a2
  bc:	00060593          	mv	a1,a2
  c0:	00050613          	mv	a2,a0
  c4:	00112623          	sw	ra,12(sp)
  c8:	f91ff0ef          	jal	58 <st7735_set_rectangle>
  cc:	2c0007b7          	lui	a5,0x2c000
  d0:	f0000737          	lui	a4,0xf0000
  d4:	00178793          	addi	a5,a5,1 # 2c000001 <__stack_top+0x2bfe0001>
  d8:	00270713          	addi	a4,a4,2 # f0000002 <__stack_top+0xeffe0002>
  dc:	00f72023          	sw	a5,0(a4)
  e0:	f00007b7          	lui	a5,0xf0000
  e4:	00178793          	addi	a5,a5,1 # f0000001 <__stack_top+0xeffe0001>
  e8:	0087a023          	sw	s0,0(a5)
  ec:	00c12083          	lw	ra,12(sp)
  f0:	00812403          	lw	s0,8(sp)
  f4:	01010113          	addi	sp,sp,16
  f8:	00008067          	ret

000000fc <st7735_draw_line>:
  fc:	fc010113          	addi	sp,sp,-64
 100:	02812c23          	sw	s0,56(sp)
 104:	40b68433          	sub	s0,a3,a1
 108:	41f45793          	srai	a5,s0,0x1f
 10c:	03412423          	sw	s4,40(sp)
 110:	0087c433          	xor	s0,a5,s0
 114:	02112e23          	sw	ra,60(sp)
 118:	02912a23          	sw	s1,52(sp)
 11c:	03212823          	sw	s2,48(sp)
 120:	03312623          	sw	s3,44(sp)
 124:	03512223          	sw	s5,36(sp)
 128:	40f40433          	sub	s0,s0,a5
 12c:	00100a13          	li	s4,1
 130:	00d5c463          	blt	a1,a3,138 <st7735_draw_line+0x3c>
 134:	fff00a13          	li	s4,-1
 138:	40c704b3          	sub	s1,a4,a2
 13c:	41f4d793          	srai	a5,s1,0x1f
 140:	0097c4b3          	xor	s1,a5,s1
 144:	40f484b3          	sub	s1,s1,a5
 148:	40900ab3          	neg	s5,s1
 14c:	fff00993          	li	s3,-1
 150:	00e65463          	bge	a2,a4,158 <st7735_draw_line+0x5c>
 154:	00100993          	li	s3,1
 158:	40940933          	sub	s2,s0,s1
 15c:	00e12e23          	sw	a4,28(sp)
 160:	00d12c23          	sw	a3,24(sp)
 164:	00c12a23          	sw	a2,20(sp)
 168:	00b12823          	sw	a1,16(sp)
 16c:	00a12623          	sw	a0,12(sp)
 170:	f39ff0ef          	jal	a8 <st7735_draw_pixel>
 174:	01012583          	lw	a1,16(sp)
 178:	01812683          	lw	a3,24(sp)
 17c:	00c12503          	lw	a0,12(sp)
 180:	01412603          	lw	a2,20(sp)
 184:	01c12703          	lw	a4,28(sp)
 188:	00d59463          	bne	a1,a3,190 <st7735_draw_line+0x94>
 18c:	02e60263          	beq	a2,a4,1b0 <st7735_draw_line+0xb4>
 190:	00191793          	slli	a5,s2,0x1
 194:	0157c863          	blt	a5,s5,1a4 <st7735_draw_line+0xa8>
 198:	40990933          	sub	s2,s2,s1
 19c:	014585b3          	add	a1,a1,s4
 1a0:	faf44ee3          	blt	s0,a5,15c <st7735_draw_line+0x60>
 1a4:	00890933          	add	s2,s2,s0
 1a8:	01360633          	add	a2,a2,s3
 1ac:	fb1ff06f          	j	15c <st7735_draw_line+0x60>
 1b0:	03c12083          	lw	ra,60(sp)
 1b4:	03812403          	lw	s0,56(sp)
 1b8:	03412483          	lw	s1,52(sp)
 1bc:	03012903          	lw	s2,48(sp)
 1c0:	02c12983          	lw	s3,44(sp)
 1c4:	02812a03          	lw	s4,40(sp)
 1c8:	02412a83          	lw	s5,36(sp)
 1cc:	04010113          	addi	sp,sp,64
 1d0:	00008067          	ret

000001d4 <st7735_draw_triangle>:
 1d4:	fb010113          	addi	sp,sp,-80
 1d8:	04812423          	sw	s0,72(sp)
 1dc:	04912223          	sw	s1,68(sp)
 1e0:	05212023          	sw	s2,64(sp)
 1e4:	03312e23          	sw	s3,60(sp)
 1e8:	03412c23          	sw	s4,56(sp)
 1ec:	03512a23          	sw	s5,52(sp)
 1f0:	04112623          	sw	ra,76(sp)
 1f4:	03612823          	sw	s6,48(sp)
 1f8:	03712623          	sw	s7,44(sp)
 1fc:	03812423          	sw	s8,40(sp)
 200:	03912223          	sw	s9,36(sp)
 204:	03a12023          	sw	s10,32(sp)
 208:	01b12e23          	sw	s11,28(sp)
 20c:	00a12423          	sw	a0,8(sp)
 210:	00060993          	mv	s3,a2
 214:	00068493          	mv	s1,a3
 218:	00070a13          	mv	s4,a4
 21c:	00078413          	mv	s0,a5
 220:	00080a93          	mv	s5,a6
 224:	00088913          	mv	s2,a7
 228:	08058063          	beqz	a1,2a8 <st7735_draw_triangle+0xd4>
 22c:	00078713          	mv	a4,a5
 230:	000a0693          	mv	a3,s4
 234:	00048613          	mv	a2,s1
 238:	00098593          	mv	a1,s3
 23c:	ec1ff0ef          	jal	fc <st7735_draw_line>
 240:	00812503          	lw	a0,8(sp)
 244:	00090713          	mv	a4,s2
 248:	000a8693          	mv	a3,s5
 24c:	00048613          	mv	a2,s1
 250:	00098593          	mv	a1,s3
 254:	ea9ff0ef          	jal	fc <st7735_draw_line>
 258:	00040613          	mv	a2,s0
 25c:	04812403          	lw	s0,72(sp)
 260:	00812503          	lw	a0,8(sp)
 264:	04c12083          	lw	ra,76(sp)
 268:	04412483          	lw	s1,68(sp)
 26c:	03c12983          	lw	s3,60(sp)
 270:	03012b03          	lw	s6,48(sp)
 274:	02c12b83          	lw	s7,44(sp)
 278:	02812c03          	lw	s8,40(sp)
 27c:	02412c83          	lw	s9,36(sp)
 280:	02012d03          	lw	s10,32(sp)
 284:	01c12d83          	lw	s11,28(sp)
 288:	00090713          	mv	a4,s2
 28c:	000a8693          	mv	a3,s5
 290:	04012903          	lw	s2,64(sp)
 294:	03412a83          	lw	s5,52(sp)
 298:	000a0593          	mv	a1,s4
 29c:	03812a03          	lw	s4,56(sp)
 2a0:	05010113          	addi	sp,sp,80
 2a4:	e59ff06f          	j	fc <st7735_draw_line>
 2a8:	1cd7c463          	blt	a5,a3,470 <st7735_draw_triangle+0x29c>
 2ac:	00d8da63          	bge	a7,a3,2c0 <st7735_draw_triangle+0xec>
 2b0:	00088493          	mv	s1,a7
 2b4:	00068913          	mv	s2,a3
 2b8:	00080993          	mv	s3,a6
 2bc:	00060a93          	mv	s5,a2
 2c0:	00894e63          	blt	s2,s0,2dc <st7735_draw_triangle+0x108>
 2c4:	00090793          	mv	a5,s2
 2c8:	00040913          	mv	s2,s0
 2cc:	00078413          	mv	s0,a5
 2d0:	000a8793          	mv	a5,s5
 2d4:	000a0a93          	mv	s5,s4
 2d8:	00078a13          	mv	s4,a5
 2dc:	413a8cb3          	sub	s9,s5,s3
 2e0:	413a0c33          	sub	s8,s4,s3
 2e4:	00048713          	mv	a4,s1
 2e8:	00000b93          	li	s7,0
 2ec:	00000b13          	li	s6,0
 2f0:	40940d33          	sub	s10,s0,s1
 2f4:	40990db3          	sub	s11,s2,s1
 2f8:	09f00813          	li	a6,159
 2fc:	07f00893          	li	a7,127
 300:	08e95663          	bge	s2,a4,38c <st7735_draw_triangle+0x1b8>
 304:	40990b33          	sub	s6,s2,s1
 308:	038b0b33          	mul	s6,s6,s8
 30c:	415a0cb3          	sub	s9,s4,s5
 310:	00000b93          	li	s7,0
 314:	00090a13          	mv	s4,s2
 318:	40940d33          	sub	s10,s0,s1
 31c:	41240db3          	sub	s11,s0,s2
 320:	09f00813          	li	a6,159
 324:	07f00893          	li	a7,127
 328:	0d445c63          	bge	s0,s4,400 <st7735_draw_triangle+0x22c>
 32c:	04c12083          	lw	ra,76(sp)
 330:	04812403          	lw	s0,72(sp)
 334:	04412483          	lw	s1,68(sp)
 338:	04012903          	lw	s2,64(sp)
 33c:	03c12983          	lw	s3,60(sp)
 340:	03812a03          	lw	s4,56(sp)
 344:	03412a83          	lw	s5,52(sp)
 348:	03012b03          	lw	s6,48(sp)
 34c:	02c12b83          	lw	s7,44(sp)
 350:	02812c03          	lw	s8,40(sp)
 354:	02412c83          	lw	s9,36(sp)
 358:	02012d03          	lw	s10,32(sp)
 35c:	01c12d83          	lw	s11,28(sp)
 360:	05010113          	addi	sp,sp,80
 364:	00008067          	ret
 368:	00090793          	mv	a5,s2
 36c:	00040913          	mv	s2,s0
 370:	00048413          	mv	s0,s1
 374:	00078493          	mv	s1,a5
 378:	000a8793          	mv	a5,s5
 37c:	000a0a93          	mv	s5,s4
 380:	00098a13          	mv	s4,s3
 384:	00078993          	mv	s3,a5
 388:	f55ff06f          	j	2dc <st7735_draw_triangle+0x108>
 38c:	00098693          	mv	a3,s3
 390:	00940663          	beq	s0,s1,39c <st7735_draw_triangle+0x1c8>
 394:	03abc6b3          	div	a3,s7,s10
 398:	013686b3          	add	a3,a3,s3
 39c:	00098793          	mv	a5,s3
 3a0:	00990663          	beq	s2,s1,3ac <st7735_draw_triangle+0x1d8>
 3a4:	03bb47b3          	div	a5,s6,s11
 3a8:	013787b3          	add	a5,a5,s3
 3ac:	04e86263          	bltu	a6,a4,3f0 <st7735_draw_triangle+0x21c>
 3b0:	00d7c863          	blt	a5,a3,3c0 <st7735_draw_triangle+0x1ec>
 3b4:	00078613          	mv	a2,a5
 3b8:	00068793          	mv	a5,a3
 3bc:	00060693          	mv	a3,a2
 3c0:	00d8d463          	bge	a7,a3,3c8 <st7735_draw_triangle+0x1f4>
 3c4:	07f00693          	li	a3,127
 3c8:	fff7c593          	not	a1,a5
 3cc:	00812503          	lw	a0,8(sp)
 3d0:	41f5d593          	srai	a1,a1,0x1f
 3d4:	00070613          	mv	a2,a4
 3d8:	00b7f5b3          	and	a1,a5,a1
 3dc:	00e12623          	sw	a4,12(sp)
 3e0:	d1dff0ef          	jal	fc <st7735_draw_line>
 3e4:	00c12703          	lw	a4,12(sp)
 3e8:	07f00893          	li	a7,127
 3ec:	09f00813          	li	a6,159
 3f0:	00170713          	addi	a4,a4,1
 3f4:	019b0b33          	add	s6,s6,s9
 3f8:	018b8bb3          	add	s7,s7,s8
 3fc:	f05ff06f          	j	300 <st7735_draw_triangle+0x12c>
 400:	00098693          	mv	a3,s3
 404:	00940663          	beq	s0,s1,410 <st7735_draw_triangle+0x23c>
 408:	03ab46b3          	div	a3,s6,s10
 40c:	013686b3          	add	a3,a3,s3
 410:	000a8793          	mv	a5,s5
 414:	00890663          	beq	s2,s0,420 <st7735_draw_triangle+0x24c>
 418:	03bbc7b3          	div	a5,s7,s11
 41c:	015787b3          	add	a5,a5,s5
 420:	05486063          	bltu	a6,s4,460 <st7735_draw_triangle+0x28c>
 424:	00d7c863          	blt	a5,a3,434 <st7735_draw_triangle+0x260>
 428:	00078713          	mv	a4,a5
 42c:	00068793          	mv	a5,a3
 430:	00070693          	mv	a3,a4
 434:	00d8d463          	bge	a7,a3,43c <st7735_draw_triangle+0x268>
 438:	07f00693          	li	a3,127
 43c:	fff7c593          	not	a1,a5
 440:	00812503          	lw	a0,8(sp)
 444:	41f5d593          	srai	a1,a1,0x1f
 448:	000a0713          	mv	a4,s4
 44c:	000a0613          	mv	a2,s4
 450:	00b7f5b3          	and	a1,a5,a1
 454:	ca9ff0ef          	jal	fc <st7735_draw_line>
 458:	07f00893          	li	a7,127
 45c:	09f00813          	li	a6,159
 460:	001a0a13          	addi	s4,s4,1
 464:	019b8bb3          	add	s7,s7,s9
 468:	018b0b33          	add	s6,s6,s8
 46c:	ebdff06f          	j	328 <st7735_draw_triangle+0x154>
 470:	eef8cce3          	blt	a7,a5,368 <st7735_draw_triangle+0x194>
 474:	00040493          	mv	s1,s0
 478:	00070993          	mv	s3,a4
 47c:	00068413          	mv	s0,a3
 480:	00060a13          	mv	s4,a2
 484:	e3dff06f          	j	2c0 <st7735_draw_triangle+0xec>
