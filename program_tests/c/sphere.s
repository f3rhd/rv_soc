
__out_tmp.elf:     file format elf32-littleriscv


Disassembly of section .text:

00000000 <_start>:
   0:	00008137          	lui	sp,0x8
   4:	234000ef          	jal	238 <main>

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
  38:	fa078793          	addi	a5,a5,-96 # fa0 <st7735_draw_line+0xabc>
  3c:	0000a6b7          	lui	a3,0xa
  40:	e3468693          	addi	a3,a3,-460 # 9e34 <st7735_draw_line+0x9950>
  44:	02f707b3          	mul	a5,a4,a5
  48:	40e68733          	sub	a4,a3,a4
  4c:	02e7c7b3          	div	a5,a5,a4
  50:	02c78533          	mul	a0,a5,a2
  54:	00008067          	ret
  58:	16850513          	addi	a0,a0,360
  5c:	fb1ff06f          	j	c <isin1000>
  60:	e9850513          	addi	a0,a0,-360
  64:	fb1ff06f          	j	14 <isin1000+0x8>

00000068 <sphere_point>:
  68:	fd010113          	addi	sp,sp,-48 # 7fd0 <st7735_draw_line+0x7aec>
  6c:	02812423          	sw	s0,40(sp)
  70:	00050413          	mv	s0,a0
  74:	05a50513          	addi	a0,a0,90
  78:	02112623          	sw	ra,44(sp)
  7c:	02912223          	sw	s1,36(sp)
  80:	03212023          	sw	s2,32(sp)
  84:	01312e23          	sw	s3,28(sp)
  88:	00058493          	mv	s1,a1
  8c:	00c12623          	sw	a2,12(sp)
  90:	00d12423          	sw	a3,8(sp)
  94:	00e12223          	sw	a4,4(sp)
  98:	f75ff0ef          	jal	c <isin1000>
  9c:	00050913          	mv	s2,a0
  a0:	00040513          	mv	a0,s0
  a4:	f69ff0ef          	jal	c <isin1000>
  a8:	00050413          	mv	s0,a0
  ac:	05a48513          	addi	a0,s1,90
  b0:	f5dff0ef          	jal	c <isin1000>
  b4:	00050993          	mv	s3,a0
  b8:	00048513          	mv	a0,s1
  bc:	f51ff0ef          	jal	c <isin1000>
  c0:	02a00893          	li	a7,42
  c4:	031907b3          	mul	a5,s2,a7
  c8:	3e800813          	li	a6,1000
  cc:	00c12603          	lw	a2,12(sp)
  d0:	00812683          	lw	a3,8(sp)
  d4:	00412703          	lw	a4,4(sp)
  d8:	02c12083          	lw	ra,44(sp)
  dc:	02412483          	lw	s1,36(sp)
  e0:	02012903          	lw	s2,32(sp)
  e4:	0307c7b3          	div	a5,a5,a6
  e8:	033785b3          	mul	a1,a5,s3
  ec:	01c12983          	lw	s3,28(sp)
  f0:	0305c5b3          	div	a1,a1,a6
  f4:	00b62023          	sw	a1,0(a2)
  f8:	03140633          	mul	a2,s0,a7
  fc:	02812403          	lw	s0,40(sp)
 100:	02f50533          	mul	a0,a0,a5
 104:	03064633          	div	a2,a2,a6
 108:	03054533          	div	a0,a0,a6
 10c:	00c6a023          	sw	a2,0(a3)
 110:	00a72023          	sw	a0,0(a4)
 114:	03010113          	addi	sp,sp,48
 118:	00008067          	ret

0000011c <transform_vertex>:
 11c:	fc010113          	addi	sp,sp,-64
 120:	02812c23          	sw	s0,56(sp)
 124:	00050413          	mv	s0,a0
 128:	05a70513          	addi	a0,a4,90
 12c:	02112e23          	sw	ra,60(sp)
 130:	02912a23          	sw	s1,52(sp)
 134:	03212823          	sw	s2,48(sp)
 138:	03312623          	sw	s3,44(sp)
 13c:	03412423          	sw	s4,40(sp)
 140:	03512223          	sw	s5,36(sp)
 144:	03612023          	sw	s6,32(sp)
 148:	01712e23          	sw	s7,28(sp)
 14c:	00060913          	mv	s2,a2
 150:	00068b93          	mv	s7,a3
 154:	00b12623          	sw	a1,12(sp)
 158:	00f12423          	sw	a5,8(sp)
 15c:	01012223          	sw	a6,4(sp)
 160:	00e12023          	sw	a4,0(sp)
 164:	ea9ff0ef          	jal	c <isin1000>
 168:	00050993          	mv	s3,a0
 16c:	00012503          	lw	a0,0(sp)
 170:	3e800a13          	li	s4,1000
 174:	e99ff0ef          	jal	c <isin1000>
 178:	03390733          	mul	a4,s2,s3
 17c:	028504b3          	mul	s1,a0,s0
 180:	00e484b3          	add	s1,s1,a4
 184:	0344c4b3          	div	s1,s1,s4
 188:	03250ab3          	mul	s5,a0,s2
 18c:	05ab8513          	addi	a0,s7,90
 190:	e7dff0ef          	jal	c <isin1000>
 194:	00050b13          	mv	s6,a0
 198:	000b8513          	mv	a0,s7
 19c:	e71ff0ef          	jal	c <isin1000>
 1a0:	00c12583          	lw	a1,12(sp)
 1a4:	10000613          	li	a2,256
 1a8:	00812783          	lw	a5,8(sp)
 1ac:	00412803          	lw	a6,4(sp)
 1b0:	036486b3          	mul	a3,s1,s6
 1b4:	03c12083          	lw	ra,60(sp)
 1b8:	03012903          	lw	s2,48(sp)
 1bc:	01c12b83          	lw	s7,28(sp)
 1c0:	02a58733          	mul	a4,a1,a0
 1c4:	00d70733          	add	a4,a4,a3
 1c8:	03474733          	div	a4,a4,s4
 1cc:	000096b7          	lui	a3,0x9
 1d0:	60068693          	addi	a3,a3,1536 # 9600 <st7735_draw_line+0x911c>
 1d4:	03340433          	mul	s0,s0,s3
 1d8:	09670713          	addi	a4,a4,150
 1dc:	02c12983          	lw	s3,44(sp)
 1e0:	02e6c6b3          	div	a3,a3,a4
 1e4:	41540733          	sub	a4,s0,s5
 1e8:	03812403          	lw	s0,56(sp)
 1ec:	02412a83          	lw	s5,36(sp)
 1f0:	03474733          	div	a4,a4,s4
 1f4:	02d70733          	mul	a4,a4,a3
 1f8:	02c74733          	div	a4,a4,a2
 1fc:	036585b3          	mul	a1,a1,s6
 200:	04070713          	addi	a4,a4,64
 204:	00e7a023          	sw	a4,0(a5)
 208:	02012b03          	lw	s6,32(sp)
 20c:	02a484b3          	mul	s1,s1,a0
 210:	409587b3          	sub	a5,a1,s1
 214:	0347c7b3          	div	a5,a5,s4
 218:	03412483          	lw	s1,52(sp)
 21c:	02812a03          	lw	s4,40(sp)
 220:	02d787b3          	mul	a5,a5,a3
 224:	02c7c7b3          	div	a5,a5,a2
 228:	05078793          	addi	a5,a5,80
 22c:	00f82023          	sw	a5,0(a6)
 230:	04010113          	addi	sp,sp,64
 234:	00008067          	ret

00000238 <main>:
 238:	fb010113          	addi	sp,sp,-80
 23c:	04912223          	sw	s1,68(sp)
 240:	05212023          	sw	s2,64(sp)
 244:	04112623          	sw	ra,76(sp)
 248:	04812423          	sw	s0,72(sp)
 24c:	03312e23          	sw	s3,60(sp)
 250:	03412c23          	sw	s4,56(sp)
 254:	03512a23          	sw	s5,52(sp)
 258:	03612823          	sw	s6,48(sp)
 25c:	03712623          	sw	s7,44(sp)
 260:	03812423          	sw	s8,40(sp)
 264:	00000493          	li	s1,0
 268:	00000913          	li	s2,0
 26c:	0a000713          	li	a4,160
 270:	08000693          	li	a3,128
 274:	00000613          	li	a2,0
 278:	00000593          	li	a1,0
 27c:	00000513          	li	a0,0
 280:	1ec000ef          	jal	46c <st7735_draw_rectangle>
 284:	fb000413          	li	s0,-80
 288:	00000b13          	li	s6,0
 28c:	00000a93          	li	s5,0
 290:	00100a13          	li	s4,1
 294:	00000993          	li	s3,0
 298:	16800b93          	li	s7,360
 29c:	01410713          	addi	a4,sp,20
 2a0:	01010693          	addi	a3,sp,16
 2a4:	00c10613          	addi	a2,sp,12
 2a8:	00098593          	mv	a1,s3
 2ac:	00040513          	mv	a0,s0
 2b0:	db9ff0ef          	jal	68 <sphere_point>
 2b4:	01412603          	lw	a2,20(sp)
 2b8:	01012583          	lw	a1,16(sp)
 2bc:	00c12503          	lw	a0,12(sp)
 2c0:	01c10813          	addi	a6,sp,28
 2c4:	01810793          	addi	a5,sp,24
 2c8:	00048713          	mv	a4,s1
 2cc:	00090693          	mv	a3,s2
 2d0:	e4dff0ef          	jal	11c <transform_vertex>
 2d4:	020a1063          	bnez	s4,2f4 <main+0xbc>
 2d8:	01c12703          	lw	a4,28(sp)
 2dc:	01812683          	lw	a3,24(sp)
 2e0:	ffe10537          	lui	a0,0xffe10
 2e4:	000b0613          	mv	a2,s6
 2e8:	000a8593          	mv	a1,s5
 2ec:	fe050513          	addi	a0,a0,-32 # ffe0ffe0 <st7735_draw_line+0xffe0fafc>
 2f0:	1f4000ef          	jal	4e4 <st7735_draw_line>
 2f4:	01498993          	addi	s3,s3,20
 2f8:	01812a83          	lw	s5,24(sp)
 2fc:	01c12b03          	lw	s6,28(sp)
 300:	00000a13          	li	s4,0
 304:	f9799ce3          	bne	s3,s7,29c <main+0x64>
 308:	01440413          	addi	s0,s0,20
 30c:	06400793          	li	a5,100
 310:	f6f41ce3          	bne	s0,a5,288 <main+0x50>
 314:	00000a13          	li	s4,0
 318:	16800c13          	li	s8,360
 31c:	00000b93          	li	s7,0
 320:	00000b13          	li	s6,0
 324:	00100a93          	li	s5,1
 328:	fb000993          	li	s3,-80
 32c:	01410713          	addi	a4,sp,20
 330:	01010693          	addi	a3,sp,16
 334:	00c10613          	addi	a2,sp,12
 338:	000a0593          	mv	a1,s4
 33c:	00098513          	mv	a0,s3
 340:	d29ff0ef          	jal	68 <sphere_point>
 344:	01412603          	lw	a2,20(sp)
 348:	01012583          	lw	a1,16(sp)
 34c:	00c12503          	lw	a0,12(sp)
 350:	01c10813          	addi	a6,sp,28
 354:	01810793          	addi	a5,sp,24
 358:	00048713          	mv	a4,s1
 35c:	00090693          	mv	a3,s2
 360:	dbdff0ef          	jal	11c <transform_vertex>
 364:	020a9063          	bnez	s5,384 <main+0x14c>
 368:	01c12703          	lw	a4,28(sp)
 36c:	01812683          	lw	a3,24(sp)
 370:	07ff0537          	lui	a0,0x7ff0
 374:	000b8613          	mv	a2,s7
 378:	000b0593          	mv	a1,s6
 37c:	7ff50513          	addi	a0,a0,2047 # 7ff07ff <st7735_draw_line+0x7ff031b>
 380:	164000ef          	jal	4e4 <st7735_draw_line>
 384:	01498993          	addi	s3,s3,20
 388:	01812b03          	lw	s6,24(sp)
 38c:	01c12b83          	lw	s7,28(sp)
 390:	00000a93          	li	s5,0
 394:	f8899ce3          	bne	s3,s0,32c <main+0xf4>
 398:	014a0a13          	addi	s4,s4,20
 39c:	f98a10e3          	bne	s4,s8,31c <main+0xe4>
 3a0:	00390713          	addi	a4,s2,3
 3a4:	16700693          	li	a3,359
 3a8:	00248793          	addi	a5,s1,2
 3ac:	00e6d463          	bge	a3,a4,3b4 <main+0x17c>
 3b0:	e9b90713          	addi	a4,s2,-357
 3b4:	00f6d463          	bge	a3,a5,3bc <main+0x184>
 3b8:	e9a48793          	addi	a5,s1,-358
 3bc:	00078493          	mv	s1,a5
 3c0:	00070913          	mv	s2,a4
 3c4:	ea9ff06f          	j	26c <main+0x34>

000003c8 <st7735_set_rectangle>:
 3c8:	00ff07b7          	lui	a5,0xff0
 3cc:	01059593          	slli	a1,a1,0x10
 3d0:	0ff6f693          	zext.b	a3,a3
 3d4:	00f5f5b3          	and	a1,a1,a5
 3d8:	00869693          	slli	a3,a3,0x8
 3dc:	01051513          	slli	a0,a0,0x10
 3e0:	0ff67613          	zext.b	a2,a2
 3e4:	00f57533          	and	a0,a0,a5
 3e8:	00861613          	slli	a2,a2,0x8
 3ec:	00d5e5b3          	or	a1,a1,a3
 3f0:	2b0007b7          	lui	a5,0x2b000
 3f4:	00c56533          	or	a0,a0,a2
 3f8:	2a000737          	lui	a4,0x2a000
 3fc:	00f5e5b3          	or	a1,a1,a5
 400:	f00007b7          	lui	a5,0xf0000
 404:	00e56533          	or	a0,a0,a4
 408:	00278793          	addi	a5,a5,2 # f0000002 <st7735_draw_line+0xeffffb1e>
 40c:	00a7a023          	sw	a0,0(a5)
 410:	00b7a023          	sw	a1,0(a5)
 414:	00008067          	ret

00000418 <st7735_draw_pixel>:
 418:	ff010113          	addi	sp,sp,-16
 41c:	00812423          	sw	s0,8(sp)
 420:	00050413          	mv	s0,a0
 424:	00058513          	mv	a0,a1
 428:	00060693          	mv	a3,a2
 42c:	00060593          	mv	a1,a2
 430:	00050613          	mv	a2,a0
 434:	00112623          	sw	ra,12(sp)
 438:	f91ff0ef          	jal	3c8 <st7735_set_rectangle>
 43c:	2c0007b7          	lui	a5,0x2c000
 440:	f0000737          	lui	a4,0xf0000
 444:	00178793          	addi	a5,a5,1 # 2c000001 <st7735_draw_line+0x2bfffb1d>
 448:	00270713          	addi	a4,a4,2 # f0000002 <st7735_draw_line+0xeffffb1e>
 44c:	00f72023          	sw	a5,0(a4)
 450:	f00007b7          	lui	a5,0xf0000
 454:	00178793          	addi	a5,a5,1 # f0000001 <st7735_draw_line+0xeffffb1d>
 458:	0087a023          	sw	s0,0(a5)
 45c:	00c12083          	lw	ra,12(sp)
 460:	00812403          	lw	s0,8(sp)
 464:	01010113          	addi	sp,sp,16
 468:	00008067          	ret

0000046c <st7735_draw_rectangle>:
 46c:	fe010113          	addi	sp,sp,-32
 470:	00812c23          	sw	s0,24(sp)
 474:	00912a23          	sw	s1,20(sp)
 478:	00068413          	mv	s0,a3
 47c:	00050493          	mv	s1,a0
 480:	00058513          	mv	a0,a1
 484:	00e606b3          	add	a3,a2,a4
 488:	00060593          	mv	a1,a2
 48c:	00850633          	add	a2,a0,s0
 490:	fff68693          	addi	a3,a3,-1
 494:	fff60613          	addi	a2,a2,-1
 498:	00112e23          	sw	ra,28(sp)
 49c:	00e12623          	sw	a4,12(sp)
 4a0:	f29ff0ef          	jal	3c8 <st7735_set_rectangle>
 4a4:	00c12703          	lw	a4,12(sp)
 4a8:	2c0007b7          	lui	a5,0x2c000
 4ac:	02e40433          	mul	s0,s0,a4
 4b0:	40145413          	srai	s0,s0,0x1
 4b4:	00f46433          	or	s0,s0,a5
 4b8:	f00007b7          	lui	a5,0xf0000
 4bc:	00278793          	addi	a5,a5,2 # f0000002 <st7735_draw_line+0xeffffb1e>
 4c0:	0087a023          	sw	s0,0(a5)
 4c4:	f00007b7          	lui	a5,0xf0000
 4c8:	00178793          	addi	a5,a5,1 # f0000001 <st7735_draw_line+0xeffffb1d>
 4cc:	0097a023          	sw	s1,0(a5)
 4d0:	01c12083          	lw	ra,28(sp)
 4d4:	01812403          	lw	s0,24(sp)
 4d8:	01412483          	lw	s1,20(sp)
 4dc:	02010113          	addi	sp,sp,32
 4e0:	00008067          	ret

000004e4 <st7735_draw_line>:
 4e4:	fc010113          	addi	sp,sp,-64
 4e8:	02812c23          	sw	s0,56(sp)
 4ec:	40b68433          	sub	s0,a3,a1
 4f0:	41f45793          	srai	a5,s0,0x1f
 4f4:	03412423          	sw	s4,40(sp)
 4f8:	0087c433          	xor	s0,a5,s0
 4fc:	02112e23          	sw	ra,60(sp)
 500:	02912a23          	sw	s1,52(sp)
 504:	03212823          	sw	s2,48(sp)
 508:	03312623          	sw	s3,44(sp)
 50c:	03512223          	sw	s5,36(sp)
 510:	40f40433          	sub	s0,s0,a5
 514:	00100a13          	li	s4,1
 518:	00d5c463          	blt	a1,a3,520 <st7735_draw_line+0x3c>
 51c:	fff00a13          	li	s4,-1
 520:	40c704b3          	sub	s1,a4,a2
 524:	41f4d793          	srai	a5,s1,0x1f
 528:	0097c4b3          	xor	s1,a5,s1
 52c:	40f484b3          	sub	s1,s1,a5
 530:	40900ab3          	neg	s5,s1
 534:	fff00993          	li	s3,-1
 538:	00e65463          	bge	a2,a4,540 <st7735_draw_line+0x5c>
 53c:	00100993          	li	s3,1
 540:	40940933          	sub	s2,s0,s1
 544:	00e12e23          	sw	a4,28(sp)
 548:	00d12c23          	sw	a3,24(sp)
 54c:	00c12a23          	sw	a2,20(sp)
 550:	00b12823          	sw	a1,16(sp)
 554:	00a12623          	sw	a0,12(sp)
 558:	ec1ff0ef          	jal	418 <st7735_draw_pixel>
 55c:	01012583          	lw	a1,16(sp)
 560:	01812683          	lw	a3,24(sp)
 564:	00c12503          	lw	a0,12(sp)
 568:	01412603          	lw	a2,20(sp)
 56c:	01c12703          	lw	a4,28(sp)
 570:	00d59463          	bne	a1,a3,578 <st7735_draw_line+0x94>
 574:	02e60263          	beq	a2,a4,598 <st7735_draw_line+0xb4>
 578:	00191793          	slli	a5,s2,0x1
 57c:	0157c863          	blt	a5,s5,58c <st7735_draw_line+0xa8>
 580:	40990933          	sub	s2,s2,s1
 584:	014585b3          	add	a1,a1,s4
 588:	faf44ee3          	blt	s0,a5,544 <st7735_draw_line+0x60>
 58c:	00890933          	add	s2,s2,s0
 590:	01360633          	add	a2,a2,s3
 594:	fb1ff06f          	j	544 <st7735_draw_line+0x60>
 598:	03c12083          	lw	ra,60(sp)
 59c:	03812403          	lw	s0,56(sp)
 5a0:	03412483          	lw	s1,52(sp)
 5a4:	03012903          	lw	s2,48(sp)
 5a8:	02c12983          	lw	s3,44(sp)
 5ac:	02812a03          	lw	s4,40(sp)
 5b0:	02412a83          	lw	s5,36(sp)
 5b4:	04010113          	addi	sp,sp,64
 5b8:	00008067          	ret
