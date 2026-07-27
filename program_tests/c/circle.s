
__out_tmp.elf:     file format elf32-littleriscv


Disassembly of section .text:

00000000 <_start>:
   0:	00008137          	lui	sp,0x8
   4:	008000ef          	jal	c <main>

00000008 <halt_loop>:
   8:	0000006f          	j	8 <halt_loop>

0000000c <main>:
   c:	fc010113          	addi	sp,sp,-64 # 7fc0 <seg_write_hex+0x7b90>
  10:	02912a23          	sw	s1,52(sp)
  14:	0a000713          	li	a4,160
  18:	08000693          	li	a3,128
  1c:	00000613          	li	a2,0
  20:	00000593          	li	a1,0
  24:	00000513          	li	a0,0
  28:	00200493          	li	s1,2
  2c:	02812c23          	sw	s0,56(sp)
  30:	03212823          	sw	s2,48(sp)
  34:	03312623          	sw	s3,44(sp)
  38:	03412423          	sw	s4,40(sp)
  3c:	03512223          	sw	s5,36(sp)
  40:	03612023          	sw	s6,32(sp)
  44:	01712e23          	sw	s7,28(sp)
  48:	02112e23          	sw	ra,60(sp)
  4c:	01812c23          	sw	s8,24(sp)
  50:	00048913          	mv	s2,s1
  54:	0d0000ef          	jal	124 <st7735_draw_rectangle>
  58:	05000413          	li	s0,80
  5c:	04000b93          	li	s7,64
  60:	07400a13          	li	s4,116
  64:	07a00b13          	li	s6,122
  68:	09400993          	li	s3,148
  6c:	09a00a93          	li	s5,154
  70:	00b00713          	li	a4,11
  74:	ffb40613          	addi	a2,s0,-5
  78:	ffbb8593          	addi	a1,s7,-5
  7c:	00070693          	mv	a3,a4
  80:	00000513          	li	a0,0
  84:	012b8bb3          	add	s7,s7,s2
  88:	09c000ef          	jal	124 <st7735_draw_rectangle>
  8c:	ffab8793          	addi	a5,s7,-6
  90:	00940433          	add	s0,s0,s1
  94:	008b9c13          	slli	s8,s7,0x8
  98:	00fa7a63          	bgeu	s4,a5,ac <main+0xa0>
  9c:	41200933          	neg	s2,s2
  a0:	077b4a63          	blt	s6,s7,114 <main+0x108>
  a4:	50000c13          	li	s8,1280
  a8:	00500b93          	li	s7,5
  ac:	ffa40793          	addi	a5,s0,-6
  b0:	00f9fc63          	bgeu	s3,a5,c8 <main+0xbc>
  b4:	008aa433          	slt	s0,s5,s0
  b8:	40800433          	neg	s0,s0
  bc:	09647413          	andi	s0,s0,150
  c0:	00540413          	addi	s0,s0,5
  c4:	409004b3          	neg	s1,s1
  c8:	001f0537          	lui	a0,0x1f0
  cc:	01f50513          	addi	a0,a0,31 # 1f001f <seg_write_hex+0x1efbef>
  d0:	00500693          	li	a3,5
  d4:	00040613          	mv	a2,s0
  d8:	000b8593          	mv	a1,s7
  dc:	214000ef          	jal	2f0 <st7735_draw_circle>
  e0:	01846533          	or	a0,s0,s8
  e4:	34c000ef          	jal	430 <seg_write_hex>
  e8:	00012623          	sw	zero,12(sp)
  ec:	00c12783          	lw	a5,12(sp)
  f0:	0000c737          	lui	a4,0xc
  f4:	34f70713          	addi	a4,a4,847 # c34f <seg_write_hex+0xbf1f>
  f8:	f6f76ce3          	bltu	a4,a5,70 <main+0x64>
  fc:	00c12783          	lw	a5,12(sp)
 100:	00178793          	addi	a5,a5,1
 104:	00f12623          	sw	a5,12(sp)
 108:	00c12783          	lw	a5,12(sp)
 10c:	fef778e3          	bgeu	a4,a5,fc <main+0xf0>
 110:	f61ff06f          	j	70 <main+0x64>
 114:	00008c37          	lui	s8,0x8
 118:	b00c0c13          	addi	s8,s8,-1280 # 7b00 <seg_write_hex+0x76d0>
 11c:	07b00b93          	li	s7,123
 120:	f8dff06f          	j	ac <main+0xa0>

00000124 <st7735_draw_rectangle>:
 124:	00e60833          	add	a6,a2,a4
 128:	00d587b3          	add	a5,a1,a3
 12c:	fff80813          	addi	a6,a6,-1
 130:	00ff08b7          	lui	a7,0xff0
 134:	fff78793          	addi	a5,a5,-1
 138:	01061613          	slli	a2,a2,0x10
 13c:	0ff87813          	zext.b	a6,a6
 140:	01167633          	and	a2,a2,a7
 144:	0ff7f793          	zext.b	a5,a5
 148:	01059593          	slli	a1,a1,0x10
 14c:	00881813          	slli	a6,a6,0x8
 150:	0115f5b3          	and	a1,a1,a7
 154:	00c86833          	or	a6,a6,a2
 158:	00879793          	slli	a5,a5,0x8
 15c:	2b000637          	lui	a2,0x2b000
 160:	00b7e7b3          	or	a5,a5,a1
 164:	00c86833          	or	a6,a6,a2
 168:	2a0005b7          	lui	a1,0x2a000
 16c:	f0000637          	lui	a2,0xf0000
 170:	00b7e7b3          	or	a5,a5,a1
 174:	00460613          	addi	a2,a2,4 # f0000004 <seg_write_hex+0xeffffbd4>
 178:	f00005b7          	lui	a1,0xf0000
 17c:	00f62023          	sw	a5,0(a2)
 180:	01062023          	sw	a6,0(a2)
 184:	02e686b3          	mul	a3,a3,a4
 188:	2c0007b7          	lui	a5,0x2c000
 18c:	4016d693          	srai	a3,a3,0x1
 190:	00f6e6b3          	or	a3,a3,a5
 194:	00d62023          	sw	a3,0(a2)
 198:	00a5a023          	sw	a0,0(a1) # f0000000 <seg_write_hex+0xeffffbd0>
 19c:	00008067          	ret

000001a0 <st7735_draw_line>:
 1a0:	40b68eb3          	sub	t4,a3,a1
 1a4:	fd010113          	addi	sp,sp,-48
 1a8:	41fed793          	srai	a5,t4,0x1f
 1ac:	01512c23          	sw	s5,24(sp)
 1b0:	01612a23          	sw	s6,20(sp)
 1b4:	01712823          	sw	s7,16(sp)
 1b8:	00068a93          	mv	s5,a3
 1bc:	01d7ceb3          	xor	t4,a5,t4
 1c0:	02812623          	sw	s0,44(sp)
 1c4:	02912423          	sw	s1,40(sp)
 1c8:	03212223          	sw	s2,36(sp)
 1cc:	03312023          	sw	s3,32(sp)
 1d0:	01412e23          	sw	s4,28(sp)
 1d4:	01812623          	sw	s8,12(sp)
 1d8:	01912423          	sw	s9,8(sp)
 1dc:	00050693          	mv	a3,a0
 1e0:	00070b13          	mv	s6,a4
 1e4:	40fe8eb3          	sub	t4,t4,a5
 1e8:	00100b93          	li	s7,1
 1ec:	0155c463          	blt	a1,s5,1f4 <st7735_draw_line+0x54>
 1f0:	fff00b93          	li	s7,-1
 1f4:	40cb0433          	sub	s0,s6,a2
 1f8:	41f45793          	srai	a5,s0,0x1f
 1fc:	0087c433          	xor	s0,a5,s0
 200:	40f40433          	sub	s0,s0,a5
 204:	40800a33          	neg	s4,s0
 208:	fff00c13          	li	s8,-1
 20c:	01665463          	bge	a2,s6,214 <st7735_draw_line+0x74>
 210:	00100c13          	li	s8,1
 214:	f0000337          	lui	t1,0xf0000
 218:	2c000737          	lui	a4,0x2c000
 21c:	00430313          	addi	t1,t1,4 # f0000004 <seg_write_hex+0xeffffbd4>
 220:	00170713          	addi	a4,a4,1 # 2c000001 <seg_write_hex+0x2bfffbd1>
 224:	408e88b3          	sub	a7,t4,s0
 228:	01059293          	slli	t0,a1,0x10
 22c:	00859f93          	slli	t6,a1,0x8
 230:	01061513          	slli	a0,a2,0x10
 234:	00861393          	slli	t2,a2,0x8
 238:	41558f33          	sub	t5,a1,s5
 23c:	00ff0e37          	lui	t3,0xff0
 240:	2a0009b7          	lui	s3,0x2a000
 244:	2b000937          	lui	s2,0x2b000
 248:	f00004b7          	lui	s1,0xf0000
 24c:	010f9813          	slli	a6,t6,0x10
 250:	01085813          	srli	a6,a6,0x10
 254:	01039c93          	slli	s9,t2,0x10
 258:	01c2f7b3          	and	a5,t0,t3
 25c:	010cdc93          	srli	s9,s9,0x10
 260:	0107e7b3          	or	a5,a5,a6
 264:	01c57833          	and	a6,a0,t3
 268:	01986833          	or	a6,a6,s9
 26c:	0137e7b3          	or	a5,a5,s3
 270:	01286833          	or	a6,a6,s2
 274:	00f32023          	sw	a5,0(t1)
 278:	01032023          	sw	a6,0(t1)
 27c:	00e32023          	sw	a4,0(t1)
 280:	00d4a023          	sw	a3,0(s1) # f0000000 <seg_write_hex+0xeffffbd0>
 284:	00189793          	slli	a5,a7,0x1
 288:	000f1463          	bnez	t5,290 <st7735_draw_line+0xf0>
 28c:	03660a63          	beq	a2,s6,2c0 <st7735_draw_line+0x120>
 290:	0147ce63          	blt	a5,s4,2ac <st7735_draw_line+0x10c>
 294:	017585b3          	add	a1,a1,s7
 298:	408888b3          	sub	a7,a7,s0
 29c:	01059293          	slli	t0,a1,0x10
 2a0:	00859f93          	slli	t6,a1,0x8
 2a4:	41558f33          	sub	t5,a1,s5
 2a8:	fafec2e3          	blt	t4,a5,24c <st7735_draw_line+0xac>
 2ac:	01860633          	add	a2,a2,s8
 2b0:	01d888b3          	add	a7,a7,t4
 2b4:	01061513          	slli	a0,a2,0x10
 2b8:	00861393          	slli	t2,a2,0x8
 2bc:	f91ff06f          	j	24c <st7735_draw_line+0xac>
 2c0:	02c12403          	lw	s0,44(sp)
 2c4:	02812483          	lw	s1,40(sp)
 2c8:	02412903          	lw	s2,36(sp)
 2cc:	02012983          	lw	s3,32(sp)
 2d0:	01c12a03          	lw	s4,28(sp)
 2d4:	01812a83          	lw	s5,24(sp)
 2d8:	01412b03          	lw	s6,20(sp)
 2dc:	01012b83          	lw	s7,16(sp)
 2e0:	00c12c03          	lw	s8,12(sp)
 2e4:	00812c83          	lw	s9,8(sp)
 2e8:	03010113          	addi	sp,sp,48
 2ec:	00008067          	ret

000002f0 <st7735_draw_circle>:
 2f0:	1206ce63          	bltz	a3,42c <st7735_draw_circle+0x13c>
 2f4:	fc010113          	addi	sp,sp,-64
 2f8:	03512223          	sw	s5,36(sp)
 2fc:	00100a93          	li	s5,1
 300:	02812c23          	sw	s0,56(sp)
 304:	02912a23          	sw	s1,52(sp)
 308:	03212823          	sw	s2,48(sp)
 30c:	03312623          	sw	s3,44(sp)
 310:	03412423          	sw	s4,40(sp)
 314:	01812c23          	sw	s8,24(sp)
 318:	01912a23          	sw	s9,20(sp)
 31c:	01a12823          	sw	s10,16(sp)
 320:	01b12623          	sw	s11,12(sp)
 324:	02112e23          	sw	ra,60(sp)
 328:	00068493          	mv	s1,a3
 32c:	00060993          	mv	s3,a2
 330:	00058a13          	mv	s4,a1
 334:	00050913          	mv	s2,a0
 338:	40da8ab3          	sub	s5,s5,a3
 33c:	00000413          	li	s0,0
 340:	40d58db3          	sub	s11,a1,a3
 344:	00d58d33          	add	s10,a1,a3
 348:	00d60cb3          	add	s9,a2,a3
 34c:	40d60c33          	sub	s8,a2,a3
 350:	01340733          	add	a4,s0,s3
 354:	00070613          	mv	a2,a4
 358:	000d0693          	mv	a3,s10
 35c:	000d8593          	mv	a1,s11
 360:	00090513          	mv	a0,s2
 364:	e3dff0ef          	jal	1a0 <st7735_draw_line>
 368:	40898733          	sub	a4,s3,s0
 36c:	00070613          	mv	a2,a4
 370:	000d0693          	mv	a3,s10
 374:	000d8593          	mv	a1,s11
 378:	00090513          	mv	a0,s2
 37c:	e25ff0ef          	jal	1a0 <st7735_draw_line>
 380:	408a05b3          	sub	a1,s4,s0
 384:	008a06b3          	add	a3,s4,s0
 388:	000c8713          	mv	a4,s9
 38c:	000c8613          	mv	a2,s9
 390:	00090513          	mv	a0,s2
 394:	e0dff0ef          	jal	1a0 <st7735_draw_line>
 398:	008a06b3          	add	a3,s4,s0
 39c:	408a05b3          	sub	a1,s4,s0
 3a0:	000c0713          	mv	a4,s8
 3a4:	000c0613          	mv	a2,s8
 3a8:	00090513          	mv	a0,s2
 3ac:	df5ff0ef          	jal	1a0 <st7735_draw_line>
 3b0:	00140413          	addi	s0,s0,1
 3b4:	020ac863          	bltz	s5,3e4 <st7735_draw_circle+0xf4>
 3b8:	fff48493          	addi	s1,s1,-1
 3bc:	409407b3          	sub	a5,s0,s1
 3c0:	00179793          	slli	a5,a5,0x1
 3c4:	00178793          	addi	a5,a5,1 # 2c000001 <seg_write_hex+0x2bfffbd1>
 3c8:	0284c863          	blt	s1,s0,3f8 <st7735_draw_circle+0x108>
 3cc:	00fa8ab3          	add	s5,s5,a5
 3d0:	409a0db3          	sub	s11,s4,s1
 3d4:	009a0d33          	add	s10,s4,s1
 3d8:	00998cb3          	add	s9,s3,s1
 3dc:	40998c33          	sub	s8,s3,s1
 3e0:	f71ff06f          	j	350 <st7735_draw_circle+0x60>
 3e4:	00141793          	slli	a5,s0,0x1
 3e8:	00178793          	addi	a5,a5,1
 3ec:	0084c663          	blt	s1,s0,3f8 <st7735_draw_circle+0x108>
 3f0:	00fa8ab3          	add	s5,s5,a5
 3f4:	f5dff06f          	j	350 <st7735_draw_circle+0x60>
 3f8:	03c12083          	lw	ra,60(sp)
 3fc:	03812403          	lw	s0,56(sp)
 400:	03412483          	lw	s1,52(sp)
 404:	03012903          	lw	s2,48(sp)
 408:	02c12983          	lw	s3,44(sp)
 40c:	02812a03          	lw	s4,40(sp)
 410:	02412a83          	lw	s5,36(sp)
 414:	01812c03          	lw	s8,24(sp)
 418:	01412c83          	lw	s9,20(sp)
 41c:	01012d03          	lw	s10,16(sp)
 420:	00c12d83          	lw	s11,12(sp)
 424:	04010113          	addi	sp,sp,64
 428:	00008067          	ret
 42c:	00008067          	ret

00000430 <seg_write_hex>:
 430:	f00007b7          	lui	a5,0xf0000
 434:	00878793          	addi	a5,a5,8 # f0000008 <seg_write_hex+0xeffffbd8>
 438:	00a79023          	sh	a0,0(a5)
 43c:	00008067          	ret
