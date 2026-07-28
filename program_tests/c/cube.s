
__out_tmp.elf:     file format elf32-littleriscv


Disassembly of section .text:

00000000 <_start>:
   0:	00008137          	lui	sp,0x8
   4:	180000ef          	jal	184 <main>

00000008 <halt_loop>:
   8:	0000006f          	j	8 <halt_loop>

0000000c <isin1000>:
   c:	04054663          	bltz	a0,58 <isin1000+0x4c>
  10:	16700793          	li	a5,359
  14:	04a7c663          	blt	a5,a0,60 <isin1000+0x54>
  18:	0b400713          	li	a4,180
  1c:	00100613          	li	a2,1
  20:	00a75663          	bge	a4,a0,2c <isin1000+0x20>
  24:	f4c50513          	addi	a0,a0,-180
  28:	fff00613          	li	a2,-1
  2c:	40a70733          	sub	a4,a4,a0
  30:	02a70733          	mul	a4,a4,a0
  34:	000017b7          	lui	a5,0x1
  38:	fa078793          	addi	a5,a5,-96 # fa0 <st7735_draw_line+0x9f0>
  3c:	0000a6b7          	lui	a3,0xa
  40:	e3468693          	addi	a3,a3,-460 # 9e34 <st7735_draw_line+0x9884>
  44:	02f707b3          	mul	a5,a4,a5
  48:	40e68733          	sub	a4,a3,a4
  4c:	02e7c7b3          	div	a5,a5,a4
  50:	02c78533          	mul	a0,a5,a2
  54:	00008067          	ret
  58:	16850513          	addi	a0,a0,360
  5c:	fb1ff06f          	j	c <isin1000>
  60:	e9850513          	addi	a0,a0,-360
  64:	fb1ff06f          	j	14 <isin1000+0x8>

00000068 <transform_vertex>:
  68:	fc010113          	addi	sp,sp,-64 # 7fc0 <st7735_draw_line+0x7a10>
  6c:	02812c23          	sw	s0,56(sp)
  70:	00050413          	mv	s0,a0
  74:	05a70513          	addi	a0,a4,90
  78:	02112e23          	sw	ra,60(sp)
  7c:	02912a23          	sw	s1,52(sp)
  80:	03212823          	sw	s2,48(sp)
  84:	03312623          	sw	s3,44(sp)
  88:	03412423          	sw	s4,40(sp)
  8c:	03512223          	sw	s5,36(sp)
  90:	03612023          	sw	s6,32(sp)
  94:	01712e23          	sw	s7,28(sp)
  98:	00060913          	mv	s2,a2
  9c:	00068b93          	mv	s7,a3
  a0:	00b12623          	sw	a1,12(sp)
  a4:	00f12423          	sw	a5,8(sp)
  a8:	01012223          	sw	a6,4(sp)
  ac:	00e12023          	sw	a4,0(sp)
  b0:	f5dff0ef          	jal	c <isin1000>
  b4:	00050993          	mv	s3,a0
  b8:	00012503          	lw	a0,0(sp)
  bc:	3e800a13          	li	s4,1000
  c0:	f4dff0ef          	jal	c <isin1000>
  c4:	03390733          	mul	a4,s2,s3
  c8:	028504b3          	mul	s1,a0,s0
  cc:	00e484b3          	add	s1,s1,a4
  d0:	0344c4b3          	div	s1,s1,s4
  d4:	03250ab3          	mul	s5,a0,s2
  d8:	05ab8513          	addi	a0,s7,90
  dc:	f31ff0ef          	jal	c <isin1000>
  e0:	00050b13          	mv	s6,a0
  e4:	000b8513          	mv	a0,s7
  e8:	f25ff0ef          	jal	c <isin1000>
  ec:	00c12583          	lw	a1,12(sp)
  f0:	10000613          	li	a2,256
  f4:	00812783          	lw	a5,8(sp)
  f8:	00412803          	lw	a6,4(sp)
  fc:	036486b3          	mul	a3,s1,s6
 100:	03c12083          	lw	ra,60(sp)
 104:	03012903          	lw	s2,48(sp)
 108:	01c12b83          	lw	s7,28(sp)
 10c:	02a58733          	mul	a4,a1,a0
 110:	00d70733          	add	a4,a4,a3
 114:	03474733          	div	a4,a4,s4
 118:	000096b7          	lui	a3,0x9
 11c:	60068693          	addi	a3,a3,1536 # 9600 <st7735_draw_line+0x9050>
 120:	03340433          	mul	s0,s0,s3
 124:	09670713          	addi	a4,a4,150
 128:	02c12983          	lw	s3,44(sp)
 12c:	02e6c6b3          	div	a3,a3,a4
 130:	41540733          	sub	a4,s0,s5
 134:	03812403          	lw	s0,56(sp)
 138:	02412a83          	lw	s5,36(sp)
 13c:	03474733          	div	a4,a4,s4
 140:	02d70733          	mul	a4,a4,a3
 144:	02c74733          	div	a4,a4,a2
 148:	036585b3          	mul	a1,a1,s6
 14c:	04070713          	addi	a4,a4,64
 150:	00e7a023          	sw	a4,0(a5)
 154:	02012b03          	lw	s6,32(sp)
 158:	02a484b3          	mul	s1,s1,a0
 15c:	409587b3          	sub	a5,a1,s1
 160:	0347c7b3          	div	a5,a5,s4
 164:	03412483          	lw	s1,52(sp)
 168:	02812a03          	lw	s4,40(sp)
 16c:	02d787b3          	mul	a5,a5,a3
 170:	02c7c7b3          	div	a5,a5,a2
 174:	05078793          	addi	a5,a5,80
 178:	00f82023          	sw	a5,0(a6)
 17c:	04010113          	addi	sp,sp,64
 180:	00008067          	ret

00000184 <main>:
 184:	f6010113          	addi	sp,sp,-160
 188:	08812c23          	sw	s0,152(sp)
 18c:	08912a23          	sw	s1,148(sp)
 190:	08112e23          	sw	ra,156(sp)
 194:	09212823          	sw	s2,144(sp)
 198:	09312623          	sw	s3,140(sp)
 19c:	09412423          	sw	s4,136(sp)
 1a0:	09512223          	sw	s5,132(sp)
 1a4:	09612023          	sw	s6,128(sp)
 1a8:	07712e23          	sw	s7,124(sp)
 1ac:	07812c23          	sw	s8,120(sp)
 1b0:	07912a23          	sw	s9,116(sp)
 1b4:	07a12823          	sw	s10,112(sp)
 1b8:	07b12623          	sw	s11,108(sp)
 1bc:	00000493          	li	s1,0
 1c0:	00000413          	li	s0,0
 1c4:	fe200613          	li	a2,-30
 1c8:	00060593          	mv	a1,a2
 1cc:	00060513          	mv	a0,a2
 1d0:	02410813          	addi	a6,sp,36
 1d4:	02010793          	addi	a5,sp,32
 1d8:	00048713          	mv	a4,s1
 1dc:	00040693          	mv	a3,s0
 1e0:	e89ff0ef          	jal	68 <transform_vertex>
 1e4:	fe200613          	li	a2,-30
 1e8:	00060593          	mv	a1,a2
 1ec:	02c10813          	addi	a6,sp,44
 1f0:	02810793          	addi	a5,sp,40
 1f4:	00048713          	mv	a4,s1
 1f8:	00040693          	mv	a3,s0
 1fc:	01e00513          	li	a0,30
 200:	e69ff0ef          	jal	68 <transform_vertex>
 204:	01e00593          	li	a1,30
 208:	00058513          	mv	a0,a1
 20c:	03410813          	addi	a6,sp,52
 210:	03010793          	addi	a5,sp,48
 214:	00048713          	mv	a4,s1
 218:	00040693          	mv	a3,s0
 21c:	fe200613          	li	a2,-30
 220:	e49ff0ef          	jal	68 <transform_vertex>
 224:	fe200613          	li	a2,-30
 228:	00060513          	mv	a0,a2
 22c:	03c10813          	addi	a6,sp,60
 230:	03810793          	addi	a5,sp,56
 234:	00048713          	mv	a4,s1
 238:	00040693          	mv	a3,s0
 23c:	01e00593          	li	a1,30
 240:	e29ff0ef          	jal	68 <transform_vertex>
 244:	fe200593          	li	a1,-30
 248:	00058513          	mv	a0,a1
 24c:	04410813          	addi	a6,sp,68
 250:	04010793          	addi	a5,sp,64
 254:	00048713          	mv	a4,s1
 258:	00040693          	mv	a3,s0
 25c:	01e00613          	li	a2,30
 260:	e09ff0ef          	jal	68 <transform_vertex>
 264:	01e00613          	li	a2,30
 268:	00060513          	mv	a0,a2
 26c:	04c10813          	addi	a6,sp,76
 270:	04810793          	addi	a5,sp,72
 274:	00048713          	mv	a4,s1
 278:	00040693          	mv	a3,s0
 27c:	fe200593          	li	a1,-30
 280:	de9ff0ef          	jal	68 <transform_vertex>
 284:	01e00613          	li	a2,30
 288:	00060593          	mv	a1,a2
 28c:	00060513          	mv	a0,a2
 290:	05410813          	addi	a6,sp,84
 294:	05010793          	addi	a5,sp,80
 298:	00048713          	mv	a4,s1
 29c:	00040693          	mv	a3,s0
 2a0:	dc9ff0ef          	jal	68 <transform_vertex>
 2a4:	01e00613          	li	a2,30
 2a8:	05c10813          	addi	a6,sp,92
 2ac:	05810793          	addi	a5,sp,88
 2b0:	00060593          	mv	a1,a2
 2b4:	00048713          	mv	a4,s1
 2b8:	00040693          	mv	a3,s0
 2bc:	fe200513          	li	a0,-30
 2c0:	da9ff0ef          	jal	68 <transform_vertex>
 2c4:	0a000713          	li	a4,160
 2c8:	08000693          	li	a3,128
 2cc:	00000613          	li	a2,0
 2d0:	00000593          	li	a1,0
 2d4:	00000513          	li	a0,0
 2d8:	264000ef          	jal	53c <st7735_draw_rectangle>
 2dc:	02012903          	lw	s2,32(sp)
 2e0:	02412983          	lw	s3,36(sp)
 2e4:	02812a03          	lw	s4,40(sp)
 2e8:	02c12a83          	lw	s5,44(sp)
 2ec:	ffe10537          	lui	a0,0xffe10
 2f0:	000a0693          	mv	a3,s4
 2f4:	000a8713          	mv	a4,s5
 2f8:	00098613          	mv	a2,s3
 2fc:	00090593          	mv	a1,s2
 300:	fe050513          	addi	a0,a0,-32 # ffe0ffe0 <st7735_draw_line+0xffe0fa30>
 304:	2ac000ef          	jal	5b0 <st7735_draw_line>
 308:	03012b03          	lw	s6,48(sp)
 30c:	03412b83          	lw	s7,52(sp)
 310:	ffe10537          	lui	a0,0xffe10
 314:	000b0693          	mv	a3,s6
 318:	000b8713          	mv	a4,s7
 31c:	000a8613          	mv	a2,s5
 320:	000a0593          	mv	a1,s4
 324:	fe050513          	addi	a0,a0,-32 # ffe0ffe0 <st7735_draw_line+0xffe0fa30>
 328:	288000ef          	jal	5b0 <st7735_draw_line>
 32c:	03812c03          	lw	s8,56(sp)
 330:	03c12c83          	lw	s9,60(sp)
 334:	ffe10537          	lui	a0,0xffe10
 338:	000c0693          	mv	a3,s8
 33c:	000c8713          	mv	a4,s9
 340:	000b8613          	mv	a2,s7
 344:	000b0593          	mv	a1,s6
 348:	fe050513          	addi	a0,a0,-32 # ffe0ffe0 <st7735_draw_line+0xffe0fa30>
 34c:	264000ef          	jal	5b0 <st7735_draw_line>
 350:	ffe10537          	lui	a0,0xffe10
 354:	00098713          	mv	a4,s3
 358:	00090693          	mv	a3,s2
 35c:	000c8613          	mv	a2,s9
 360:	000c0593          	mv	a1,s8
 364:	fe050513          	addi	a0,a0,-32 # ffe0ffe0 <st7735_draw_line+0xffe0fa30>
 368:	248000ef          	jal	5b0 <st7735_draw_line>
 36c:	04812783          	lw	a5,72(sp)
 370:	04012d03          	lw	s10,64(sp)
 374:	04412d83          	lw	s11,68(sp)
 378:	00f12423          	sw	a5,8(sp)
 37c:	04c12783          	lw	a5,76(sp)
 380:	00812683          	lw	a3,8(sp)
 384:	07ff0537          	lui	a0,0x7ff0
 388:	00078713          	mv	a4,a5
 38c:	000d8613          	mv	a2,s11
 390:	000d0593          	mv	a1,s10
 394:	7ff50513          	addi	a0,a0,2047 # 7ff07ff <st7735_draw_line+0x7ff024f>
 398:	00f12623          	sw	a5,12(sp)
 39c:	214000ef          	jal	5b0 <st7735_draw_line>
 3a0:	05012783          	lw	a5,80(sp)
 3a4:	00c12603          	lw	a2,12(sp)
 3a8:	00812583          	lw	a1,8(sp)
 3ac:	00f12823          	sw	a5,16(sp)
 3b0:	05412783          	lw	a5,84(sp)
 3b4:	01012683          	lw	a3,16(sp)
 3b8:	07ff0537          	lui	a0,0x7ff0
 3bc:	00078713          	mv	a4,a5
 3c0:	7ff50513          	addi	a0,a0,2047 # 7ff07ff <st7735_draw_line+0x7ff024f>
 3c4:	00f12a23          	sw	a5,20(sp)
 3c8:	1e8000ef          	jal	5b0 <st7735_draw_line>
 3cc:	05812783          	lw	a5,88(sp)
 3d0:	01412603          	lw	a2,20(sp)
 3d4:	01012583          	lw	a1,16(sp)
 3d8:	00f12c23          	sw	a5,24(sp)
 3dc:	05c12783          	lw	a5,92(sp)
 3e0:	01812683          	lw	a3,24(sp)
 3e4:	07ff0537          	lui	a0,0x7ff0
 3e8:	00078713          	mv	a4,a5
 3ec:	7ff50513          	addi	a0,a0,2047 # 7ff07ff <st7735_draw_line+0x7ff024f>
 3f0:	00f12e23          	sw	a5,28(sp)
 3f4:	1bc000ef          	jal	5b0 <st7735_draw_line>
 3f8:	01c12603          	lw	a2,28(sp)
 3fc:	01812583          	lw	a1,24(sp)
 400:	07ff0537          	lui	a0,0x7ff0
 404:	000d8713          	mv	a4,s11
 408:	000d0693          	mv	a3,s10
 40c:	7ff50513          	addi	a0,a0,2047 # 7ff07ff <st7735_draw_line+0x7ff024f>
 410:	1a0000ef          	jal	5b0 <st7735_draw_line>
 414:	000d8713          	mv	a4,s11
 418:	000d0693          	mv	a3,s10
 41c:	00098613          	mv	a2,s3
 420:	00090593          	mv	a1,s2
 424:	fff00513          	li	a0,-1
 428:	188000ef          	jal	5b0 <st7735_draw_line>
 42c:	00c12703          	lw	a4,12(sp)
 430:	00812683          	lw	a3,8(sp)
 434:	000a8613          	mv	a2,s5
 438:	000a0593          	mv	a1,s4
 43c:	fff00513          	li	a0,-1
 440:	170000ef          	jal	5b0 <st7735_draw_line>
 444:	01412703          	lw	a4,20(sp)
 448:	01012683          	lw	a3,16(sp)
 44c:	000b8613          	mv	a2,s7
 450:	000b0593          	mv	a1,s6
 454:	fff00513          	li	a0,-1
 458:	158000ef          	jal	5b0 <st7735_draw_line>
 45c:	01c12703          	lw	a4,28(sp)
 460:	01812683          	lw	a3,24(sp)
 464:	000c8613          	mv	a2,s9
 468:	000c0593          	mv	a1,s8
 46c:	fff00513          	li	a0,-1
 470:	140000ef          	jal	5b0 <st7735_draw_line>
 474:	00340713          	addi	a4,s0,3
 478:	16700693          	li	a3,359
 47c:	00248793          	addi	a5,s1,2
 480:	00e6d463          	bge	a3,a4,488 <main+0x304>
 484:	e9b40713          	addi	a4,s0,-357
 488:	00f6d463          	bge	a3,a5,490 <main+0x30c>
 48c:	e9a48793          	addi	a5,s1,-358
 490:	00078493          	mv	s1,a5
 494:	00070413          	mv	s0,a4
 498:	d2dff06f          	j	1c4 <main+0x40>

0000049c <st7735_set_rectangle>:
 49c:	00ff07b7          	lui	a5,0xff0
 4a0:	01059593          	slli	a1,a1,0x10
 4a4:	0ff6f693          	zext.b	a3,a3
 4a8:	00f5f5b3          	and	a1,a1,a5
 4ac:	00869693          	slli	a3,a3,0x8
 4b0:	01051513          	slli	a0,a0,0x10
 4b4:	0ff67613          	zext.b	a2,a2
 4b8:	00f57533          	and	a0,a0,a5
 4bc:	00861613          	slli	a2,a2,0x8
 4c0:	00d5e5b3          	or	a1,a1,a3
 4c4:	2b0007b7          	lui	a5,0x2b000
 4c8:	00c56533          	or	a0,a0,a2
 4cc:	2a000737          	lui	a4,0x2a000
 4d0:	00f5e5b3          	or	a1,a1,a5
 4d4:	f00007b7          	lui	a5,0xf0000
 4d8:	00e56533          	or	a0,a0,a4
 4dc:	00478793          	addi	a5,a5,4 # f0000004 <st7735_draw_line+0xeffffa54>
 4e0:	00a7a023          	sw	a0,0(a5)
 4e4:	00b7a023          	sw	a1,0(a5)
 4e8:	00008067          	ret

000004ec <st7735_draw_pixel>:
 4ec:	ff010113          	addi	sp,sp,-16
 4f0:	00812423          	sw	s0,8(sp)
 4f4:	00050413          	mv	s0,a0
 4f8:	00058513          	mv	a0,a1
 4fc:	00060693          	mv	a3,a2
 500:	00060593          	mv	a1,a2
 504:	00050613          	mv	a2,a0
 508:	00112623          	sw	ra,12(sp)
 50c:	f91ff0ef          	jal	49c <st7735_set_rectangle>
 510:	2c0007b7          	lui	a5,0x2c000
 514:	f0000737          	lui	a4,0xf0000
 518:	00178793          	addi	a5,a5,1 # 2c000001 <st7735_draw_line+0x2bfffa51>
 51c:	00470713          	addi	a4,a4,4 # f0000004 <st7735_draw_line+0xeffffa54>
 520:	00f72023          	sw	a5,0(a4)
 524:	f00007b7          	lui	a5,0xf0000
 528:	0087a023          	sw	s0,0(a5) # f0000000 <st7735_draw_line+0xeffffa50>
 52c:	00c12083          	lw	ra,12(sp)
 530:	00812403          	lw	s0,8(sp)
 534:	01010113          	addi	sp,sp,16
 538:	00008067          	ret

0000053c <st7735_draw_rectangle>:
 53c:	fe010113          	addi	sp,sp,-32
 540:	00812c23          	sw	s0,24(sp)
 544:	00912a23          	sw	s1,20(sp)
 548:	00068413          	mv	s0,a3
 54c:	00050493          	mv	s1,a0
 550:	00058513          	mv	a0,a1
 554:	00e606b3          	add	a3,a2,a4
 558:	00060593          	mv	a1,a2
 55c:	00850633          	add	a2,a0,s0
 560:	fff68693          	addi	a3,a3,-1
 564:	fff60613          	addi	a2,a2,-1
 568:	00112e23          	sw	ra,28(sp)
 56c:	00e12623          	sw	a4,12(sp)
 570:	f2dff0ef          	jal	49c <st7735_set_rectangle>
 574:	00c12703          	lw	a4,12(sp)
 578:	2c0007b7          	lui	a5,0x2c000
 57c:	02e40433          	mul	s0,s0,a4
 580:	40145413          	srai	s0,s0,0x1
 584:	00f46433          	or	s0,s0,a5
 588:	f00007b7          	lui	a5,0xf0000
 58c:	00478793          	addi	a5,a5,4 # f0000004 <st7735_draw_line+0xeffffa54>
 590:	0087a023          	sw	s0,0(a5)
 594:	f00007b7          	lui	a5,0xf0000
 598:	0097a023          	sw	s1,0(a5) # f0000000 <st7735_draw_line+0xeffffa50>
 59c:	01c12083          	lw	ra,28(sp)
 5a0:	01812403          	lw	s0,24(sp)
 5a4:	01412483          	lw	s1,20(sp)
 5a8:	02010113          	addi	sp,sp,32
 5ac:	00008067          	ret

000005b0 <st7735_draw_line>:
 5b0:	fc010113          	addi	sp,sp,-64
 5b4:	02812c23          	sw	s0,56(sp)
 5b8:	40b68433          	sub	s0,a3,a1
 5bc:	41f45793          	srai	a5,s0,0x1f
 5c0:	03412423          	sw	s4,40(sp)
 5c4:	0087c433          	xor	s0,a5,s0
 5c8:	02112e23          	sw	ra,60(sp)
 5cc:	02912a23          	sw	s1,52(sp)
 5d0:	03212823          	sw	s2,48(sp)
 5d4:	03312623          	sw	s3,44(sp)
 5d8:	03512223          	sw	s5,36(sp)
 5dc:	40f40433          	sub	s0,s0,a5
 5e0:	00100a13          	li	s4,1
 5e4:	00d5c463          	blt	a1,a3,5ec <st7735_draw_line+0x3c>
 5e8:	fff00a13          	li	s4,-1
 5ec:	40c704b3          	sub	s1,a4,a2
 5f0:	41f4d793          	srai	a5,s1,0x1f
 5f4:	0097c4b3          	xor	s1,a5,s1
 5f8:	40f484b3          	sub	s1,s1,a5
 5fc:	40900ab3          	neg	s5,s1
 600:	fff00993          	li	s3,-1
 604:	00e65463          	bge	a2,a4,60c <st7735_draw_line+0x5c>
 608:	00100993          	li	s3,1
 60c:	40940933          	sub	s2,s0,s1
 610:	00e12e23          	sw	a4,28(sp)
 614:	00d12c23          	sw	a3,24(sp)
 618:	00c12a23          	sw	a2,20(sp)
 61c:	00b12823          	sw	a1,16(sp)
 620:	00a12623          	sw	a0,12(sp)
 624:	ec9ff0ef          	jal	4ec <st7735_draw_pixel>
 628:	01012583          	lw	a1,16(sp)
 62c:	01812683          	lw	a3,24(sp)
 630:	00c12503          	lw	a0,12(sp)
 634:	01412603          	lw	a2,20(sp)
 638:	01c12703          	lw	a4,28(sp)
 63c:	00d59463          	bne	a1,a3,644 <st7735_draw_line+0x94>
 640:	02e60263          	beq	a2,a4,664 <st7735_draw_line+0xb4>
 644:	00191793          	slli	a5,s2,0x1
 648:	0157c863          	blt	a5,s5,658 <st7735_draw_line+0xa8>
 64c:	40990933          	sub	s2,s2,s1
 650:	014585b3          	add	a1,a1,s4
 654:	faf44ee3          	blt	s0,a5,610 <st7735_draw_line+0x60>
 658:	00890933          	add	s2,s2,s0
 65c:	01360633          	add	a2,a2,s3
 660:	fb1ff06f          	j	610 <st7735_draw_line+0x60>
 664:	03c12083          	lw	ra,60(sp)
 668:	03812403          	lw	s0,56(sp)
 66c:	03412483          	lw	s1,52(sp)
 670:	03012903          	lw	s2,48(sp)
 674:	02c12983          	lw	s3,44(sp)
 678:	02812a03          	lw	s4,40(sp)
 67c:	02412a83          	lw	s5,36(sp)
 680:	04010113          	addi	sp,sp,64
 684:	00008067          	ret
