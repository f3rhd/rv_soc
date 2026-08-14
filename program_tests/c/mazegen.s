
__out_tmp.elf:     file format elf32-littleriscv


Disassembly of section .text:

00000000 <_start>:
   0:	00008137          	lui	sp,0x8
   4:	688000ef          	jal	68c <main>

00000008 <halt_loop>:
   8:	0000006f          	j	8 <halt_loop>

0000000c <delay>:
   c:	ff010113          	addi	sp,sp,-16 # 7ff0 <seg_write_hex+0x77f0>
  10:	00012623          	sw	zero,12(sp)
  14:	00c12783          	lw	a5,12(sp)
  18:	00a7e663          	bltu	a5,a0,24 <delay+0x18>
  1c:	01010113          	addi	sp,sp,16
  20:	00008067          	ret
  24:	00c12783          	lw	a5,12(sp)
  28:	00178793          	addi	a5,a5,1
  2c:	00f12623          	sw	a5,12(sp)
  30:	fe5ff06f          	j	14 <delay+0x8>

00000034 <rand_next>:
  34:	00052783          	lw	a5,0(a0)
  38:	41c65737          	lui	a4,0x41c65
  3c:	e6d70713          	addi	a4,a4,-403 # 41c64e6d <seg_write_hex+0x41c6466d>
  40:	02e787b3          	mul	a5,a5,a4
  44:	00003737          	lui	a4,0x3
  48:	03970713          	addi	a4,a4,57 # 3039 <seg_write_hex+0x2839>
  4c:	00e787b3          	add	a5,a5,a4
  50:	00179713          	slli	a4,a5,0x1
  54:	00f52023          	sw	a5,0(a0)
  58:	01175513          	srli	a0,a4,0x11
  5c:	00008067          	ret

00000060 <dir_dx>:
  60:	00100793          	li	a5,1
  64:	00f50863          	beq	a0,a5,74 <dir_dx+0x14>
  68:	ffd50513          	addi	a0,a0,-3
  6c:	00153513          	seqz	a0,a0
  70:	40a00533          	neg	a0,a0
  74:	00008067          	ret

00000078 <draw_cell>:
  78:	ff010113          	addi	sp,sp,-16
  7c:	00812423          	sw	s0,8(sp)
  80:	00912223          	sw	s1,4(sp)
  84:	00800713          	li	a4,8
  88:	00359413          	slli	s0,a1,0x3
  8c:	00361493          	slli	s1,a2,0x3
  90:	01212023          	sw	s2,0(sp)
  94:	00048613          	mv	a2,s1
  98:	00050913          	mv	s2,a0
  9c:	00040593          	mv	a1,s0
  a0:	00068513          	mv	a0,a3
  a4:	00070693          	mv	a3,a4
  a8:	00112623          	sw	ra,12(sp)
  ac:	6cc000ef          	jal	778 <st7735_draw_rectangle>
  b0:	00197793          	andi	a5,s2,1
  b4:	00078e63          	beqz	a5,d0 <draw_cell+0x58>
  b8:	00100713          	li	a4,1
  bc:	00800693          	li	a3,8
  c0:	00048613          	mv	a2,s1
  c4:	00040593          	mv	a1,s0
  c8:	00000513          	li	a0,0
  cc:	6ac000ef          	jal	778 <st7735_draw_rectangle>
  d0:	00497793          	andi	a5,s2,4
  d4:	00078e63          	beqz	a5,f0 <draw_cell+0x78>
  d8:	00100713          	li	a4,1
  dc:	00800693          	li	a3,8
  e0:	00748613          	addi	a2,s1,7
  e4:	00040593          	mv	a1,s0
  e8:	00000513          	li	a0,0
  ec:	68c000ef          	jal	778 <st7735_draw_rectangle>
  f0:	00897793          	andi	a5,s2,8
  f4:	00078e63          	beqz	a5,110 <draw_cell+0x98>
  f8:	00800713          	li	a4,8
  fc:	00100693          	li	a3,1
 100:	00048613          	mv	a2,s1
 104:	00040593          	mv	a1,s0
 108:	00000513          	li	a0,0
 10c:	66c000ef          	jal	778 <st7735_draw_rectangle>
 110:	00297913          	andi	s2,s2,2
 114:	02090863          	beqz	s2,144 <draw_cell+0xcc>
 118:	00740593          	addi	a1,s0,7
 11c:	00812403          	lw	s0,8(sp)
 120:	00c12083          	lw	ra,12(sp)
 124:	00012903          	lw	s2,0(sp)
 128:	00048613          	mv	a2,s1
 12c:	00412483          	lw	s1,4(sp)
 130:	00800713          	li	a4,8
 134:	00100693          	li	a3,1
 138:	00000513          	li	a0,0
 13c:	01010113          	addi	sp,sp,16
 140:	6380006f          	j	778 <st7735_draw_rectangle>
 144:	00c12083          	lw	ra,12(sp)
 148:	00812403          	lw	s0,8(sp)
 14c:	00412483          	lw	s1,4(sp)
 150:	00012903          	lw	s2,0(sp)
 154:	01010113          	addi	sp,sp,16
 158:	00008067          	ret

0000015c <generate_maze>:
 15c:	81010113          	addi	sp,sp,-2032
 160:	7f212023          	sw	s2,2016(sp)
 164:	7da12023          	sw	s10,1984(sp)
 168:	7e112623          	sw	ra,2028(sp)
 16c:	7e812423          	sw	s0,2024(sp)
 170:	7e912223          	sw	s1,2020(sp)
 174:	7d312e23          	sw	s3,2012(sp)
 178:	7d412c23          	sw	s4,2008(sp)
 17c:	7d512a23          	sw	s5,2004(sp)
 180:	7d612823          	sw	s6,2000(sp)
 184:	7d712623          	sw	s7,1996(sp)
 188:	7d812423          	sw	s8,1992(sp)
 18c:	7d912223          	sw	s9,1988(sp)
 190:	c6010113          	addi	sp,sp,-928
 194:	00050913          	mv	s2,a0
 198:	00058d13          	mv	s10,a1
 19c:	00000793          	li	a5,0
 1a0:	00f00513          	li	a0,15
 1a4:	02010693          	addi	a3,sp,32
 1a8:	01000813          	li	a6,16
 1ac:	14000893          	li	a7,320
 1b0:	00f905b3          	add	a1,s2,a5
 1b4:	00000713          	li	a4,0
 1b8:	00f68633          	add	a2,a3,a5
 1bc:	00e58333          	add	t1,a1,a4
 1c0:	00a30023          	sb	a0,0(t1)
 1c4:	00e60333          	add	t1,a2,a4
 1c8:	00030023          	sb	zero,0(t1)
 1cc:	00170713          	addi	a4,a4,1
 1d0:	ff0716e3          	bne	a4,a6,1bc <generate_maze+0x60>
 1d4:	01078793          	addi	a5,a5,16
 1d8:	fd179ce3          	bne	a5,a7,1b0 <generate_maze+0x54>
 1dc:	00094503          	lbu	a0,0(s2)
 1e0:	07ff06b7          	lui	a3,0x7ff0
 1e4:	00100493          	li	s1,1
 1e8:	7ff68693          	addi	a3,a3,2047 # 7ff07ff <seg_write_hex+0x7feffff>
 1ec:	00000613          	li	a2,0
 1f0:	00000593          	li	a1,0
 1f4:	b6010a93          	addi	s5,sp,-1184
 1f8:	4c9a8023          	sb	s1,1216(s5)
 1fc:	600aa023          	sw	zero,1536(s5)
 200:	600aa223          	sw	zero,1540(s5)
 204:	00400a13          	li	s4,4
 208:	e71ff0ef          	jal	78 <draw_cell>
 20c:	00048993          	mv	s3,s1
 210:	fff48413          	addi	s0,s1,-1
 214:	00341793          	slli	a5,s0,0x3
 218:	00fa87b3          	add	a5,s5,a5
 21c:	6007a583          	lw	a1,1536(a5)
 220:	6047a603          	lw	a2,1540(a5)
 224:	00000b13          	li	s6,0
 228:	00000c13          	li	s8,0
 22c:	000b0513          	mv	a0,s6
 230:	00b12623          	sw	a1,12(sp)
 234:	00c12423          	sw	a2,8(sp)
 238:	e29ff0ef          	jal	60 <dir_dx>
 23c:	00c12583          	lw	a1,12(sp)
 240:	00812603          	lw	a2,8(sp)
 244:	fff00793          	li	a5,-1
 248:	00b50533          	add	a0,a0,a1
 24c:	000b0663          	beqz	s6,258 <generate_maze+0xfc>
 250:	ffeb0793          	addi	a5,s6,-2
 254:	0017b793          	seqz	a5,a5
 258:	01053713          	sltiu	a4,a0,16
 25c:	00f607b3          	add	a5,a2,a5
 260:	02070863          	beqz	a4,290 <generate_maze+0x134>
 264:	0147b713          	sltiu	a4,a5,20
 268:	02070463          	beqz	a4,290 <generate_maze+0x134>
 26c:	00479793          	slli	a5,a5,0x4
 270:	00fa87b3          	add	a5,s5,a5
 274:	00a787b3          	add	a5,a5,a0
 278:	4c07c783          	lbu	a5,1216(a5)
 27c:	00079a63          	bnez	a5,290 <generate_maze+0x134>
 280:	002c1793          	slli	a5,s8,0x2
 284:	00fa87b3          	add	a5,s5,a5
 288:	4b67a823          	sw	s6,1200(a5)
 28c:	001c0c13          	addi	s8,s8,1
 290:	001b0b13          	addi	s6,s6,1
 294:	f94b1ce3          	bne	s6,s4,22c <generate_maze+0xd0>
 298:	00461b93          	slli	s7,a2,0x4
 29c:	01790bb3          	add	s7,s2,s7
 2a0:	00bb8bb3          	add	s7,s7,a1
 2a4:	080c1863          	bnez	s8,334 <generate_maze+0x1d8>
 2a8:	000bc503          	lbu	a0,0(s7)
 2ac:	fff00693          	li	a3,-1
 2b0:	dc9ff0ef          	jal	78 <draw_cell>
 2b4:	16041063          	bnez	s0,414 <generate_maze+0x2b8>
 2b8:	00000493          	li	s1,0
 2bc:	01000a13          	li	s4,16
 2c0:	01400a93          	li	s5,20
 2c4:	00449993          	slli	s3,s1,0x4
 2c8:	013909b3          	add	s3,s2,s3
 2cc:	00000413          	li	s0,0
 2d0:	008987b3          	add	a5,s3,s0
 2d4:	0007c503          	lbu	a0,0(a5)
 2d8:	00040593          	mv	a1,s0
 2dc:	fff00693          	li	a3,-1
 2e0:	00048613          	mv	a2,s1
 2e4:	00140413          	addi	s0,s0,1
 2e8:	d91ff0ef          	jal	78 <draw_cell>
 2ec:	ff4412e3          	bne	s0,s4,2d0 <generate_maze+0x174>
 2f0:	00148493          	addi	s1,s1,1
 2f4:	fd5498e3          	bne	s1,s5,2c4 <generate_maze+0x168>
 2f8:	3a010113          	addi	sp,sp,928
 2fc:	7ec12083          	lw	ra,2028(sp)
 300:	7e812403          	lw	s0,2024(sp)
 304:	7e412483          	lw	s1,2020(sp)
 308:	7e012903          	lw	s2,2016(sp)
 30c:	7dc12983          	lw	s3,2012(sp)
 310:	7d812a03          	lw	s4,2008(sp)
 314:	7d412a83          	lw	s5,2004(sp)
 318:	7d012b03          	lw	s6,2000(sp)
 31c:	7cc12b83          	lw	s7,1996(sp)
 320:	7c812c03          	lw	s8,1992(sp)
 324:	7c412c83          	lw	s9,1988(sp)
 328:	7c012d03          	lw	s10,1984(sp)
 32c:	7f010113          	addi	sp,sp,2032
 330:	00008067          	ret
 334:	000d0513          	mv	a0,s10
 338:	00b12623          	sw	a1,12(sp)
 33c:	00c12423          	sw	a2,8(sp)
 340:	cf5ff0ef          	jal	34 <rand_next>
 344:	03857533          	remu	a0,a0,s8
 348:	fff00b13          	li	s6,-1
 34c:	00251513          	slli	a0,a0,0x2
 350:	00aa8533          	add	a0,s5,a0
 354:	4b052403          	lw	s0,1200(a0)
 358:	00040513          	mv	a0,s0
 35c:	d05ff0ef          	jal	60 <dir_dx>
 360:	00c12583          	lw	a1,12(sp)
 364:	00812603          	lw	a2,8(sp)
 368:	00b50c33          	add	s8,a0,a1
 36c:	00040663          	beqz	s0,378 <generate_maze+0x21c>
 370:	ffe40b13          	addi	s6,s0,-2
 374:	001b3b13          	seqz	s6,s6
 378:	000bc703          	lbu	a4,0(s7)
 37c:	008997b3          	sll	a5,s3,s0
 380:	01660b33          	add	s6,a2,s6
 384:	fff7c793          	not	a5,a5
 388:	00e7f7b3          	and	a5,a5,a4
 38c:	004b1713          	slli	a4,s6,0x4
 390:	00e90cb3          	add	s9,s2,a4
 394:	00fb8023          	sb	a5,0(s7)
 398:	018c8cb3          	add	s9,s9,s8
 39c:	00240793          	addi	a5,s0,2
 3a0:	000cc683          	lbu	a3,0(s9)
 3a4:	0037f793          	andi	a5,a5,3
 3a8:	00f997b3          	sll	a5,s3,a5
 3ac:	fff7c793          	not	a5,a5
 3b0:	00ea8733          	add	a4,s5,a4
 3b4:	00d7f7b3          	and	a5,a5,a3
 3b8:	01870733          	add	a4,a4,s8
 3bc:	00fc8023          	sb	a5,0(s9)
 3c0:	4d370023          	sb	s3,1216(a4)
 3c4:	000bc503          	lbu	a0,0(s7)
 3c8:	00148413          	addi	s0,s1,1
 3cc:	07ff06b7          	lui	a3,0x7ff0
 3d0:	00349493          	slli	s1,s1,0x3
 3d4:	009a84b3          	add	s1,s5,s1
 3d8:	7ff68693          	addi	a3,a3,2047 # 7ff07ff <seg_write_hex+0x7feffff>
 3dc:	6184a023          	sw	s8,1536(s1)
 3e0:	6164a223          	sw	s6,1540(s1)
 3e4:	c95ff0ef          	jal	78 <draw_cell>
 3e8:	000cc503          	lbu	a0,0(s9)
 3ec:	07ff06b7          	lui	a3,0x7ff0
 3f0:	7ff68693          	addi	a3,a3,2047 # 7ff07ff <seg_write_hex+0x7feffff>
 3f4:	000b0613          	mv	a2,s6
 3f8:	000c0593          	mv	a1,s8
 3fc:	c7dff0ef          	jal	78 <draw_cell>
 400:	00040513          	mv	a0,s0
 404:	3fc000ef          	jal	800 <seg_write_hex>
 408:	00001537          	lui	a0,0x1
 40c:	fa050513          	addi	a0,a0,-96 # fa0 <seg_write_hex+0x7a0>
 410:	bfdff0ef          	jal	c <delay>
 414:	00040493          	mv	s1,s0
 418:	df9ff06f          	j	210 <generate_maze+0xb4>

0000041c <solve_maze>:
 41c:	f8010113          	addi	sp,sp,-128
 420:	07312623          	sw	s3,108(sp)
 424:	06112e23          	sw	ra,124(sp)
 428:	06812c23          	sw	s0,120(sp)
 42c:	06912a23          	sw	s1,116(sp)
 430:	07212823          	sw	s2,112(sp)
 434:	07412423          	sw	s4,104(sp)
 438:	07512223          	sw	s5,100(sp)
 43c:	07612023          	sw	s6,96(sp)
 440:	05712e23          	sw	s7,92(sp)
 444:	05812c23          	sw	s8,88(sp)
 448:	05912a23          	sw	s9,84(sp)
 44c:	05a12823          	sw	s10,80(sp)
 450:	05b12623          	sw	s11,76(sp)
 454:	80010113          	addi	sp,sp,-2048
 458:	80010113          	addi	sp,sp,-2048
 45c:	14010793          	addi	a5,sp,320
 460:	00050993          	mv	s3,a0
 464:	00010713          	mv	a4,sp
 468:	50078593          	addi	a1,a5,1280
 46c:	fff00513          	li	a0,-1
 470:	01000813          	li	a6,16
 474:	00078613          	mv	a2,a5
 478:	00000693          	li	a3,0
 47c:	00d708b3          	add	a7,a4,a3
 480:	00a62023          	sw	a0,0(a2)
 484:	00088023          	sb	zero,0(a7)
 488:	00168693          	addi	a3,a3,1
 48c:	00460613          	addi	a2,a2,4
 490:	ff0696e3          	bne	a3,a6,47c <solve_maze+0x60>
 494:	04078793          	addi	a5,a5,64
 498:	01070713          	addi	a4,a4,16
 49c:	fcf59ce3          	bne	a1,a5,474 <solve_maze+0x58>
 4a0:	00100493          	li	s1,1
 4a4:	04010413          	addi	s0,sp,64
 4a8:	64010c93          	addi	s9,sp,1600
 4ac:	00000a13          	li	s4,0
 4b0:	00000d93          	li	s11,0
 4b4:	00048b13          	mv	s6,s1
 4b8:	fc940023          	sb	s1,-64(s0)
 4bc:	60042023          	sw	zero,1536(s0)
 4c0:	60042223          	sw	zero,1540(s0)
 4c4:	000cad03          	lw	s10,0(s9)
 4c8:	004cac03          	lw	s8,4(s9)
 4cc:	ff1d0793          	addi	a5,s10,-15
 4d0:	0e079063          	bnez	a5,5b0 <solve_maze+0x194>
 4d4:	fedc0793          	addi	a5,s8,-19
 4d8:	0c079c63          	bnez	a5,5b0 <solve_maze+0x194>
 4dc:	00000913          	li	s2,0
 4e0:	13f00493          	li	s1,319
 4e4:	01000a93          	li	s5,16
 4e8:	fff00b13          	li	s6,-1
 4ec:	0354c633          	div	a2,s1,s5
 4f0:	001f06b7          	lui	a3,0x1f0
 4f4:	01f68693          	addi	a3,a3,31 # 1f001f <seg_write_hex+0x1ef81f>
 4f8:	00190913          	addi	s2,s2,1
 4fc:	0354ea33          	rem	s4,s1,s5
 500:	00461493          	slli	s1,a2,0x4
 504:	009987b3          	add	a5,s3,s1
 508:	014787b3          	add	a5,a5,s4
 50c:	0007c503          	lbu	a0,0(a5)
 510:	000a0593          	mv	a1,s4
 514:	014484b3          	add	s1,s1,s4
 518:	b61ff0ef          	jal	78 <draw_cell>
 51c:	00249493          	slli	s1,s1,0x2
 520:	00090513          	mv	a0,s2
 524:	009404b3          	add	s1,s0,s1
 528:	1004a483          	lw	s1,256(s1)
 52c:	2c4000ef          	jal	7f0 <led_write>
 530:	00004537          	lui	a0,0x4
 534:	a9850513          	addi	a0,a0,-1384 # 3a98 <seg_write_hex+0x3298>
 538:	ad5ff0ef          	jal	c <delay>
 53c:	fb6498e3          	bne	s1,s6,4ec <solve_maze+0xd0>
 540:	0009c503          	lbu	a0,0(s3)
 544:	07e006b7          	lui	a3,0x7e00
 548:	7e068693          	addi	a3,a3,2016 # 7e007e0 <seg_write_hex+0x7dfffe0>
 54c:	00000613          	li	a2,0
 550:	00000593          	li	a1,0
 554:	b25ff0ef          	jal	78 <draw_cell>
 558:	000012b7          	lui	t0,0x1
 55c:	13f9c503          	lbu	a0,319(s3)
 560:	00510133          	add	sp,sp,t0
 564:	07c12083          	lw	ra,124(sp)
 568:	07812403          	lw	s0,120(sp)
 56c:	07412483          	lw	s1,116(sp)
 570:	07012903          	lw	s2,112(sp)
 574:	06c12983          	lw	s3,108(sp)
 578:	06812a03          	lw	s4,104(sp)
 57c:	06412a83          	lw	s5,100(sp)
 580:	06012b03          	lw	s6,96(sp)
 584:	05c12b83          	lw	s7,92(sp)
 588:	05812c03          	lw	s8,88(sp)
 58c:	05412c83          	lw	s9,84(sp)
 590:	05012d03          	lw	s10,80(sp)
 594:	04c12d83          	lw	s11,76(sp)
 598:	f80106b7          	lui	a3,0xf8010
 59c:	80068693          	addi	a3,a3,-2048 # f800f800 <seg_write_hex+0xf800f000>
 5a0:	01300613          	li	a2,19
 5a4:	00f00593          	li	a1,15
 5a8:	08010113          	addi	sp,sp,128
 5ac:	acdff06f          	j	78 <draw_cell>
 5b0:	004c1b93          	slli	s7,s8,0x4
 5b4:	01798ab3          	add	s5,s3,s7
 5b8:	001d8d93          	addi	s11,s11,1
 5bc:	00000913          	li	s2,0
 5c0:	01aa8ab3          	add	s5,s5,s10
 5c4:	000ac783          	lbu	a5,0(s5)
 5c8:	012b1733          	sll	a4,s6,s2
 5cc:	00e7f7b3          	and	a5,a5,a4
 5d0:	0a079263          	bnez	a5,674 <solve_maze+0x258>
 5d4:	00090513          	mv	a0,s2
 5d8:	a89ff0ef          	jal	60 <dir_dx>
 5dc:	01a505b3          	add	a1,a0,s10
 5e0:	fff00613          	li	a2,-1
 5e4:	00090663          	beqz	s2,5f0 <solve_maze+0x1d4>
 5e8:	ffe90613          	addi	a2,s2,-2
 5ec:	00163613          	seqz	a2,a2
 5f0:	0105b793          	sltiu	a5,a1,16
 5f4:	00cc0633          	add	a2,s8,a2
 5f8:	06078e63          	beqz	a5,674 <solve_maze+0x258>
 5fc:	01463793          	sltiu	a5,a2,20
 600:	06078a63          	beqz	a5,674 <solve_maze+0x258>
 604:	00461793          	slli	a5,a2,0x4
 608:	00f40733          	add	a4,s0,a5
 60c:	00b70733          	add	a4,a4,a1
 610:	fc074683          	lbu	a3,-64(a4)
 614:	06069063          	bnez	a3,674 <solve_maze+0x258>
 618:	fd670023          	sb	s6,-64(a4)
 61c:	00b78733          	add	a4,a5,a1
 620:	00f987b3          	add	a5,s3,a5
 624:	00b787b3          	add	a5,a5,a1
 628:	00271713          	slli	a4,a4,0x2
 62c:	0007c503          	lbu	a0,0(a5)
 630:	00e40733          	add	a4,s0,a4
 634:	01ab86b3          	add	a3,s7,s10
 638:	10d72023          	sw	a3,256(a4)
 63c:	00349713          	slli	a4,s1,0x3
 640:	07ff06b7          	lui	a3,0x7ff0
 644:	00e40733          	add	a4,s0,a4
 648:	7ff68693          	addi	a3,a3,2047 # 7ff07ff <seg_write_hex+0x7feffff>
 64c:	60b72023          	sw	a1,1536(a4)
 650:	60c72223          	sw	a2,1540(a4)
 654:	001a0a13          	addi	s4,s4,1
 658:	a21ff0ef          	jal	78 <draw_cell>
 65c:	000a0513          	mv	a0,s4
 660:	1a0000ef          	jal	800 <seg_write_hex>
 664:	00001537          	lui	a0,0x1
 668:	bb850513          	addi	a0,a0,-1096 # bb8 <seg_write_hex+0x3b8>
 66c:	9a1ff0ef          	jal	c <delay>
 670:	00148493          	addi	s1,s1,1
 674:	00190913          	addi	s2,s2,1
 678:	00400793          	li	a5,4
 67c:	f4f914e3          	bne	s2,a5,5c4 <solve_maze+0x1a8>
 680:	008c8c93          	addi	s9,s9,8
 684:	e49dc0e3          	blt	s11,s1,4c4 <solve_maze+0xa8>
 688:	e55ff06f          	j	4dc <solve_maze+0xc0>

0000068c <main>:
 68c:	ea010113          	addi	sp,sp,-352
 690:	0000c7b7          	lui	a5,0xc
 694:	14812c23          	sw	s0,344(sp)
 698:	14912a23          	sw	s1,340(sp)
 69c:	eef78793          	addi	a5,a5,-273 # beef <seg_write_hex+0xb6ef>
 6a0:	0a000713          	li	a4,160
 6a4:	08000693          	li	a3,128
 6a8:	00000613          	li	a2,0
 6ac:	00000593          	li	a1,0
 6b0:	00000513          	li	a0,0
 6b4:	9e3784b7          	lui	s1,0x9e378
 6b8:	00003437          	lui	s0,0x3
 6bc:	14112e23          	sw	ra,348(sp)
 6c0:	00f12623          	sw	a5,12(sp)
 6c4:	9b148493          	addi	s1,s1,-1615 # 9e3779b1 <seg_write_hex+0x9e3771b1>
 6c8:	0b0000ef          	jal	778 <st7735_draw_rectangle>
 6cc:	03940413          	addi	s0,s0,57 # 3039 <seg_write_hex+0x2839>
 6d0:	00c10593          	addi	a1,sp,12
 6d4:	01010513          	addi	a0,sp,16
 6d8:	a85ff0ef          	jal	15c <generate_maze>
 6dc:	002dc537          	lui	a0,0x2dc
 6e0:	6c050513          	addi	a0,a0,1728 # 2dc6c0 <seg_write_hex+0x2dbec0>
 6e4:	929ff0ef          	jal	c <delay>
 6e8:	01010513          	addi	a0,sp,16
 6ec:	d31ff0ef          	jal	41c <solve_maze>
 6f0:	00895537          	lui	a0,0x895
 6f4:	44050513          	addi	a0,a0,1088 # 895440 <seg_write_hex+0x894c40>
 6f8:	915ff0ef          	jal	c <delay>
 6fc:	00c12783          	lw	a5,12(sp)
 700:	0a000713          	li	a4,160
 704:	08000693          	li	a3,128
 708:	029787b3          	mul	a5,a5,s1
 70c:	00000613          	li	a2,0
 710:	00000593          	li	a1,0
 714:	00000513          	li	a0,0
 718:	008787b3          	add	a5,a5,s0
 71c:	00f12623          	sw	a5,12(sp)
 720:	058000ef          	jal	778 <st7735_draw_rectangle>
 724:	fadff06f          	j	6d0 <main+0x44>

00000728 <st7735_set_rectangle>:
 728:	00ff07b7          	lui	a5,0xff0
 72c:	01059593          	slli	a1,a1,0x10
 730:	0ff6f693          	zext.b	a3,a3
 734:	00f5f5b3          	and	a1,a1,a5
 738:	00869693          	slli	a3,a3,0x8
 73c:	01051513          	slli	a0,a0,0x10
 740:	0ff67613          	zext.b	a2,a2
 744:	00f57533          	and	a0,a0,a5
 748:	00861613          	slli	a2,a2,0x8
 74c:	00d5e5b3          	or	a1,a1,a3
 750:	2b0007b7          	lui	a5,0x2b000
 754:	00c56533          	or	a0,a0,a2
 758:	2a000737          	lui	a4,0x2a000
 75c:	00f5e5b3          	or	a1,a1,a5
 760:	f00007b7          	lui	a5,0xf0000
 764:	00e56533          	or	a0,a0,a4
 768:	00278793          	addi	a5,a5,2 # f0000002 <seg_write_hex+0xeffff802>
 76c:	00a7a023          	sw	a0,0(a5)
 770:	00b7a023          	sw	a1,0(a5)
 774:	00008067          	ret

00000778 <st7735_draw_rectangle>:
 778:	fe010113          	addi	sp,sp,-32
 77c:	00812c23          	sw	s0,24(sp)
 780:	00912a23          	sw	s1,20(sp)
 784:	00068413          	mv	s0,a3
 788:	00050493          	mv	s1,a0
 78c:	00058513          	mv	a0,a1
 790:	00e606b3          	add	a3,a2,a4
 794:	00060593          	mv	a1,a2
 798:	00850633          	add	a2,a0,s0
 79c:	fff68693          	addi	a3,a3,-1
 7a0:	fff60613          	addi	a2,a2,-1
 7a4:	00112e23          	sw	ra,28(sp)
 7a8:	00e12623          	sw	a4,12(sp)
 7ac:	f7dff0ef          	jal	728 <st7735_set_rectangle>
 7b0:	00c12703          	lw	a4,12(sp)
 7b4:	2c0007b7          	lui	a5,0x2c000
 7b8:	02e40433          	mul	s0,s0,a4
 7bc:	40145413          	srai	s0,s0,0x1
 7c0:	00f46433          	or	s0,s0,a5
 7c4:	f00007b7          	lui	a5,0xf0000
 7c8:	00278793          	addi	a5,a5,2 # f0000002 <seg_write_hex+0xeffff802>
 7cc:	0087a023          	sw	s0,0(a5)
 7d0:	f00007b7          	lui	a5,0xf0000
 7d4:	00178793          	addi	a5,a5,1 # f0000001 <seg_write_hex+0xeffff801>
 7d8:	0097a023          	sw	s1,0(a5)
 7dc:	01c12083          	lw	ra,28(sp)
 7e0:	01812403          	lw	s0,24(sp)
 7e4:	01412483          	lw	s1,20(sp)
 7e8:	02010113          	addi	sp,sp,32
 7ec:	00008067          	ret

000007f0 <led_write>:
 7f0:	f00007b7          	lui	a5,0xf0000
 7f4:	00878793          	addi	a5,a5,8 # f0000008 <seg_write_hex+0xeffff808>
 7f8:	00a79023          	sh	a0,0(a5)
 7fc:	00008067          	ret

00000800 <seg_write_hex>:
 800:	f00007b7          	lui	a5,0xf0000
 804:	00478793          	addi	a5,a5,4 # f0000004 <seg_write_hex+0xeffff804>
 808:	00a79023          	sh	a0,0(a5)
 80c:	00008067          	ret
