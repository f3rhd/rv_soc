
__out_tmp.elf:     file format elf32-littleriscv


Disassembly of section .text:

00000000 <_start>:
   0:	00008137          	lui	sp,0x8
   4:	008000ef          	jal	c <main>

00000008 <halt_loop>:
   8:	0000006f          	j	8 <halt_loop>

0000000c <main>:
   c:	ff010113          	addi	sp,sp,-16 # 7ff0 <st7735_set_rectangle+0x7a44>
  10:	00112623          	sw	ra,12(sp)
  14:	08c00893          	li	a7,140
  18:	06c00813          	li	a6,108
  1c:	08c00793          	li	a5,140
  20:	01400713          	li	a4,20
  24:	05000693          	li	a3,80
  28:	04000613          	li	a2,64
  2c:	00000593          	li	a1,0
  30:	001f0537          	lui	a0,0x1f0
  34:	01f50513          	addi	a0,a0,31 # 1f001f <st7735_set_rectangle+0x1efa73>
  38:	168000ef          	jal	1a0 <st7735_draw_triangle>
  3c:	00000793          	li	a5,0
  40:	00078513          	mv	a0,a5
  44:	00c12083          	lw	ra,12(sp)
  48:	01010113          	addi	sp,sp,16
  4c:	00008067          	ret

00000050 <st7735_draw_pixel>:
  50:	fe010113          	addi	sp,sp,-32
  54:	00112e23          	sw	ra,28(sp)
  58:	00a12623          	sw	a0,12(sp)
  5c:	00b12423          	sw	a1,8(sp)
  60:	00c12223          	sw	a2,4(sp)
  64:	00412683          	lw	a3,4(sp)
  68:	00812603          	lw	a2,8(sp)
  6c:	00412583          	lw	a1,4(sp)
  70:	00812503          	lw	a0,8(sp)
  74:	538000ef          	jal	5ac <st7735_set_rectangle>
  78:	00100593          	li	a1,1
  7c:	00c12503          	lw	a0,12(sp)
  80:	4d8000ef          	jal	558 <st7735_stream_pixel>
  84:	00000013          	nop
  88:	01c12083          	lw	ra,28(sp)
  8c:	02010113          	addi	sp,sp,32
  90:	00008067          	ret

00000094 <st7735_triangle_fill_span>:
  94:	fd010113          	addi	sp,sp,-48
  98:	02112623          	sw	ra,44(sp)
  9c:	00a12623          	sw	a0,12(sp)
  a0:	00b12423          	sw	a1,8(sp)
  a4:	00c12223          	sw	a2,4(sp)
  a8:	00d12023          	sw	a3,0(sp)
  ac:	00812783          	lw	a5,8(sp)
  b0:	0607ca63          	bltz	a5,124 <st7735_triangle_fill_span+0x90>
  b4:	00812703          	lw	a4,8(sp)
  b8:	09f00793          	li	a5,159
  bc:	06e7c463          	blt	a5,a4,124 <st7735_triangle_fill_span+0x90>
  c0:	00412703          	lw	a4,4(sp)
  c4:	00012783          	lw	a5,0(sp)
  c8:	00e7de63          	bge	a5,a4,e4 <st7735_triangle_fill_span+0x50>
  cc:	00412783          	lw	a5,4(sp)
  d0:	00f12e23          	sw	a5,28(sp)
  d4:	00012783          	lw	a5,0(sp)
  d8:	00f12223          	sw	a5,4(sp)
  dc:	01c12783          	lw	a5,28(sp)
  e0:	00f12023          	sw	a5,0(sp)
  e4:	00412783          	lw	a5,4(sp)
  e8:	0007d463          	bgez	a5,f0 <st7735_triangle_fill_span+0x5c>
  ec:	00000793          	li	a5,0
  f0:	00f12223          	sw	a5,4(sp)
  f4:	00012783          	lw	a5,0(sp)
  f8:	07f00713          	li	a4,127
  fc:	00f75463          	bge	a4,a5,104 <st7735_triangle_fill_span+0x70>
 100:	07f00793          	li	a5,127
 104:	00f12023          	sw	a5,0(sp)
 108:	00812703          	lw	a4,8(sp)
 10c:	00012683          	lw	a3,0(sp)
 110:	00812603          	lw	a2,8(sp)
 114:	00412583          	lw	a1,4(sp)
 118:	00c12503          	lw	a0,12(sp)
 11c:	2d0000ef          	jal	3ec <st7735_draw_line>
 120:	0080006f          	j	128 <st7735_triangle_fill_span+0x94>
 124:	00000013          	nop
 128:	02c12083          	lw	ra,44(sp)
 12c:	03010113          	addi	sp,sp,48
 130:	00008067          	ret

00000134 <st7735_triangle_edge_x>:
 134:	fe010113          	addi	sp,sp,-32
 138:	00a12e23          	sw	a0,28(sp)
 13c:	00b12c23          	sw	a1,24(sp)
 140:	00c12a23          	sw	a2,20(sp)
 144:	00d12823          	sw	a3,16(sp)
 148:	00e12623          	sw	a4,12(sp)
 14c:	01412703          	lw	a4,20(sp)
 150:	00c12783          	lw	a5,12(sp)
 154:	00f71663          	bne	a4,a5,160 <st7735_triangle_edge_x+0x2c>
 158:	01812783          	lw	a5,24(sp)
 15c:	0380006f          	j	194 <st7735_triangle_edge_x+0x60>
 160:	01012703          	lw	a4,16(sp)
 164:	01812783          	lw	a5,24(sp)
 168:	40f70733          	sub	a4,a4,a5
 16c:	01c12683          	lw	a3,28(sp)
 170:	01412783          	lw	a5,20(sp)
 174:	40f687b3          	sub	a5,a3,a5
 178:	02f70733          	mul	a4,a4,a5
 17c:	00c12683          	lw	a3,12(sp)
 180:	01412783          	lw	a5,20(sp)
 184:	40f687b3          	sub	a5,a3,a5
 188:	02f74733          	div	a4,a4,a5
 18c:	01812783          	lw	a5,24(sp)
 190:	00f707b3          	add	a5,a4,a5
 194:	00078513          	mv	a0,a5
 198:	02010113          	addi	sp,sp,32
 19c:	00008067          	ret

000001a0 <st7735_draw_triangle>:
 1a0:	f8010113          	addi	sp,sp,-128
 1a4:	06112e23          	sw	ra,124(sp)
 1a8:	00a12e23          	sw	a0,28(sp)
 1ac:	00b12c23          	sw	a1,24(sp)
 1b0:	00c12a23          	sw	a2,20(sp)
 1b4:	00d12823          	sw	a3,16(sp)
 1b8:	00e12623          	sw	a4,12(sp)
 1bc:	00f12423          	sw	a5,8(sp)
 1c0:	01012223          	sw	a6,4(sp)
 1c4:	01112023          	sw	a7,0(sp)
 1c8:	01812783          	lw	a5,24(sp)
 1cc:	04078863          	beqz	a5,21c <st7735_draw_triangle+0x7c>
 1d0:	00812703          	lw	a4,8(sp)
 1d4:	00c12683          	lw	a3,12(sp)
 1d8:	01012603          	lw	a2,16(sp)
 1dc:	01412583          	lw	a1,20(sp)
 1e0:	01c12503          	lw	a0,28(sp)
 1e4:	208000ef          	jal	3ec <st7735_draw_line>
 1e8:	00012703          	lw	a4,0(sp)
 1ec:	00412683          	lw	a3,4(sp)
 1f0:	01012603          	lw	a2,16(sp)
 1f4:	01412583          	lw	a1,20(sp)
 1f8:	01c12503          	lw	a0,28(sp)
 1fc:	1f0000ef          	jal	3ec <st7735_draw_line>
 200:	00012703          	lw	a4,0(sp)
 204:	00412683          	lw	a3,4(sp)
 208:	00812603          	lw	a2,8(sp)
 20c:	00c12583          	lw	a1,12(sp)
 210:	01c12503          	lw	a0,28(sp)
 214:	1d8000ef          	jal	3ec <st7735_draw_line>
 218:	1c80006f          	j	3e0 <st7735_draw_triangle+0x240>
 21c:	01412783          	lw	a5,20(sp)
 220:	06f12623          	sw	a5,108(sp)
 224:	01012783          	lw	a5,16(sp)
 228:	06f12423          	sw	a5,104(sp)
 22c:	00c12783          	lw	a5,12(sp)
 230:	06f12223          	sw	a5,100(sp)
 234:	00812783          	lw	a5,8(sp)
 238:	06f12023          	sw	a5,96(sp)
 23c:	00412783          	lw	a5,4(sp)
 240:	04f12e23          	sw	a5,92(sp)
 244:	00012783          	lw	a5,0(sp)
 248:	04f12c23          	sw	a5,88(sp)
 24c:	06812703          	lw	a4,104(sp)
 250:	06012783          	lw	a5,96(sp)
 254:	02e7da63          	bge	a5,a4,288 <st7735_draw_triangle+0xe8>
 258:	06c12783          	lw	a5,108(sp)
 25c:	04f12623          	sw	a5,76(sp)
 260:	06412783          	lw	a5,100(sp)
 264:	06f12623          	sw	a5,108(sp)
 268:	04c12783          	lw	a5,76(sp)
 26c:	06f12223          	sw	a5,100(sp)
 270:	06812783          	lw	a5,104(sp)
 274:	04f12423          	sw	a5,72(sp)
 278:	06012783          	lw	a5,96(sp)
 27c:	06f12423          	sw	a5,104(sp)
 280:	04812783          	lw	a5,72(sp)
 284:	06f12023          	sw	a5,96(sp)
 288:	06812703          	lw	a4,104(sp)
 28c:	05812783          	lw	a5,88(sp)
 290:	02e7da63          	bge	a5,a4,2c4 <st7735_draw_triangle+0x124>
 294:	06c12783          	lw	a5,108(sp)
 298:	04f12223          	sw	a5,68(sp)
 29c:	05c12783          	lw	a5,92(sp)
 2a0:	06f12623          	sw	a5,108(sp)
 2a4:	04412783          	lw	a5,68(sp)
 2a8:	04f12e23          	sw	a5,92(sp)
 2ac:	06812783          	lw	a5,104(sp)
 2b0:	04f12023          	sw	a5,64(sp)
 2b4:	05812783          	lw	a5,88(sp)
 2b8:	06f12423          	sw	a5,104(sp)
 2bc:	04012783          	lw	a5,64(sp)
 2c0:	04f12c23          	sw	a5,88(sp)
 2c4:	06012703          	lw	a4,96(sp)
 2c8:	05812783          	lw	a5,88(sp)
 2cc:	02e7da63          	bge	a5,a4,300 <st7735_draw_triangle+0x160>
 2d0:	06412783          	lw	a5,100(sp)
 2d4:	02f12e23          	sw	a5,60(sp)
 2d8:	05c12783          	lw	a5,92(sp)
 2dc:	06f12223          	sw	a5,100(sp)
 2e0:	03c12783          	lw	a5,60(sp)
 2e4:	04f12e23          	sw	a5,92(sp)
 2e8:	06012783          	lw	a5,96(sp)
 2ec:	02f12c23          	sw	a5,56(sp)
 2f0:	05812783          	lw	a5,88(sp)
 2f4:	06f12023          	sw	a5,96(sp)
 2f8:	03812783          	lw	a5,56(sp)
 2fc:	04f12c23          	sw	a5,88(sp)
 300:	06812783          	lw	a5,104(sp)
 304:	04f12a23          	sw	a5,84(sp)
 308:	05c0006f          	j	364 <st7735_draw_triangle+0x1c4>
 30c:	05812703          	lw	a4,88(sp)
 310:	05c12683          	lw	a3,92(sp)
 314:	06812603          	lw	a2,104(sp)
 318:	06c12583          	lw	a1,108(sp)
 31c:	05412503          	lw	a0,84(sp)
 320:	e15ff0ef          	jal	134 <st7735_triangle_edge_x>
 324:	02a12623          	sw	a0,44(sp)
 328:	06012703          	lw	a4,96(sp)
 32c:	06412683          	lw	a3,100(sp)
 330:	06812603          	lw	a2,104(sp)
 334:	06c12583          	lw	a1,108(sp)
 338:	05412503          	lw	a0,84(sp)
 33c:	df9ff0ef          	jal	134 <st7735_triangle_edge_x>
 340:	02a12423          	sw	a0,40(sp)
 344:	02812683          	lw	a3,40(sp)
 348:	02c12603          	lw	a2,44(sp)
 34c:	05412583          	lw	a1,84(sp)
 350:	01c12503          	lw	a0,28(sp)
 354:	d41ff0ef          	jal	94 <st7735_triangle_fill_span>
 358:	05412783          	lw	a5,84(sp)
 35c:	00178793          	addi	a5,a5,1
 360:	04f12a23          	sw	a5,84(sp)
 364:	05412703          	lw	a4,84(sp)
 368:	06012783          	lw	a5,96(sp)
 36c:	fae7d0e3          	bge	a5,a4,30c <st7735_draw_triangle+0x16c>
 370:	06012783          	lw	a5,96(sp)
 374:	04f12823          	sw	a5,80(sp)
 378:	05c0006f          	j	3d4 <st7735_draw_triangle+0x234>
 37c:	05812703          	lw	a4,88(sp)
 380:	05c12683          	lw	a3,92(sp)
 384:	06812603          	lw	a2,104(sp)
 388:	06c12583          	lw	a1,108(sp)
 38c:	05012503          	lw	a0,80(sp)
 390:	da5ff0ef          	jal	134 <st7735_triangle_edge_x>
 394:	02a12a23          	sw	a0,52(sp)
 398:	05812703          	lw	a4,88(sp)
 39c:	05c12683          	lw	a3,92(sp)
 3a0:	06012603          	lw	a2,96(sp)
 3a4:	06412583          	lw	a1,100(sp)
 3a8:	05012503          	lw	a0,80(sp)
 3ac:	d89ff0ef          	jal	134 <st7735_triangle_edge_x>
 3b0:	02a12823          	sw	a0,48(sp)
 3b4:	03012683          	lw	a3,48(sp)
 3b8:	03412603          	lw	a2,52(sp)
 3bc:	05012583          	lw	a1,80(sp)
 3c0:	01c12503          	lw	a0,28(sp)
 3c4:	cd1ff0ef          	jal	94 <st7735_triangle_fill_span>
 3c8:	05012783          	lw	a5,80(sp)
 3cc:	00178793          	addi	a5,a5,1
 3d0:	04f12823          	sw	a5,80(sp)
 3d4:	05012703          	lw	a4,80(sp)
 3d8:	05812783          	lw	a5,88(sp)
 3dc:	fae7d0e3          	bge	a5,a4,37c <st7735_draw_triangle+0x1dc>
 3e0:	07c12083          	lw	ra,124(sp)
 3e4:	08010113          	addi	sp,sp,128
 3e8:	00008067          	ret

000003ec <st7735_draw_line>:
 3ec:	fa010113          	addi	sp,sp,-96
 3f0:	04112e23          	sw	ra,92(sp)
 3f4:	00a12e23          	sw	a0,28(sp)
 3f8:	00b12c23          	sw	a1,24(sp)
 3fc:	00c12a23          	sw	a2,20(sp)
 400:	00d12823          	sw	a3,16(sp)
 404:	00e12623          	sw	a4,12(sp)
 408:	01812783          	lw	a5,24(sp)
 40c:	04f12623          	sw	a5,76(sp)
 410:	01412783          	lw	a5,20(sp)
 414:	04f12423          	sw	a5,72(sp)
 418:	01012783          	lw	a5,16(sp)
 41c:	02f12c23          	sw	a5,56(sp)
 420:	00c12783          	lw	a5,12(sp)
 424:	02f12a23          	sw	a5,52(sp)
 428:	03812703          	lw	a4,56(sp)
 42c:	04c12783          	lw	a5,76(sp)
 430:	40f70733          	sub	a4,a4,a5
 434:	41f75793          	srai	a5,a4,0x1f
 438:	00e7c733          	xor	a4,a5,a4
 43c:	40f707b3          	sub	a5,a4,a5
 440:	02f12823          	sw	a5,48(sp)
 444:	04c12703          	lw	a4,76(sp)
 448:	03812783          	lw	a5,56(sp)
 44c:	00f75863          	bge	a4,a5,45c <st7735_draw_line+0x70>
 450:	00100793          	li	a5,1
 454:	04f12223          	sw	a5,68(sp)
 458:	00c0006f          	j	464 <st7735_draw_line+0x78>
 45c:	fff00793          	li	a5,-1
 460:	04f12223          	sw	a5,68(sp)
 464:	03412703          	lw	a4,52(sp)
 468:	04812783          	lw	a5,72(sp)
 46c:	40f707b3          	sub	a5,a4,a5
 470:	41f7d713          	srai	a4,a5,0x1f
 474:	00f747b3          	xor	a5,a4,a5
 478:	40e787b3          	sub	a5,a5,a4
 47c:	40f007b3          	neg	a5,a5
 480:	02f12623          	sw	a5,44(sp)
 484:	04812703          	lw	a4,72(sp)
 488:	03412783          	lw	a5,52(sp)
 48c:	00f75863          	bge	a4,a5,49c <st7735_draw_line+0xb0>
 490:	00100793          	li	a5,1
 494:	04f12023          	sw	a5,64(sp)
 498:	00c0006f          	j	4a4 <st7735_draw_line+0xb8>
 49c:	fff00793          	li	a5,-1
 4a0:	04f12023          	sw	a5,64(sp)
 4a4:	03012703          	lw	a4,48(sp)
 4a8:	02c12783          	lw	a5,44(sp)
 4ac:	00f707b3          	add	a5,a4,a5
 4b0:	02f12e23          	sw	a5,60(sp)
 4b4:	04812603          	lw	a2,72(sp)
 4b8:	04c12583          	lw	a1,76(sp)
 4bc:	01c12503          	lw	a0,28(sp)
 4c0:	b91ff0ef          	jal	50 <st7735_draw_pixel>
 4c4:	04c12703          	lw	a4,76(sp)
 4c8:	03812783          	lw	a5,56(sp)
 4cc:	00f71863          	bne	a4,a5,4dc <st7735_draw_line+0xf0>
 4d0:	04812703          	lw	a4,72(sp)
 4d4:	03412783          	lw	a5,52(sp)
 4d8:	06f70663          	beq	a4,a5,544 <st7735_draw_line+0x158>
 4dc:	03c12783          	lw	a5,60(sp)
 4e0:	00179793          	slli	a5,a5,0x1
 4e4:	02f12423          	sw	a5,40(sp)
 4e8:	02812703          	lw	a4,40(sp)
 4ec:	02c12783          	lw	a5,44(sp)
 4f0:	02f74263          	blt	a4,a5,514 <st7735_draw_line+0x128>
 4f4:	03c12703          	lw	a4,60(sp)
 4f8:	02c12783          	lw	a5,44(sp)
 4fc:	00f707b3          	add	a5,a4,a5
 500:	02f12e23          	sw	a5,60(sp)
 504:	04c12703          	lw	a4,76(sp)
 508:	04412783          	lw	a5,68(sp)
 50c:	00f707b3          	add	a5,a4,a5
 510:	04f12623          	sw	a5,76(sp)
 514:	02812703          	lw	a4,40(sp)
 518:	03012783          	lw	a5,48(sp)
 51c:	f8e7cce3          	blt	a5,a4,4b4 <st7735_draw_line+0xc8>
 520:	03c12703          	lw	a4,60(sp)
 524:	03012783          	lw	a5,48(sp)
 528:	00f707b3          	add	a5,a4,a5
 52c:	02f12e23          	sw	a5,60(sp)
 530:	04812703          	lw	a4,72(sp)
 534:	04012783          	lw	a5,64(sp)
 538:	00f707b3          	add	a5,a4,a5
 53c:	04f12423          	sw	a5,72(sp)
 540:	f75ff06f          	j	4b4 <st7735_draw_line+0xc8>
 544:	00000013          	nop
 548:	00000013          	nop
 54c:	05c12083          	lw	ra,92(sp)
 550:	06010113          	addi	sp,sp,96
 554:	00008067          	ret

00000558 <st7735_stream_pixel>:
 558:	fe010113          	addi	sp,sp,-32
 55c:	00a12623          	sw	a0,12(sp)
 560:	00b12423          	sw	a1,8(sp)
 564:	f00007b7          	lui	a5,0xf0000
 568:	00f12e23          	sw	a5,28(sp)
 56c:	f00007b7          	lui	a5,0xf0000
 570:	00478793          	addi	a5,a5,4 # f0000004 <st7735_set_rectangle+0xeffffa58>
 574:	00f12c23          	sw	a5,24(sp)
 578:	00812703          	lw	a4,8(sp)
 57c:	2c0007b7          	lui	a5,0x2c000
 580:	00f767b3          	or	a5,a4,a5
 584:	00f12a23          	sw	a5,20(sp)
 588:	01412783          	lw	a5,20(sp)
 58c:	01812703          	lw	a4,24(sp)
 590:	00f72023          	sw	a5,0(a4)
 594:	00c12783          	lw	a5,12(sp)
 598:	01c12703          	lw	a4,28(sp)
 59c:	00f72023          	sw	a5,0(a4)
 5a0:	00000013          	nop
 5a4:	02010113          	addi	sp,sp,32
 5a8:	00008067          	ret

000005ac <st7735_set_rectangle>:
 5ac:	fe010113          	addi	sp,sp,-32
 5b0:	00a12623          	sw	a0,12(sp)
 5b4:	00b12423          	sw	a1,8(sp)
 5b8:	00c12223          	sw	a2,4(sp)
 5bc:	00d12023          	sw	a3,0(sp)
 5c0:	f00007b7          	lui	a5,0xf0000
 5c4:	00478793          	addi	a5,a5,4 # f0000004 <st7735_set_rectangle+0xeffffa58>
 5c8:	00f12e23          	sw	a5,28(sp)
 5cc:	00c12783          	lw	a5,12(sp)
 5d0:	01079713          	slli	a4,a5,0x10
 5d4:	00ff07b7          	lui	a5,0xff0
 5d8:	00f77733          	and	a4,a4,a5
 5dc:	2a0007b7          	lui	a5,0x2a000
 5e0:	00f76733          	or	a4,a4,a5
 5e4:	00412783          	lw	a5,4(sp)
 5e8:	00879793          	slli	a5,a5,0x8
 5ec:	01079793          	slli	a5,a5,0x10
 5f0:	0107d793          	srli	a5,a5,0x10
 5f4:	00f767b3          	or	a5,a4,a5
 5f8:	00f12c23          	sw	a5,24(sp)
 5fc:	00812783          	lw	a5,8(sp)
 600:	01079713          	slli	a4,a5,0x10
 604:	00ff07b7          	lui	a5,0xff0
 608:	00f77733          	and	a4,a4,a5
 60c:	2b0007b7          	lui	a5,0x2b000
 610:	00f76733          	or	a4,a4,a5
 614:	00012783          	lw	a5,0(sp)
 618:	00879793          	slli	a5,a5,0x8
 61c:	01079793          	slli	a5,a5,0x10
 620:	0107d793          	srli	a5,a5,0x10
 624:	00f767b3          	or	a5,a4,a5
 628:	00f12a23          	sw	a5,20(sp)
 62c:	01812783          	lw	a5,24(sp)
 630:	01412703          	lw	a4,20(sp)
 634:	01c12683          	lw	a3,28(sp)
 638:	00f6a023          	sw	a5,0(a3)
 63c:	00e6a023          	sw	a4,0(a3)
 640:	00000013          	nop
 644:	02010113          	addi	sp,sp,32
 648:	00008067          	ret
