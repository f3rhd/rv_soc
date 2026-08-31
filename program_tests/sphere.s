
__out_tmp.elf:     file format elf32-littleriscv


Disassembly of section .text:

00000000 <__static_end>:
   0:	00001197          	auipc	gp,0x1
   4:	80018193          	addi	gp,gp,-2048 # 800 <__global_pointer$>
   8:	00020117          	auipc	sp,0x20
   c:	ff810113          	addi	sp,sp,-8 # 20000 <__stack_top>
  10:	234000ef          	jal	244 <main>

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

00000074 <sphere_point>:
  74:	fd010113          	addi	sp,sp,-48
  78:	02812423          	sw	s0,40(sp)
  7c:	00050413          	mv	s0,a0
  80:	05a50513          	addi	a0,a0,90
  84:	02112623          	sw	ra,44(sp)
  88:	02912223          	sw	s1,36(sp)
  8c:	03212023          	sw	s2,32(sp)
  90:	01312e23          	sw	s3,28(sp)
  94:	00058493          	mv	s1,a1
  98:	00c12623          	sw	a2,12(sp)
  9c:	00d12423          	sw	a3,8(sp)
  a0:	00e12223          	sw	a4,4(sp)
  a4:	f75ff0ef          	jal	18 <isin1000>
  a8:	00050913          	mv	s2,a0
  ac:	00040513          	mv	a0,s0
  b0:	f69ff0ef          	jal	18 <isin1000>
  b4:	00050413          	mv	s0,a0
  b8:	05a48513          	addi	a0,s1,90
  bc:	f5dff0ef          	jal	18 <isin1000>
  c0:	00050993          	mv	s3,a0
  c4:	00048513          	mv	a0,s1
  c8:	f51ff0ef          	jal	18 <isin1000>
  cc:	02a00893          	li	a7,42
  d0:	031907b3          	mul	a5,s2,a7
  d4:	3e800813          	li	a6,1000
  d8:	00c12603          	lw	a2,12(sp)
  dc:	00812683          	lw	a3,8(sp)
  e0:	00412703          	lw	a4,4(sp)
  e4:	02c12083          	lw	ra,44(sp)
  e8:	02412483          	lw	s1,36(sp)
  ec:	02012903          	lw	s2,32(sp)
  f0:	0307c7b3          	div	a5,a5,a6
  f4:	033785b3          	mul	a1,a5,s3
  f8:	01c12983          	lw	s3,28(sp)
  fc:	0305c5b3          	div	a1,a1,a6
 100:	00b62023          	sw	a1,0(a2)
 104:	03140633          	mul	a2,s0,a7
 108:	02812403          	lw	s0,40(sp)
 10c:	02f50533          	mul	a0,a0,a5
 110:	03064633          	div	a2,a2,a6
 114:	03054533          	div	a0,a0,a6
 118:	00c6a023          	sw	a2,0(a3)
 11c:	00a72023          	sw	a0,0(a4)
 120:	03010113          	addi	sp,sp,48
 124:	00008067          	ret

00000128 <transform_vertex>:
 128:	fc010113          	addi	sp,sp,-64
 12c:	02812c23          	sw	s0,56(sp)
 130:	00050413          	mv	s0,a0
 134:	05a70513          	addi	a0,a4,90
 138:	02112e23          	sw	ra,60(sp)
 13c:	02912a23          	sw	s1,52(sp)
 140:	03212823          	sw	s2,48(sp)
 144:	03312623          	sw	s3,44(sp)
 148:	03412423          	sw	s4,40(sp)
 14c:	03512223          	sw	s5,36(sp)
 150:	03612023          	sw	s6,32(sp)
 154:	01712e23          	sw	s7,28(sp)
 158:	00060913          	mv	s2,a2
 15c:	00068b93          	mv	s7,a3
 160:	00b12623          	sw	a1,12(sp)
 164:	00f12423          	sw	a5,8(sp)
 168:	01012223          	sw	a6,4(sp)
 16c:	00e12023          	sw	a4,0(sp)
 170:	ea9ff0ef          	jal	18 <isin1000>
 174:	00050993          	mv	s3,a0
 178:	00012503          	lw	a0,0(sp)
 17c:	3e800a13          	li	s4,1000
 180:	e99ff0ef          	jal	18 <isin1000>
 184:	03390733          	mul	a4,s2,s3
 188:	028504b3          	mul	s1,a0,s0
 18c:	00e484b3          	add	s1,s1,a4
 190:	0344c4b3          	div	s1,s1,s4
 194:	03250ab3          	mul	s5,a0,s2
 198:	05ab8513          	addi	a0,s7,90
 19c:	e7dff0ef          	jal	18 <isin1000>
 1a0:	00050b13          	mv	s6,a0
 1a4:	000b8513          	mv	a0,s7
 1a8:	e71ff0ef          	jal	18 <isin1000>
 1ac:	00c12583          	lw	a1,12(sp)
 1b0:	10000613          	li	a2,256
 1b4:	00812783          	lw	a5,8(sp)
 1b8:	00412803          	lw	a6,4(sp)
 1bc:	036486b3          	mul	a3,s1,s6
 1c0:	03c12083          	lw	ra,60(sp)
 1c4:	03012903          	lw	s2,48(sp)
 1c8:	01c12b83          	lw	s7,28(sp)
 1cc:	02a58733          	mul	a4,a1,a0
 1d0:	00d70733          	add	a4,a4,a3
 1d4:	03474733          	div	a4,a4,s4
 1d8:	000096b7          	lui	a3,0x9
 1dc:	60068693          	addi	a3,a3,1536 # 9600 <__static_reserve+0x8600>
 1e0:	03340433          	mul	s0,s0,s3
 1e4:	09670713          	addi	a4,a4,150
 1e8:	02c12983          	lw	s3,44(sp)
 1ec:	02e6c6b3          	div	a3,a3,a4
 1f0:	41540733          	sub	a4,s0,s5
 1f4:	03812403          	lw	s0,56(sp)
 1f8:	02412a83          	lw	s5,36(sp)
 1fc:	03474733          	div	a4,a4,s4
 200:	02d70733          	mul	a4,a4,a3
 204:	02c74733          	div	a4,a4,a2
 208:	036585b3          	mul	a1,a1,s6
 20c:	04070713          	addi	a4,a4,64
 210:	00e7a023          	sw	a4,0(a5)
 214:	02012b03          	lw	s6,32(sp)
 218:	02a484b3          	mul	s1,s1,a0
 21c:	409587b3          	sub	a5,a1,s1
 220:	0347c7b3          	div	a5,a5,s4
 224:	03412483          	lw	s1,52(sp)
 228:	02812a03          	lw	s4,40(sp)
 22c:	02d787b3          	mul	a5,a5,a3
 230:	02c7c7b3          	div	a5,a5,a2
 234:	05078793          	addi	a5,a5,80
 238:	00f82023          	sw	a5,0(a6)
 23c:	04010113          	addi	sp,sp,64
 240:	00008067          	ret

00000244 <main>:
 244:	fb010113          	addi	sp,sp,-80
 248:	04912223          	sw	s1,68(sp)
 24c:	05212023          	sw	s2,64(sp)
 250:	04112623          	sw	ra,76(sp)
 254:	04812423          	sw	s0,72(sp)
 258:	03312e23          	sw	s3,60(sp)
 25c:	03412c23          	sw	s4,56(sp)
 260:	03512a23          	sw	s5,52(sp)
 264:	03612823          	sw	s6,48(sp)
 268:	03712623          	sw	s7,44(sp)
 26c:	03812423          	sw	s8,40(sp)
 270:	00000493          	li	s1,0
 274:	00000913          	li	s2,0
 278:	0a000713          	li	a4,160
 27c:	08000693          	li	a3,128
 280:	00000613          	li	a2,0
 284:	00000593          	li	a1,0
 288:	00000513          	li	a0,0
 28c:	1ec000ef          	jal	478 <st7735_draw_rectangle>
 290:	fb000413          	li	s0,-80
 294:	00000b13          	li	s6,0
 298:	00000a93          	li	s5,0
 29c:	00100a13          	li	s4,1
 2a0:	00000993          	li	s3,0
 2a4:	16800b93          	li	s7,360
 2a8:	01410713          	addi	a4,sp,20
 2ac:	01010693          	addi	a3,sp,16
 2b0:	00c10613          	addi	a2,sp,12
 2b4:	00098593          	mv	a1,s3
 2b8:	00040513          	mv	a0,s0
 2bc:	db9ff0ef          	jal	74 <sphere_point>
 2c0:	01412603          	lw	a2,20(sp)
 2c4:	01012583          	lw	a1,16(sp)
 2c8:	00c12503          	lw	a0,12(sp)
 2cc:	01c10813          	addi	a6,sp,28
 2d0:	01810793          	addi	a5,sp,24
 2d4:	00048713          	mv	a4,s1
 2d8:	00090693          	mv	a3,s2
 2dc:	e4dff0ef          	jal	128 <transform_vertex>
 2e0:	020a1063          	bnez	s4,300 <main+0xbc>
 2e4:	01c12703          	lw	a4,28(sp)
 2e8:	01812683          	lw	a3,24(sp)
 2ec:	ffe10537          	lui	a0,0xffe10
 2f0:	000b0613          	mv	a2,s6
 2f4:	000a8593          	mv	a1,s5
 2f8:	fe050513          	addi	a0,a0,-32 # ffe0ffe0 <__stack_top+0xffdeffe0>
 2fc:	1f4000ef          	jal	4f0 <st7735_draw_line>
 300:	01498993          	addi	s3,s3,20
 304:	01812a83          	lw	s5,24(sp)
 308:	01c12b03          	lw	s6,28(sp)
 30c:	00000a13          	li	s4,0
 310:	f9799ce3          	bne	s3,s7,2a8 <main+0x64>
 314:	01440413          	addi	s0,s0,20
 318:	06400793          	li	a5,100
 31c:	f6f41ce3          	bne	s0,a5,294 <main+0x50>
 320:	00000a13          	li	s4,0
 324:	16800c13          	li	s8,360
 328:	00000b93          	li	s7,0
 32c:	00000b13          	li	s6,0
 330:	00100a93          	li	s5,1
 334:	fb000993          	li	s3,-80
 338:	01410713          	addi	a4,sp,20
 33c:	01010693          	addi	a3,sp,16
 340:	00c10613          	addi	a2,sp,12
 344:	000a0593          	mv	a1,s4
 348:	00098513          	mv	a0,s3
 34c:	d29ff0ef          	jal	74 <sphere_point>
 350:	01412603          	lw	a2,20(sp)
 354:	01012583          	lw	a1,16(sp)
 358:	00c12503          	lw	a0,12(sp)
 35c:	01c10813          	addi	a6,sp,28
 360:	01810793          	addi	a5,sp,24
 364:	00048713          	mv	a4,s1
 368:	00090693          	mv	a3,s2
 36c:	dbdff0ef          	jal	128 <transform_vertex>
 370:	020a9063          	bnez	s5,390 <main+0x14c>
 374:	01c12703          	lw	a4,28(sp)
 378:	01812683          	lw	a3,24(sp)
 37c:	07ff0537          	lui	a0,0x7ff0
 380:	000b8613          	mv	a2,s7
 384:	000b0593          	mv	a1,s6
 388:	7ff50513          	addi	a0,a0,2047 # 7ff07ff <__stack_top+0x7fd07ff>
 38c:	164000ef          	jal	4f0 <st7735_draw_line>
 390:	01498993          	addi	s3,s3,20
 394:	01812b03          	lw	s6,24(sp)
 398:	01c12b83          	lw	s7,28(sp)
 39c:	00000a93          	li	s5,0
 3a0:	f8899ce3          	bne	s3,s0,338 <main+0xf4>
 3a4:	014a0a13          	addi	s4,s4,20
 3a8:	f98a10e3          	bne	s4,s8,328 <main+0xe4>
 3ac:	00390713          	addi	a4,s2,3
 3b0:	16700693          	li	a3,359
 3b4:	00248793          	addi	a5,s1,2
 3b8:	00e6d463          	bge	a3,a4,3c0 <main+0x17c>
 3bc:	e9b90713          	addi	a4,s2,-357
 3c0:	00f6d463          	bge	a3,a5,3c8 <main+0x184>
 3c4:	e9a48793          	addi	a5,s1,-358
 3c8:	00078493          	mv	s1,a5
 3cc:	00070913          	mv	s2,a4
 3d0:	ea9ff06f          	j	278 <main+0x34>

000003d4 <st7735_set_rectangle>:
 3d4:	00ff07b7          	lui	a5,0xff0
 3d8:	01059593          	slli	a1,a1,0x10
 3dc:	0ff6f693          	zext.b	a3,a3
 3e0:	00f5f5b3          	and	a1,a1,a5
 3e4:	00869693          	slli	a3,a3,0x8
 3e8:	01051513          	slli	a0,a0,0x10
 3ec:	0ff67613          	zext.b	a2,a2
 3f0:	00f57533          	and	a0,a0,a5
 3f4:	00861613          	slli	a2,a2,0x8
 3f8:	00d5e5b3          	or	a1,a1,a3
 3fc:	2b0007b7          	lui	a5,0x2b000
 400:	00c56533          	or	a0,a0,a2
 404:	2a000737          	lui	a4,0x2a000
 408:	00f5e5b3          	or	a1,a1,a5
 40c:	f00007b7          	lui	a5,0xf0000
 410:	00e56533          	or	a0,a0,a4
 414:	00278793          	addi	a5,a5,2 # f0000002 <__stack_top+0xeffe0002>
 418:	00a7a023          	sw	a0,0(a5)
 41c:	00b7a023          	sw	a1,0(a5)
 420:	00008067          	ret

00000424 <st7735_draw_pixel>:
 424:	ff010113          	addi	sp,sp,-16
 428:	00812423          	sw	s0,8(sp)
 42c:	00050413          	mv	s0,a0
 430:	00058513          	mv	a0,a1
 434:	00060693          	mv	a3,a2
 438:	00060593          	mv	a1,a2
 43c:	00050613          	mv	a2,a0
 440:	00112623          	sw	ra,12(sp)
 444:	f91ff0ef          	jal	3d4 <st7735_set_rectangle>
 448:	2c0007b7          	lui	a5,0x2c000
 44c:	f0000737          	lui	a4,0xf0000
 450:	00178793          	addi	a5,a5,1 # 2c000001 <__stack_top+0x2bfe0001>
 454:	00270713          	addi	a4,a4,2 # f0000002 <__stack_top+0xeffe0002>
 458:	00f72023          	sw	a5,0(a4)
 45c:	f00007b7          	lui	a5,0xf0000
 460:	00178793          	addi	a5,a5,1 # f0000001 <__stack_top+0xeffe0001>
 464:	0087a023          	sw	s0,0(a5)
 468:	00c12083          	lw	ra,12(sp)
 46c:	00812403          	lw	s0,8(sp)
 470:	01010113          	addi	sp,sp,16
 474:	00008067          	ret

00000478 <st7735_draw_rectangle>:
 478:	fe010113          	addi	sp,sp,-32
 47c:	00812c23          	sw	s0,24(sp)
 480:	00912a23          	sw	s1,20(sp)
 484:	00068413          	mv	s0,a3
 488:	00050493          	mv	s1,a0
 48c:	00058513          	mv	a0,a1
 490:	00e606b3          	add	a3,a2,a4
 494:	00060593          	mv	a1,a2
 498:	00850633          	add	a2,a0,s0
 49c:	fff68693          	addi	a3,a3,-1
 4a0:	fff60613          	addi	a2,a2,-1
 4a4:	00112e23          	sw	ra,28(sp)
 4a8:	00e12623          	sw	a4,12(sp)
 4ac:	f29ff0ef          	jal	3d4 <st7735_set_rectangle>
 4b0:	00c12703          	lw	a4,12(sp)
 4b4:	2c0007b7          	lui	a5,0x2c000
 4b8:	02e40433          	mul	s0,s0,a4
 4bc:	40145413          	srai	s0,s0,0x1
 4c0:	00f46433          	or	s0,s0,a5
 4c4:	f00007b7          	lui	a5,0xf0000
 4c8:	00278793          	addi	a5,a5,2 # f0000002 <__stack_top+0xeffe0002>
 4cc:	0087a023          	sw	s0,0(a5)
 4d0:	f00007b7          	lui	a5,0xf0000
 4d4:	00178793          	addi	a5,a5,1 # f0000001 <__stack_top+0xeffe0001>
 4d8:	0097a023          	sw	s1,0(a5)
 4dc:	01c12083          	lw	ra,28(sp)
 4e0:	01812403          	lw	s0,24(sp)
 4e4:	01412483          	lw	s1,20(sp)
 4e8:	02010113          	addi	sp,sp,32
 4ec:	00008067          	ret

000004f0 <st7735_draw_line>:
 4f0:	fc010113          	addi	sp,sp,-64
 4f4:	02812c23          	sw	s0,56(sp)
 4f8:	40b68433          	sub	s0,a3,a1
 4fc:	41f45793          	srai	a5,s0,0x1f
 500:	03412423          	sw	s4,40(sp)
 504:	0087c433          	xor	s0,a5,s0
 508:	02112e23          	sw	ra,60(sp)
 50c:	02912a23          	sw	s1,52(sp)
 510:	03212823          	sw	s2,48(sp)
 514:	03312623          	sw	s3,44(sp)
 518:	03512223          	sw	s5,36(sp)
 51c:	40f40433          	sub	s0,s0,a5
 520:	00100a13          	li	s4,1
 524:	00d5c463          	blt	a1,a3,52c <st7735_draw_line+0x3c>
 528:	fff00a13          	li	s4,-1
 52c:	40c704b3          	sub	s1,a4,a2
 530:	41f4d793          	srai	a5,s1,0x1f
 534:	0097c4b3          	xor	s1,a5,s1
 538:	40f484b3          	sub	s1,s1,a5
 53c:	40900ab3          	neg	s5,s1
 540:	fff00993          	li	s3,-1
 544:	00e65463          	bge	a2,a4,54c <st7735_draw_line+0x5c>
 548:	00100993          	li	s3,1
 54c:	40940933          	sub	s2,s0,s1
 550:	00e12e23          	sw	a4,28(sp)
 554:	00d12c23          	sw	a3,24(sp)
 558:	00c12a23          	sw	a2,20(sp)
 55c:	00b12823          	sw	a1,16(sp)
 560:	00a12623          	sw	a0,12(sp)
 564:	ec1ff0ef          	jal	424 <st7735_draw_pixel>
 568:	01012583          	lw	a1,16(sp)
 56c:	01812683          	lw	a3,24(sp)
 570:	00c12503          	lw	a0,12(sp)
 574:	01412603          	lw	a2,20(sp)
 578:	01c12703          	lw	a4,28(sp)
 57c:	00d59463          	bne	a1,a3,584 <st7735_draw_line+0x94>
 580:	02e60263          	beq	a2,a4,5a4 <st7735_draw_line+0xb4>
 584:	00191793          	slli	a5,s2,0x1
 588:	0157c863          	blt	a5,s5,598 <st7735_draw_line+0xa8>
 58c:	40990933          	sub	s2,s2,s1
 590:	014585b3          	add	a1,a1,s4
 594:	faf44ee3          	blt	s0,a5,550 <st7735_draw_line+0x60>
 598:	00890933          	add	s2,s2,s0
 59c:	01360633          	add	a2,a2,s3
 5a0:	fb1ff06f          	j	550 <st7735_draw_line+0x60>
 5a4:	03c12083          	lw	ra,60(sp)
 5a8:	03812403          	lw	s0,56(sp)
 5ac:	03412483          	lw	s1,52(sp)
 5b0:	03012903          	lw	s2,48(sp)
 5b4:	02c12983          	lw	s3,44(sp)
 5b8:	02812a03          	lw	s4,40(sp)
 5bc:	02412a83          	lw	s5,36(sp)
 5c0:	04010113          	addi	sp,sp,64
 5c4:	00008067          	ret
