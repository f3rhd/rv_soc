
__out_tmp.elf:     file format elf32-littleriscv


Disassembly of section .text:

00000000 <__static_end>:
   0:	00001197          	auipc	gp,0x1
   4:	80018193          	addi	gp,gp,-2048 # 800 <__global_pointer$>
   8:	00020117          	auipc	sp,0x20
   c:	ff810113          	addi	sp,sp,-8 # 20000 <__stack_top>
  10:	1ec000ef          	jal	1fc <main>

00000014 <halt_loop>:
  14:	0000006f          	j	14 <halt_loop>

00000018 <change_color_on_collision>:
  18:	ff010113          	addi	sp,sp,-16
  1c:	00a12623          	sw	a0,12(sp)
  20:	00b12423          	sw	a1,8(sp)
  24:	00812703          	lw	a4,8(sp)
  28:	00800793          	li	a5,8
  2c:	14f70c63          	beq	a4,a5,184 <change_color_on_collision+0x16c>
  30:	00812703          	lw	a4,8(sp)
  34:	00800793          	li	a5,8
  38:	16e7c063          	blt	a5,a4,198 <change_color_on_collision+0x180>
  3c:	00812703          	lw	a4,8(sp)
  40:	00700793          	li	a5,7
  44:	12f70663          	beq	a4,a5,170 <change_color_on_collision+0x158>
  48:	00812703          	lw	a4,8(sp)
  4c:	00700793          	li	a5,7
  50:	14e7c463          	blt	a5,a4,198 <change_color_on_collision+0x180>
  54:	00812703          	lw	a4,8(sp)
  58:	00600793          	li	a5,6
  5c:	10f70063          	beq	a4,a5,15c <change_color_on_collision+0x144>
  60:	00812703          	lw	a4,8(sp)
  64:	00600793          	li	a5,6
  68:	12e7c863          	blt	a5,a4,198 <change_color_on_collision+0x180>
  6c:	00812703          	lw	a4,8(sp)
  70:	00500793          	li	a5,5
  74:	0cf70a63          	beq	a4,a5,148 <change_color_on_collision+0x130>
  78:	00812703          	lw	a4,8(sp)
  7c:	00500793          	li	a5,5
  80:	10e7cc63          	blt	a5,a4,198 <change_color_on_collision+0x180>
  84:	00812703          	lw	a4,8(sp)
  88:	00400793          	li	a5,4
  8c:	0af70463          	beq	a4,a5,134 <change_color_on_collision+0x11c>
  90:	00812703          	lw	a4,8(sp)
  94:	00400793          	li	a5,4
  98:	10e7c063          	blt	a5,a4,198 <change_color_on_collision+0x180>
  9c:	00812703          	lw	a4,8(sp)
  a0:	00300793          	li	a5,3
  a4:	06f70e63          	beq	a4,a5,120 <change_color_on_collision+0x108>
  a8:	00812703          	lw	a4,8(sp)
  ac:	00300793          	li	a5,3
  b0:	0ee7c463          	blt	a5,a4,198 <change_color_on_collision+0x180>
  b4:	00812703          	lw	a4,8(sp)
  b8:	00200793          	li	a5,2
  bc:	04f70863          	beq	a4,a5,10c <change_color_on_collision+0xf4>
  c0:	00812703          	lw	a4,8(sp)
  c4:	00200793          	li	a5,2
  c8:	0ce7c863          	blt	a5,a4,198 <change_color_on_collision+0x180>
  cc:	00812783          	lw	a5,8(sp)
  d0:	00078a63          	beqz	a5,e4 <change_color_on_collision+0xcc>
  d4:	00812703          	lw	a4,8(sp)
  d8:	00100793          	li	a5,1
  dc:	00f70e63          	beq	a4,a5,f8 <change_color_on_collision+0xe0>
  e0:	0b80006f          	j	198 <change_color_on_collision+0x180>
  e4:	00c12783          	lw	a5,12(sp)
  e8:	001f0737          	lui	a4,0x1f0
  ec:	01f70713          	addi	a4,a4,31 # 1f001f <__stack_top+0x1d001f>
  f0:	00e7a023          	sw	a4,0(a5)
  f4:	0b00006f          	j	1a4 <change_color_on_collision+0x18c>
  f8:	00c12783          	lw	a5,12(sp)
  fc:	001f0737          	lui	a4,0x1f0
 100:	01f70713          	addi	a4,a4,31 # 1f001f <__stack_top+0x1d001f>
 104:	00e7a023          	sw	a4,0(a5)
 108:	09c0006f          	j	1a4 <change_color_on_collision+0x18c>
 10c:	00c12783          	lw	a5,12(sp)
 110:	07e00737          	lui	a4,0x7e00
 114:	7e070713          	addi	a4,a4,2016 # 7e007e0 <__stack_top+0x7de07e0>
 118:	00e7a023          	sw	a4,0(a5)
 11c:	0880006f          	j	1a4 <change_color_on_collision+0x18c>
 120:	00c12783          	lw	a5,12(sp)
 124:	f8010737          	lui	a4,0xf8010
 128:	80070713          	addi	a4,a4,-2048 # f800f800 <__stack_top+0xf7fef800>
 12c:	00e7a023          	sw	a4,0(a5)
 130:	0740006f          	j	1a4 <change_color_on_collision+0x18c>
 134:	00c12783          	lw	a5,12(sp)
 138:	ffe10737          	lui	a4,0xffe10
 13c:	fe070713          	addi	a4,a4,-32 # ffe0ffe0 <__stack_top+0xffdeffe0>
 140:	00e7a023          	sw	a4,0(a5)
 144:	0600006f          	j	1a4 <change_color_on_collision+0x18c>
 148:	00c12783          	lw	a5,12(sp)
 14c:	f8200737          	lui	a4,0xf8200
 150:	81f70713          	addi	a4,a4,-2017 # f81ff81f <__stack_top+0xf81df81f>
 154:	00e7a023          	sw	a4,0(a5)
 158:	04c0006f          	j	1a4 <change_color_on_collision+0x18c>
 15c:	00c12783          	lw	a5,12(sp)
 160:	07ff0737          	lui	a4,0x7ff0
 164:	7ff70713          	addi	a4,a4,2047 # 7ff07ff <__stack_top+0x7fd07ff>
 168:	00e7a023          	sw	a4,0(a5)
 16c:	0380006f          	j	1a4 <change_color_on_collision+0x18c>
 170:	00c12783          	lw	a5,12(sp)
 174:	053f0737          	lui	a4,0x53f0
 178:	53f70713          	addi	a4,a4,1343 # 53f053f <__stack_top+0x53d053f>
 17c:	00e7a023          	sw	a4,0(a5)
 180:	0240006f          	j	1a4 <change_color_on_collision+0x18c>
 184:	00c12783          	lw	a5,12(sp)
 188:	cdbfd737          	lui	a4,0xcdbfd
 18c:	dbf70713          	addi	a4,a4,-577 # cdbfcdbf <__stack_top+0xcdbdcdbf>
 190:	00e7a023          	sw	a4,0(a5)
 194:	0100006f          	j	1a4 <change_color_on_collision+0x18c>
 198:	00c12783          	lw	a5,12(sp)
 19c:	0007a023          	sw	zero,0(a5)
 1a0:	00000013          	nop
 1a4:	00000013          	nop
 1a8:	01010113          	addi	sp,sp,16
 1ac:	00008067          	ret

000001b0 <delay>:
 1b0:	ff010113          	addi	sp,sp,-16
 1b4:	00012623          	sw	zero,12(sp)
 1b8:	00c12783          	lw	a5,12(sp)
 1bc:	00a7e663          	bltu	a5,a0,1c8 <delay+0x18>
 1c0:	01010113          	addi	sp,sp,16
 1c4:	00008067          	ret
 1c8:	00c12783          	lw	a5,12(sp)
 1cc:	00178793          	addi	a5,a5,1
 1d0:	00f12623          	sw	a5,12(sp)
 1d4:	fe5ff06f          	j	1b8 <delay+0x8>

000001d8 <draw_dvd>:
 1d8:	ff010113          	addi	sp,sp,-16
 1dc:	00060793          	mv	a5,a2
 1e0:	01400713          	li	a4,20
 1e4:	00058613          	mv	a2,a1
 1e8:	00050593          	mv	a1,a0
 1ec:	00070693          	mv	a3,a4
 1f0:	00078513          	mv	a0,a5
 1f4:	01010113          	addi	sp,sp,16
 1f8:	1880006f          	j	380 <st7735_draw_rectangle>

000001fc <main>:
 1fc:	fc010113          	addi	sp,sp,-64
 200:	0a000713          	li	a4,160
 204:	08000693          	li	a3,128
 208:	00000613          	li	a2,0
 20c:	00000593          	li	a1,0
 210:	00000513          	li	a0,0
 214:	02812c23          	sw	s0,56(sp)
 218:	02912a23          	sw	s1,52(sp)
 21c:	03212823          	sw	s2,48(sp)
 220:	03312623          	sw	s3,44(sp)
 224:	03412423          	sw	s4,40(sp)
 228:	03512223          	sw	s5,36(sp)
 22c:	03612023          	sw	s6,32(sp)
 230:	01712e23          	sw	s7,28(sp)
 234:	01812c23          	sw	s8,24(sp)
 238:	02112e23          	sw	ra,60(sp)
 23c:	144000ef          	jal	380 <st7735_draw_rectangle>
 240:	001007b7          	lui	a5,0x100
 244:	01078793          	addi	a5,a5,16 # 100010 <__stack_top+0xe0010>
 248:	00200993          	li	s3,2
 24c:	00f12223          	sw	a5,4(sp)
 250:	00098a13          	mv	s4,s3
 254:	05000413          	li	s0,80
 258:	04000493          	li	s1,64
 25c:	00000913          	li	s2,0
 260:	06a00a93          	li	s5,106
 264:	06b00b93          	li	s7,107
 268:	08a00b13          	li	s6,138
 26c:	00800c13          	li	s8,8
 270:	01400713          	li	a4,20
 274:	00070693          	mv	a3,a4
 278:	00040613          	mv	a2,s0
 27c:	00048593          	mv	a1,s1
 280:	00000513          	li	a0,0
 284:	0fc000ef          	jal	380 <st7735_draw_rectangle>
 288:	014484b3          	add	s1,s1,s4
 28c:	fff48713          	addi	a4,s1,-1
 290:	01340433          	add	s0,s0,s3
 294:	00000793          	li	a5,0
 298:	00eafa63          	bgeu	s5,a4,2ac <main+0xb0>
 29c:	41400a33          	neg	s4,s4
 2a0:	049bc063          	blt	s7,s1,2e0 <main+0xe4>
 2a4:	00000493          	li	s1,0
 2a8:	00100793          	li	a5,1
 2ac:	fff40713          	addi	a4,s0,-1
 2b0:	02eb7c63          	bgeu	s6,a4,2e8 <main+0xec>
 2b4:	08b00793          	li	a5,139
 2b8:	413009b3          	neg	s3,s3
 2bc:	0487de63          	bge	a5,s0,318 <main+0x11c>
 2c0:	08c00413          	li	s0,140
 2c4:	00190913          	addi	s2,s2,1
 2c8:	012c5463          	bge	s8,s2,2d0 <main+0xd4>
 2cc:	00000913          	li	s2,0
 2d0:	00090593          	mv	a1,s2
 2d4:	00410513          	addi	a0,sp,4
 2d8:	d41ff0ef          	jal	18 <change_color_on_collision>
 2dc:	0100006f          	j	2ec <main+0xf0>
 2e0:	06c00493          	li	s1,108
 2e4:	fc5ff06f          	j	2a8 <main+0xac>
 2e8:	fc079ee3          	bnez	a5,2c4 <main+0xc8>
 2ec:	00849513          	slli	a0,s1,0x8
 2f0:	00856533          	or	a0,a0,s0
 2f4:	02c000ef          	jal	320 <seg_write_hex>
 2f8:	00412603          	lw	a2,4(sp)
 2fc:	00048513          	mv	a0,s1
 300:	00040593          	mv	a1,s0
 304:	ed5ff0ef          	jal	1d8 <draw_dvd>
 308:	0003d537          	lui	a0,0x3d
 30c:	09050513          	addi	a0,a0,144 # 3d090 <__stack_top+0x1d090>
 310:	ea1ff0ef          	jal	1b0 <delay>
 314:	f5dff06f          	j	270 <main+0x74>
 318:	00000413          	li	s0,0
 31c:	fa9ff06f          	j	2c4 <main+0xc8>

00000320 <seg_write_hex>:
 320:	f00007b7          	lui	a5,0xf0000
 324:	00478793          	addi	a5,a5,4 # f0000004 <__stack_top+0xeffe0004>
 328:	00a79023          	sh	a0,0(a5)
 32c:	00008067          	ret

00000330 <st7735_set_rectangle>:
 330:	00ff07b7          	lui	a5,0xff0
 334:	01059593          	slli	a1,a1,0x10
 338:	0ff6f693          	zext.b	a3,a3
 33c:	00f5f5b3          	and	a1,a1,a5
 340:	00869693          	slli	a3,a3,0x8
 344:	01051513          	slli	a0,a0,0x10
 348:	0ff67613          	zext.b	a2,a2
 34c:	00f57533          	and	a0,a0,a5
 350:	00861613          	slli	a2,a2,0x8
 354:	00d5e5b3          	or	a1,a1,a3
 358:	2b0007b7          	lui	a5,0x2b000
 35c:	00c56533          	or	a0,a0,a2
 360:	2a000737          	lui	a4,0x2a000
 364:	00f5e5b3          	or	a1,a1,a5
 368:	f00007b7          	lui	a5,0xf0000
 36c:	00e56533          	or	a0,a0,a4
 370:	00278793          	addi	a5,a5,2 # f0000002 <__stack_top+0xeffe0002>
 374:	00a7a023          	sw	a0,0(a5)
 378:	00b7a023          	sw	a1,0(a5)
 37c:	00008067          	ret

00000380 <st7735_draw_rectangle>:
 380:	fe010113          	addi	sp,sp,-32
 384:	00812c23          	sw	s0,24(sp)
 388:	00912a23          	sw	s1,20(sp)
 38c:	00068413          	mv	s0,a3
 390:	00050493          	mv	s1,a0
 394:	00058513          	mv	a0,a1
 398:	00e606b3          	add	a3,a2,a4
 39c:	00060593          	mv	a1,a2
 3a0:	00850633          	add	a2,a0,s0
 3a4:	fff68693          	addi	a3,a3,-1
 3a8:	fff60613          	addi	a2,a2,-1
 3ac:	00112e23          	sw	ra,28(sp)
 3b0:	00e12623          	sw	a4,12(sp)
 3b4:	f7dff0ef          	jal	330 <st7735_set_rectangle>
 3b8:	00c12703          	lw	a4,12(sp)
 3bc:	2c0007b7          	lui	a5,0x2c000
 3c0:	02e40433          	mul	s0,s0,a4
 3c4:	40145413          	srai	s0,s0,0x1
 3c8:	00f46433          	or	s0,s0,a5
 3cc:	f00007b7          	lui	a5,0xf0000
 3d0:	00278793          	addi	a5,a5,2 # f0000002 <__stack_top+0xeffe0002>
 3d4:	0087a023          	sw	s0,0(a5)
 3d8:	f00007b7          	lui	a5,0xf0000
 3dc:	00178793          	addi	a5,a5,1 # f0000001 <__stack_top+0xeffe0001>
 3e0:	0097a023          	sw	s1,0(a5)
 3e4:	01c12083          	lw	ra,28(sp)
 3e8:	01812403          	lw	s0,24(sp)
 3ec:	01412483          	lw	s1,20(sp)
 3f0:	02010113          	addi	sp,sp,32
 3f4:	00008067          	ret
