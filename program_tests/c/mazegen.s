
__out_tmp.elf:     file format elf32-littleriscv


Disassembly of section .text:

00000000 <__static_end>:
   0:	00001197          	auipc	gp,0x1
   4:	80018193          	addi	gp,gp,-2048 # 800 <__global_pointer$>
   8:	00020117          	auipc	sp,0x20
   c:	ff810113          	addi	sp,sp,-8 # 20000 <__stack_top>
  10:	6e8000ef          	jal	6f8 <main>

00000014 <halt_loop>:
  14:	0000006f          	j	14 <halt_loop>

00000018 <delay>:
  18:	ff010113          	addi	sp,sp,-16
  1c:	00012623          	sw	zero,12(sp)
  20:	00c12783          	lw	a5,12(sp)
  24:	00a7e663          	bltu	a5,a0,30 <delay+0x18>
  28:	01010113          	addi	sp,sp,16
  2c:	00008067          	ret
  30:	00c12783          	lw	a5,12(sp)
  34:	00178793          	addi	a5,a5,1
  38:	00f12623          	sw	a5,12(sp)
  3c:	fe5ff06f          	j	20 <delay+0x8>

00000040 <rand_next>:
  40:	00052783          	lw	a5,0(a0)
  44:	41c65737          	lui	a4,0x41c65
  48:	e6d70713          	addi	a4,a4,-403 # 41c64e6d <__stack_top+0x41c44e6d>
  4c:	02e787b3          	mul	a5,a5,a4
  50:	00003737          	lui	a4,0x3
  54:	03970713          	addi	a4,a4,57 # 3039 <__static_reserve+0x2039>
  58:	00e787b3          	add	a5,a5,a4
  5c:	00179713          	slli	a4,a5,0x1
  60:	00f52023          	sw	a5,0(a0)
  64:	01175513          	srli	a0,a4,0x11
  68:	00008067          	ret

0000006c <dir_dx>:
  6c:	00100793          	li	a5,1
  70:	00f50863          	beq	a0,a5,80 <dir_dx+0x14>
  74:	ffd50513          	addi	a0,a0,-3
  78:	00153513          	seqz	a0,a0
  7c:	40a00533          	neg	a0,a0
  80:	00008067          	ret

00000084 <draw_cell>:
  84:	ff010113          	addi	sp,sp,-16
  88:	01212023          	sw	s2,0(sp)
  8c:	00050913          	mv	s2,a0
  90:	00068513          	mv	a0,a3
  94:	00300693          	li	a3,3
  98:	00812423          	sw	s0,8(sp)
  9c:	00912223          	sw	s1,4(sp)
  a0:	02d58433          	mul	s0,a1,a3
  a4:	00068713          	mv	a4,a3
  a8:	00112623          	sw	ra,12(sp)
  ac:	02d604b3          	mul	s1,a2,a3
  b0:	00040593          	mv	a1,s0
  b4:	00048613          	mv	a2,s1
  b8:	760000ef          	jal	818 <st7735_draw_rectangle>
  bc:	00197793          	andi	a5,s2,1
  c0:	00078e63          	beqz	a5,dc <draw_cell+0x58>
  c4:	00300693          	li	a3,3
  c8:	00100713          	li	a4,1
  cc:	00048613          	mv	a2,s1
  d0:	00040593          	mv	a1,s0
  d4:	00000513          	li	a0,0
  d8:	740000ef          	jal	818 <st7735_draw_rectangle>
  dc:	00497793          	andi	a5,s2,4
  e0:	00078e63          	beqz	a5,fc <draw_cell+0x78>
  e4:	00100713          	li	a4,1
  e8:	00300693          	li	a3,3
  ec:	00248613          	addi	a2,s1,2
  f0:	00040593          	mv	a1,s0
  f4:	00000513          	li	a0,0
  f8:	720000ef          	jal	818 <st7735_draw_rectangle>
  fc:	00897793          	andi	a5,s2,8
 100:	00078e63          	beqz	a5,11c <draw_cell+0x98>
 104:	00300713          	li	a4,3
 108:	00100693          	li	a3,1
 10c:	00048613          	mv	a2,s1
 110:	00040593          	mv	a1,s0
 114:	00000513          	li	a0,0
 118:	700000ef          	jal	818 <st7735_draw_rectangle>
 11c:	00297913          	andi	s2,s2,2
 120:	02090863          	beqz	s2,150 <draw_cell+0xcc>
 124:	00240593          	addi	a1,s0,2
 128:	00812403          	lw	s0,8(sp)
 12c:	00c12083          	lw	ra,12(sp)
 130:	00012903          	lw	s2,0(sp)
 134:	00048613          	mv	a2,s1
 138:	00412483          	lw	s1,4(sp)
 13c:	00300713          	li	a4,3
 140:	00100693          	li	a3,1
 144:	00000513          	li	a0,0
 148:	01010113          	addi	sp,sp,16
 14c:	6cc0006f          	j	818 <st7735_draw_rectangle>
 150:	00c12083          	lw	ra,12(sp)
 154:	00812403          	lw	s0,8(sp)
 158:	00412483          	lw	s1,4(sp)
 15c:	00012903          	lw	s2,0(sp)
 160:	01010113          	addi	sp,sp,16
 164:	00008067          	ret

00000168 <generate_maze>:
 168:	ffffc2b7          	lui	t0,0xffffc
 16c:	81010113          	addi	sp,sp,-2032
 170:	94028293          	addi	t0,t0,-1728 # ffffb940 <__stack_top+0xfffdb940>
 174:	7d312e23          	sw	s3,2012(sp)
 178:	7e112623          	sw	ra,2028(sp)
 17c:	7e812423          	sw	s0,2024(sp)
 180:	7e912223          	sw	s1,2020(sp)
 184:	7f212023          	sw	s2,2016(sp)
 188:	7d412c23          	sw	s4,2008(sp)
 18c:	7d512a23          	sw	s5,2004(sp)
 190:	7d612823          	sw	s6,2000(sp)
 194:	7d712623          	sw	s7,1996(sp)
 198:	7d812423          	sw	s8,1992(sp)
 19c:	7d912223          	sw	s9,1988(sp)
 1a0:	7da12023          	sw	s10,1984(sp)
 1a4:	7bb12e23          	sw	s11,1980(sp)
 1a8:	00001637          	lui	a2,0x1
 1ac:	00510133          	add	sp,sp,t0
 1b0:	00050993          	mv	s3,a0
 1b4:	00b12223          	sw	a1,4(sp)
 1b8:	00000793          	li	a5,0
 1bc:	00f00813          	li	a6,15
 1c0:	02c10713          	addi	a4,sp,44
 1c4:	02a00893          	li	a7,42
 1c8:	8b260613          	addi	a2,a2,-1870 # 8b2 <st7735_draw_rectangle+0x9a>
 1cc:	00f98533          	add	a0,s3,a5
 1d0:	00000693          	li	a3,0
 1d4:	00f705b3          	add	a1,a4,a5
 1d8:	00d50333          	add	t1,a0,a3
 1dc:	01030023          	sb	a6,0(t1)
 1e0:	00d58333          	add	t1,a1,a3
 1e4:	00030023          	sb	zero,0(t1)
 1e8:	00168693          	addi	a3,a3,1
 1ec:	ff1696e3          	bne	a3,a7,1d8 <generate_maze+0x70>
 1f0:	02a78793          	addi	a5,a5,42
 1f4:	fcc79ce3          	bne	a5,a2,1cc <generate_maze+0x64>
 1f8:	0009c503          	lbu	a0,0(s3)
 1fc:	7ff10913          	addi	s2,sp,2047
 200:	07ff06b7          	lui	a3,0x7ff0
 204:	00100b93          	li	s7,1
 208:	7ff68693          	addi	a3,a3,2047 # 7ff07ff <__stack_top+0x7fd07ff>
 20c:	00000613          	li	a2,0
 210:	00000593          	li	a1,0
 214:	67190913          	addi	s2,s2,1649
 218:	e7010493          	addi	s1,sp,-400
 21c:	1b748e23          	sb	s7,444(s1)
 220:	a6092823          	sw	zero,-1424(s2)
 224:	a6092a23          	sw	zero,-1420(s2)
 228:	00400b13          	li	s6,4
 22c:	e59ff0ef          	jal	84 <draw_cell>
 230:	02a00a13          	li	s4,42
 234:	000b8a93          	mv	s5,s7
 238:	fffb8413          	addi	s0,s7,-1
 23c:	00341793          	slli	a5,s0,0x3
 240:	00f907b3          	add	a5,s2,a5
 244:	a707a583          	lw	a1,-1424(a5)
 248:	a747a603          	lw	a2,-1420(a5)
 24c:	00000c13          	li	s8,0
 250:	00000d13          	li	s10,0
 254:	000c0513          	mv	a0,s8
 258:	00b12623          	sw	a1,12(sp)
 25c:	00c12423          	sw	a2,8(sp)
 260:	e0dff0ef          	jal	6c <dir_dx>
 264:	00c12583          	lw	a1,12(sp)
 268:	00812603          	lw	a2,8(sp)
 26c:	fff00793          	li	a5,-1
 270:	00b50533          	add	a0,a0,a1
 274:	000c0663          	beqz	s8,280 <generate_maze+0x118>
 278:	ffec0793          	addi	a5,s8,-2
 27c:	0017b793          	seqz	a5,a5
 280:	02a53713          	sltiu	a4,a0,42
 284:	00f607b3          	add	a5,a2,a5
 288:	02070863          	beqz	a4,2b8 <generate_maze+0x150>
 28c:	0357b713          	sltiu	a4,a5,53
 290:	02070463          	beqz	a4,2b8 <generate_maze+0x150>
 294:	034787b3          	mul	a5,a5,s4
 298:	00f487b3          	add	a5,s1,a5
 29c:	00a787b3          	add	a5,a5,a0
 2a0:	1bc7c783          	lbu	a5,444(a5)
 2a4:	00079a63          	bnez	a5,2b8 <generate_maze+0x150>
 2a8:	002d1793          	slli	a5,s10,0x2
 2ac:	00f487b3          	add	a5,s1,a5
 2b0:	1b87a623          	sw	s8,428(a5)
 2b4:	001d0d13          	addi	s10,s10,1
 2b8:	001c0c13          	addi	s8,s8,1
 2bc:	f96c1ce3          	bne	s8,s6,254 <generate_maze+0xec>
 2c0:	03460cb3          	mul	s9,a2,s4
 2c4:	01998cb3          	add	s9,s3,s9
 2c8:	00bc8cb3          	add	s9,s9,a1
 2cc:	080d1e63          	bnez	s10,368 <generate_maze+0x200>
 2d0:	000cc503          	lbu	a0,0(s9)
 2d4:	fff00693          	li	a3,-1
 2d8:	dadff0ef          	jal	84 <draw_cell>
 2dc:	16041663          	bnez	s0,448 <generate_maze+0x2e0>
 2e0:	00000493          	li	s1,0
 2e4:	02a00a13          	li	s4,42
 2e8:	03500a93          	li	s5,53
 2ec:	03448933          	mul	s2,s1,s4
 2f0:	00000413          	li	s0,0
 2f4:	01298933          	add	s2,s3,s2
 2f8:	008907b3          	add	a5,s2,s0
 2fc:	0007c503          	lbu	a0,0(a5)
 300:	00040593          	mv	a1,s0
 304:	fff00693          	li	a3,-1
 308:	00048613          	mv	a2,s1
 30c:	00140413          	addi	s0,s0,1
 310:	d75ff0ef          	jal	84 <draw_cell>
 314:	ff4412e3          	bne	s0,s4,2f8 <generate_maze+0x190>
 318:	00148493          	addi	s1,s1,1
 31c:	fd5498e3          	bne	s1,s5,2ec <generate_maze+0x184>
 320:	000042b7          	lui	t0,0x4
 324:	6c028293          	addi	t0,t0,1728 # 46c0 <__static_reserve+0x36c0>
 328:	00510133          	add	sp,sp,t0
 32c:	7ec12083          	lw	ra,2028(sp)
 330:	7e812403          	lw	s0,2024(sp)
 334:	7e412483          	lw	s1,2020(sp)
 338:	7e012903          	lw	s2,2016(sp)
 33c:	7dc12983          	lw	s3,2012(sp)
 340:	7d812a03          	lw	s4,2008(sp)
 344:	7d412a83          	lw	s5,2004(sp)
 348:	7d012b03          	lw	s6,2000(sp)
 34c:	7cc12b83          	lw	s7,1996(sp)
 350:	7c812c03          	lw	s8,1992(sp)
 354:	7c412c83          	lw	s9,1988(sp)
 358:	7c012d03          	lw	s10,1984(sp)
 35c:	7bc12d83          	lw	s11,1980(sp)
 360:	7f010113          	addi	sp,sp,2032
 364:	00008067          	ret
 368:	00412503          	lw	a0,4(sp)
 36c:	00b12623          	sw	a1,12(sp)
 370:	00c12423          	sw	a2,8(sp)
 374:	ccdff0ef          	jal	40 <rand_next>
 378:	03a57533          	remu	a0,a0,s10
 37c:	fff00c13          	li	s8,-1
 380:	00251513          	slli	a0,a0,0x2
 384:	00a48533          	add	a0,s1,a0
 388:	1ac52403          	lw	s0,428(a0)
 38c:	00040513          	mv	a0,s0
 390:	cddff0ef          	jal	6c <dir_dx>
 394:	00c12583          	lw	a1,12(sp)
 398:	00812603          	lw	a2,8(sp)
 39c:	00b50d33          	add	s10,a0,a1
 3a0:	00040663          	beqz	s0,3ac <generate_maze+0x244>
 3a4:	ffe40c13          	addi	s8,s0,-2
 3a8:	001c3c13          	seqz	s8,s8
 3ac:	000cc703          	lbu	a4,0(s9)
 3b0:	008a97b3          	sll	a5,s5,s0
 3b4:	01860c33          	add	s8,a2,s8
 3b8:	fff7c793          	not	a5,a5
 3bc:	00e7f7b3          	and	a5,a5,a4
 3c0:	034c0733          	mul	a4,s8,s4
 3c4:	00fc8023          	sb	a5,0(s9)
 3c8:	00240793          	addi	a5,s0,2
 3cc:	0037f793          	andi	a5,a5,3
 3d0:	00fa97b3          	sll	a5,s5,a5
 3d4:	fff7c793          	not	a5,a5
 3d8:	001b8413          	addi	s0,s7,1
 3dc:	003b9b93          	slli	s7,s7,0x3
 3e0:	01790bb3          	add	s7,s2,s7
 3e4:	a7aba823          	sw	s10,-1424(s7)
 3e8:	00e98db3          	add	s11,s3,a4
 3ec:	01ad8db3          	add	s11,s11,s10
 3f0:	000dc683          	lbu	a3,0(s11)
 3f4:	00e48733          	add	a4,s1,a4
 3f8:	01a70733          	add	a4,a4,s10
 3fc:	00d7f7b3          	and	a5,a5,a3
 400:	00fd8023          	sb	a5,0(s11)
 404:	1b570e23          	sb	s5,444(a4)
 408:	000cc503          	lbu	a0,0(s9)
 40c:	07ff06b7          	lui	a3,0x7ff0
 410:	7ff68693          	addi	a3,a3,2047 # 7ff07ff <__stack_top+0x7fd07ff>
 414:	a78baa23          	sw	s8,-1420(s7)
 418:	c6dff0ef          	jal	84 <draw_cell>
 41c:	000dc503          	lbu	a0,0(s11)
 420:	07ff06b7          	lui	a3,0x7ff0
 424:	7ff68693          	addi	a3,a3,2047 # 7ff07ff <__stack_top+0x7fd07ff>
 428:	000c0613          	mv	a2,s8
 42c:	000d0593          	mv	a1,s10
 430:	c55ff0ef          	jal	84 <draw_cell>
 434:	00040513          	mv	a0,s0
 438:	380000ef          	jal	7b8 <seg_write_hex>
 43c:	00001537          	lui	a0,0x1
 440:	fa050513          	addi	a0,a0,-96 # fa0 <st7735_draw_rectangle+0x788>
 444:	bd5ff0ef          	jal	18 <delay>
 448:	00040b93          	mv	s7,s0
 44c:	dedff06f          	j	238 <generate_maze+0xd0>

00000450 <solve_maze>:
 450:	eb010113          	addi	sp,sp,-336
 454:	ffff92b7          	lui	t0,0xffff9
 458:	14912223          	sw	s1,324(sp)
 45c:	14112623          	sw	ra,332(sp)
 460:	14812423          	sw	s0,328(sp)
 464:	15212023          	sw	s2,320(sp)
 468:	13312e23          	sw	s3,316(sp)
 46c:	13412c23          	sw	s4,312(sp)
 470:	13512a23          	sw	s5,308(sp)
 474:	13612823          	sw	s6,304(sp)
 478:	13712623          	sw	s7,300(sp)
 47c:	13812423          	sw	s8,296(sp)
 480:	13912223          	sw	s9,292(sp)
 484:	13a12023          	sw	s10,288(sp)
 488:	11b12e23          	sw	s11,284(sp)
 48c:	00510133          	add	sp,sp,t0
 490:	7ff10793          	addi	a5,sp,2047
 494:	000026b7          	lui	a3,0x2
 498:	0b978793          	addi	a5,a5,185
 49c:	2c868693          	addi	a3,a3,712 # 22c8 <__static_reserve+0x12c8>
 4a0:	00050493          	mv	s1,a0
 4a4:	00410713          	addi	a4,sp,4
 4a8:	00d786b3          	add	a3,a5,a3
 4ac:	fff00513          	li	a0,-1
 4b0:	02a00813          	li	a6,42
 4b4:	00078593          	mv	a1,a5
 4b8:	00000613          	li	a2,0
 4bc:	00c708b3          	add	a7,a4,a2
 4c0:	00a5a023          	sw	a0,0(a1)
 4c4:	00088023          	sb	zero,0(a7)
 4c8:	00160613          	addi	a2,a2,1
 4cc:	00458593          	addi	a1,a1,4
 4d0:	ff0616e3          	bne	a2,a6,4bc <solve_maze+0x6c>
 4d4:	0a878793          	addi	a5,a5,168
 4d8:	02a70713          	addi	a4,a4,42
 4dc:	fcf69ce3          	bne	a3,a5,4b4 <solve_maze+0x64>
 4e0:	00003737          	lui	a4,0x3
 4e4:	11070713          	addi	a4,a4,272 # 3110 <__static_reserve+0x2110>
 4e8:	000037b7          	lui	a5,0x3
 4ec:	00e10cb3          	add	s9,sp,a4
 4f0:	11010c13          	addi	s8,sp,272
 4f4:	00100913          	li	s2,1
 4f8:	b8078793          	addi	a5,a5,-1152 # 2b80 <__static_reserve+0x1b80>
 4fc:	ef2c0a23          	sb	s2,-268(s8)
 500:	a60ca823          	sw	zero,-1424(s9)
 504:	a60caa23          	sw	zero,-1420(s9)
 508:	00f10433          	add	s0,sp,a5
 50c:	00000a93          	li	s5,0
 510:	00000b13          	li	s6,0
 514:	02a00b93          	li	s7,42
 518:	00042d83          	lw	s11,0(s0)
 51c:	00442d03          	lw	s10,4(s0)
 520:	fd7d8793          	addi	a5,s11,-41
 524:	0e079663          	bnez	a5,610 <solve_maze+0x1c0>
 528:	fccd0793          	addi	a5,s10,-52
 52c:	0e079263          	bnez	a5,610 <solve_maze+0x1c0>
 530:	00001437          	lui	s0,0x1
 534:	00000913          	li	s2,0
 538:	8b140413          	addi	s0,s0,-1871 # 8b1 <st7735_draw_rectangle+0x99>
 53c:	02a00a93          	li	s5,42
 540:	11010993          	addi	s3,sp,272
 544:	fff00b13          	li	s6,-1
 548:	03544633          	div	a2,s0,s5
 54c:	001f06b7          	lui	a3,0x1f0
 550:	01f68693          	addi	a3,a3,31 # 1f001f <__stack_top+0x1d001f>
 554:	00190913          	addi	s2,s2,1
 558:	03546a33          	rem	s4,s0,s5
 55c:	03560433          	mul	s0,a2,s5
 560:	000a0593          	mv	a1,s4
 564:	008487b3          	add	a5,s1,s0
 568:	014787b3          	add	a5,a5,s4
 56c:	0007c503          	lbu	a0,0(a5)
 570:	01440433          	add	s0,s0,s4
 574:	00241413          	slli	s0,s0,0x2
 578:	b0dff0ef          	jal	84 <draw_cell>
 57c:	00090513          	mv	a0,s2
 580:	00898433          	add	s0,s3,s0
 584:	7a842403          	lw	s0,1960(s0)
 588:	220000ef          	jal	7a8 <led_write>
 58c:	00004537          	lui	a0,0x4
 590:	a9850513          	addi	a0,a0,-1384 # 3a98 <__static_reserve+0x2a98>
 594:	a85ff0ef          	jal	18 <delay>
 598:	fb6418e3          	bne	s0,s6,548 <solve_maze+0xf8>
 59c:	0004c503          	lbu	a0,0(s1)
 5a0:	07e006b7          	lui	a3,0x7e00
 5a4:	7e068693          	addi	a3,a3,2016 # 7e007e0 <__stack_top+0x7de07e0>
 5a8:	00000613          	li	a2,0
 5ac:	00000593          	li	a1,0
 5b0:	ad5ff0ef          	jal	84 <draw_cell>
 5b4:	7ff48493          	addi	s1,s1,2047
 5b8:	000072b7          	lui	t0,0x7
 5bc:	0b24c503          	lbu	a0,178(s1)
 5c0:	00510133          	add	sp,sp,t0
 5c4:	14c12083          	lw	ra,332(sp)
 5c8:	14812403          	lw	s0,328(sp)
 5cc:	14412483          	lw	s1,324(sp)
 5d0:	14012903          	lw	s2,320(sp)
 5d4:	13c12983          	lw	s3,316(sp)
 5d8:	13812a03          	lw	s4,312(sp)
 5dc:	13412a83          	lw	s5,308(sp)
 5e0:	13012b03          	lw	s6,304(sp)
 5e4:	12c12b83          	lw	s7,300(sp)
 5e8:	12812c03          	lw	s8,296(sp)
 5ec:	12412c83          	lw	s9,292(sp)
 5f0:	12012d03          	lw	s10,288(sp)
 5f4:	11c12d83          	lw	s11,284(sp)
 5f8:	f80106b7          	lui	a3,0xf8010
 5fc:	80068693          	addi	a3,a3,-2048 # f800f800 <__stack_top+0xf7fef800>
 600:	03400613          	li	a2,52
 604:	02900593          	li	a1,41
 608:	15010113          	addi	sp,sp,336
 60c:	a79ff06f          	j	84 <draw_cell>
 610:	037d0a33          	mul	s4,s10,s7
 614:	001b0b13          	addi	s6,s6,1
 618:	00000993          	li	s3,0
 61c:	01448a33          	add	s4,s1,s4
 620:	01ba0a33          	add	s4,s4,s11
 624:	000a4783          	lbu	a5,0(s4)
 628:	00100713          	li	a4,1
 62c:	01371733          	sll	a4,a4,s3
 630:	00e7f7b3          	and	a5,a5,a4
 634:	0a079663          	bnez	a5,6e0 <solve_maze+0x290>
 638:	00098513          	mv	a0,s3
 63c:	a31ff0ef          	jal	6c <dir_dx>
 640:	01b505b3          	add	a1,a0,s11
 644:	fff00613          	li	a2,-1
 648:	00098663          	beqz	s3,654 <solve_maze+0x204>
 64c:	ffe98613          	addi	a2,s3,-2
 650:	00163613          	seqz	a2,a2
 654:	02a5b793          	sltiu	a5,a1,42
 658:	00cd0633          	add	a2,s10,a2
 65c:	08078263          	beqz	a5,6e0 <solve_maze+0x290>
 660:	03563793          	sltiu	a5,a2,53
 664:	06078e63          	beqz	a5,6e0 <solve_maze+0x290>
 668:	037607b3          	mul	a5,a2,s7
 66c:	00fc0733          	add	a4,s8,a5
 670:	00b70733          	add	a4,a4,a1
 674:	ef474683          	lbu	a3,-268(a4)
 678:	06069463          	bnez	a3,6e0 <solve_maze+0x290>
 67c:	00100693          	li	a3,1
 680:	eed70a23          	sb	a3,-268(a4)
 684:	037d06b3          	mul	a3,s10,s7
 688:	00b78733          	add	a4,a5,a1
 68c:	00f487b3          	add	a5,s1,a5
 690:	00b787b3          	add	a5,a5,a1
 694:	00271713          	slli	a4,a4,0x2
 698:	0007c503          	lbu	a0,0(a5)
 69c:	00ec0733          	add	a4,s8,a4
 6a0:	001a8a93          	addi	s5,s5,1
 6a4:	01b686b3          	add	a3,a3,s11
 6a8:	7ad72423          	sw	a3,1960(a4)
 6ac:	00391713          	slli	a4,s2,0x3
 6b0:	07ff06b7          	lui	a3,0x7ff0
 6b4:	00ec8733          	add	a4,s9,a4
 6b8:	7ff68693          	addi	a3,a3,2047 # 7ff07ff <__stack_top+0x7fd07ff>
 6bc:	a6b72823          	sw	a1,-1424(a4)
 6c0:	a6c72a23          	sw	a2,-1420(a4)
 6c4:	9c1ff0ef          	jal	84 <draw_cell>
 6c8:	000a8513          	mv	a0,s5
 6cc:	0ec000ef          	jal	7b8 <seg_write_hex>
 6d0:	00001537          	lui	a0,0x1
 6d4:	bb850513          	addi	a0,a0,-1096 # bb8 <st7735_draw_rectangle+0x3a0>
 6d8:	941ff0ef          	jal	18 <delay>
 6dc:	00190913          	addi	s2,s2,1
 6e0:	00198993          	addi	s3,s3,1
 6e4:	00400793          	li	a5,4
 6e8:	f2f99ee3          	bne	s3,a5,624 <solve_maze+0x1d4>
 6ec:	00840413          	addi	s0,s0,8
 6f0:	e32b44e3          	blt	s6,s2,518 <solve_maze+0xc8>
 6f4:	e3dff06f          	j	530 <solve_maze+0xe0>

000006f8 <main>:
 6f8:	81010113          	addi	sp,sp,-2032
 6fc:	7e812423          	sw	s0,2024(sp)
 700:	7f212023          	sw	s2,2016(sp)
 704:	7d312e23          	sw	s3,2012(sp)
 708:	7e112623          	sw	ra,2028(sp)
 70c:	7e912223          	sw	s1,2020(sp)
 710:	7d412c23          	sw	s4,2008(sp)
 714:	0000c7b7          	lui	a5,0xc
 718:	f1010113          	addi	sp,sp,-240
 71c:	eef78793          	addi	a5,a5,-273 # beef <__static_reserve+0xaeef>
 720:	0a000713          	li	a4,160
 724:	08000693          	li	a3,128
 728:	00000613          	li	a2,0
 72c:	00000593          	li	a1,0
 730:	00000513          	li	a0,0
 734:	9e3789b7          	lui	s3,0x9e378
 738:	00003937          	lui	s2,0x3
 73c:	8c010413          	addi	s0,sp,-1856
 740:	74f42423          	sw	a5,1864(s0)
 744:	9b198993          	addi	s3,s3,-1615 # 9e3779b1 <__stack_top+0x9e3579b1>
 748:	0d0000ef          	jal	818 <st7735_draw_rectangle>
 74c:	03990913          	addi	s2,s2,57 # 3039 <__static_reserve+0x2039>
 750:	00810593          	addi	a1,sp,8
 754:	00c10513          	addi	a0,sp,12
 758:	a11ff0ef          	jal	168 <generate_maze>
 75c:	00031537          	lui	a0,0x31
 760:	d4050513          	addi	a0,a0,-704 # 30d40 <__stack_top+0x10d40>
 764:	8b5ff0ef          	jal	18 <delay>
 768:	00c10513          	addi	a0,sp,12
 76c:	ce5ff0ef          	jal	450 <solve_maze>
 770:	00092537          	lui	a0,0x92
 774:	7c050513          	addi	a0,a0,1984 # 927c0 <__stack_top+0x727c0>
 778:	8a1ff0ef          	jal	18 <delay>
 77c:	74842783          	lw	a5,1864(s0)
 780:	0a000713          	li	a4,160
 784:	08000693          	li	a3,128
 788:	033787b3          	mul	a5,a5,s3
 78c:	00000613          	li	a2,0
 790:	00000593          	li	a1,0
 794:	00000513          	li	a0,0
 798:	012787b3          	add	a5,a5,s2
 79c:	74f42423          	sw	a5,1864(s0)
 7a0:	078000ef          	jal	818 <st7735_draw_rectangle>
 7a4:	fadff06f          	j	750 <main+0x58>

000007a8 <led_write>:
 7a8:	f00007b7          	lui	a5,0xf0000
 7ac:	00878793          	addi	a5,a5,8 # f0000008 <__stack_top+0xeffe0008>
 7b0:	00a79023          	sh	a0,0(a5)
 7b4:	00008067          	ret

000007b8 <seg_write_hex>:
 7b8:	f00007b7          	lui	a5,0xf0000
 7bc:	00478793          	addi	a5,a5,4 # f0000004 <__stack_top+0xeffe0004>
 7c0:	00a79023          	sh	a0,0(a5)
 7c4:	00008067          	ret

000007c8 <st7735_set_rectangle>:
 7c8:	00ff07b7          	lui	a5,0xff0
 7cc:	01059593          	slli	a1,a1,0x10
 7d0:	0ff6f693          	zext.b	a3,a3
 7d4:	00f5f5b3          	and	a1,a1,a5
 7d8:	00869693          	slli	a3,a3,0x8
 7dc:	01051513          	slli	a0,a0,0x10
 7e0:	0ff67613          	zext.b	a2,a2
 7e4:	00f57533          	and	a0,a0,a5
 7e8:	00861613          	slli	a2,a2,0x8
 7ec:	00d5e5b3          	or	a1,a1,a3
 7f0:	2b0007b7          	lui	a5,0x2b000
 7f4:	00c56533          	or	a0,a0,a2
 7f8:	2a000737          	lui	a4,0x2a000
 7fc:	00f5e5b3          	or	a1,a1,a5
 800:	f00007b7          	lui	a5,0xf0000
 804:	00e56533          	or	a0,a0,a4
 808:	00278793          	addi	a5,a5,2 # f0000002 <__stack_top+0xeffe0002>
 80c:	00a7a023          	sw	a0,0(a5)
 810:	00b7a023          	sw	a1,0(a5)
 814:	00008067          	ret

00000818 <st7735_draw_rectangle>:
 818:	fe010113          	addi	sp,sp,-32
 81c:	00812c23          	sw	s0,24(sp)
 820:	00912a23          	sw	s1,20(sp)
 824:	00068413          	mv	s0,a3
 828:	00050493          	mv	s1,a0
 82c:	00058513          	mv	a0,a1
 830:	00e606b3          	add	a3,a2,a4
 834:	00060593          	mv	a1,a2
 838:	00850633          	add	a2,a0,s0
 83c:	fff68693          	addi	a3,a3,-1
 840:	fff60613          	addi	a2,a2,-1
 844:	00112e23          	sw	ra,28(sp)
 848:	00e12623          	sw	a4,12(sp)
 84c:	f7dff0ef          	jal	7c8 <st7735_set_rectangle>
 850:	00c12703          	lw	a4,12(sp)
 854:	2c0007b7          	lui	a5,0x2c000
 858:	02e40433          	mul	s0,s0,a4
 85c:	40145413          	srai	s0,s0,0x1
 860:	00f46433          	or	s0,s0,a5
 864:	f00007b7          	lui	a5,0xf0000
 868:	00278793          	addi	a5,a5,2 # f0000002 <__stack_top+0xeffe0002>
 86c:	0087a023          	sw	s0,0(a5)
 870:	f00007b7          	lui	a5,0xf0000
 874:	00178793          	addi	a5,a5,1 # f0000001 <__stack_top+0xeffe0001>
 878:	0097a023          	sw	s1,0(a5)
 87c:	01c12083          	lw	ra,28(sp)
 880:	01812403          	lw	s0,24(sp)
 884:	01412483          	lw	s1,20(sp)
 888:	02010113          	addi	sp,sp,32
 88c:	00008067          	ret
