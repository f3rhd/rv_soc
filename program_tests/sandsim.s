
__out_tmp.elf:     file format elf32-littleriscv


Disassembly of section .text:

00000000 <__static_end>:
   0:	00001197          	auipc	gp,0x1
   4:	80018193          	addi	gp,gp,-2048 # 800 <__global_pointer$>
   8:	00020117          	auipc	sp,0x20
   c:	ff810113          	addi	sp,sp,-8 # 20000 <__stack_top>
  10:	240000ef          	jal	250 <main>

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

0000006c <draw_cell>:
  6c:	00060793          	mv	a5,a2
  70:	00400713          	li	a4,4
  74:	00259613          	slli	a2,a1,0x2
  78:	00070693          	mv	a3,a4
  7c:	00251593          	slli	a1,a0,0x2
  80:	00078513          	mv	a0,a5
  84:	4640006f          	j	4e8 <st7735_draw_rectangle>

00000088 <clear_grid>:
  88:	50050713          	addi	a4,a0,1280
  8c:	02000693          	li	a3,32
  90:	00000793          	li	a5,0
  94:	00f50633          	add	a2,a0,a5
  98:	00060023          	sb	zero,0(a2)
  9c:	00178793          	addi	a5,a5,1
  a0:	fed79ae3          	bne	a5,a3,94 <clear_grid+0xc>
  a4:	02050513          	addi	a0,a0,32
  a8:	fee514e3          	bne	a0,a4,90 <clear_grid+0x8>
  ac:	0a000713          	li	a4,160
  b0:	08000693          	li	a3,128
  b4:	00000613          	li	a2,0
  b8:	00000593          	li	a1,0
  bc:	00000513          	li	a0,0
  c0:	4280006f          	j	4e8 <st7735_draw_rectangle>

000000c4 <simulate_step>:
  c4:	fc010113          	addi	sp,sp,-64
  c8:	02912a23          	sw	s1,52(sp)
  cc:	03412423          	sw	s4,40(sp)
  d0:	03512223          	sw	s5,36(sp)
  d4:	01712e23          	sw	s7,28(sp)
  d8:	01812c23          	sw	s8,24(sp)
  dc:	01b12623          	sw	s11,12(sp)
  e0:	02112e23          	sw	ra,60(sp)
  e4:	02812c23          	sw	s0,56(sp)
  e8:	03212823          	sw	s2,48(sp)
  ec:	03312623          	sw	s3,44(sp)
  f0:	03612023          	sw	s6,32(sp)
  f4:	01912a23          	sw	s9,20(sp)
  f8:	01a12823          	sw	s10,16(sp)
  fc:	00058d93          	mv	s11,a1
 100:	4e050a13          	addi	s4,a0,1248
 104:	02700493          	li	s1,39
 108:	00100a93          	li	s5,1
 10c:	01f00b93          	li	s7,31
 110:	02000c13          	li	s8,32
 114:	000a0b13          	mv	s6,s4
 118:	fe0a0a13          	addi	s4,s4,-32
 11c:	00048d13          	mv	s10,s1
 120:	000a0993          	mv	s3,s4
 124:	fff48493          	addi	s1,s1,-1
 128:	00000413          	li	s0,0
 12c:	0009c783          	lbu	a5,0(s3)
 130:	03579e63          	bne	a5,s5,16c <simulate_step+0xa8>
 134:	008b07b3          	add	a5,s6,s0
 138:	0007c703          	lbu	a4,0(a5)
 13c:	06071e63          	bnez	a4,1b8 <simulate_step+0xf4>
 140:	00098023          	sb	zero,0(s3)
 144:	00000613          	li	a2,0
 148:	00048593          	mv	a1,s1
 14c:	00040513          	mv	a0,s0
 150:	01578023          	sb	s5,0(a5)
 154:	f19ff0ef          	jal	6c <draw_cell>
 158:	07ff0637          	lui	a2,0x7ff0
 15c:	7ff60613          	addi	a2,a2,2047 # 7ff07ff <__stack_top+0x7fd07ff>
 160:	000d0593          	mv	a1,s10
 164:	00040513          	mv	a0,s0
 168:	f05ff0ef          	jal	6c <draw_cell>
 16c:	00140413          	addi	s0,s0,1
 170:	00198993          	addi	s3,s3,1
 174:	fb841ce3          	bne	s0,s8,12c <simulate_step+0x68>
 178:	f8049ee3          	bnez	s1,114 <simulate_step+0x50>
 17c:	03c12083          	lw	ra,60(sp)
 180:	03812403          	lw	s0,56(sp)
 184:	03412483          	lw	s1,52(sp)
 188:	03012903          	lw	s2,48(sp)
 18c:	02c12983          	lw	s3,44(sp)
 190:	02812a03          	lw	s4,40(sp)
 194:	02412a83          	lw	s5,36(sp)
 198:	02012b03          	lw	s6,32(sp)
 19c:	01c12b83          	lw	s7,28(sp)
 1a0:	01812c03          	lw	s8,24(sp)
 1a4:	01412c83          	lw	s9,20(sp)
 1a8:	01012d03          	lw	s10,16(sp)
 1ac:	00c12d83          	lw	s11,12(sp)
 1b0:	04010113          	addi	sp,sp,64
 1b4:	00008067          	ret
 1b8:	000d8513          	mv	a0,s11
 1bc:	e85ff0ef          	jal	40 <rand_next>
 1c0:	00157513          	andi	a0,a0,1
 1c4:	000a8913          	mv	s2,s5
 1c8:	00050463          	beqz	a0,1d0 <simulate_step+0x10c>
 1cc:	fff00913          	li	s2,-1
 1d0:	00890cb3          	add	s9,s2,s0
 1d4:	039bee63          	bltu	s7,s9,210 <simulate_step+0x14c>
 1d8:	019b07b3          	add	a5,s6,s9
 1dc:	0007c703          	lbu	a4,0(a5)
 1e0:	02071863          	bnez	a4,210 <simulate_step+0x14c>
 1e4:	00098023          	sb	zero,0(s3)
 1e8:	00000613          	li	a2,0
 1ec:	00048593          	mv	a1,s1
 1f0:	00040513          	mv	a0,s0
 1f4:	01578023          	sb	s5,0(a5)
 1f8:	e75ff0ef          	jal	6c <draw_cell>
 1fc:	07ff0637          	lui	a2,0x7ff0
 200:	7ff60613          	addi	a2,a2,2047 # 7ff07ff <__stack_top+0x7fd07ff>
 204:	000d0593          	mv	a1,s10
 208:	000c8513          	mv	a0,s9
 20c:	f5dff06f          	j	168 <simulate_step+0xa4>
 210:	41240933          	sub	s2,s0,s2
 214:	f52bece3          	bltu	s7,s2,16c <simulate_step+0xa8>
 218:	012b07b3          	add	a5,s6,s2
 21c:	0007c703          	lbu	a4,0(a5)
 220:	f40716e3          	bnez	a4,16c <simulate_step+0xa8>
 224:	00098023          	sb	zero,0(s3)
 228:	00000613          	li	a2,0
 22c:	00048593          	mv	a1,s1
 230:	00040513          	mv	a0,s0
 234:	01578023          	sb	s5,0(a5)
 238:	e35ff0ef          	jal	6c <draw_cell>
 23c:	07ff0637          	lui	a2,0x7ff0
 240:	7ff60613          	addi	a2,a2,2047 # 7ff07ff <__stack_top+0x7fd07ff>
 244:	000d0593          	mv	a1,s10
 248:	00090513          	mv	a0,s2
 24c:	f1dff06f          	j	168 <simulate_step+0xa4>

00000250 <main>:
 250:	ac010113          	addi	sp,sp,-1344
 254:	00000593          	li	a1,0
 258:	00800513          	li	a0,8
 25c:	52112e23          	sw	ra,1340(sp)
 260:	52812c23          	sw	s0,1336(sp)
 264:	52912a23          	sw	s1,1332(sp)
 268:	53212823          	sw	s2,1328(sp)
 26c:	53512223          	sw	s5,1316(sp)
 270:	53612023          	sw	s6,1312(sp)
 274:	51712e23          	sw	s7,1308(sp)
 278:	53312623          	sw	s3,1324(sp)
 27c:	53412423          	sw	s4,1320(sp)
 280:	51812c23          	sw	s8,1304(sp)
 284:	51912a23          	sw	s9,1300(sp)
 288:	1d0000ef          	jal	458 <set_pin_mode>
 28c:	00000593          	li	a1,0
 290:	00900513          	li	a0,9
 294:	1c4000ef          	jal	458 <set_pin_mode>
 298:	00000593          	li	a1,0
 29c:	00a00513          	li	a0,10
 2a0:	1b8000ef          	jal	458 <set_pin_mode>
 2a4:	00000593          	li	a1,0
 2a8:	00b00513          	li	a0,11
 2ac:	1ac000ef          	jal	458 <set_pin_mode>
 2b0:	000067b7          	lui	a5,0x6
 2b4:	a5d78793          	addi	a5,a5,-1443 # 5a5d <__static_reserve+0x4a5d>
 2b8:	01010513          	addi	a0,sp,16
 2bc:	00f12623          	sw	a5,12(sp)
 2c0:	00000913          	li	s2,0
 2c4:	dc5ff0ef          	jal	88 <clear_grid>
 2c8:	00000493          	li	s1,0
 2cc:	00000b93          	li	s7,0
 2d0:	01000413          	li	s0,16
 2d4:	01e00a93          	li	s5,30
 2d8:	00100b13          	li	s6,1
 2dc:	00800513          	li	a0,8
 2e0:	198000ef          	jal	478 <read_pin>
 2e4:	00050c13          	mv	s8,a0
 2e8:	00900513          	li	a0,9
 2ec:	18c000ef          	jal	478 <read_pin>
 2f0:	00050a13          	mv	s4,a0
 2f4:	00a00513          	li	a0,10
 2f8:	180000ef          	jal	478 <read_pin>
 2fc:	00050c93          	mv	s9,a0
 300:	00b00513          	li	a0,11
 304:	174000ef          	jal	478 <read_pin>
 308:	00050993          	mv	s3,a0
 30c:	000a0863          	beqz	s4,31c <main+0xcc>
 310:	000b9663          	bnez	s7,31c <main+0xcc>
 314:	01010513          	addi	a0,sp,16
 318:	d71ff0ef          	jal	88 <clear_grid>
 31c:	009037b3          	snez	a5,s1
 320:	40f484b3          	sub	s1,s1,a5
 324:	51040793          	addi	a5,s0,1296
 328:	002787b3          	add	a5,a5,sp
 32c:	b007c783          	lbu	a5,-1280(a5)
 330:	00079a63          	bnez	a5,344 <main+0xf4>
 334:	00000613          	li	a2,0
 338:	00000593          	li	a1,0
 33c:	00040513          	mv	a0,s0
 340:	d2dff0ef          	jal	6c <draw_cell>
 344:	00049e63          	bnez	s1,360 <main+0x110>
 348:	0a0c9e63          	bnez	s9,404 <main+0x1b4>
 34c:	00098a63          	beqz	s3,360 <main+0x110>
 350:	00400493          	li	s1,4
 354:	008ac663          	blt	s5,s0,360 <main+0x110>
 358:	00140413          	addi	s0,s0,1
 35c:	00400493          	li	s1,4
 360:	012037b3          	snez	a5,s2
 364:	40f90933          	sub	s2,s2,a5
 368:	51040793          	addi	a5,s0,1296
 36c:	002789b3          	add	s3,a5,sp
 370:	00091a63          	bnez	s2,384 <main+0x134>
 374:	000c0863          	beqz	s8,384 <main+0x134>
 378:	b009c783          	lbu	a5,-1280(s3)
 37c:	08078c63          	beqz	a5,414 <main+0x1c4>
 380:	00200913          	li	s2,2
 384:	00c10593          	addi	a1,sp,12
 388:	01010513          	addi	a0,sp,16
 38c:	d39ff0ef          	jal	c4 <simulate_step>
 390:	b009c783          	lbu	a5,-1280(s3)
 394:	00079c63          	bnez	a5,3ac <main+0x15c>
 398:	001f0637          	lui	a2,0x1f0
 39c:	01f60613          	addi	a2,a2,31 # 1f001f <__stack_top+0x1d001f>
 3a0:	00000593          	li	a1,0
 3a4:	00040513          	mv	a0,s0
 3a8:	cc5ff0ef          	jal	6c <draw_cell>
 3ac:	01010693          	addi	a3,sp,16
 3b0:	00000513          	li	a0,0
 3b4:	02000613          	li	a2,32
 3b8:	00000713          	li	a4,0
 3bc:	00e687b3          	add	a5,a3,a4
 3c0:	0007c783          	lbu	a5,0(a5)
 3c4:	00170713          	addi	a4,a4,1
 3c8:	fff78793          	addi	a5,a5,-1
 3cc:	0017b793          	seqz	a5,a5
 3d0:	00f50533          	add	a0,a0,a5
 3d4:	fec714e3          	bne	a4,a2,3bc <main+0x16c>
 3d8:	02068693          	addi	a3,a3,32
 3dc:	51010793          	addi	a5,sp,1296
 3e0:	fcf69ce3          	bne	a3,a5,3b8 <main+0x168>
 3e4:	064000ef          	jal	448 <seg_write_hex>
 3e8:	00040513          	mv	a0,s0
 3ec:	04c000ef          	jal	438 <led_write>
 3f0:	00005537          	lui	a0,0x5
 3f4:	e2050513          	addi	a0,a0,-480 # 4e20 <__static_reserve+0x3e20>
 3f8:	c21ff0ef          	jal	18 <delay>
 3fc:	000a0b93          	mv	s7,s4
 400:	eddff06f          	j	2dc <main+0x8c>
 404:	02805663          	blez	s0,430 <main+0x1e0>
 408:	fff40413          	addi	s0,s0,-1
 40c:	00400493          	li	s1,4
 410:	f3dff06f          	j	34c <main+0xfc>
 414:	07ff0637          	lui	a2,0x7ff0
 418:	7ff60613          	addi	a2,a2,2047 # 7ff07ff <__stack_top+0x7fd07ff>
 41c:	00000593          	li	a1,0
 420:	00040513          	mv	a0,s0
 424:	b1698023          	sb	s6,-1280(s3)
 428:	c45ff0ef          	jal	6c <draw_cell>
 42c:	f55ff06f          	j	380 <main+0x130>
 430:	f20986e3          	beqz	s3,35c <main+0x10c>
 434:	f25ff06f          	j	358 <main+0x108>

00000438 <led_write>:
 438:	f00007b7          	lui	a5,0xf0000
 43c:	00878793          	addi	a5,a5,8 # f0000008 <__stack_top+0xeffe0008>
 440:	00a79023          	sh	a0,0(a5)
 444:	00008067          	ret

00000448 <seg_write_hex>:
 448:	f00007b7          	lui	a5,0xf0000
 44c:	00478793          	addi	a5,a5,4 # f0000004 <__stack_top+0xeffe0004>
 450:	00a79023          	sh	a0,0(a5)
 454:	00008067          	ret

00000458 <set_pin_mode>:
 458:	00151513          	slli	a0,a0,0x1
 45c:	0015f593          	andi	a1,a1,1
 460:	03e57513          	andi	a0,a0,62
 464:	f00007b7          	lui	a5,0xf0000
 468:	00b56533          	or	a0,a0,a1
 46c:	01078793          	addi	a5,a5,16 # f0000010 <__stack_top+0xeffe0010>
 470:	00a7a023          	sw	a0,0(a5)
 474:	00008067          	ret

00000478 <read_pin>:
 478:	01f57513          	andi	a0,a0,31
 47c:	f00007b7          	lui	a5,0xf0000
 480:	04078793          	addi	a5,a5,64 # f0000040 <__stack_top+0xeffe0040>
 484:	00851513          	slli	a0,a0,0x8
 488:	00f56533          	or	a0,a0,a5
 48c:	00052503          	lw	a0,0(a0)
 490:	00157513          	andi	a0,a0,1
 494:	00008067          	ret

00000498 <st7735_set_rectangle>:
 498:	00ff07b7          	lui	a5,0xff0
 49c:	01059593          	slli	a1,a1,0x10
 4a0:	0ff6f693          	zext.b	a3,a3
 4a4:	00f5f5b3          	and	a1,a1,a5
 4a8:	00869693          	slli	a3,a3,0x8
 4ac:	01051513          	slli	a0,a0,0x10
 4b0:	0ff67613          	zext.b	a2,a2
 4b4:	00f57533          	and	a0,a0,a5
 4b8:	00861613          	slli	a2,a2,0x8
 4bc:	00d5e5b3          	or	a1,a1,a3
 4c0:	2b0007b7          	lui	a5,0x2b000
 4c4:	00c56533          	or	a0,a0,a2
 4c8:	2a000737          	lui	a4,0x2a000
 4cc:	00f5e5b3          	or	a1,a1,a5
 4d0:	f00007b7          	lui	a5,0xf0000
 4d4:	00e56533          	or	a0,a0,a4
 4d8:	00278793          	addi	a5,a5,2 # f0000002 <__stack_top+0xeffe0002>
 4dc:	00a7a023          	sw	a0,0(a5)
 4e0:	00b7a023          	sw	a1,0(a5)
 4e4:	00008067          	ret

000004e8 <st7735_draw_rectangle>:
 4e8:	fe010113          	addi	sp,sp,-32
 4ec:	00812c23          	sw	s0,24(sp)
 4f0:	00912a23          	sw	s1,20(sp)
 4f4:	00068413          	mv	s0,a3
 4f8:	00050493          	mv	s1,a0
 4fc:	00058513          	mv	a0,a1
 500:	00e606b3          	add	a3,a2,a4
 504:	00060593          	mv	a1,a2
 508:	00850633          	add	a2,a0,s0
 50c:	fff68693          	addi	a3,a3,-1
 510:	fff60613          	addi	a2,a2,-1
 514:	00112e23          	sw	ra,28(sp)
 518:	00e12623          	sw	a4,12(sp)
 51c:	f7dff0ef          	jal	498 <st7735_set_rectangle>
 520:	00c12703          	lw	a4,12(sp)
 524:	2c0007b7          	lui	a5,0x2c000
 528:	02e40433          	mul	s0,s0,a4
 52c:	40145413          	srai	s0,s0,0x1
 530:	00f46433          	or	s0,s0,a5
 534:	f00007b7          	lui	a5,0xf0000
 538:	00278793          	addi	a5,a5,2 # f0000002 <__stack_top+0xeffe0002>
 53c:	0087a023          	sw	s0,0(a5)
 540:	f00007b7          	lui	a5,0xf0000
 544:	00178793          	addi	a5,a5,1 # f0000001 <__stack_top+0xeffe0001>
 548:	0097a023          	sw	s1,0(a5)
 54c:	01c12083          	lw	ra,28(sp)
 550:	01812403          	lw	s0,24(sp)
 554:	01412483          	lw	s1,20(sp)
 558:	02010113          	addi	sp,sp,32
 55c:	00008067          	ret
