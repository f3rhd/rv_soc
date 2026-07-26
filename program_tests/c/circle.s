
__out_tmp.elf:     file format elf32-littleriscv


Disassembly of section .text:

00000000 <_start>:
   0:	00008137          	lui	sp,0x8
   4:	030000ef          	jal	34 <main>

00000008 <halt_loop>:
   8:	0000006f          	j	8 <halt_loop>

0000000c <delay>:
   c:	ff010113          	addi	sp,sp,-16 # 7ff0 <st7735_draw_circle+0x7cdc>
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
  7c:	140000ef          	jal	1bc <st7735_draw_rectangle>
  80:	05000413          	li	s0,80
  84:	04000493          	li	s1,64
  88:	05600a13          	li	s4,86
  8c:	06b00b13          	li	s6,107
  90:	07600a93          	li	s5,118
  94:	08b00b93          	li	s7,139
  98:	00040613          	mv	a2,s0
  9c:	00048593          	mv	a1,s1
  a0:	01e00693          	li	a3,30
  a4:	00000513          	li	a0,0
  a8:	26c000ef          	jal	314 <st7735_draw_circle>
  ac:	013484b3          	add	s1,s1,s3
  b0:	feb48793          	addi	a5,s1,-21
  b4:	01240433          	add	s0,s0,s2
  b8:	00fa7c63          	bgeu	s4,a5,d0 <main+0x9c>
  bc:	009b24b3          	slt	s1,s6,s1
  c0:	409004b3          	neg	s1,s1
  c4:	0584f493          	andi	s1,s1,88
  c8:	413009b3          	neg	s3,s3
  cc:	01448493          	addi	s1,s1,20
  d0:	feb40793          	addi	a5,s0,-21
  d4:	41200c33          	neg	s8,s2
  d8:	04faf063          	bgeu	s5,a5,118 <main+0xe4>
  dc:	008ba433          	slt	s0,s7,s0
  e0:	40800433          	neg	s0,s0
  e4:	07847413          	andi	s0,s0,120
  e8:	01440413          	addi	s0,s0,20
  ec:	00100537          	lui	a0,0x100
  f0:	01400693          	li	a3,20
  f4:	00040613          	mv	a2,s0
  f8:	00048593          	mv	a1,s1
  fc:	01050513          	addi	a0,a0,16 # 100010 <st7735_draw_circle+0xffcfc>
 100:	214000ef          	jal	314 <st7735_draw_circle>
 104:	0003d537          	lui	a0,0x3d
 108:	09050513          	addi	a0,a0,144 # 3d090 <st7735_draw_circle+0x3cd7c>
 10c:	f01ff0ef          	jal	c <delay>
 110:	000c0913          	mv	s2,s8
 114:	f85ff06f          	j	98 <main+0x64>
 118:	00090c13          	mv	s8,s2
 11c:	fd1ff06f          	j	ec <main+0xb8>

00000120 <st7735_set_rectangle>:
 120:	00ff07b7          	lui	a5,0xff0
 124:	01059593          	slli	a1,a1,0x10
 128:	0ff6f693          	zext.b	a3,a3
 12c:	00f5f5b3          	and	a1,a1,a5
 130:	00869693          	slli	a3,a3,0x8
 134:	01051513          	slli	a0,a0,0x10
 138:	0ff67613          	zext.b	a2,a2
 13c:	00f57533          	and	a0,a0,a5
 140:	00861613          	slli	a2,a2,0x8
 144:	00d5e5b3          	or	a1,a1,a3
 148:	2b0007b7          	lui	a5,0x2b000
 14c:	00c56533          	or	a0,a0,a2
 150:	2a000737          	lui	a4,0x2a000
 154:	00f5e5b3          	or	a1,a1,a5
 158:	f00007b7          	lui	a5,0xf0000
 15c:	00e56533          	or	a0,a0,a4
 160:	00478793          	addi	a5,a5,4 # f0000004 <st7735_draw_circle+0xeffffcf0>
 164:	00a7a023          	sw	a0,0(a5)
 168:	00b7a023          	sw	a1,0(a5)
 16c:	00008067          	ret

00000170 <st7735_draw_pixel>:
 170:	ff010113          	addi	sp,sp,-16
 174:	00812423          	sw	s0,8(sp)
 178:	00050413          	mv	s0,a0
 17c:	00058513          	mv	a0,a1
 180:	00060693          	mv	a3,a2
 184:	00060593          	mv	a1,a2
 188:	00050613          	mv	a2,a0
 18c:	00112623          	sw	ra,12(sp)
 190:	f91ff0ef          	jal	120 <st7735_set_rectangle>
 194:	f00007b7          	lui	a5,0xf0000
 198:	2c000737          	lui	a4,0x2c000
 19c:	00478793          	addi	a5,a5,4 # f0000004 <st7735_draw_circle+0xeffffcf0>
 1a0:	00e7a023          	sw	a4,0(a5)
 1a4:	f00007b7          	lui	a5,0xf0000
 1a8:	0087a023          	sw	s0,0(a5) # f0000000 <st7735_draw_circle+0xeffffcec>
 1ac:	00c12083          	lw	ra,12(sp)
 1b0:	00812403          	lw	s0,8(sp)
 1b4:	01010113          	addi	sp,sp,16
 1b8:	00008067          	ret

000001bc <st7735_draw_rectangle>:
 1bc:	fe010113          	addi	sp,sp,-32
 1c0:	00812c23          	sw	s0,24(sp)
 1c4:	00912a23          	sw	s1,20(sp)
 1c8:	00068413          	mv	s0,a3
 1cc:	00050493          	mv	s1,a0
 1d0:	00058513          	mv	a0,a1
 1d4:	00e606b3          	add	a3,a2,a4
 1d8:	00060593          	mv	a1,a2
 1dc:	00850633          	add	a2,a0,s0
 1e0:	fff68693          	addi	a3,a3,-1
 1e4:	fff60613          	addi	a2,a2,-1
 1e8:	00e12623          	sw	a4,12(sp)
 1ec:	00112e23          	sw	ra,28(sp)
 1f0:	f31ff0ef          	jal	120 <st7735_set_rectangle>
 1f4:	00c12703          	lw	a4,12(sp)
 1f8:	f00007b7          	lui	a5,0xf0000
 1fc:	00478793          	addi	a5,a5,4 # f0000004 <st7735_draw_circle+0xeffffcf0>
 200:	02e40433          	mul	s0,s0,a4
 204:	2c000737          	lui	a4,0x2c000
 208:	40145413          	srai	s0,s0,0x1
 20c:	00e7a023          	sw	a4,0(a5)
 210:	00000793          	li	a5,0
 214:	f0000737          	lui	a4,0xf0000
 218:	0087cc63          	blt	a5,s0,230 <st7735_draw_rectangle+0x74>
 21c:	01c12083          	lw	ra,28(sp)
 220:	01812403          	lw	s0,24(sp)
 224:	01412483          	lw	s1,20(sp)
 228:	02010113          	addi	sp,sp,32
 22c:	00008067          	ret
 230:	00972023          	sw	s1,0(a4) # f0000000 <st7735_draw_circle+0xeffffcec>
 234:	00178793          	addi	a5,a5,1
 238:	fe1ff06f          	j	218 <st7735_draw_rectangle+0x5c>

0000023c <st7735_draw_line>:
 23c:	fc010113          	addi	sp,sp,-64
 240:	02812c23          	sw	s0,56(sp)
 244:	40b68433          	sub	s0,a3,a1
 248:	41f45793          	srai	a5,s0,0x1f
 24c:	03412423          	sw	s4,40(sp)
 250:	0087c433          	xor	s0,a5,s0
 254:	02112e23          	sw	ra,60(sp)
 258:	02912a23          	sw	s1,52(sp)
 25c:	03212823          	sw	s2,48(sp)
 260:	03312623          	sw	s3,44(sp)
 264:	03512223          	sw	s5,36(sp)
 268:	40f40433          	sub	s0,s0,a5
 26c:	00100a13          	li	s4,1
 270:	00d5c463          	blt	a1,a3,278 <st7735_draw_line+0x3c>
 274:	fff00a13          	li	s4,-1
 278:	40c704b3          	sub	s1,a4,a2
 27c:	41f4d793          	srai	a5,s1,0x1f
 280:	0097c4b3          	xor	s1,a5,s1
 284:	40f484b3          	sub	s1,s1,a5
 288:	40900ab3          	neg	s5,s1
 28c:	fff00993          	li	s3,-1
 290:	00e65463          	bge	a2,a4,298 <st7735_draw_line+0x5c>
 294:	00100993          	li	s3,1
 298:	40940933          	sub	s2,s0,s1
 29c:	00e12e23          	sw	a4,28(sp)
 2a0:	00d12c23          	sw	a3,24(sp)
 2a4:	00c12a23          	sw	a2,20(sp)
 2a8:	00b12823          	sw	a1,16(sp)
 2ac:	00a12623          	sw	a0,12(sp)
 2b0:	ec1ff0ef          	jal	170 <st7735_draw_pixel>
 2b4:	01012583          	lw	a1,16(sp)
 2b8:	01812683          	lw	a3,24(sp)
 2bc:	00c12503          	lw	a0,12(sp)
 2c0:	01412603          	lw	a2,20(sp)
 2c4:	01c12703          	lw	a4,28(sp)
 2c8:	00d59463          	bne	a1,a3,2d0 <st7735_draw_line+0x94>
 2cc:	02e60263          	beq	a2,a4,2f0 <st7735_draw_line+0xb4>
 2d0:	00191793          	slli	a5,s2,0x1
 2d4:	0157c863          	blt	a5,s5,2e4 <st7735_draw_line+0xa8>
 2d8:	40990933          	sub	s2,s2,s1
 2dc:	014585b3          	add	a1,a1,s4
 2e0:	faf44ee3          	blt	s0,a5,29c <st7735_draw_line+0x60>
 2e4:	00890933          	add	s2,s2,s0
 2e8:	01360633          	add	a2,a2,s3
 2ec:	fb1ff06f          	j	29c <st7735_draw_line+0x60>
 2f0:	03c12083          	lw	ra,60(sp)
 2f4:	03812403          	lw	s0,56(sp)
 2f8:	03412483          	lw	s1,52(sp)
 2fc:	03012903          	lw	s2,48(sp)
 300:	02c12983          	lw	s3,44(sp)
 304:	02812a03          	lw	s4,40(sp)
 308:	02412a83          	lw	s5,36(sp)
 30c:	04010113          	addi	sp,sp,64
 310:	00008067          	ret

00000314 <st7735_draw_circle>:
 314:	fd010113          	addi	sp,sp,-48
 318:	03212023          	sw	s2,32(sp)
 31c:	00100913          	li	s2,1
 320:	02812423          	sw	s0,40(sp)
 324:	02912223          	sw	s1,36(sp)
 328:	01312e23          	sw	s3,28(sp)
 32c:	01412c23          	sw	s4,24(sp)
 330:	01512a23          	sw	s5,20(sp)
 334:	02112623          	sw	ra,44(sp)
 338:	00050a93          	mv	s5,a0
 33c:	00058993          	mv	s3,a1
 340:	00060a13          	mv	s4,a2
 344:	00068413          	mv	s0,a3
 348:	40d90933          	sub	s2,s2,a3
 34c:	00000493          	li	s1,0
 350:	02945463          	bge	s0,s1,378 <st7735_draw_circle+0x64>
 354:	02c12083          	lw	ra,44(sp)
 358:	02812403          	lw	s0,40(sp)
 35c:	02412483          	lw	s1,36(sp)
 360:	02012903          	lw	s2,32(sp)
 364:	01c12983          	lw	s3,28(sp)
 368:	01812a03          	lw	s4,24(sp)
 36c:	01412a83          	lw	s5,20(sp)
 370:	03010113          	addi	sp,sp,48
 374:	00008067          	ret
 378:	009a0733          	add	a4,s4,s1
 37c:	408985b3          	sub	a1,s3,s0
 380:	013406b3          	add	a3,s0,s3
 384:	00070613          	mv	a2,a4
 388:	000a8513          	mv	a0,s5
 38c:	00d12623          	sw	a3,12(sp)
 390:	00b12423          	sw	a1,8(sp)
 394:	ea9ff0ef          	jal	23c <st7735_draw_line>
 398:	00c12683          	lw	a3,12(sp)
 39c:	00812583          	lw	a1,8(sp)
 3a0:	409a0733          	sub	a4,s4,s1
 3a4:	00070613          	mv	a2,a4
 3a8:	000a8513          	mv	a0,s5
 3ac:	e91ff0ef          	jal	23c <st7735_draw_line>
 3b0:	01440733          	add	a4,s0,s4
 3b4:	409985b3          	sub	a1,s3,s1
 3b8:	013486b3          	add	a3,s1,s3
 3bc:	00070613          	mv	a2,a4
 3c0:	000a8513          	mv	a0,s5
 3c4:	00d12623          	sw	a3,12(sp)
 3c8:	00b12423          	sw	a1,8(sp)
 3cc:	e71ff0ef          	jal	23c <st7735_draw_line>
 3d0:	00c12683          	lw	a3,12(sp)
 3d4:	00812583          	lw	a1,8(sp)
 3d8:	408a0733          	sub	a4,s4,s0
 3dc:	00070613          	mv	a2,a4
 3e0:	000a8513          	mv	a0,s5
 3e4:	e59ff0ef          	jal	23c <st7735_draw_line>
 3e8:	00148493          	addi	s1,s1,1
 3ec:	00149793          	slli	a5,s1,0x1
 3f0:	00094863          	bltz	s2,400 <st7735_draw_circle+0xec>
 3f4:	fff40413          	addi	s0,s0,-1
 3f8:	408487b3          	sub	a5,s1,s0
 3fc:	00179793          	slli	a5,a5,0x1
 400:	00178793          	addi	a5,a5,1
 404:	00f90933          	add	s2,s2,a5
 408:	f49ff06f          	j	350 <st7735_draw_circle+0x3c>
