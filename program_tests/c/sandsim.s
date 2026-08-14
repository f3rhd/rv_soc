
__out_tmp.elf:     file format elf32-littleriscv


Disassembly of section .text:

00000000 <_start>:
   0:	00008137          	lui	sp,0x8
   4:	240000ef          	jal	244 <main>

00000008 <halt_loop>:
   8:	0000006f          	j	8 <halt_loop>

0000000c <delay>:
   c:	ff010113          	addi	sp,sp,-16 # 7ff0 <read_pin+0x7abc>
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
  3c:	e6d70713          	addi	a4,a4,-403 # 41c64e6d <read_pin+0x41c64939>
  40:	02e787b3          	mul	a5,a5,a4
  44:	00003737          	lui	a4,0x3
  48:	03970713          	addi	a4,a4,57 # 3039 <read_pin+0x2b05>
  4c:	00e787b3          	add	a5,a5,a4
  50:	00179713          	slli	a4,a5,0x1
  54:	00f52023          	sw	a5,0(a0)
  58:	01175513          	srli	a0,a4,0x11
  5c:	00008067          	ret

00000060 <draw_cell>:
  60:	00060793          	mv	a5,a2
  64:	00400713          	li	a4,4
  68:	00259613          	slli	a2,a1,0x2
  6c:	00070693          	mv	a3,a4
  70:	00251593          	slli	a1,a0,0x2
  74:	00078513          	mv	a0,a5
  78:	4040006f          	j	47c <st7735_draw_rectangle>

0000007c <clear_grid>:
  7c:	50050713          	addi	a4,a0,1280
  80:	02000693          	li	a3,32
  84:	00000793          	li	a5,0
  88:	00f50633          	add	a2,a0,a5
  8c:	00060023          	sb	zero,0(a2)
  90:	00178793          	addi	a5,a5,1
  94:	fed79ae3          	bne	a5,a3,88 <clear_grid+0xc>
  98:	02050513          	addi	a0,a0,32
  9c:	fee514e3          	bne	a0,a4,84 <clear_grid+0x8>
  a0:	0a000713          	li	a4,160
  a4:	08000693          	li	a3,128
  a8:	00000613          	li	a2,0
  ac:	00000593          	li	a1,0
  b0:	00000513          	li	a0,0
  b4:	3c80006f          	j	47c <st7735_draw_rectangle>

000000b8 <simulate_step>:
  b8:	fc010113          	addi	sp,sp,-64
  bc:	02912a23          	sw	s1,52(sp)
  c0:	03412423          	sw	s4,40(sp)
  c4:	03512223          	sw	s5,36(sp)
  c8:	01712e23          	sw	s7,28(sp)
  cc:	01812c23          	sw	s8,24(sp)
  d0:	01b12623          	sw	s11,12(sp)
  d4:	02112e23          	sw	ra,60(sp)
  d8:	02812c23          	sw	s0,56(sp)
  dc:	03212823          	sw	s2,48(sp)
  e0:	03312623          	sw	s3,44(sp)
  e4:	03612023          	sw	s6,32(sp)
  e8:	01912a23          	sw	s9,20(sp)
  ec:	01a12823          	sw	s10,16(sp)
  f0:	00058d93          	mv	s11,a1
  f4:	4e050a13          	addi	s4,a0,1248
  f8:	02700493          	li	s1,39
  fc:	00100a93          	li	s5,1
 100:	01f00b93          	li	s7,31
 104:	02000c13          	li	s8,32
 108:	000a0b13          	mv	s6,s4
 10c:	fe0a0a13          	addi	s4,s4,-32
 110:	00048d13          	mv	s10,s1
 114:	000a0993          	mv	s3,s4
 118:	fff48493          	addi	s1,s1,-1
 11c:	00000413          	li	s0,0
 120:	0009c783          	lbu	a5,0(s3)
 124:	03579e63          	bne	a5,s5,160 <simulate_step+0xa8>
 128:	008b07b3          	add	a5,s6,s0
 12c:	0007c703          	lbu	a4,0(a5)
 130:	06071e63          	bnez	a4,1ac <simulate_step+0xf4>
 134:	00098023          	sb	zero,0(s3)
 138:	00000613          	li	a2,0
 13c:	00048593          	mv	a1,s1
 140:	00040513          	mv	a0,s0
 144:	01578023          	sb	s5,0(a5)
 148:	f19ff0ef          	jal	60 <draw_cell>
 14c:	07ff0637          	lui	a2,0x7ff0
 150:	7ff60613          	addi	a2,a2,2047 # 7ff07ff <read_pin+0x7ff02cb>
 154:	000d0593          	mv	a1,s10
 158:	00040513          	mv	a0,s0
 15c:	f05ff0ef          	jal	60 <draw_cell>
 160:	00140413          	addi	s0,s0,1
 164:	00198993          	addi	s3,s3,1
 168:	fb841ce3          	bne	s0,s8,120 <simulate_step+0x68>
 16c:	f8049ee3          	bnez	s1,108 <simulate_step+0x50>
 170:	03c12083          	lw	ra,60(sp)
 174:	03812403          	lw	s0,56(sp)
 178:	03412483          	lw	s1,52(sp)
 17c:	03012903          	lw	s2,48(sp)
 180:	02c12983          	lw	s3,44(sp)
 184:	02812a03          	lw	s4,40(sp)
 188:	02412a83          	lw	s5,36(sp)
 18c:	02012b03          	lw	s6,32(sp)
 190:	01c12b83          	lw	s7,28(sp)
 194:	01812c03          	lw	s8,24(sp)
 198:	01412c83          	lw	s9,20(sp)
 19c:	01012d03          	lw	s10,16(sp)
 1a0:	00c12d83          	lw	s11,12(sp)
 1a4:	04010113          	addi	sp,sp,64
 1a8:	00008067          	ret
 1ac:	000d8513          	mv	a0,s11
 1b0:	e85ff0ef          	jal	34 <rand_next>
 1b4:	00157513          	andi	a0,a0,1
 1b8:	000a8913          	mv	s2,s5
 1bc:	00050463          	beqz	a0,1c4 <simulate_step+0x10c>
 1c0:	fff00913          	li	s2,-1
 1c4:	00890cb3          	add	s9,s2,s0
 1c8:	039bee63          	bltu	s7,s9,204 <simulate_step+0x14c>
 1cc:	019b07b3          	add	a5,s6,s9
 1d0:	0007c703          	lbu	a4,0(a5)
 1d4:	02071863          	bnez	a4,204 <simulate_step+0x14c>
 1d8:	00098023          	sb	zero,0(s3)
 1dc:	00000613          	li	a2,0
 1e0:	00048593          	mv	a1,s1
 1e4:	00040513          	mv	a0,s0
 1e8:	01578023          	sb	s5,0(a5)
 1ec:	e75ff0ef          	jal	60 <draw_cell>
 1f0:	07ff0637          	lui	a2,0x7ff0
 1f4:	7ff60613          	addi	a2,a2,2047 # 7ff07ff <read_pin+0x7ff02cb>
 1f8:	000d0593          	mv	a1,s10
 1fc:	000c8513          	mv	a0,s9
 200:	f5dff06f          	j	15c <simulate_step+0xa4>
 204:	41240933          	sub	s2,s0,s2
 208:	f52bece3          	bltu	s7,s2,160 <simulate_step+0xa8>
 20c:	012b07b3          	add	a5,s6,s2
 210:	0007c703          	lbu	a4,0(a5)
 214:	f40716e3          	bnez	a4,160 <simulate_step+0xa8>
 218:	00098023          	sb	zero,0(s3)
 21c:	00000613          	li	a2,0
 220:	00048593          	mv	a1,s1
 224:	00040513          	mv	a0,s0
 228:	01578023          	sb	s5,0(a5)
 22c:	e35ff0ef          	jal	60 <draw_cell>
 230:	07ff0637          	lui	a2,0x7ff0
 234:	7ff60613          	addi	a2,a2,2047 # 7ff07ff <read_pin+0x7ff02cb>
 238:	000d0593          	mv	a1,s10
 23c:	00090513          	mv	a0,s2
 240:	f1dff06f          	j	15c <simulate_step+0xa4>

00000244 <main>:
 244:	ac010113          	addi	sp,sp,-1344
 248:	00000593          	li	a1,0
 24c:	00800513          	li	a0,8
 250:	52112e23          	sw	ra,1340(sp)
 254:	52812c23          	sw	s0,1336(sp)
 258:	52912a23          	sw	s1,1332(sp)
 25c:	53212823          	sw	s2,1328(sp)
 260:	53512223          	sw	s5,1316(sp)
 264:	53612023          	sw	s6,1312(sp)
 268:	51712e23          	sw	s7,1308(sp)
 26c:	53312623          	sw	s3,1324(sp)
 270:	53412423          	sw	s4,1320(sp)
 274:	51812c23          	sw	s8,1304(sp)
 278:	51912a23          	sw	s9,1300(sp)
 27c:	298000ef          	jal	514 <set_pin_mode>
 280:	00000593          	li	a1,0
 284:	00900513          	li	a0,9
 288:	28c000ef          	jal	514 <set_pin_mode>
 28c:	00000593          	li	a1,0
 290:	00a00513          	li	a0,10
 294:	280000ef          	jal	514 <set_pin_mode>
 298:	00000593          	li	a1,0
 29c:	00b00513          	li	a0,11
 2a0:	274000ef          	jal	514 <set_pin_mode>
 2a4:	000067b7          	lui	a5,0x6
 2a8:	a5d78793          	addi	a5,a5,-1443 # 5a5d <read_pin+0x5529>
 2ac:	01010513          	addi	a0,sp,16
 2b0:	00f12623          	sw	a5,12(sp)
 2b4:	00000913          	li	s2,0
 2b8:	dc5ff0ef          	jal	7c <clear_grid>
 2bc:	00000493          	li	s1,0
 2c0:	00000b93          	li	s7,0
 2c4:	01000413          	li	s0,16
 2c8:	01e00a93          	li	s5,30
 2cc:	00100b13          	li	s6,1
 2d0:	00800513          	li	a0,8
 2d4:	260000ef          	jal	534 <read_pin>
 2d8:	00050c13          	mv	s8,a0
 2dc:	00900513          	li	a0,9
 2e0:	254000ef          	jal	534 <read_pin>
 2e4:	00050a13          	mv	s4,a0
 2e8:	00a00513          	li	a0,10
 2ec:	248000ef          	jal	534 <read_pin>
 2f0:	00050c93          	mv	s9,a0
 2f4:	00b00513          	li	a0,11
 2f8:	23c000ef          	jal	534 <read_pin>
 2fc:	00050993          	mv	s3,a0
 300:	000a0863          	beqz	s4,310 <main+0xcc>
 304:	000b9663          	bnez	s7,310 <main+0xcc>
 308:	01010513          	addi	a0,sp,16
 30c:	d71ff0ef          	jal	7c <clear_grid>
 310:	009037b3          	snez	a5,s1
 314:	40f484b3          	sub	s1,s1,a5
 318:	51040793          	addi	a5,s0,1296
 31c:	002787b3          	add	a5,a5,sp
 320:	b007c783          	lbu	a5,-1280(a5)
 324:	00079a63          	bnez	a5,338 <main+0xf4>
 328:	00000613          	li	a2,0
 32c:	00000593          	li	a1,0
 330:	00040513          	mv	a0,s0
 334:	d2dff0ef          	jal	60 <draw_cell>
 338:	00049e63          	bnez	s1,354 <main+0x110>
 33c:	0a0c9e63          	bnez	s9,3f8 <main+0x1b4>
 340:	00098a63          	beqz	s3,354 <main+0x110>
 344:	00400493          	li	s1,4
 348:	008ac663          	blt	s5,s0,354 <main+0x110>
 34c:	00140413          	addi	s0,s0,1
 350:	00400493          	li	s1,4
 354:	012037b3          	snez	a5,s2
 358:	40f90933          	sub	s2,s2,a5
 35c:	51040793          	addi	a5,s0,1296
 360:	002789b3          	add	s3,a5,sp
 364:	00091a63          	bnez	s2,378 <main+0x134>
 368:	000c0863          	beqz	s8,378 <main+0x134>
 36c:	b009c783          	lbu	a5,-1280(s3)
 370:	08078c63          	beqz	a5,408 <main+0x1c4>
 374:	00200913          	li	s2,2
 378:	00c10593          	addi	a1,sp,12
 37c:	01010513          	addi	a0,sp,16
 380:	d39ff0ef          	jal	b8 <simulate_step>
 384:	b009c783          	lbu	a5,-1280(s3)
 388:	00079c63          	bnez	a5,3a0 <main+0x15c>
 38c:	001f0637          	lui	a2,0x1f0
 390:	01f60613          	addi	a2,a2,31 # 1f001f <read_pin+0x1efaeb>
 394:	00000593          	li	a1,0
 398:	00040513          	mv	a0,s0
 39c:	cc5ff0ef          	jal	60 <draw_cell>
 3a0:	01010693          	addi	a3,sp,16
 3a4:	00000513          	li	a0,0
 3a8:	02000613          	li	a2,32
 3ac:	00000713          	li	a4,0
 3b0:	00e687b3          	add	a5,a3,a4
 3b4:	0007c783          	lbu	a5,0(a5)
 3b8:	00170713          	addi	a4,a4,1
 3bc:	fff78793          	addi	a5,a5,-1
 3c0:	0017b793          	seqz	a5,a5
 3c4:	00f50533          	add	a0,a0,a5
 3c8:	fec714e3          	bne	a4,a2,3b0 <main+0x16c>
 3cc:	02068693          	addi	a3,a3,32
 3d0:	51010793          	addi	a5,sp,1296
 3d4:	fcf69ce3          	bne	a3,a5,3ac <main+0x168>
 3d8:	12c000ef          	jal	504 <seg_write_hex>
 3dc:	00040513          	mv	a0,s0
 3e0:	114000ef          	jal	4f4 <led_write>
 3e4:	00005537          	lui	a0,0x5
 3e8:	e2050513          	addi	a0,a0,-480 # 4e20 <read_pin+0x48ec>
 3ec:	c21ff0ef          	jal	c <delay>
 3f0:	000a0b93          	mv	s7,s4
 3f4:	eddff06f          	j	2d0 <main+0x8c>
 3f8:	02805663          	blez	s0,424 <main+0x1e0>
 3fc:	fff40413          	addi	s0,s0,-1
 400:	00400493          	li	s1,4
 404:	f3dff06f          	j	340 <main+0xfc>
 408:	07ff0637          	lui	a2,0x7ff0
 40c:	7ff60613          	addi	a2,a2,2047 # 7ff07ff <read_pin+0x7ff02cb>
 410:	00000593          	li	a1,0
 414:	00040513          	mv	a0,s0
 418:	b1698023          	sb	s6,-1280(s3)
 41c:	c45ff0ef          	jal	60 <draw_cell>
 420:	f55ff06f          	j	374 <main+0x130>
 424:	f20986e3          	beqz	s3,350 <main+0x10c>
 428:	f25ff06f          	j	34c <main+0x108>

0000042c <st7735_set_rectangle>:
 42c:	00ff07b7          	lui	a5,0xff0
 430:	01059593          	slli	a1,a1,0x10
 434:	0ff6f693          	zext.b	a3,a3
 438:	00f5f5b3          	and	a1,a1,a5
 43c:	00869693          	slli	a3,a3,0x8
 440:	01051513          	slli	a0,a0,0x10
 444:	0ff67613          	zext.b	a2,a2
 448:	00f57533          	and	a0,a0,a5
 44c:	00861613          	slli	a2,a2,0x8
 450:	00d5e5b3          	or	a1,a1,a3
 454:	2b0007b7          	lui	a5,0x2b000
 458:	00c56533          	or	a0,a0,a2
 45c:	2a000737          	lui	a4,0x2a000
 460:	00f5e5b3          	or	a1,a1,a5
 464:	f00007b7          	lui	a5,0xf0000
 468:	00e56533          	or	a0,a0,a4
 46c:	00278793          	addi	a5,a5,2 # f0000002 <read_pin+0xefffface>
 470:	00a7a023          	sw	a0,0(a5)
 474:	00b7a023          	sw	a1,0(a5)
 478:	00008067          	ret

0000047c <st7735_draw_rectangle>:
 47c:	fe010113          	addi	sp,sp,-32
 480:	00812c23          	sw	s0,24(sp)
 484:	00912a23          	sw	s1,20(sp)
 488:	00068413          	mv	s0,a3
 48c:	00050493          	mv	s1,a0
 490:	00058513          	mv	a0,a1
 494:	00e606b3          	add	a3,a2,a4
 498:	00060593          	mv	a1,a2
 49c:	00850633          	add	a2,a0,s0
 4a0:	fff68693          	addi	a3,a3,-1
 4a4:	fff60613          	addi	a2,a2,-1
 4a8:	00112e23          	sw	ra,28(sp)
 4ac:	00e12623          	sw	a4,12(sp)
 4b0:	f7dff0ef          	jal	42c <st7735_set_rectangle>
 4b4:	00c12703          	lw	a4,12(sp)
 4b8:	2c0007b7          	lui	a5,0x2c000
 4bc:	02e40433          	mul	s0,s0,a4
 4c0:	40145413          	srai	s0,s0,0x1
 4c4:	00f46433          	or	s0,s0,a5
 4c8:	f00007b7          	lui	a5,0xf0000
 4cc:	00278793          	addi	a5,a5,2 # f0000002 <read_pin+0xefffface>
 4d0:	0087a023          	sw	s0,0(a5)
 4d4:	f00007b7          	lui	a5,0xf0000
 4d8:	00178793          	addi	a5,a5,1 # f0000001 <read_pin+0xeffffacd>
 4dc:	0097a023          	sw	s1,0(a5)
 4e0:	01c12083          	lw	ra,28(sp)
 4e4:	01812403          	lw	s0,24(sp)
 4e8:	01412483          	lw	s1,20(sp)
 4ec:	02010113          	addi	sp,sp,32
 4f0:	00008067          	ret

000004f4 <led_write>:
 4f4:	f00007b7          	lui	a5,0xf0000
 4f8:	00878793          	addi	a5,a5,8 # f0000008 <read_pin+0xeffffad4>
 4fc:	00a79023          	sh	a0,0(a5)
 500:	00008067          	ret

00000504 <seg_write_hex>:
 504:	f00007b7          	lui	a5,0xf0000
 508:	00478793          	addi	a5,a5,4 # f0000004 <read_pin+0xeffffad0>
 50c:	00a79023          	sh	a0,0(a5)
 510:	00008067          	ret

00000514 <set_pin_mode>:
 514:	00151513          	slli	a0,a0,0x1
 518:	0015f593          	andi	a1,a1,1
 51c:	03e57513          	andi	a0,a0,62
 520:	f00007b7          	lui	a5,0xf0000
 524:	00b56533          	or	a0,a0,a1
 528:	01078793          	addi	a5,a5,16 # f0000010 <read_pin+0xeffffadc>
 52c:	00a7a023          	sw	a0,0(a5)
 530:	00008067          	ret

00000534 <read_pin>:
 534:	01f57513          	andi	a0,a0,31
 538:	f00007b7          	lui	a5,0xf0000
 53c:	04078793          	addi	a5,a5,64 # f0000040 <read_pin+0xeffffb0c>
 540:	00851513          	slli	a0,a0,0x8
 544:	00f56533          	or	a0,a0,a5
 548:	00052503          	lw	a0,0(a0)
 54c:	00157513          	andi	a0,a0,1
 550:	00008067          	ret
