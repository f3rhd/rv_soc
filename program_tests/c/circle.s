
__out_tmp.elf:     file format elf32-littleriscv


Disassembly of section .text:

00000000 <__static_end>:
   0:	00001197          	auipc	gp,0x1
   4:	80018193          	addi	gp,gp,-2048 # 800 <__global_pointer$>
   8:	00020117          	auipc	sp,0x20
   c:	ff810113          	addi	sp,sp,-8 # 20000 <__stack_top>
  10:	030000ef          	jal	40 <main>

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

00000040 <main>:
  40:	fd010113          	addi	sp,sp,-48
  44:	03212023          	sw	s2,32(sp)
  48:	0a000713          	li	a4,160
  4c:	08000693          	li	a3,128
  50:	00000613          	li	a2,0
  54:	00000593          	li	a1,0
  58:	00000513          	li	a0,0
  5c:	00200913          	li	s2,2
  60:	02812423          	sw	s0,40(sp)
  64:	02912223          	sw	s1,36(sp)
  68:	01312e23          	sw	s3,28(sp)
  6c:	01412c23          	sw	s4,24(sp)
  70:	01512a23          	sw	s5,20(sp)
  74:	01612823          	sw	s6,16(sp)
  78:	01712623          	sw	s7,12(sp)
  7c:	02112623          	sw	ra,44(sp)
  80:	01812423          	sw	s8,8(sp)
  84:	00090993          	mv	s3,s2
  88:	168000ef          	jal	1f0 <st7735_draw_rectangle>
  8c:	05000413          	li	s0,80
  90:	04000493          	li	s1,64
  94:	07400a13          	li	s4,116
  98:	07a00b13          	li	s6,122
  9c:	09400a93          	li	s5,148
  a0:	09a00b93          	li	s7,154
  a4:	00b00713          	li	a4,11
  a8:	ffb40613          	addi	a2,s0,-5
  ac:	ffb48593          	addi	a1,s1,-5
  b0:	00070693          	mv	a3,a4
  b4:	00000513          	li	a0,0
  b8:	138000ef          	jal	1f0 <st7735_draw_rectangle>
  bc:	013484b3          	add	s1,s1,s3
  c0:	ffa48793          	addi	a5,s1,-6
  c4:	01240433          	add	s0,s0,s2
  c8:	00fa7c63          	bgeu	s4,a5,e0 <main+0xa0>
  cc:	009b24b3          	slt	s1,s6,s1
  d0:	409004b3          	neg	s1,s1
  d4:	0764f493          	andi	s1,s1,118
  d8:	413009b3          	neg	s3,s3
  dc:	00548493          	addi	s1,s1,5
  e0:	ffa40793          	addi	a5,s0,-6
  e4:	41200c33          	neg	s8,s2
  e8:	04faf663          	bgeu	s5,a5,134 <main+0xf4>
  ec:	008ba433          	slt	s0,s7,s0
  f0:	40800433          	neg	s0,s0
  f4:	09647413          	andi	s0,s0,150
  f8:	00540413          	addi	s0,s0,5
  fc:	001f0537          	lui	a0,0x1f0
 100:	00500693          	li	a3,5
 104:	00040613          	mv	a2,s0
 108:	00048593          	mv	a1,s1
 10c:	01f50513          	addi	a0,a0,31 # 1f001f <__stack_top+0x1d001f>
 110:	230000ef          	jal	340 <st7735_draw_circle>
 114:	00849513          	slli	a0,s1,0x8
 118:	00856533          	or	a0,a0,s0
 11c:	020000ef          	jal	13c <seg_write_hex>
 120:	0000c537          	lui	a0,0xc
 124:	35050513          	addi	a0,a0,848 # c350 <__static_reserve+0xb350>
 128:	ef1ff0ef          	jal	18 <delay>
 12c:	000c0913          	mv	s2,s8
 130:	f75ff06f          	j	a4 <main+0x64>
 134:	00090c13          	mv	s8,s2
 138:	fc5ff06f          	j	fc <main+0xbc>

0000013c <seg_write_hex>:
 13c:	f00007b7          	lui	a5,0xf0000
 140:	00478793          	addi	a5,a5,4 # f0000004 <__stack_top+0xeffe0004>
 144:	00a79023          	sh	a0,0(a5)
 148:	00008067          	ret

0000014c <st7735_set_rectangle>:
 14c:	00ff07b7          	lui	a5,0xff0
 150:	01059593          	slli	a1,a1,0x10
 154:	0ff6f693          	zext.b	a3,a3
 158:	00f5f5b3          	and	a1,a1,a5
 15c:	00869693          	slli	a3,a3,0x8
 160:	01051513          	slli	a0,a0,0x10
 164:	0ff67613          	zext.b	a2,a2
 168:	00f57533          	and	a0,a0,a5
 16c:	00861613          	slli	a2,a2,0x8
 170:	00d5e5b3          	or	a1,a1,a3
 174:	2b0007b7          	lui	a5,0x2b000
 178:	00c56533          	or	a0,a0,a2
 17c:	2a000737          	lui	a4,0x2a000
 180:	00f5e5b3          	or	a1,a1,a5
 184:	f00007b7          	lui	a5,0xf0000
 188:	00e56533          	or	a0,a0,a4
 18c:	00278793          	addi	a5,a5,2 # f0000002 <__stack_top+0xeffe0002>
 190:	00a7a023          	sw	a0,0(a5)
 194:	00b7a023          	sw	a1,0(a5)
 198:	00008067          	ret

0000019c <st7735_draw_pixel>:
 19c:	ff010113          	addi	sp,sp,-16
 1a0:	00812423          	sw	s0,8(sp)
 1a4:	00050413          	mv	s0,a0
 1a8:	00058513          	mv	a0,a1
 1ac:	00060693          	mv	a3,a2
 1b0:	00060593          	mv	a1,a2
 1b4:	00050613          	mv	a2,a0
 1b8:	00112623          	sw	ra,12(sp)
 1bc:	f91ff0ef          	jal	14c <st7735_set_rectangle>
 1c0:	2c0007b7          	lui	a5,0x2c000
 1c4:	f0000737          	lui	a4,0xf0000
 1c8:	00178793          	addi	a5,a5,1 # 2c000001 <__stack_top+0x2bfe0001>
 1cc:	00270713          	addi	a4,a4,2 # f0000002 <__stack_top+0xeffe0002>
 1d0:	00f72023          	sw	a5,0(a4)
 1d4:	f00007b7          	lui	a5,0xf0000
 1d8:	00178793          	addi	a5,a5,1 # f0000001 <__stack_top+0xeffe0001>
 1dc:	0087a023          	sw	s0,0(a5)
 1e0:	00c12083          	lw	ra,12(sp)
 1e4:	00812403          	lw	s0,8(sp)
 1e8:	01010113          	addi	sp,sp,16
 1ec:	00008067          	ret

000001f0 <st7735_draw_rectangle>:
 1f0:	fe010113          	addi	sp,sp,-32
 1f4:	00812c23          	sw	s0,24(sp)
 1f8:	00912a23          	sw	s1,20(sp)
 1fc:	00068413          	mv	s0,a3
 200:	00050493          	mv	s1,a0
 204:	00058513          	mv	a0,a1
 208:	00e606b3          	add	a3,a2,a4
 20c:	00060593          	mv	a1,a2
 210:	00850633          	add	a2,a0,s0
 214:	fff68693          	addi	a3,a3,-1
 218:	fff60613          	addi	a2,a2,-1
 21c:	00112e23          	sw	ra,28(sp)
 220:	00e12623          	sw	a4,12(sp)
 224:	f29ff0ef          	jal	14c <st7735_set_rectangle>
 228:	00c12703          	lw	a4,12(sp)
 22c:	2c0007b7          	lui	a5,0x2c000
 230:	02e40433          	mul	s0,s0,a4
 234:	40145413          	srai	s0,s0,0x1
 238:	00f46433          	or	s0,s0,a5
 23c:	f00007b7          	lui	a5,0xf0000
 240:	00278793          	addi	a5,a5,2 # f0000002 <__stack_top+0xeffe0002>
 244:	0087a023          	sw	s0,0(a5)
 248:	f00007b7          	lui	a5,0xf0000
 24c:	00178793          	addi	a5,a5,1 # f0000001 <__stack_top+0xeffe0001>
 250:	0097a023          	sw	s1,0(a5)
 254:	01c12083          	lw	ra,28(sp)
 258:	01812403          	lw	s0,24(sp)
 25c:	01412483          	lw	s1,20(sp)
 260:	02010113          	addi	sp,sp,32
 264:	00008067          	ret

00000268 <st7735_draw_line>:
 268:	fc010113          	addi	sp,sp,-64
 26c:	02812c23          	sw	s0,56(sp)
 270:	40b68433          	sub	s0,a3,a1
 274:	41f45793          	srai	a5,s0,0x1f
 278:	03412423          	sw	s4,40(sp)
 27c:	0087c433          	xor	s0,a5,s0
 280:	02112e23          	sw	ra,60(sp)
 284:	02912a23          	sw	s1,52(sp)
 288:	03212823          	sw	s2,48(sp)
 28c:	03312623          	sw	s3,44(sp)
 290:	03512223          	sw	s5,36(sp)
 294:	40f40433          	sub	s0,s0,a5
 298:	00100a13          	li	s4,1
 29c:	00d5c463          	blt	a1,a3,2a4 <st7735_draw_line+0x3c>
 2a0:	fff00a13          	li	s4,-1
 2a4:	40c704b3          	sub	s1,a4,a2
 2a8:	41f4d793          	srai	a5,s1,0x1f
 2ac:	0097c4b3          	xor	s1,a5,s1
 2b0:	40f484b3          	sub	s1,s1,a5
 2b4:	40900ab3          	neg	s5,s1
 2b8:	fff00993          	li	s3,-1
 2bc:	00e65463          	bge	a2,a4,2c4 <st7735_draw_line+0x5c>
 2c0:	00100993          	li	s3,1
 2c4:	40940933          	sub	s2,s0,s1
 2c8:	00e12e23          	sw	a4,28(sp)
 2cc:	00d12c23          	sw	a3,24(sp)
 2d0:	00c12a23          	sw	a2,20(sp)
 2d4:	00b12823          	sw	a1,16(sp)
 2d8:	00a12623          	sw	a0,12(sp)
 2dc:	ec1ff0ef          	jal	19c <st7735_draw_pixel>
 2e0:	01012583          	lw	a1,16(sp)
 2e4:	01812683          	lw	a3,24(sp)
 2e8:	00c12503          	lw	a0,12(sp)
 2ec:	01412603          	lw	a2,20(sp)
 2f0:	01c12703          	lw	a4,28(sp)
 2f4:	00d59463          	bne	a1,a3,2fc <st7735_draw_line+0x94>
 2f8:	02e60263          	beq	a2,a4,31c <st7735_draw_line+0xb4>
 2fc:	00191793          	slli	a5,s2,0x1
 300:	0157c863          	blt	a5,s5,310 <st7735_draw_line+0xa8>
 304:	40990933          	sub	s2,s2,s1
 308:	014585b3          	add	a1,a1,s4
 30c:	faf44ee3          	blt	s0,a5,2c8 <st7735_draw_line+0x60>
 310:	00890933          	add	s2,s2,s0
 314:	01360633          	add	a2,a2,s3
 318:	fb1ff06f          	j	2c8 <st7735_draw_line+0x60>
 31c:	03c12083          	lw	ra,60(sp)
 320:	03812403          	lw	s0,56(sp)
 324:	03412483          	lw	s1,52(sp)
 328:	03012903          	lw	s2,48(sp)
 32c:	02c12983          	lw	s3,44(sp)
 330:	02812a03          	lw	s4,40(sp)
 334:	02412a83          	lw	s5,36(sp)
 338:	04010113          	addi	sp,sp,64
 33c:	00008067          	ret

00000340 <st7735_draw_circle>:
 340:	fd010113          	addi	sp,sp,-48
 344:	03212023          	sw	s2,32(sp)
 348:	00100913          	li	s2,1
 34c:	02812423          	sw	s0,40(sp)
 350:	02912223          	sw	s1,36(sp)
 354:	01312e23          	sw	s3,28(sp)
 358:	01412c23          	sw	s4,24(sp)
 35c:	01512a23          	sw	s5,20(sp)
 360:	02112623          	sw	ra,44(sp)
 364:	00050a93          	mv	s5,a0
 368:	00058993          	mv	s3,a1
 36c:	00060a13          	mv	s4,a2
 370:	00068413          	mv	s0,a3
 374:	40d90933          	sub	s2,s2,a3
 378:	00000493          	li	s1,0
 37c:	02945463          	bge	s0,s1,3a4 <st7735_draw_circle+0x64>
 380:	02c12083          	lw	ra,44(sp)
 384:	02812403          	lw	s0,40(sp)
 388:	02412483          	lw	s1,36(sp)
 38c:	02012903          	lw	s2,32(sp)
 390:	01c12983          	lw	s3,28(sp)
 394:	01812a03          	lw	s4,24(sp)
 398:	01412a83          	lw	s5,20(sp)
 39c:	03010113          	addi	sp,sp,48
 3a0:	00008067          	ret
 3a4:	009a0733          	add	a4,s4,s1
 3a8:	408985b3          	sub	a1,s3,s0
 3ac:	013406b3          	add	a3,s0,s3
 3b0:	00070613          	mv	a2,a4
 3b4:	000a8513          	mv	a0,s5
 3b8:	00d12623          	sw	a3,12(sp)
 3bc:	00b12423          	sw	a1,8(sp)
 3c0:	ea9ff0ef          	jal	268 <st7735_draw_line>
 3c4:	00c12683          	lw	a3,12(sp)
 3c8:	00812583          	lw	a1,8(sp)
 3cc:	409a0733          	sub	a4,s4,s1
 3d0:	00070613          	mv	a2,a4
 3d4:	000a8513          	mv	a0,s5
 3d8:	e91ff0ef          	jal	268 <st7735_draw_line>
 3dc:	01440733          	add	a4,s0,s4
 3e0:	409985b3          	sub	a1,s3,s1
 3e4:	013486b3          	add	a3,s1,s3
 3e8:	00070613          	mv	a2,a4
 3ec:	000a8513          	mv	a0,s5
 3f0:	00d12623          	sw	a3,12(sp)
 3f4:	00b12423          	sw	a1,8(sp)
 3f8:	e71ff0ef          	jal	268 <st7735_draw_line>
 3fc:	00c12683          	lw	a3,12(sp)
 400:	00812583          	lw	a1,8(sp)
 404:	408a0733          	sub	a4,s4,s0
 408:	00070613          	mv	a2,a4
 40c:	000a8513          	mv	a0,s5
 410:	e59ff0ef          	jal	268 <st7735_draw_line>
 414:	00148493          	addi	s1,s1,1
 418:	00149793          	slli	a5,s1,0x1
 41c:	00094863          	bltz	s2,42c <st7735_draw_circle+0xec>
 420:	fff40413          	addi	s0,s0,-1
 424:	408487b3          	sub	a5,s1,s0
 428:	00179793          	slli	a5,a5,0x1
 42c:	00178793          	addi	a5,a5,1
 430:	00f90933          	add	s2,s2,a5
 434:	f49ff06f          	j	37c <st7735_draw_circle+0x3c>
