
__out_tmp.elf:     file format elf32-littleriscv


Disassembly of section .text:

00000000 <__static_end>:
   0:	00001197          	auipc	gp,0x1
   4:	80018193          	addi	gp,gp,-2048 # 800 <__global_pointer$>
   8:	00020117          	auipc	sp,0x20
   c:	ff810113          	addi	sp,sp,-8 # 20000 <__stack_top>
  10:	180000ef          	jal	190 <main>

00000014 <halt_loop>:
  14:	0000006f          	j	14 <halt_loop>

00000018 <isin1000>:
  18:	04054663          	bltz	a0,64 <isin1000+0x4c>
  1c:	16700793          	li	a5,359
  20:	04a7c663          	blt	a5,a0,6c <isin1000+0x54>
  24:	0b400713          	li	a4,180
  28:	00100613          	li	a2,1
  2c:	00a75663          	bge	a4,a0,38 <isin1000+0x20>
  30:	f4c50513          	addi	a0,a0,-180
  34:	fff00613          	li	a2,-1
  38:	40a70733          	sub	a4,a4,a0
  3c:	02a70733          	mul	a4,a4,a0
  40:	000017b7          	lui	a5,0x1
  44:	fa078793          	addi	a5,a5,-96 # fa0 <__global_pointer$+0x7a0>
  48:	0000a6b7          	lui	a3,0xa
  4c:	e3468693          	addi	a3,a3,-460 # 9e34 <__static_reserve+0x8e34>
  50:	02f707b3          	mul	a5,a4,a5
  54:	40e68733          	sub	a4,a3,a4
  58:	02e7c7b3          	div	a5,a5,a4
  5c:	02c78533          	mul	a0,a5,a2
  60:	00008067          	ret
  64:	16850513          	addi	a0,a0,360
  68:	fb1ff06f          	j	18 <isin1000>
  6c:	e9850513          	addi	a0,a0,-360
  70:	fb1ff06f          	j	20 <isin1000+0x8>

00000074 <transform_vertex>:
  74:	fc010113          	addi	sp,sp,-64
  78:	02812c23          	sw	s0,56(sp)
  7c:	00050413          	mv	s0,a0
  80:	05a70513          	addi	a0,a4,90
  84:	02112e23          	sw	ra,60(sp)
  88:	02912a23          	sw	s1,52(sp)
  8c:	03212823          	sw	s2,48(sp)
  90:	03312623          	sw	s3,44(sp)
  94:	03412423          	sw	s4,40(sp)
  98:	03512223          	sw	s5,36(sp)
  9c:	03612023          	sw	s6,32(sp)
  a0:	01712e23          	sw	s7,28(sp)
  a4:	00060913          	mv	s2,a2
  a8:	00068b93          	mv	s7,a3
  ac:	00b12623          	sw	a1,12(sp)
  b0:	00f12423          	sw	a5,8(sp)
  b4:	01012223          	sw	a6,4(sp)
  b8:	00e12023          	sw	a4,0(sp)
  bc:	f5dff0ef          	jal	18 <isin1000>
  c0:	00050993          	mv	s3,a0
  c4:	00012503          	lw	a0,0(sp)
  c8:	3e800a13          	li	s4,1000
  cc:	f4dff0ef          	jal	18 <isin1000>
  d0:	03390733          	mul	a4,s2,s3
  d4:	028504b3          	mul	s1,a0,s0
  d8:	00e484b3          	add	s1,s1,a4
  dc:	0344c4b3          	div	s1,s1,s4
  e0:	03250ab3          	mul	s5,a0,s2
  e4:	05ab8513          	addi	a0,s7,90
  e8:	f31ff0ef          	jal	18 <isin1000>
  ec:	00050b13          	mv	s6,a0
  f0:	000b8513          	mv	a0,s7
  f4:	f25ff0ef          	jal	18 <isin1000>
  f8:	00c12583          	lw	a1,12(sp)
  fc:	10000613          	li	a2,256
 100:	00812783          	lw	a5,8(sp)
 104:	00412803          	lw	a6,4(sp)
 108:	036486b3          	mul	a3,s1,s6
 10c:	03c12083          	lw	ra,60(sp)
 110:	03012903          	lw	s2,48(sp)
 114:	01c12b83          	lw	s7,28(sp)
 118:	02a58733          	mul	a4,a1,a0
 11c:	00d70733          	add	a4,a4,a3
 120:	03474733          	div	a4,a4,s4
 124:	000096b7          	lui	a3,0x9
 128:	60068693          	addi	a3,a3,1536 # 9600 <__static_reserve+0x8600>
 12c:	03340433          	mul	s0,s0,s3
 130:	09670713          	addi	a4,a4,150
 134:	02c12983          	lw	s3,44(sp)
 138:	02e6c6b3          	div	a3,a3,a4
 13c:	41540733          	sub	a4,s0,s5
 140:	03812403          	lw	s0,56(sp)
 144:	02412a83          	lw	s5,36(sp)
 148:	03474733          	div	a4,a4,s4
 14c:	02d70733          	mul	a4,a4,a3
 150:	02c74733          	div	a4,a4,a2
 154:	036585b3          	mul	a1,a1,s6
 158:	04070713          	addi	a4,a4,64
 15c:	00e7a023          	sw	a4,0(a5)
 160:	02012b03          	lw	s6,32(sp)
 164:	02a484b3          	mul	s1,s1,a0
 168:	409587b3          	sub	a5,a1,s1
 16c:	0347c7b3          	div	a5,a5,s4
 170:	03412483          	lw	s1,52(sp)
 174:	02812a03          	lw	s4,40(sp)
 178:	02d787b3          	mul	a5,a5,a3
 17c:	02c7c7b3          	div	a5,a5,a2
 180:	05078793          	addi	a5,a5,80
 184:	00f82023          	sw	a5,0(a6)
 188:	04010113          	addi	sp,sp,64
 18c:	00008067          	ret

00000190 <main>:
 190:	f6010113          	addi	sp,sp,-160
 194:	08812c23          	sw	s0,152(sp)
 198:	08912a23          	sw	s1,148(sp)
 19c:	08112e23          	sw	ra,156(sp)
 1a0:	09212823          	sw	s2,144(sp)
 1a4:	09312623          	sw	s3,140(sp)
 1a8:	09412423          	sw	s4,136(sp)
 1ac:	09512223          	sw	s5,132(sp)
 1b0:	09612023          	sw	s6,128(sp)
 1b4:	07712e23          	sw	s7,124(sp)
 1b8:	07812c23          	sw	s8,120(sp)
 1bc:	07912a23          	sw	s9,116(sp)
 1c0:	07a12823          	sw	s10,112(sp)
 1c4:	07b12623          	sw	s11,108(sp)
 1c8:	00000493          	li	s1,0
 1cc:	00000413          	li	s0,0
 1d0:	fe200613          	li	a2,-30
 1d4:	00060593          	mv	a1,a2
 1d8:	00060513          	mv	a0,a2
 1dc:	02410813          	addi	a6,sp,36
 1e0:	02010793          	addi	a5,sp,32
 1e4:	00048713          	mv	a4,s1
 1e8:	00040693          	mv	a3,s0
 1ec:	e89ff0ef          	jal	74 <transform_vertex>
 1f0:	fe200613          	li	a2,-30
 1f4:	00060593          	mv	a1,a2
 1f8:	02c10813          	addi	a6,sp,44
 1fc:	02810793          	addi	a5,sp,40
 200:	00048713          	mv	a4,s1
 204:	00040693          	mv	a3,s0
 208:	01e00513          	li	a0,30
 20c:	e69ff0ef          	jal	74 <transform_vertex>
 210:	01e00593          	li	a1,30
 214:	00058513          	mv	a0,a1
 218:	03410813          	addi	a6,sp,52
 21c:	03010793          	addi	a5,sp,48
 220:	00048713          	mv	a4,s1
 224:	00040693          	mv	a3,s0
 228:	fe200613          	li	a2,-30
 22c:	e49ff0ef          	jal	74 <transform_vertex>
 230:	fe200613          	li	a2,-30
 234:	00060513          	mv	a0,a2
 238:	03c10813          	addi	a6,sp,60
 23c:	03810793          	addi	a5,sp,56
 240:	00048713          	mv	a4,s1
 244:	00040693          	mv	a3,s0
 248:	01e00593          	li	a1,30
 24c:	e29ff0ef          	jal	74 <transform_vertex>
 250:	fe200593          	li	a1,-30
 254:	00058513          	mv	a0,a1
 258:	04410813          	addi	a6,sp,68
 25c:	04010793          	addi	a5,sp,64
 260:	00048713          	mv	a4,s1
 264:	00040693          	mv	a3,s0
 268:	01e00613          	li	a2,30
 26c:	e09ff0ef          	jal	74 <transform_vertex>
 270:	01e00613          	li	a2,30
 274:	00060513          	mv	a0,a2
 278:	04c10813          	addi	a6,sp,76
 27c:	04810793          	addi	a5,sp,72
 280:	00048713          	mv	a4,s1
 284:	00040693          	mv	a3,s0
 288:	fe200593          	li	a1,-30
 28c:	de9ff0ef          	jal	74 <transform_vertex>
 290:	01e00613          	li	a2,30
 294:	00060593          	mv	a1,a2
 298:	00060513          	mv	a0,a2
 29c:	05410813          	addi	a6,sp,84
 2a0:	05010793          	addi	a5,sp,80
 2a4:	00048713          	mv	a4,s1
 2a8:	00040693          	mv	a3,s0
 2ac:	dc9ff0ef          	jal	74 <transform_vertex>
 2b0:	01e00613          	li	a2,30
 2b4:	05c10813          	addi	a6,sp,92
 2b8:	05810793          	addi	a5,sp,88
 2bc:	00060593          	mv	a1,a2
 2c0:	00048713          	mv	a4,s1
 2c4:	00040693          	mv	a3,s0
 2c8:	fe200513          	li	a0,-30
 2cc:	da9ff0ef          	jal	74 <transform_vertex>
 2d0:	0a000713          	li	a4,160
 2d4:	08000693          	li	a3,128
 2d8:	00000613          	li	a2,0
 2dc:	00000593          	li	a1,0
 2e0:	00000513          	li	a0,0
 2e4:	268000ef          	jal	54c <st7735_draw_rectangle>
 2e8:	02012903          	lw	s2,32(sp)
 2ec:	02412983          	lw	s3,36(sp)
 2f0:	02812a03          	lw	s4,40(sp)
 2f4:	02c12a83          	lw	s5,44(sp)
 2f8:	ffe10537          	lui	a0,0xffe10
 2fc:	000a0693          	mv	a3,s4
 300:	000a8713          	mv	a4,s5
 304:	00098613          	mv	a2,s3
 308:	00090593          	mv	a1,s2
 30c:	fe050513          	addi	a0,a0,-32 # ffe0ffe0 <__stack_top+0xffdeffe0>
 310:	2b4000ef          	jal	5c4 <st7735_draw_line>
 314:	03012b03          	lw	s6,48(sp)
 318:	03412b83          	lw	s7,52(sp)
 31c:	ffe10537          	lui	a0,0xffe10
 320:	000b0693          	mv	a3,s6
 324:	000b8713          	mv	a4,s7
 328:	000a8613          	mv	a2,s5
 32c:	000a0593          	mv	a1,s4
 330:	fe050513          	addi	a0,a0,-32 # ffe0ffe0 <__stack_top+0xffdeffe0>
 334:	290000ef          	jal	5c4 <st7735_draw_line>
 338:	03812c03          	lw	s8,56(sp)
 33c:	03c12c83          	lw	s9,60(sp)
 340:	ffe10537          	lui	a0,0xffe10
 344:	000c0693          	mv	a3,s8
 348:	000c8713          	mv	a4,s9
 34c:	000b8613          	mv	a2,s7
 350:	000b0593          	mv	a1,s6
 354:	fe050513          	addi	a0,a0,-32 # ffe0ffe0 <__stack_top+0xffdeffe0>
 358:	26c000ef          	jal	5c4 <st7735_draw_line>
 35c:	ffe10537          	lui	a0,0xffe10
 360:	00098713          	mv	a4,s3
 364:	00090693          	mv	a3,s2
 368:	000c8613          	mv	a2,s9
 36c:	000c0593          	mv	a1,s8
 370:	fe050513          	addi	a0,a0,-32 # ffe0ffe0 <__stack_top+0xffdeffe0>
 374:	250000ef          	jal	5c4 <st7735_draw_line>
 378:	04812783          	lw	a5,72(sp)
 37c:	04012d03          	lw	s10,64(sp)
 380:	04412d83          	lw	s11,68(sp)
 384:	00f12423          	sw	a5,8(sp)
 388:	04c12783          	lw	a5,76(sp)
 38c:	00812683          	lw	a3,8(sp)
 390:	07ff0537          	lui	a0,0x7ff0
 394:	00078713          	mv	a4,a5
 398:	000d8613          	mv	a2,s11
 39c:	000d0593          	mv	a1,s10
 3a0:	7ff50513          	addi	a0,a0,2047 # 7ff07ff <__stack_top+0x7fd07ff>
 3a4:	00f12623          	sw	a5,12(sp)
 3a8:	21c000ef          	jal	5c4 <st7735_draw_line>
 3ac:	05012783          	lw	a5,80(sp)
 3b0:	00c12603          	lw	a2,12(sp)
 3b4:	00812583          	lw	a1,8(sp)
 3b8:	00f12823          	sw	a5,16(sp)
 3bc:	05412783          	lw	a5,84(sp)
 3c0:	01012683          	lw	a3,16(sp)
 3c4:	07ff0537          	lui	a0,0x7ff0
 3c8:	00078713          	mv	a4,a5
 3cc:	7ff50513          	addi	a0,a0,2047 # 7ff07ff <__stack_top+0x7fd07ff>
 3d0:	00f12a23          	sw	a5,20(sp)
 3d4:	1f0000ef          	jal	5c4 <st7735_draw_line>
 3d8:	05812783          	lw	a5,88(sp)
 3dc:	01412603          	lw	a2,20(sp)
 3e0:	01012583          	lw	a1,16(sp)
 3e4:	00f12c23          	sw	a5,24(sp)
 3e8:	05c12783          	lw	a5,92(sp)
 3ec:	01812683          	lw	a3,24(sp)
 3f0:	07ff0537          	lui	a0,0x7ff0
 3f4:	00078713          	mv	a4,a5
 3f8:	7ff50513          	addi	a0,a0,2047 # 7ff07ff <__stack_top+0x7fd07ff>
 3fc:	00f12e23          	sw	a5,28(sp)
 400:	1c4000ef          	jal	5c4 <st7735_draw_line>
 404:	01c12603          	lw	a2,28(sp)
 408:	01812583          	lw	a1,24(sp)
 40c:	07ff0537          	lui	a0,0x7ff0
 410:	000d8713          	mv	a4,s11
 414:	000d0693          	mv	a3,s10
 418:	7ff50513          	addi	a0,a0,2047 # 7ff07ff <__stack_top+0x7fd07ff>
 41c:	1a8000ef          	jal	5c4 <st7735_draw_line>
 420:	000d8713          	mv	a4,s11
 424:	000d0693          	mv	a3,s10
 428:	00098613          	mv	a2,s3
 42c:	00090593          	mv	a1,s2
 430:	fff00513          	li	a0,-1
 434:	190000ef          	jal	5c4 <st7735_draw_line>
 438:	00c12703          	lw	a4,12(sp)
 43c:	00812683          	lw	a3,8(sp)
 440:	000a8613          	mv	a2,s5
 444:	000a0593          	mv	a1,s4
 448:	fff00513          	li	a0,-1
 44c:	178000ef          	jal	5c4 <st7735_draw_line>
 450:	01412703          	lw	a4,20(sp)
 454:	01012683          	lw	a3,16(sp)
 458:	000b8613          	mv	a2,s7
 45c:	000b0593          	mv	a1,s6
 460:	fff00513          	li	a0,-1
 464:	160000ef          	jal	5c4 <st7735_draw_line>
 468:	01c12703          	lw	a4,28(sp)
 46c:	01812683          	lw	a3,24(sp)
 470:	000c8613          	mv	a2,s9
 474:	000c0593          	mv	a1,s8
 478:	fff00513          	li	a0,-1
 47c:	148000ef          	jal	5c4 <st7735_draw_line>
 480:	00340713          	addi	a4,s0,3
 484:	16700693          	li	a3,359
 488:	00248793          	addi	a5,s1,2
 48c:	00e6d463          	bge	a3,a4,494 <main+0x304>
 490:	e9b40713          	addi	a4,s0,-357
 494:	00f6d463          	bge	a3,a5,49c <main+0x30c>
 498:	e9a48793          	addi	a5,s1,-358
 49c:	00078493          	mv	s1,a5
 4a0:	00070413          	mv	s0,a4
 4a4:	d2dff06f          	j	1d0 <main+0x40>

000004a8 <st7735_set_rectangle>:
 4a8:	00ff07b7          	lui	a5,0xff0
 4ac:	01059593          	slli	a1,a1,0x10
 4b0:	0ff6f693          	zext.b	a3,a3
 4b4:	00f5f5b3          	and	a1,a1,a5
 4b8:	00869693          	slli	a3,a3,0x8
 4bc:	01051513          	slli	a0,a0,0x10
 4c0:	0ff67613          	zext.b	a2,a2
 4c4:	00f57533          	and	a0,a0,a5
 4c8:	00861613          	slli	a2,a2,0x8
 4cc:	00d5e5b3          	or	a1,a1,a3
 4d0:	2b0007b7          	lui	a5,0x2b000
 4d4:	00c56533          	or	a0,a0,a2
 4d8:	2a000737          	lui	a4,0x2a000
 4dc:	00f5e5b3          	or	a1,a1,a5
 4e0:	f00007b7          	lui	a5,0xf0000
 4e4:	00e56533          	or	a0,a0,a4
 4e8:	00278793          	addi	a5,a5,2 # f0000002 <__stack_top+0xeffe0002>
 4ec:	00a7a023          	sw	a0,0(a5)
 4f0:	00b7a023          	sw	a1,0(a5)
 4f4:	00008067          	ret

000004f8 <st7735_draw_pixel>:
 4f8:	ff010113          	addi	sp,sp,-16
 4fc:	00812423          	sw	s0,8(sp)
 500:	00050413          	mv	s0,a0
 504:	00058513          	mv	a0,a1
 508:	00060693          	mv	a3,a2
 50c:	00060593          	mv	a1,a2
 510:	00050613          	mv	a2,a0
 514:	00112623          	sw	ra,12(sp)
 518:	f91ff0ef          	jal	4a8 <st7735_set_rectangle>
 51c:	2c0007b7          	lui	a5,0x2c000
 520:	f0000737          	lui	a4,0xf0000
 524:	00178793          	addi	a5,a5,1 # 2c000001 <__stack_top+0x2bfe0001>
 528:	00270713          	addi	a4,a4,2 # f0000002 <__stack_top+0xeffe0002>
 52c:	00f72023          	sw	a5,0(a4)
 530:	f00007b7          	lui	a5,0xf0000
 534:	00178793          	addi	a5,a5,1 # f0000001 <__stack_top+0xeffe0001>
 538:	0087a023          	sw	s0,0(a5)
 53c:	00c12083          	lw	ra,12(sp)
 540:	00812403          	lw	s0,8(sp)
 544:	01010113          	addi	sp,sp,16
 548:	00008067          	ret

0000054c <st7735_draw_rectangle>:
 54c:	fe010113          	addi	sp,sp,-32
 550:	00812c23          	sw	s0,24(sp)
 554:	00912a23          	sw	s1,20(sp)
 558:	00068413          	mv	s0,a3
 55c:	00050493          	mv	s1,a0
 560:	00058513          	mv	a0,a1
 564:	00e606b3          	add	a3,a2,a4
 568:	00060593          	mv	a1,a2
 56c:	00850633          	add	a2,a0,s0
 570:	fff68693          	addi	a3,a3,-1
 574:	fff60613          	addi	a2,a2,-1
 578:	00112e23          	sw	ra,28(sp)
 57c:	00e12623          	sw	a4,12(sp)
 580:	f29ff0ef          	jal	4a8 <st7735_set_rectangle>
 584:	00c12703          	lw	a4,12(sp)
 588:	2c0007b7          	lui	a5,0x2c000
 58c:	02e40433          	mul	s0,s0,a4
 590:	40145413          	srai	s0,s0,0x1
 594:	00f46433          	or	s0,s0,a5
 598:	f00007b7          	lui	a5,0xf0000
 59c:	00278793          	addi	a5,a5,2 # f0000002 <__stack_top+0xeffe0002>
 5a0:	0087a023          	sw	s0,0(a5)
 5a4:	f00007b7          	lui	a5,0xf0000
 5a8:	00178793          	addi	a5,a5,1 # f0000001 <__stack_top+0xeffe0001>
 5ac:	0097a023          	sw	s1,0(a5)
 5b0:	01c12083          	lw	ra,28(sp)
 5b4:	01812403          	lw	s0,24(sp)
 5b8:	01412483          	lw	s1,20(sp)
 5bc:	02010113          	addi	sp,sp,32
 5c0:	00008067          	ret

000005c4 <st7735_draw_line>:
 5c4:	fc010113          	addi	sp,sp,-64
 5c8:	02812c23          	sw	s0,56(sp)
 5cc:	40b68433          	sub	s0,a3,a1
 5d0:	41f45793          	srai	a5,s0,0x1f
 5d4:	03412423          	sw	s4,40(sp)
 5d8:	0087c433          	xor	s0,a5,s0
 5dc:	02112e23          	sw	ra,60(sp)
 5e0:	02912a23          	sw	s1,52(sp)
 5e4:	03212823          	sw	s2,48(sp)
 5e8:	03312623          	sw	s3,44(sp)
 5ec:	03512223          	sw	s5,36(sp)
 5f0:	40f40433          	sub	s0,s0,a5
 5f4:	00100a13          	li	s4,1
 5f8:	00d5c463          	blt	a1,a3,600 <st7735_draw_line+0x3c>
 5fc:	fff00a13          	li	s4,-1
 600:	40c704b3          	sub	s1,a4,a2
 604:	41f4d793          	srai	a5,s1,0x1f
 608:	0097c4b3          	xor	s1,a5,s1
 60c:	40f484b3          	sub	s1,s1,a5
 610:	40900ab3          	neg	s5,s1
 614:	fff00993          	li	s3,-1
 618:	00e65463          	bge	a2,a4,620 <st7735_draw_line+0x5c>
 61c:	00100993          	li	s3,1
 620:	40940933          	sub	s2,s0,s1
 624:	00e12e23          	sw	a4,28(sp)
 628:	00d12c23          	sw	a3,24(sp)
 62c:	00c12a23          	sw	a2,20(sp)
 630:	00b12823          	sw	a1,16(sp)
 634:	00a12623          	sw	a0,12(sp)
 638:	ec1ff0ef          	jal	4f8 <st7735_draw_pixel>
 63c:	01012583          	lw	a1,16(sp)
 640:	01812683          	lw	a3,24(sp)
 644:	00c12503          	lw	a0,12(sp)
 648:	01412603          	lw	a2,20(sp)
 64c:	01c12703          	lw	a4,28(sp)
 650:	00d59463          	bne	a1,a3,658 <st7735_draw_line+0x94>
 654:	02e60263          	beq	a2,a4,678 <st7735_draw_line+0xb4>
 658:	00191793          	slli	a5,s2,0x1
 65c:	0157c863          	blt	a5,s5,66c <st7735_draw_line+0xa8>
 660:	40990933          	sub	s2,s2,s1
 664:	014585b3          	add	a1,a1,s4
 668:	faf44ee3          	blt	s0,a5,624 <st7735_draw_line+0x60>
 66c:	00890933          	add	s2,s2,s0
 670:	01360633          	add	a2,a2,s3
 674:	fb1ff06f          	j	624 <st7735_draw_line+0x60>
 678:	03c12083          	lw	ra,60(sp)
 67c:	03812403          	lw	s0,56(sp)
 680:	03412483          	lw	s1,52(sp)
 684:	03012903          	lw	s2,48(sp)
 688:	02c12983          	lw	s3,44(sp)
 68c:	02812a03          	lw	s4,40(sp)
 690:	02412a83          	lw	s5,36(sp)
 694:	04010113          	addi	sp,sp,64
 698:	00008067          	ret
