
__out_tmp.elf:     file format elf32-littleriscv


Disassembly of section .text:

00000000 <__static_end>:
   0:	00001197          	auipc	gp,0x1
   4:	80018193          	addi	gp,gp,-2048 # 800 <__global_pointer$>
   8:	00020117          	auipc	sp,0x20
   c:	ff810113          	addi	sp,sp,-8 # 20000 <__stack_top>
  10:	140000ef          	jal	150 <main>

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
  70:	00800713          	li	a4,8
  74:	00359613          	slli	a2,a1,0x3
  78:	00070693          	mv	a3,a4
  7c:	00351593          	slli	a1,a0,0x3
  80:	00078513          	mv	a0,a5
  84:	5840006f          	j	608 <st7735_draw_rectangle>

00000088 <is_on_snake>:
  88:	00000793          	li	a5,0
  8c:	00b7c663          	blt	a5,a1,98 <is_on_snake+0x10>
  90:	00000513          	li	a0,0
  94:	00008067          	ret
  98:	00052703          	lw	a4,0(a0)
  9c:	00c71663          	bne	a4,a2,a8 <is_on_snake+0x20>
  a0:	00452703          	lw	a4,4(a0)
  a4:	00d70863          	beq	a4,a3,b4 <is_on_snake+0x2c>
  a8:	00178793          	addi	a5,a5,1
  ac:	00850513          	addi	a0,a0,8
  b0:	fddff06f          	j	8c <is_on_snake+0x4>
  b4:	00100513          	li	a0,1
  b8:	00008067          	ret

000000bc <place_food>:
  bc:	fd010113          	addi	sp,sp,-48
  c0:	02912223          	sw	s1,36(sp)
  c4:	03212023          	sw	s2,32(sp)
  c8:	01312e23          	sw	s3,28(sp)
  cc:	01412c23          	sw	s4,24(sp)
  d0:	01512a23          	sw	s5,20(sp)
  d4:	02112623          	sw	ra,44(sp)
  d8:	02812423          	sw	s0,40(sp)
  dc:	00050493          	mv	s1,a0
  e0:	00058a13          	mv	s4,a1
  e4:	00060a93          	mv	s5,a2
  e8:	00068993          	mv	s3,a3
  ec:	01400913          	li	s2,20
  f0:	00098513          	mv	a0,s3
  f4:	f4dff0ef          	jal	40 <rand_next>
  f8:	00f57413          	andi	s0,a0,15
  fc:	00098513          	mv	a0,s3
 100:	f41ff0ef          	jal	40 <rand_next>
 104:	032576b3          	remu	a3,a0,s2
 108:	00040613          	mv	a2,s0
 10c:	000a8593          	mv	a1,s5
 110:	000a0513          	mv	a0,s4
 114:	00d12623          	sw	a3,12(sp)
 118:	f71ff0ef          	jal	88 <is_on_snake>
 11c:	00c12683          	lw	a3,12(sp)
 120:	fc0518e3          	bnez	a0,f0 <place_food+0x34>
 124:	0084a023          	sw	s0,0(s1)
 128:	02c12083          	lw	ra,44(sp)
 12c:	02812403          	lw	s0,40(sp)
 130:	00d4a223          	sw	a3,4(s1)
 134:	02012903          	lw	s2,32(sp)
 138:	02412483          	lw	s1,36(sp)
 13c:	01c12983          	lw	s3,28(sp)
 140:	01812a03          	lw	s4,24(sp)
 144:	01412a83          	lw	s5,20(sp)
 148:	03010113          	addi	sp,sp,48
 14c:	00008067          	ret

00000150 <main>:
 150:	81010113          	addi	sp,sp,-2032
 154:	7e112623          	sw	ra,2028(sp)
 158:	7d412c23          	sw	s4,2008(sp)
 15c:	7d512a23          	sw	s5,2004(sp)
 160:	7d612823          	sw	s6,2000(sp)
 164:	7d712623          	sw	s7,1996(sp)
 168:	7da12023          	sw	s10,1984(sp)
 16c:	7bb12e23          	sw	s11,1980(sp)
 170:	7e812423          	sw	s0,2024(sp)
 174:	7e912223          	sw	s1,2020(sp)
 178:	7f212023          	sw	s2,2016(sp)
 17c:	7d312e23          	sw	s3,2012(sp)
 180:	7d812423          	sw	s8,1992(sp)
 184:	7d912223          	sw	s9,1988(sp)
 188:	00000593          	li	a1,0
 18c:	d7010113          	addi	sp,sp,-656
 190:	00b00513          	li	a0,11
 194:	3e4000ef          	jal	578 <set_pin_mode>
 198:	00000593          	li	a1,0
 19c:	01300513          	li	a0,19
 1a0:	3d8000ef          	jal	578 <set_pin_mode>
 1a4:	00000593          	li	a1,0
 1a8:	00900513          	li	a0,9
 1ac:	3cc000ef          	jal	578 <set_pin_mode>
 1b0:	00000593          	li	a1,0
 1b4:	00800513          	li	a0,8
 1b8:	3c0000ef          	jal	578 <set_pin_mode>
 1bc:	00c10737          	lui	a4,0xc10
 1c0:	fee70713          	addi	a4,a4,-18 # c0ffee <__stack_top+0xbeffee>
 1c4:	00000b93          	li	s7,0
 1c8:	00000b13          	li	s6,0
 1cc:	00000a93          	li	s5,0
 1d0:	00000a13          	li	s4,0
 1d4:	a4010d13          	addi	s10,sp,-1472
 1d8:	00a00d93          	li	s11,10
 1dc:	00800793          	li	a5,8
 1e0:	60fd2023          	sw	a5,1536(s10)
 1e4:	24010793          	addi	a5,sp,576
 1e8:	df478793          	addi	a5,a5,-524
 1ec:	00f12a23          	sw	a5,20(sp)
 1f0:	01412683          	lw	a3,20(sp)
 1f4:	24010793          	addi	a5,sp,576
 1f8:	df878793          	addi	a5,a5,-520
 1fc:	04010993          	addi	s3,sp,64
 200:	5eed2a23          	sw	a4,1524(s10)
 204:	00700713          	li	a4,7
 208:	00078513          	mv	a0,a5
 20c:	60ed2423          	sw	a4,1544(s10)
 210:	00300613          	li	a2,3
 214:	00600713          	li	a4,6
 218:	00098593          	mv	a1,s3
 21c:	60ed2823          	sw	a4,1552(s10)
 220:	00f12c23          	sw	a5,24(sp)
 224:	61bd2223          	sw	s11,1540(s10)
 228:	61bd2623          	sw	s11,1548(s10)
 22c:	61bd2a23          	sw	s11,1556(s10)
 230:	e8dff0ef          	jal	bc <place_food>
 234:	5f8d2783          	lw	a5,1528(s10)
 238:	0a000713          	li	a4,160
 23c:	08000693          	li	a3,128
 240:	00f12623          	sw	a5,12(sp)
 244:	5fcd2783          	lw	a5,1532(s10)
 248:	00000613          	li	a2,0
 24c:	00000593          	li	a1,0
 250:	00000513          	li	a0,0
 254:	00f12423          	sw	a5,8(sp)
 258:	01898493          	addi	s1,s3,24
 25c:	3ac000ef          	jal	608 <st7735_draw_rectangle>
 260:	00098413          	mv	s0,s3
 264:	00442583          	lw	a1,4(s0)
 268:	00042503          	lw	a0,0(s0)
 26c:	07e00637          	lui	a2,0x7e00
 270:	7e060613          	addi	a2,a2,2016 # 7e007e0 <__stack_top+0x7de07e0>
 274:	00840413          	addi	s0,s0,8
 278:	df5ff0ef          	jal	6c <draw_cell>
 27c:	fe8494e3          	bne	s1,s0,264 <main+0x114>
 280:	fff00613          	li	a2,-1
 284:	00a00593          	li	a1,10
 288:	00800513          	li	a0,8
 28c:	de1ff0ef          	jal	6c <draw_cell>
 290:	00812583          	lw	a1,8(sp)
 294:	00c12503          	lw	a0,12(sp)
 298:	001f0637          	lui	a2,0x1f0
 29c:	01f60613          	addi	a2,a2,31 # 1f001f <__stack_top+0x1d001f>
 2a0:	dcdff0ef          	jal	6c <draw_cell>
 2a4:	000b8813          	mv	a6,s7
 2a8:	000b0593          	mv	a1,s6
 2ac:	000a8613          	mv	a2,s5
 2b0:	000a0c13          	mv	s8,s4
 2b4:	00a00413          	li	s0,10
 2b8:	00800493          	li	s1,8
 2bc:	00000693          	li	a3,0
 2c0:	00100713          	li	a4,1
 2c4:	00012823          	sw	zero,16(sp)
 2c8:	00300913          	li	s2,3
 2cc:	00b00513          	li	a0,11
 2d0:	02e12623          	sw	a4,44(sp)
 2d4:	03012423          	sw	a6,40(sp)
 2d8:	02d12223          	sw	a3,36(sp)
 2dc:	02b12023          	sw	a1,32(sp)
 2e0:	00c12e23          	sw	a2,28(sp)
 2e4:	2b4000ef          	jal	598 <read_pin>
 2e8:	00050a13          	mv	s4,a0
 2ec:	01300513          	li	a0,19
 2f0:	2a8000ef          	jal	598 <read_pin>
 2f4:	00050a93          	mv	s5,a0
 2f8:	00900513          	li	a0,9
 2fc:	29c000ef          	jal	598 <read_pin>
 300:	00050b13          	mv	s6,a0
 304:	00800513          	li	a0,8
 308:	290000ef          	jal	598 <read_pin>
 30c:	02412683          	lw	a3,36(sp)
 310:	01c12603          	lw	a2,28(sp)
 314:	02012583          	lw	a1,32(sp)
 318:	00dc6c33          	or	s8,s8,a3
 31c:	02812803          	lw	a6,40(sp)
 320:	02c12703          	lw	a4,44(sp)
 324:	00050b93          	mv	s7,a0
 328:	000c1463          	bnez	s8,330 <main+0x1e0>
 32c:	000a1863          	bnez	s4,33c <main+0x1ec>
 330:	00068c93          	mv	s9,a3
 334:	00070c13          	mv	s8,a4
 338:	00c0006f          	j	344 <main+0x1f4>
 33c:	fff00c93          	li	s9,-1
 340:	00000c13          	li	s8,0
 344:	00d66633          	or	a2,a2,a3
 348:	00061863          	bnez	a2,358 <main+0x208>
 34c:	000a8663          	beqz	s5,358 <main+0x208>
 350:	00100c93          	li	s9,1
 354:	00000c13          	li	s8,0
 358:	00e5e5b3          	or	a1,a1,a4
 35c:	00059863          	bnez	a1,36c <main+0x21c>
 360:	000b0663          	beqz	s6,36c <main+0x21c>
 364:	00000c93          	li	s9,0
 368:	fff00c13          	li	s8,-1
 36c:	00e86833          	or	a6,a6,a4
 370:	00081863          	bnez	a6,380 <main+0x230>
 374:	000b8663          	beqz	s7,380 <main+0x230>
 378:	00000c93          	li	s9,0
 37c:	00100c13          	li	s8,1
 380:	01400713          	li	a4,20
 384:	01000793          	li	a5,16
 388:	009c04b3          	add	s1,s8,s1
 38c:	008c8433          	add	s0,s9,s0
 390:	02f4e4b3          	rem	s1,s1,a5
 394:	00c12783          	lw	a5,12(sp)
 398:	02e46433          	rem	s0,s0,a4
 39c:	00f4f493          	andi	s1,s1,15
 3a0:	00e40433          	add	s0,s0,a4
 3a4:	02e46433          	rem	s0,s0,a4
 3a8:	00f49663          	bne	s1,a5,3b4 <main+0x264>
 3ac:	00812783          	lw	a5,8(sp)
 3b0:	12878463          	beq	a5,s0,4d8 <main+0x388>
 3b4:	fff90593          	addi	a1,s2,-1
 3b8:	00000813          	li	a6,0
 3bc:	00040693          	mv	a3,s0
 3c0:	00048613          	mv	a2,s1
 3c4:	00098513          	mv	a0,s3
 3c8:	01012e23          	sw	a6,28(sp)
 3cc:	cbdff0ef          	jal	88 <is_on_snake>
 3d0:	10051a63          	bnez	a0,4e4 <main+0x394>
 3d4:	fff90713          	addi	a4,s2,-1
 3d8:	00371713          	slli	a4,a4,0x3
 3dc:	00ed0733          	add	a4,s10,a4
 3e0:	01c12803          	lw	a6,28(sp)
 3e4:	60072503          	lw	a0,1536(a4)
 3e8:	60472583          	lw	a1,1540(a4)
 3ec:	00391693          	slli	a3,s2,0x3
 3f0:	ff898713          	addi	a4,s3,-8
 3f4:	00d70733          	add	a4,a4,a3
 3f8:	ff872603          	lw	a2,-8(a4)
 3fc:	ff870713          	addi	a4,a4,-8
 400:	00c72423          	sw	a2,8(a4)
 404:	00472603          	lw	a2,4(a4)
 408:	00c72623          	sw	a2,12(a4)
 40c:	fee996e3          	bne	s3,a4,3f8 <main+0x2a8>
 410:	609d2023          	sw	s1,1536(s10)
 414:	608d2223          	sw	s0,1540(s10)
 418:	00000613          	li	a2,0
 41c:	04080e63          	beqz	a6,478 <main+0x328>
 420:	13f00713          	li	a4,319
 424:	01274a63          	blt	a4,s2,438 <main+0x2e8>
 428:	00dd0733          	add	a4,s10,a3
 42c:	60a72023          	sw	a0,1536(a4)
 430:	60b72223          	sw	a1,1540(a4)
 434:	00190913          	addi	s2,s2,1
 438:	01012783          	lw	a5,16(sp)
 43c:	01812503          	lw	a0,24(sp)
 440:	01412683          	lw	a3,20(sp)
 444:	00178793          	addi	a5,a5,1
 448:	00090613          	mv	a2,s2
 44c:	00098593          	mv	a1,s3
 450:	00f12823          	sw	a5,16(sp)
 454:	c69ff0ef          	jal	bc <place_food>
 458:	5f8d2783          	lw	a5,1528(s10)
 45c:	001f0637          	lui	a2,0x1f0
 460:	01f60613          	addi	a2,a2,31 # 1f001f <__stack_top+0x1d001f>
 464:	00f12623          	sw	a5,12(sp)
 468:	5fcd2783          	lw	a5,1532(s10)
 46c:	00c12503          	lw	a0,12(sp)
 470:	00f12423          	sw	a5,8(sp)
 474:	00078593          	mv	a1,a5
 478:	bf5ff0ef          	jal	6c <draw_cell>
 47c:	60cd2583          	lw	a1,1548(s10)
 480:	608d2503          	lw	a0,1544(s10)
 484:	07e00637          	lui	a2,0x7e00
 488:	7e060613          	addi	a2,a2,2016 # 7e007e0 <__stack_top+0x7de07e0>
 48c:	be1ff0ef          	jal	6c <draw_cell>
 490:	fff00613          	li	a2,-1
 494:	00040593          	mv	a1,s0
 498:	00048513          	mv	a0,s1
 49c:	bd1ff0ef          	jal	6c <draw_cell>
 4a0:	01012503          	lw	a0,16(sp)
 4a4:	0c4000ef          	jal	568 <seg_write_hex>
 4a8:	00090513          	mv	a0,s2
 4ac:	0ac000ef          	jal	558 <led_write>
 4b0:	000dc537          	lui	a0,0xdc
 4b4:	ba050513          	addi	a0,a0,-1120 # dbba0 <__stack_top+0xbbba0>
 4b8:	b61ff0ef          	jal	18 <delay>
 4bc:	000c0713          	mv	a4,s8
 4c0:	000c8693          	mv	a3,s9
 4c4:	000b8813          	mv	a6,s7
 4c8:	000b0593          	mv	a1,s6
 4cc:	000a8613          	mv	a2,s5
 4d0:	000a0c13          	mv	s8,s4
 4d4:	df9ff06f          	j	2cc <main+0x17c>
 4d8:	00090593          	mv	a1,s2
 4dc:	00100813          	li	a6,1
 4e0:	eddff06f          	j	3bc <main+0x26c>
 4e4:	00600413          	li	s0,6
 4e8:	001f0537          	lui	a0,0x1f0
 4ec:	0a000713          	li	a4,160
 4f0:	08000693          	li	a3,128
 4f4:	00000613          	li	a2,0
 4f8:	00000593          	li	a1,0
 4fc:	01f50513          	addi	a0,a0,31 # 1f001f <__stack_top+0x1d001f>
 500:	108000ef          	jal	608 <st7735_draw_rectangle>
 504:	00025537          	lui	a0,0x25
 508:	9f050513          	addi	a0,a0,-1552 # 249f0 <__stack_top+0x49f0>
 50c:	b0dff0ef          	jal	18 <delay>
 510:	0a000713          	li	a4,160
 514:	08000693          	li	a3,128
 518:	00000613          	li	a2,0
 51c:	00000593          	li	a1,0
 520:	00000513          	li	a0,0
 524:	0e4000ef          	jal	608 <st7735_draw_rectangle>
 528:	00025537          	lui	a0,0x25
 52c:	9f050513          	addi	a0,a0,-1552 # 249f0 <__stack_top+0x49f0>
 530:	fff40413          	addi	s0,s0,-1
 534:	ae5ff0ef          	jal	18 <delay>
 538:	fa0418e3          	bnez	s0,4e8 <main+0x398>
 53c:	5f4d2703          	lw	a4,1524(s10)
 540:	9e3786b7          	lui	a3,0x9e378
 544:	9b168693          	addi	a3,a3,-1615 # 9e3779b1 <__stack_top+0x9e3579b1>
 548:	02d70733          	mul	a4,a4,a3
 54c:	01012783          	lw	a5,16(sp)
 550:	00f70733          	add	a4,a4,a5
 554:	c89ff06f          	j	1dc <main+0x8c>

00000558 <led_write>:
 558:	f00007b7          	lui	a5,0xf0000
 55c:	00878793          	addi	a5,a5,8 # f0000008 <__stack_top+0xeffe0008>
 560:	00a79023          	sh	a0,0(a5)
 564:	00008067          	ret

00000568 <seg_write_hex>:
 568:	f00007b7          	lui	a5,0xf0000
 56c:	00478793          	addi	a5,a5,4 # f0000004 <__stack_top+0xeffe0004>
 570:	00a79023          	sh	a0,0(a5)
 574:	00008067          	ret

00000578 <set_pin_mode>:
 578:	00151513          	slli	a0,a0,0x1
 57c:	0015f593          	andi	a1,a1,1
 580:	03e57513          	andi	a0,a0,62
 584:	f00007b7          	lui	a5,0xf0000
 588:	00b56533          	or	a0,a0,a1
 58c:	01078793          	addi	a5,a5,16 # f0000010 <__stack_top+0xeffe0010>
 590:	00a7a023          	sw	a0,0(a5)
 594:	00008067          	ret

00000598 <read_pin>:
 598:	01f57513          	andi	a0,a0,31
 59c:	f00007b7          	lui	a5,0xf0000
 5a0:	04078793          	addi	a5,a5,64 # f0000040 <__stack_top+0xeffe0040>
 5a4:	00851513          	slli	a0,a0,0x8
 5a8:	00f56533          	or	a0,a0,a5
 5ac:	00052503          	lw	a0,0(a0)
 5b0:	00157513          	andi	a0,a0,1
 5b4:	00008067          	ret

000005b8 <st7735_set_rectangle>:
 5b8:	00ff07b7          	lui	a5,0xff0
 5bc:	01059593          	slli	a1,a1,0x10
 5c0:	0ff6f693          	zext.b	a3,a3
 5c4:	00f5f5b3          	and	a1,a1,a5
 5c8:	00869693          	slli	a3,a3,0x8
 5cc:	01051513          	slli	a0,a0,0x10
 5d0:	0ff67613          	zext.b	a2,a2
 5d4:	00f57533          	and	a0,a0,a5
 5d8:	00861613          	slli	a2,a2,0x8
 5dc:	00d5e5b3          	or	a1,a1,a3
 5e0:	2b0007b7          	lui	a5,0x2b000
 5e4:	00c56533          	or	a0,a0,a2
 5e8:	2a000737          	lui	a4,0x2a000
 5ec:	00f5e5b3          	or	a1,a1,a5
 5f0:	f00007b7          	lui	a5,0xf0000
 5f4:	00e56533          	or	a0,a0,a4
 5f8:	00278793          	addi	a5,a5,2 # f0000002 <__stack_top+0xeffe0002>
 5fc:	00a7a023          	sw	a0,0(a5)
 600:	00b7a023          	sw	a1,0(a5)
 604:	00008067          	ret

00000608 <st7735_draw_rectangle>:
 608:	fe010113          	addi	sp,sp,-32
 60c:	00812c23          	sw	s0,24(sp)
 610:	00912a23          	sw	s1,20(sp)
 614:	00068413          	mv	s0,a3
 618:	00050493          	mv	s1,a0
 61c:	00058513          	mv	a0,a1
 620:	00e606b3          	add	a3,a2,a4
 624:	00060593          	mv	a1,a2
 628:	00850633          	add	a2,a0,s0
 62c:	fff68693          	addi	a3,a3,-1
 630:	fff60613          	addi	a2,a2,-1
 634:	00112e23          	sw	ra,28(sp)
 638:	00e12623          	sw	a4,12(sp)
 63c:	f7dff0ef          	jal	5b8 <st7735_set_rectangle>
 640:	00c12703          	lw	a4,12(sp)
 644:	2c0007b7          	lui	a5,0x2c000
 648:	02e40433          	mul	s0,s0,a4
 64c:	40145413          	srai	s0,s0,0x1
 650:	00f46433          	or	s0,s0,a5
 654:	f00007b7          	lui	a5,0xf0000
 658:	00278793          	addi	a5,a5,2 # f0000002 <__stack_top+0xeffe0002>
 65c:	0087a023          	sw	s0,0(a5)
 660:	f00007b7          	lui	a5,0xf0000
 664:	00178793          	addi	a5,a5,1 # f0000001 <__stack_top+0xeffe0001>
 668:	0097a023          	sw	s1,0(a5)
 66c:	01c12083          	lw	ra,28(sp)
 670:	01812403          	lw	s0,24(sp)
 674:	01412483          	lw	s1,20(sp)
 678:	02010113          	addi	sp,sp,32
 67c:	00008067          	ret
