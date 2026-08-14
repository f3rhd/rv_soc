
__out_tmp.elf:     file format elf32-littleriscv


Disassembly of section .text:

00000000 <_start>:
   0:	00008137          	lui	sp,0x8
   4:	6e8000ef          	jal	6ec <main>

00000008 <halt_loop>:
   8:	0000006f          	j	8 <halt_loop>

0000000c <delay>:
   c:	ff010113          	addi	sp,sp,-16 # 7ff0 <seg_write_hex+0x777c>
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
  3c:	e6d70713          	addi	a4,a4,-403 # 41c64e6d <seg_write_hex+0x41c645f9>
  40:	02e787b3          	mul	a5,a5,a4
  44:	00003737          	lui	a4,0x3
  48:	03970713          	addi	a4,a4,57 # 3039 <seg_write_hex+0x27c5>
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
  7c:	01212023          	sw	s2,0(sp)
  80:	00050913          	mv	s2,a0
  84:	00068513          	mv	a0,a3
  88:	00300693          	li	a3,3
  8c:	00812423          	sw	s0,8(sp)
  90:	00912223          	sw	s1,4(sp)
  94:	02d58433          	mul	s0,a1,a3
  98:	00068713          	mv	a4,a3
  9c:	00112623          	sw	ra,12(sp)
  a0:	02d604b3          	mul	s1,a2,a3
  a4:	00040593          	mv	a1,s0
  a8:	00048613          	mv	a2,s1
  ac:	740000ef          	jal	7ec <st7735_draw_rectangle>
  b0:	00197793          	andi	a5,s2,1
  b4:	00078e63          	beqz	a5,d0 <draw_cell+0x58>
  b8:	00300693          	li	a3,3
  bc:	00100713          	li	a4,1
  c0:	00048613          	mv	a2,s1
  c4:	00040593          	mv	a1,s0
  c8:	00000513          	li	a0,0
  cc:	720000ef          	jal	7ec <st7735_draw_rectangle>
  d0:	00497793          	andi	a5,s2,4
  d4:	00078e63          	beqz	a5,f0 <draw_cell+0x78>
  d8:	00100713          	li	a4,1
  dc:	00300693          	li	a3,3
  e0:	00248613          	addi	a2,s1,2
  e4:	00040593          	mv	a1,s0
  e8:	00000513          	li	a0,0
  ec:	700000ef          	jal	7ec <st7735_draw_rectangle>
  f0:	00897793          	andi	a5,s2,8
  f4:	00078e63          	beqz	a5,110 <draw_cell+0x98>
  f8:	00300713          	li	a4,3
  fc:	00100693          	li	a3,1
 100:	00048613          	mv	a2,s1
 104:	00040593          	mv	a1,s0
 108:	00000513          	li	a0,0
 10c:	6e0000ef          	jal	7ec <st7735_draw_rectangle>
 110:	00297913          	andi	s2,s2,2
 114:	02090863          	beqz	s2,144 <draw_cell+0xcc>
 118:	00240593          	addi	a1,s0,2
 11c:	00812403          	lw	s0,8(sp)
 120:	00c12083          	lw	ra,12(sp)
 124:	00012903          	lw	s2,0(sp)
 128:	00048613          	mv	a2,s1
 12c:	00412483          	lw	s1,4(sp)
 130:	00300713          	li	a4,3
 134:	00100693          	li	a3,1
 138:	00000513          	li	a0,0
 13c:	01010113          	addi	sp,sp,16
 140:	6ac0006f          	j	7ec <st7735_draw_rectangle>
 144:	00c12083          	lw	ra,12(sp)
 148:	00812403          	lw	s0,8(sp)
 14c:	00412483          	lw	s1,4(sp)
 150:	00012903          	lw	s2,0(sp)
 154:	01010113          	addi	sp,sp,16
 158:	00008067          	ret

0000015c <generate_maze>:
 15c:	ffffc2b7          	lui	t0,0xffffc
 160:	81010113          	addi	sp,sp,-2032
 164:	94028293          	addi	t0,t0,-1728 # ffffb940 <seg_write_hex+0xffffb0cc>
 168:	7d312e23          	sw	s3,2012(sp)
 16c:	7e112623          	sw	ra,2028(sp)
 170:	7e812423          	sw	s0,2024(sp)
 174:	7e912223          	sw	s1,2020(sp)
 178:	7f212023          	sw	s2,2016(sp)
 17c:	7d412c23          	sw	s4,2008(sp)
 180:	7d512a23          	sw	s5,2004(sp)
 184:	7d612823          	sw	s6,2000(sp)
 188:	7d712623          	sw	s7,1996(sp)
 18c:	7d812423          	sw	s8,1992(sp)
 190:	7d912223          	sw	s9,1988(sp)
 194:	7da12023          	sw	s10,1984(sp)
 198:	7bb12e23          	sw	s11,1980(sp)
 19c:	00001637          	lui	a2,0x1
 1a0:	00510133          	add	sp,sp,t0
 1a4:	00050993          	mv	s3,a0
 1a8:	00b12223          	sw	a1,4(sp)
 1ac:	00000793          	li	a5,0
 1b0:	00f00813          	li	a6,15
 1b4:	02c10713          	addi	a4,sp,44
 1b8:	02a00893          	li	a7,42
 1bc:	8b260613          	addi	a2,a2,-1870 # 8b2 <seg_write_hex+0x3e>
 1c0:	00f98533          	add	a0,s3,a5
 1c4:	00000693          	li	a3,0
 1c8:	00f705b3          	add	a1,a4,a5
 1cc:	00d50333          	add	t1,a0,a3
 1d0:	01030023          	sb	a6,0(t1)
 1d4:	00d58333          	add	t1,a1,a3
 1d8:	00030023          	sb	zero,0(t1)
 1dc:	00168693          	addi	a3,a3,1
 1e0:	ff1696e3          	bne	a3,a7,1cc <generate_maze+0x70>
 1e4:	02a78793          	addi	a5,a5,42
 1e8:	fcc79ce3          	bne	a5,a2,1c0 <generate_maze+0x64>
 1ec:	0009c503          	lbu	a0,0(s3)
 1f0:	7ff10913          	addi	s2,sp,2047
 1f4:	07ff06b7          	lui	a3,0x7ff0
 1f8:	00100b93          	li	s7,1
 1fc:	7ff68693          	addi	a3,a3,2047 # 7ff07ff <seg_write_hex+0x7feff8b>
 200:	00000613          	li	a2,0
 204:	00000593          	li	a1,0
 208:	67190913          	addi	s2,s2,1649
 20c:	e7010493          	addi	s1,sp,-400
 210:	1b748e23          	sb	s7,444(s1)
 214:	a6092823          	sw	zero,-1424(s2)
 218:	a6092a23          	sw	zero,-1420(s2)
 21c:	00400b13          	li	s6,4
 220:	e59ff0ef          	jal	78 <draw_cell>
 224:	02a00a13          	li	s4,42
 228:	000b8a93          	mv	s5,s7
 22c:	fffb8413          	addi	s0,s7,-1
 230:	00341793          	slli	a5,s0,0x3
 234:	00f907b3          	add	a5,s2,a5
 238:	a707a583          	lw	a1,-1424(a5)
 23c:	a747a603          	lw	a2,-1420(a5)
 240:	00000c13          	li	s8,0
 244:	00000d13          	li	s10,0
 248:	000c0513          	mv	a0,s8
 24c:	00b12623          	sw	a1,12(sp)
 250:	00c12423          	sw	a2,8(sp)
 254:	e0dff0ef          	jal	60 <dir_dx>
 258:	00c12583          	lw	a1,12(sp)
 25c:	00812603          	lw	a2,8(sp)
 260:	fff00793          	li	a5,-1
 264:	00b50533          	add	a0,a0,a1
 268:	000c0663          	beqz	s8,274 <generate_maze+0x118>
 26c:	ffec0793          	addi	a5,s8,-2
 270:	0017b793          	seqz	a5,a5
 274:	02a53713          	sltiu	a4,a0,42
 278:	00f607b3          	add	a5,a2,a5
 27c:	02070863          	beqz	a4,2ac <generate_maze+0x150>
 280:	0357b713          	sltiu	a4,a5,53
 284:	02070463          	beqz	a4,2ac <generate_maze+0x150>
 288:	034787b3          	mul	a5,a5,s4
 28c:	00f487b3          	add	a5,s1,a5
 290:	00a787b3          	add	a5,a5,a0
 294:	1bc7c783          	lbu	a5,444(a5)
 298:	00079a63          	bnez	a5,2ac <generate_maze+0x150>
 29c:	002d1793          	slli	a5,s10,0x2
 2a0:	00f487b3          	add	a5,s1,a5
 2a4:	1b87a623          	sw	s8,428(a5)
 2a8:	001d0d13          	addi	s10,s10,1
 2ac:	001c0c13          	addi	s8,s8,1
 2b0:	f96c1ce3          	bne	s8,s6,248 <generate_maze+0xec>
 2b4:	03460cb3          	mul	s9,a2,s4
 2b8:	01998cb3          	add	s9,s3,s9
 2bc:	00bc8cb3          	add	s9,s9,a1
 2c0:	080d1e63          	bnez	s10,35c <generate_maze+0x200>
 2c4:	000cc503          	lbu	a0,0(s9)
 2c8:	fff00693          	li	a3,-1
 2cc:	dadff0ef          	jal	78 <draw_cell>
 2d0:	16041663          	bnez	s0,43c <generate_maze+0x2e0>
 2d4:	00000493          	li	s1,0
 2d8:	02a00a13          	li	s4,42
 2dc:	03500a93          	li	s5,53
 2e0:	03448933          	mul	s2,s1,s4
 2e4:	00000413          	li	s0,0
 2e8:	01298933          	add	s2,s3,s2
 2ec:	008907b3          	add	a5,s2,s0
 2f0:	0007c503          	lbu	a0,0(a5)
 2f4:	00040593          	mv	a1,s0
 2f8:	fff00693          	li	a3,-1
 2fc:	00048613          	mv	a2,s1
 300:	00140413          	addi	s0,s0,1
 304:	d75ff0ef          	jal	78 <draw_cell>
 308:	ff4412e3          	bne	s0,s4,2ec <generate_maze+0x190>
 30c:	00148493          	addi	s1,s1,1
 310:	fd5498e3          	bne	s1,s5,2e0 <generate_maze+0x184>
 314:	000042b7          	lui	t0,0x4
 318:	6c028293          	addi	t0,t0,1728 # 46c0 <seg_write_hex+0x3e4c>
 31c:	00510133          	add	sp,sp,t0
 320:	7ec12083          	lw	ra,2028(sp)
 324:	7e812403          	lw	s0,2024(sp)
 328:	7e412483          	lw	s1,2020(sp)
 32c:	7e012903          	lw	s2,2016(sp)
 330:	7dc12983          	lw	s3,2012(sp)
 334:	7d812a03          	lw	s4,2008(sp)
 338:	7d412a83          	lw	s5,2004(sp)
 33c:	7d012b03          	lw	s6,2000(sp)
 340:	7cc12b83          	lw	s7,1996(sp)
 344:	7c812c03          	lw	s8,1992(sp)
 348:	7c412c83          	lw	s9,1988(sp)
 34c:	7c012d03          	lw	s10,1984(sp)
 350:	7bc12d83          	lw	s11,1980(sp)
 354:	7f010113          	addi	sp,sp,2032
 358:	00008067          	ret
 35c:	00412503          	lw	a0,4(sp)
 360:	00b12623          	sw	a1,12(sp)
 364:	00c12423          	sw	a2,8(sp)
 368:	ccdff0ef          	jal	34 <rand_next>
 36c:	03a57533          	remu	a0,a0,s10
 370:	fff00c13          	li	s8,-1
 374:	00251513          	slli	a0,a0,0x2
 378:	00a48533          	add	a0,s1,a0
 37c:	1ac52403          	lw	s0,428(a0)
 380:	00040513          	mv	a0,s0
 384:	cddff0ef          	jal	60 <dir_dx>
 388:	00c12583          	lw	a1,12(sp)
 38c:	00812603          	lw	a2,8(sp)
 390:	00b50d33          	add	s10,a0,a1
 394:	00040663          	beqz	s0,3a0 <generate_maze+0x244>
 398:	ffe40c13          	addi	s8,s0,-2
 39c:	001c3c13          	seqz	s8,s8
 3a0:	000cc703          	lbu	a4,0(s9)
 3a4:	008a97b3          	sll	a5,s5,s0
 3a8:	01860c33          	add	s8,a2,s8
 3ac:	fff7c793          	not	a5,a5
 3b0:	00e7f7b3          	and	a5,a5,a4
 3b4:	034c0733          	mul	a4,s8,s4
 3b8:	00fc8023          	sb	a5,0(s9)
 3bc:	00240793          	addi	a5,s0,2
 3c0:	0037f793          	andi	a5,a5,3
 3c4:	00fa97b3          	sll	a5,s5,a5
 3c8:	fff7c793          	not	a5,a5
 3cc:	001b8413          	addi	s0,s7,1
 3d0:	003b9b93          	slli	s7,s7,0x3
 3d4:	01790bb3          	add	s7,s2,s7
 3d8:	a7aba823          	sw	s10,-1424(s7)
 3dc:	00e98db3          	add	s11,s3,a4
 3e0:	01ad8db3          	add	s11,s11,s10
 3e4:	000dc683          	lbu	a3,0(s11)
 3e8:	00e48733          	add	a4,s1,a4
 3ec:	01a70733          	add	a4,a4,s10
 3f0:	00d7f7b3          	and	a5,a5,a3
 3f4:	00fd8023          	sb	a5,0(s11)
 3f8:	1b570e23          	sb	s5,444(a4)
 3fc:	000cc503          	lbu	a0,0(s9)
 400:	07ff06b7          	lui	a3,0x7ff0
 404:	7ff68693          	addi	a3,a3,2047 # 7ff07ff <seg_write_hex+0x7feff8b>
 408:	a78baa23          	sw	s8,-1420(s7)
 40c:	c6dff0ef          	jal	78 <draw_cell>
 410:	000dc503          	lbu	a0,0(s11)
 414:	07ff06b7          	lui	a3,0x7ff0
 418:	7ff68693          	addi	a3,a3,2047 # 7ff07ff <seg_write_hex+0x7feff8b>
 41c:	000c0613          	mv	a2,s8
 420:	000d0593          	mv	a1,s10
 424:	c55ff0ef          	jal	78 <draw_cell>
 428:	00040513          	mv	a0,s0
 42c:	448000ef          	jal	874 <seg_write_hex>
 430:	00001537          	lui	a0,0x1
 434:	fa050513          	addi	a0,a0,-96 # fa0 <seg_write_hex+0x72c>
 438:	bd5ff0ef          	jal	c <delay>
 43c:	00040b93          	mv	s7,s0
 440:	dedff06f          	j	22c <generate_maze+0xd0>

00000444 <solve_maze>:
 444:	eb010113          	addi	sp,sp,-336
 448:	ffff92b7          	lui	t0,0xffff9
 44c:	14912223          	sw	s1,324(sp)
 450:	14112623          	sw	ra,332(sp)
 454:	14812423          	sw	s0,328(sp)
 458:	15212023          	sw	s2,320(sp)
 45c:	13312e23          	sw	s3,316(sp)
 460:	13412c23          	sw	s4,312(sp)
 464:	13512a23          	sw	s5,308(sp)
 468:	13612823          	sw	s6,304(sp)
 46c:	13712623          	sw	s7,300(sp)
 470:	13812423          	sw	s8,296(sp)
 474:	13912223          	sw	s9,292(sp)
 478:	13a12023          	sw	s10,288(sp)
 47c:	11b12e23          	sw	s11,284(sp)
 480:	00510133          	add	sp,sp,t0
 484:	7ff10793          	addi	a5,sp,2047
 488:	000026b7          	lui	a3,0x2
 48c:	0b978793          	addi	a5,a5,185
 490:	2c868693          	addi	a3,a3,712 # 22c8 <seg_write_hex+0x1a54>
 494:	00050493          	mv	s1,a0
 498:	00410713          	addi	a4,sp,4
 49c:	00d786b3          	add	a3,a5,a3
 4a0:	fff00513          	li	a0,-1
 4a4:	02a00813          	li	a6,42
 4a8:	00078593          	mv	a1,a5
 4ac:	00000613          	li	a2,0
 4b0:	00c708b3          	add	a7,a4,a2
 4b4:	00a5a023          	sw	a0,0(a1)
 4b8:	00088023          	sb	zero,0(a7)
 4bc:	00160613          	addi	a2,a2,1
 4c0:	00458593          	addi	a1,a1,4
 4c4:	ff0616e3          	bne	a2,a6,4b0 <solve_maze+0x6c>
 4c8:	0a878793          	addi	a5,a5,168
 4cc:	02a70713          	addi	a4,a4,42
 4d0:	fcf69ce3          	bne	a3,a5,4a8 <solve_maze+0x64>
 4d4:	00003737          	lui	a4,0x3
 4d8:	11070713          	addi	a4,a4,272 # 3110 <seg_write_hex+0x289c>
 4dc:	000037b7          	lui	a5,0x3
 4e0:	00e10cb3          	add	s9,sp,a4
 4e4:	11010c13          	addi	s8,sp,272
 4e8:	00100913          	li	s2,1
 4ec:	b8078793          	addi	a5,a5,-1152 # 2b80 <seg_write_hex+0x230c>
 4f0:	ef2c0a23          	sb	s2,-268(s8)
 4f4:	a60ca823          	sw	zero,-1424(s9)
 4f8:	a60caa23          	sw	zero,-1420(s9)
 4fc:	00f10433          	add	s0,sp,a5
 500:	00000a93          	li	s5,0
 504:	00000b13          	li	s6,0
 508:	02a00b93          	li	s7,42
 50c:	00042d83          	lw	s11,0(s0)
 510:	00442d03          	lw	s10,4(s0)
 514:	fd7d8793          	addi	a5,s11,-41
 518:	0e079663          	bnez	a5,604 <solve_maze+0x1c0>
 51c:	fccd0793          	addi	a5,s10,-52
 520:	0e079263          	bnez	a5,604 <solve_maze+0x1c0>
 524:	00001437          	lui	s0,0x1
 528:	00000913          	li	s2,0
 52c:	8b140413          	addi	s0,s0,-1871 # 8b1 <seg_write_hex+0x3d>
 530:	02a00a93          	li	s5,42
 534:	11010993          	addi	s3,sp,272
 538:	fff00b13          	li	s6,-1
 53c:	03544633          	div	a2,s0,s5
 540:	001f06b7          	lui	a3,0x1f0
 544:	01f68693          	addi	a3,a3,31 # 1f001f <seg_write_hex+0x1ef7ab>
 548:	00190913          	addi	s2,s2,1
 54c:	03546a33          	rem	s4,s0,s5
 550:	03560433          	mul	s0,a2,s5
 554:	000a0593          	mv	a1,s4
 558:	008487b3          	add	a5,s1,s0
 55c:	014787b3          	add	a5,a5,s4
 560:	0007c503          	lbu	a0,0(a5)
 564:	01440433          	add	s0,s0,s4
 568:	00241413          	slli	s0,s0,0x2
 56c:	b0dff0ef          	jal	78 <draw_cell>
 570:	00090513          	mv	a0,s2
 574:	00898433          	add	s0,s3,s0
 578:	7a842403          	lw	s0,1960(s0)
 57c:	2e8000ef          	jal	864 <led_write>
 580:	00004537          	lui	a0,0x4
 584:	a9850513          	addi	a0,a0,-1384 # 3a98 <seg_write_hex+0x3224>
 588:	a85ff0ef          	jal	c <delay>
 58c:	fb6418e3          	bne	s0,s6,53c <solve_maze+0xf8>
 590:	0004c503          	lbu	a0,0(s1)
 594:	07e006b7          	lui	a3,0x7e00
 598:	7e068693          	addi	a3,a3,2016 # 7e007e0 <seg_write_hex+0x7dfff6c>
 59c:	00000613          	li	a2,0
 5a0:	00000593          	li	a1,0
 5a4:	ad5ff0ef          	jal	78 <draw_cell>
 5a8:	7ff48493          	addi	s1,s1,2047
 5ac:	000072b7          	lui	t0,0x7
 5b0:	0b24c503          	lbu	a0,178(s1)
 5b4:	00510133          	add	sp,sp,t0
 5b8:	14c12083          	lw	ra,332(sp)
 5bc:	14812403          	lw	s0,328(sp)
 5c0:	14412483          	lw	s1,324(sp)
 5c4:	14012903          	lw	s2,320(sp)
 5c8:	13c12983          	lw	s3,316(sp)
 5cc:	13812a03          	lw	s4,312(sp)
 5d0:	13412a83          	lw	s5,308(sp)
 5d4:	13012b03          	lw	s6,304(sp)
 5d8:	12c12b83          	lw	s7,300(sp)
 5dc:	12812c03          	lw	s8,296(sp)
 5e0:	12412c83          	lw	s9,292(sp)
 5e4:	12012d03          	lw	s10,288(sp)
 5e8:	11c12d83          	lw	s11,284(sp)
 5ec:	f80106b7          	lui	a3,0xf8010
 5f0:	80068693          	addi	a3,a3,-2048 # f800f800 <seg_write_hex+0xf800ef8c>
 5f4:	03400613          	li	a2,52
 5f8:	02900593          	li	a1,41
 5fc:	15010113          	addi	sp,sp,336
 600:	a79ff06f          	j	78 <draw_cell>
 604:	037d0a33          	mul	s4,s10,s7
 608:	001b0b13          	addi	s6,s6,1
 60c:	00000993          	li	s3,0
 610:	01448a33          	add	s4,s1,s4
 614:	01ba0a33          	add	s4,s4,s11
 618:	000a4783          	lbu	a5,0(s4)
 61c:	00100713          	li	a4,1
 620:	01371733          	sll	a4,a4,s3
 624:	00e7f7b3          	and	a5,a5,a4
 628:	0a079663          	bnez	a5,6d4 <solve_maze+0x290>
 62c:	00098513          	mv	a0,s3
 630:	a31ff0ef          	jal	60 <dir_dx>
 634:	01b505b3          	add	a1,a0,s11
 638:	fff00613          	li	a2,-1
 63c:	00098663          	beqz	s3,648 <solve_maze+0x204>
 640:	ffe98613          	addi	a2,s3,-2
 644:	00163613          	seqz	a2,a2
 648:	02a5b793          	sltiu	a5,a1,42
 64c:	00cd0633          	add	a2,s10,a2
 650:	08078263          	beqz	a5,6d4 <solve_maze+0x290>
 654:	03563793          	sltiu	a5,a2,53
 658:	06078e63          	beqz	a5,6d4 <solve_maze+0x290>
 65c:	037607b3          	mul	a5,a2,s7
 660:	00fc0733          	add	a4,s8,a5
 664:	00b70733          	add	a4,a4,a1
 668:	ef474683          	lbu	a3,-268(a4)
 66c:	06069463          	bnez	a3,6d4 <solve_maze+0x290>
 670:	00100693          	li	a3,1
 674:	eed70a23          	sb	a3,-268(a4)
 678:	037d06b3          	mul	a3,s10,s7
 67c:	00b78733          	add	a4,a5,a1
 680:	00f487b3          	add	a5,s1,a5
 684:	00b787b3          	add	a5,a5,a1
 688:	00271713          	slli	a4,a4,0x2
 68c:	0007c503          	lbu	a0,0(a5)
 690:	00ec0733          	add	a4,s8,a4
 694:	001a8a93          	addi	s5,s5,1
 698:	01b686b3          	add	a3,a3,s11
 69c:	7ad72423          	sw	a3,1960(a4)
 6a0:	00391713          	slli	a4,s2,0x3
 6a4:	07ff06b7          	lui	a3,0x7ff0
 6a8:	00ec8733          	add	a4,s9,a4
 6ac:	7ff68693          	addi	a3,a3,2047 # 7ff07ff <seg_write_hex+0x7feff8b>
 6b0:	a6b72823          	sw	a1,-1424(a4)
 6b4:	a6c72a23          	sw	a2,-1420(a4)
 6b8:	9c1ff0ef          	jal	78 <draw_cell>
 6bc:	000a8513          	mv	a0,s5
 6c0:	1b4000ef          	jal	874 <seg_write_hex>
 6c4:	00001537          	lui	a0,0x1
 6c8:	bb850513          	addi	a0,a0,-1096 # bb8 <seg_write_hex+0x344>
 6cc:	941ff0ef          	jal	c <delay>
 6d0:	00190913          	addi	s2,s2,1
 6d4:	00198993          	addi	s3,s3,1
 6d8:	00400793          	li	a5,4
 6dc:	f2f99ee3          	bne	s3,a5,618 <solve_maze+0x1d4>
 6e0:	00840413          	addi	s0,s0,8
 6e4:	e32b44e3          	blt	s6,s2,50c <solve_maze+0xc8>
 6e8:	e3dff06f          	j	524 <solve_maze+0xe0>

000006ec <main>:
 6ec:	81010113          	addi	sp,sp,-2032
 6f0:	7e812423          	sw	s0,2024(sp)
 6f4:	7f212023          	sw	s2,2016(sp)
 6f8:	7d312e23          	sw	s3,2012(sp)
 6fc:	7e112623          	sw	ra,2028(sp)
 700:	7e912223          	sw	s1,2020(sp)
 704:	7d412c23          	sw	s4,2008(sp)
 708:	0000c7b7          	lui	a5,0xc
 70c:	f1010113          	addi	sp,sp,-240
 710:	eef78793          	addi	a5,a5,-273 # beef <seg_write_hex+0xb67b>
 714:	0a000713          	li	a4,160
 718:	08000693          	li	a3,128
 71c:	00000613          	li	a2,0
 720:	00000593          	li	a1,0
 724:	00000513          	li	a0,0
 728:	9e3789b7          	lui	s3,0x9e378
 72c:	00003937          	lui	s2,0x3
 730:	8c010413          	addi	s0,sp,-1856
 734:	74f42423          	sw	a5,1864(s0)
 738:	9b198993          	addi	s3,s3,-1615 # 9e3779b1 <seg_write_hex+0x9e37713d>
 73c:	0b0000ef          	jal	7ec <st7735_draw_rectangle>
 740:	03990913          	addi	s2,s2,57 # 3039 <seg_write_hex+0x27c5>
 744:	00810593          	addi	a1,sp,8
 748:	00c10513          	addi	a0,sp,12
 74c:	a11ff0ef          	jal	15c <generate_maze>
 750:	00031537          	lui	a0,0x31
 754:	d4050513          	addi	a0,a0,-704 # 30d40 <seg_write_hex+0x304cc>
 758:	8b5ff0ef          	jal	c <delay>
 75c:	00c10513          	addi	a0,sp,12
 760:	ce5ff0ef          	jal	444 <solve_maze>
 764:	00092537          	lui	a0,0x92
 768:	7c050513          	addi	a0,a0,1984 # 927c0 <seg_write_hex+0x91f4c>
 76c:	8a1ff0ef          	jal	c <delay>
 770:	74842783          	lw	a5,1864(s0)
 774:	0a000713          	li	a4,160
 778:	08000693          	li	a3,128
 77c:	033787b3          	mul	a5,a5,s3
 780:	00000613          	li	a2,0
 784:	00000593          	li	a1,0
 788:	00000513          	li	a0,0
 78c:	012787b3          	add	a5,a5,s2
 790:	74f42423          	sw	a5,1864(s0)
 794:	058000ef          	jal	7ec <st7735_draw_rectangle>
 798:	fadff06f          	j	744 <main+0x58>

0000079c <st7735_set_rectangle>:
 79c:	00ff07b7          	lui	a5,0xff0
 7a0:	01059593          	slli	a1,a1,0x10
 7a4:	0ff6f693          	zext.b	a3,a3
 7a8:	00f5f5b3          	and	a1,a1,a5
 7ac:	00869693          	slli	a3,a3,0x8
 7b0:	01051513          	slli	a0,a0,0x10
 7b4:	0ff67613          	zext.b	a2,a2
 7b8:	00f57533          	and	a0,a0,a5
 7bc:	00861613          	slli	a2,a2,0x8
 7c0:	00d5e5b3          	or	a1,a1,a3
 7c4:	2b0007b7          	lui	a5,0x2b000
 7c8:	00c56533          	or	a0,a0,a2
 7cc:	2a000737          	lui	a4,0x2a000
 7d0:	00f5e5b3          	or	a1,a1,a5
 7d4:	f00007b7          	lui	a5,0xf0000
 7d8:	00e56533          	or	a0,a0,a4
 7dc:	00278793          	addi	a5,a5,2 # f0000002 <seg_write_hex+0xeffff78e>
 7e0:	00a7a023          	sw	a0,0(a5)
 7e4:	00b7a023          	sw	a1,0(a5)
 7e8:	00008067          	ret

000007ec <st7735_draw_rectangle>:
 7ec:	fe010113          	addi	sp,sp,-32
 7f0:	00812c23          	sw	s0,24(sp)
 7f4:	00912a23          	sw	s1,20(sp)
 7f8:	00068413          	mv	s0,a3
 7fc:	00050493          	mv	s1,a0
 800:	00058513          	mv	a0,a1
 804:	00e606b3          	add	a3,a2,a4
 808:	00060593          	mv	a1,a2
 80c:	00850633          	add	a2,a0,s0
 810:	fff68693          	addi	a3,a3,-1
 814:	fff60613          	addi	a2,a2,-1
 818:	00112e23          	sw	ra,28(sp)
 81c:	00e12623          	sw	a4,12(sp)
 820:	f7dff0ef          	jal	79c <st7735_set_rectangle>
 824:	00c12703          	lw	a4,12(sp)
 828:	2c0007b7          	lui	a5,0x2c000
 82c:	02e40433          	mul	s0,s0,a4
 830:	40145413          	srai	s0,s0,0x1
 834:	00f46433          	or	s0,s0,a5
 838:	f00007b7          	lui	a5,0xf0000
 83c:	00278793          	addi	a5,a5,2 # f0000002 <seg_write_hex+0xeffff78e>
 840:	0087a023          	sw	s0,0(a5)
 844:	f00007b7          	lui	a5,0xf0000
 848:	00178793          	addi	a5,a5,1 # f0000001 <seg_write_hex+0xeffff78d>
 84c:	0097a023          	sw	s1,0(a5)
 850:	01c12083          	lw	ra,28(sp)
 854:	01812403          	lw	s0,24(sp)
 858:	01412483          	lw	s1,20(sp)
 85c:	02010113          	addi	sp,sp,32
 860:	00008067          	ret

00000864 <led_write>:
 864:	f00007b7          	lui	a5,0xf0000
 868:	00878793          	addi	a5,a5,8 # f0000008 <seg_write_hex+0xeffff794>
 86c:	00a79023          	sh	a0,0(a5)
 870:	00008067          	ret

00000874 <seg_write_hex>:
 874:	f00007b7          	lui	a5,0xf0000
 878:	00478793          	addi	a5,a5,4 # f0000004 <seg_write_hex+0xeffff790>
 87c:	00a79023          	sh	a0,0(a5)
 880:	00008067          	ret
