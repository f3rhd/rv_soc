
__out_tmp.elf:     file format elf32-littleriscv


Disassembly of section .text:

00000000 <_start>:
   0:	00008137          	lui	sp,0x8
   4:	1ec000ef          	jal	1f0 <main>

00000008 <halt_loop>:
   8:	0000006f          	j	8 <halt_loop>

0000000c <change_color_on_collision>:
   c:	ff010113          	addi	sp,sp,-16 # 7ff0 <st7735_draw_rectangle+0x7c5c>
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
  e0:	01f70713          	addi	a4,a4,31 # 1f001f <st7735_draw_rectangle+0x1efc8b>
  e4:	00e7a023          	sw	a4,0(a5)
  e8:	0b00006f          	j	198 <change_color_on_collision+0x18c>
  ec:	00c12783          	lw	a5,12(sp)
  f0:	001f0737          	lui	a4,0x1f0
  f4:	01f70713          	addi	a4,a4,31 # 1f001f <st7735_draw_rectangle+0x1efc8b>
  f8:	00e7a023          	sw	a4,0(a5)
  fc:	09c0006f          	j	198 <change_color_on_collision+0x18c>
 100:	00c12783          	lw	a5,12(sp)
 104:	07e00737          	lui	a4,0x7e00
 108:	7e070713          	addi	a4,a4,2016 # 7e007e0 <st7735_draw_rectangle+0x7e0044c>
 10c:	00e7a023          	sw	a4,0(a5)
 110:	0880006f          	j	198 <change_color_on_collision+0x18c>
 114:	00c12783          	lw	a5,12(sp)
 118:	f8010737          	lui	a4,0xf8010
 11c:	80070713          	addi	a4,a4,-2048 # f800f800 <st7735_draw_rectangle+0xf800f46c>
 120:	00e7a023          	sw	a4,0(a5)
 124:	0740006f          	j	198 <change_color_on_collision+0x18c>
 128:	00c12783          	lw	a5,12(sp)
 12c:	ffe10737          	lui	a4,0xffe10
 130:	fe070713          	addi	a4,a4,-32 # ffe0ffe0 <st7735_draw_rectangle+0xffe0fc4c>
 134:	00e7a023          	sw	a4,0(a5)
 138:	0600006f          	j	198 <change_color_on_collision+0x18c>
 13c:	00c12783          	lw	a5,12(sp)
 140:	f8200737          	lui	a4,0xf8200
 144:	81f70713          	addi	a4,a4,-2017 # f81ff81f <st7735_draw_rectangle+0xf81ff48b>
 148:	00e7a023          	sw	a4,0(a5)
 14c:	04c0006f          	j	198 <change_color_on_collision+0x18c>
 150:	00c12783          	lw	a5,12(sp)
 154:	07ff0737          	lui	a4,0x7ff0
 158:	7ff70713          	addi	a4,a4,2047 # 7ff07ff <st7735_draw_rectangle+0x7ff046b>
 15c:	00e7a023          	sw	a4,0(a5)
 160:	0380006f          	j	198 <change_color_on_collision+0x18c>
 164:	00c12783          	lw	a5,12(sp)
 168:	053f0737          	lui	a4,0x53f0
 16c:	53f70713          	addi	a4,a4,1343 # 53f053f <st7735_draw_rectangle+0x53f01ab>
 170:	00e7a023          	sw	a4,0(a5)
 174:	0240006f          	j	198 <change_color_on_collision+0x18c>
 178:	00c12783          	lw	a5,12(sp)
 17c:	cdbfd737          	lui	a4,0xcdbfd
 180:	dbf70713          	addi	a4,a4,-577 # cdbfcdbf <st7735_draw_rectangle+0xcdbfca2b>
 184:	00e7a023          	sw	a4,0(a5)
 188:	0100006f          	j	198 <change_color_on_collision+0x18c>
 18c:	00c12783          	lw	a5,12(sp)
 190:	0007a023          	sw	zero,0(a5)
 194:	00000013          	nop
 198:	00000013          	nop
 19c:	01010113          	addi	sp,sp,16
 1a0:	00008067          	ret

000001a4 <delay>:
 1a4:	ff010113          	addi	sp,sp,-16
 1a8:	00012623          	sw	zero,12(sp)
 1ac:	00c12783          	lw	a5,12(sp)
 1b0:	00a7e663          	bltu	a5,a0,1bc <delay+0x18>
 1b4:	01010113          	addi	sp,sp,16
 1b8:	00008067          	ret
 1bc:	00c12783          	lw	a5,12(sp)
 1c0:	00178793          	addi	a5,a5,1
 1c4:	00f12623          	sw	a5,12(sp)
 1c8:	fe5ff06f          	j	1ac <delay+0x8>

000001cc <draw_dvd>:
 1cc:	ff010113          	addi	sp,sp,-16
 1d0:	00060793          	mv	a5,a2
 1d4:	01400713          	li	a4,20
 1d8:	00058613          	mv	a2,a1
 1dc:	00050593          	mv	a1,a0
 1e0:	00070693          	mv	a3,a4
 1e4:	00078513          	mv	a0,a5
 1e8:	01010113          	addi	sp,sp,16
 1ec:	1a80006f          	j	394 <st7735_draw_rectangle>

000001f0 <main>:
 1f0:	fc010113          	addi	sp,sp,-64
 1f4:	0a000713          	li	a4,160
 1f8:	08000693          	li	a3,128
 1fc:	00000613          	li	a2,0
 200:	00000593          	li	a1,0
 204:	00000513          	li	a0,0
 208:	02812c23          	sw	s0,56(sp)
 20c:	02912a23          	sw	s1,52(sp)
 210:	03212823          	sw	s2,48(sp)
 214:	03312623          	sw	s3,44(sp)
 218:	03412423          	sw	s4,40(sp)
 21c:	03512223          	sw	s5,36(sp)
 220:	03612023          	sw	s6,32(sp)
 224:	01712e23          	sw	s7,28(sp)
 228:	01812c23          	sw	s8,24(sp)
 22c:	02112e23          	sw	ra,60(sp)
 230:	164000ef          	jal	394 <st7735_draw_rectangle>
 234:	001007b7          	lui	a5,0x100
 238:	01078793          	addi	a5,a5,16 # 100010 <st7735_draw_rectangle+0xffc7c>
 23c:	00200993          	li	s3,2
 240:	00f12223          	sw	a5,4(sp)
 244:	00098a13          	mv	s4,s3
 248:	05000493          	li	s1,80
 24c:	04000413          	li	s0,64
 250:	00000913          	li	s2,0
 254:	06a00a93          	li	s5,106
 258:	06b00b93          	li	s7,107
 25c:	08a00b13          	li	s6,138
 260:	00800c13          	li	s8,8
 264:	01400713          	li	a4,20
 268:	00070693          	mv	a3,a4
 26c:	00048613          	mv	a2,s1
 270:	00040593          	mv	a1,s0
 274:	00000513          	li	a0,0
 278:	11c000ef          	jal	394 <st7735_draw_rectangle>
 27c:	01440433          	add	s0,s0,s4
 280:	fff40713          	addi	a4,s0,-1
 284:	013484b3          	add	s1,s1,s3
 288:	00000793          	li	a5,0
 28c:	00eafa63          	bgeu	s5,a4,2a0 <main+0xb0>
 290:	41400a33          	neg	s4,s4
 294:	048bc063          	blt	s7,s0,2d4 <main+0xe4>
 298:	00000413          	li	s0,0
 29c:	00100793          	li	a5,1
 2a0:	fff48713          	addi	a4,s1,-1
 2a4:	02eb7c63          	bgeu	s6,a4,2dc <main+0xec>
 2a8:	08b00793          	li	a5,139
 2ac:	413009b3          	neg	s3,s3
 2b0:	0497dc63          	bge	a5,s1,308 <main+0x118>
 2b4:	08c00493          	li	s1,140
 2b8:	00190913          	addi	s2,s2,1
 2bc:	012c5463          	bge	s8,s2,2c4 <main+0xd4>
 2c0:	00000913          	li	s2,0
 2c4:	00090593          	mv	a1,s2
 2c8:	00410513          	addi	a0,sp,4
 2cc:	d41ff0ef          	jal	c <change_color_on_collision>
 2d0:	0100006f          	j	2e0 <main+0xf0>
 2d4:	06c00413          	li	s0,108
 2d8:	fc5ff06f          	j	29c <main+0xac>
 2dc:	fc079ee3          	bnez	a5,2b8 <main+0xc8>
 2e0:	00412603          	lw	a2,4(sp)
 2e4:	00040513          	mv	a0,s0
 2e8:	00048593          	mv	a1,s1
 2ec:	ee1ff0ef          	jal	1cc <draw_dvd>
 2f0:	00412783          	lw	a5,4(sp)
 2f4:	00078e63          	beqz	a5,310 <main+0x120>
 2f8:	0003d537          	lui	a0,0x3d
 2fc:	09050513          	addi	a0,a0,144 # 3d090 <st7735_draw_rectangle+0x3ccfc>
 300:	ea5ff0ef          	jal	1a4 <delay>
 304:	f61ff06f          	j	264 <main+0x74>
 308:	00000493          	li	s1,0
 30c:	fadff06f          	j	2b8 <main+0xc8>
 310:	03c12083          	lw	ra,60(sp)
 314:	03812403          	lw	s0,56(sp)
 318:	03412483          	lw	s1,52(sp)
 31c:	03012903          	lw	s2,48(sp)
 320:	02c12983          	lw	s3,44(sp)
 324:	02812a03          	lw	s4,40(sp)
 328:	02412a83          	lw	s5,36(sp)
 32c:	02012b03          	lw	s6,32(sp)
 330:	01c12b83          	lw	s7,28(sp)
 334:	01812c03          	lw	s8,24(sp)
 338:	00000513          	li	a0,0
 33c:	04010113          	addi	sp,sp,64
 340:	00008067          	ret

00000344 <st7735_set_rectangle>:
 344:	00ff07b7          	lui	a5,0xff0
 348:	01059593          	slli	a1,a1,0x10
 34c:	0ff6f693          	zext.b	a3,a3
 350:	00f5f5b3          	and	a1,a1,a5
 354:	00869693          	slli	a3,a3,0x8
 358:	01051513          	slli	a0,a0,0x10
 35c:	0ff67613          	zext.b	a2,a2
 360:	00f57533          	and	a0,a0,a5
 364:	00861613          	slli	a2,a2,0x8
 368:	00d5e5b3          	or	a1,a1,a3
 36c:	2b0007b7          	lui	a5,0x2b000
 370:	00c56533          	or	a0,a0,a2
 374:	2a000737          	lui	a4,0x2a000
 378:	00f5e5b3          	or	a1,a1,a5
 37c:	f00007b7          	lui	a5,0xf0000
 380:	00e56533          	or	a0,a0,a4
 384:	00478793          	addi	a5,a5,4 # f0000004 <st7735_draw_rectangle+0xeffffc70>
 388:	00a7a023          	sw	a0,0(a5)
 38c:	00b7a023          	sw	a1,0(a5)
 390:	00008067          	ret

00000394 <st7735_draw_rectangle>:
 394:	fe010113          	addi	sp,sp,-32
 398:	00812c23          	sw	s0,24(sp)
 39c:	00912a23          	sw	s1,20(sp)
 3a0:	00068413          	mv	s0,a3
 3a4:	00050493          	mv	s1,a0
 3a8:	00058513          	mv	a0,a1
 3ac:	00e606b3          	add	a3,a2,a4
 3b0:	00060593          	mv	a1,a2
 3b4:	00850633          	add	a2,a0,s0
 3b8:	fff68693          	addi	a3,a3,-1
 3bc:	fff60613          	addi	a2,a2,-1
 3c0:	00e12623          	sw	a4,12(sp)
 3c4:	00112e23          	sw	ra,28(sp)
 3c8:	f7dff0ef          	jal	344 <st7735_set_rectangle>
 3cc:	00c12703          	lw	a4,12(sp)
 3d0:	f00007b7          	lui	a5,0xf0000
 3d4:	00478793          	addi	a5,a5,4 # f0000004 <st7735_draw_rectangle+0xeffffc70>
 3d8:	02e40433          	mul	s0,s0,a4
 3dc:	2c000737          	lui	a4,0x2c000
 3e0:	40145413          	srai	s0,s0,0x1
 3e4:	00e7a023          	sw	a4,0(a5)
 3e8:	00000793          	li	a5,0
 3ec:	f0000737          	lui	a4,0xf0000
 3f0:	0087cc63          	blt	a5,s0,408 <st7735_draw_rectangle+0x74>
 3f4:	01c12083          	lw	ra,28(sp)
 3f8:	01812403          	lw	s0,24(sp)
 3fc:	01412483          	lw	s1,20(sp)
 400:	02010113          	addi	sp,sp,32
 404:	00008067          	ret
 408:	00972023          	sw	s1,0(a4) # f0000000 <st7735_draw_rectangle+0xeffffc6c>
 40c:	00178793          	addi	a5,a5,1
 410:	fe1ff06f          	j	3f0 <st7735_draw_rectangle+0x5c>
