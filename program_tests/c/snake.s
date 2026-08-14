
__out_tmp.elf:     file format elf32-littleriscv


Disassembly of section .text:

00000000 <_start>:
   0:	00008137          	lui	sp,0x8
   4:	140000ef          	jal	144 <main>

00000008 <halt_loop>:
   8:	0000006f          	j	8 <halt_loop>

0000000c <delay>:
   c:	ff010113          	addi	sp,sp,-16 # 7ff0 <read_pin+0x799c>
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
  3c:	e6d70713          	addi	a4,a4,-403 # 41c64e6d <read_pin+0x41c64819>
  40:	02e787b3          	mul	a5,a5,a4
  44:	00003737          	lui	a4,0x3
  48:	03970713          	addi	a4,a4,57 # 3039 <read_pin+0x29e5>
  4c:	00e787b3          	add	a5,a5,a4
  50:	00179713          	slli	a4,a5,0x1
  54:	00f52023          	sw	a5,0(a0)
  58:	01175513          	srli	a0,a4,0x11
  5c:	00008067          	ret

00000060 <draw_cell>:
  60:	00060793          	mv	a5,a2
  64:	00800713          	li	a4,8
  68:	00359613          	slli	a2,a1,0x3
  6c:	00070693          	mv	a3,a4
  70:	00351593          	slli	a1,a0,0x3
  74:	00078513          	mv	a0,a5
  78:	5240006f          	j	59c <st7735_draw_rectangle>

0000007c <is_on_snake>:
  7c:	00000793          	li	a5,0
  80:	00b7c663          	blt	a5,a1,8c <is_on_snake+0x10>
  84:	00000513          	li	a0,0
  88:	00008067          	ret
  8c:	00052703          	lw	a4,0(a0)
  90:	00c71663          	bne	a4,a2,9c <is_on_snake+0x20>
  94:	00452703          	lw	a4,4(a0)
  98:	00d70863          	beq	a4,a3,a8 <is_on_snake+0x2c>
  9c:	00178793          	addi	a5,a5,1
  a0:	00850513          	addi	a0,a0,8
  a4:	fddff06f          	j	80 <is_on_snake+0x4>
  a8:	00100513          	li	a0,1
  ac:	00008067          	ret

000000b0 <place_food>:
  b0:	fd010113          	addi	sp,sp,-48
  b4:	02912223          	sw	s1,36(sp)
  b8:	03212023          	sw	s2,32(sp)
  bc:	01312e23          	sw	s3,28(sp)
  c0:	01412c23          	sw	s4,24(sp)
  c4:	01512a23          	sw	s5,20(sp)
  c8:	02112623          	sw	ra,44(sp)
  cc:	02812423          	sw	s0,40(sp)
  d0:	00050493          	mv	s1,a0
  d4:	00058a13          	mv	s4,a1
  d8:	00060a93          	mv	s5,a2
  dc:	00068993          	mv	s3,a3
  e0:	01400913          	li	s2,20
  e4:	00098513          	mv	a0,s3
  e8:	f4dff0ef          	jal	34 <rand_next>
  ec:	00f57413          	andi	s0,a0,15
  f0:	00098513          	mv	a0,s3
  f4:	f41ff0ef          	jal	34 <rand_next>
  f8:	032576b3          	remu	a3,a0,s2
  fc:	00040613          	mv	a2,s0
 100:	000a8593          	mv	a1,s5
 104:	000a0513          	mv	a0,s4
 108:	00d12623          	sw	a3,12(sp)
 10c:	f71ff0ef          	jal	7c <is_on_snake>
 110:	00c12683          	lw	a3,12(sp)
 114:	fc0518e3          	bnez	a0,e4 <place_food+0x34>
 118:	0084a023          	sw	s0,0(s1)
 11c:	02c12083          	lw	ra,44(sp)
 120:	02812403          	lw	s0,40(sp)
 124:	00d4a223          	sw	a3,4(s1)
 128:	02012903          	lw	s2,32(sp)
 12c:	02412483          	lw	s1,36(sp)
 130:	01c12983          	lw	s3,28(sp)
 134:	01812a03          	lw	s4,24(sp)
 138:	01412a83          	lw	s5,20(sp)
 13c:	03010113          	addi	sp,sp,48
 140:	00008067          	ret

00000144 <main>:
 144:	81010113          	addi	sp,sp,-2032
 148:	7e112623          	sw	ra,2028(sp)
 14c:	7d412c23          	sw	s4,2008(sp)
 150:	7d512a23          	sw	s5,2004(sp)
 154:	7d612823          	sw	s6,2000(sp)
 158:	7d712623          	sw	s7,1996(sp)
 15c:	7da12023          	sw	s10,1984(sp)
 160:	7bb12e23          	sw	s11,1980(sp)
 164:	7e812423          	sw	s0,2024(sp)
 168:	7e912223          	sw	s1,2020(sp)
 16c:	7f212023          	sw	s2,2016(sp)
 170:	7d312e23          	sw	s3,2012(sp)
 174:	7d812423          	sw	s8,1992(sp)
 178:	7d912223          	sw	s9,1988(sp)
 17c:	00000593          	li	a1,0
 180:	d7010113          	addi	sp,sp,-656
 184:	00b00513          	li	a0,11
 188:	4ac000ef          	jal	634 <set_pin_mode>
 18c:	00000593          	li	a1,0
 190:	01300513          	li	a0,19
 194:	4a0000ef          	jal	634 <set_pin_mode>
 198:	00000593          	li	a1,0
 19c:	00900513          	li	a0,9
 1a0:	494000ef          	jal	634 <set_pin_mode>
 1a4:	00000593          	li	a1,0
 1a8:	00800513          	li	a0,8
 1ac:	488000ef          	jal	634 <set_pin_mode>
 1b0:	00c10737          	lui	a4,0xc10
 1b4:	fee70713          	addi	a4,a4,-18 # c0ffee <read_pin+0xc0f99a>
 1b8:	00000b93          	li	s7,0
 1bc:	00000b13          	li	s6,0
 1c0:	00000a93          	li	s5,0
 1c4:	00000a13          	li	s4,0
 1c8:	a4010d13          	addi	s10,sp,-1472
 1cc:	00a00d93          	li	s11,10
 1d0:	00800793          	li	a5,8
 1d4:	60fd2023          	sw	a5,1536(s10)
 1d8:	24010793          	addi	a5,sp,576
 1dc:	df478793          	addi	a5,a5,-524
 1e0:	00f12a23          	sw	a5,20(sp)
 1e4:	01412683          	lw	a3,20(sp)
 1e8:	24010793          	addi	a5,sp,576
 1ec:	df878793          	addi	a5,a5,-520
 1f0:	04010993          	addi	s3,sp,64
 1f4:	5eed2a23          	sw	a4,1524(s10)
 1f8:	00700713          	li	a4,7
 1fc:	00078513          	mv	a0,a5
 200:	60ed2423          	sw	a4,1544(s10)
 204:	00300613          	li	a2,3
 208:	00600713          	li	a4,6
 20c:	00098593          	mv	a1,s3
 210:	60ed2823          	sw	a4,1552(s10)
 214:	00f12c23          	sw	a5,24(sp)
 218:	61bd2223          	sw	s11,1540(s10)
 21c:	61bd2623          	sw	s11,1548(s10)
 220:	61bd2a23          	sw	s11,1556(s10)
 224:	e8dff0ef          	jal	b0 <place_food>
 228:	5f8d2783          	lw	a5,1528(s10)
 22c:	0a000713          	li	a4,160
 230:	08000693          	li	a3,128
 234:	00f12623          	sw	a5,12(sp)
 238:	5fcd2783          	lw	a5,1532(s10)
 23c:	00000613          	li	a2,0
 240:	00000593          	li	a1,0
 244:	00000513          	li	a0,0
 248:	00f12423          	sw	a5,8(sp)
 24c:	01898493          	addi	s1,s3,24
 250:	34c000ef          	jal	59c <st7735_draw_rectangle>
 254:	00098413          	mv	s0,s3
 258:	00442583          	lw	a1,4(s0)
 25c:	00042503          	lw	a0,0(s0)
 260:	07e00637          	lui	a2,0x7e00
 264:	7e060613          	addi	a2,a2,2016 # 7e007e0 <read_pin+0x7e0018c>
 268:	00840413          	addi	s0,s0,8
 26c:	df5ff0ef          	jal	60 <draw_cell>
 270:	fe8494e3          	bne	s1,s0,258 <main+0x114>
 274:	fff00613          	li	a2,-1
 278:	00a00593          	li	a1,10
 27c:	00800513          	li	a0,8
 280:	de1ff0ef          	jal	60 <draw_cell>
 284:	00812583          	lw	a1,8(sp)
 288:	00c12503          	lw	a0,12(sp)
 28c:	001f0637          	lui	a2,0x1f0
 290:	01f60613          	addi	a2,a2,31 # 1f001f <read_pin+0x1ef9cb>
 294:	dcdff0ef          	jal	60 <draw_cell>
 298:	000b8813          	mv	a6,s7
 29c:	000b0593          	mv	a1,s6
 2a0:	000a8613          	mv	a2,s5
 2a4:	000a0c13          	mv	s8,s4
 2a8:	00a00413          	li	s0,10
 2ac:	00800493          	li	s1,8
 2b0:	00000693          	li	a3,0
 2b4:	00100713          	li	a4,1
 2b8:	00012823          	sw	zero,16(sp)
 2bc:	00300913          	li	s2,3
 2c0:	00b00513          	li	a0,11
 2c4:	02e12623          	sw	a4,44(sp)
 2c8:	03012423          	sw	a6,40(sp)
 2cc:	02d12223          	sw	a3,36(sp)
 2d0:	02b12023          	sw	a1,32(sp)
 2d4:	00c12e23          	sw	a2,28(sp)
 2d8:	37c000ef          	jal	654 <read_pin>
 2dc:	00050a13          	mv	s4,a0
 2e0:	01300513          	li	a0,19
 2e4:	370000ef          	jal	654 <read_pin>
 2e8:	00050a93          	mv	s5,a0
 2ec:	00900513          	li	a0,9
 2f0:	364000ef          	jal	654 <read_pin>
 2f4:	00050b13          	mv	s6,a0
 2f8:	00800513          	li	a0,8
 2fc:	358000ef          	jal	654 <read_pin>
 300:	02412683          	lw	a3,36(sp)
 304:	01c12603          	lw	a2,28(sp)
 308:	02012583          	lw	a1,32(sp)
 30c:	00dc6c33          	or	s8,s8,a3
 310:	02812803          	lw	a6,40(sp)
 314:	02c12703          	lw	a4,44(sp)
 318:	00050b93          	mv	s7,a0
 31c:	000c1463          	bnez	s8,324 <main+0x1e0>
 320:	000a1863          	bnez	s4,330 <main+0x1ec>
 324:	00068c93          	mv	s9,a3
 328:	00070c13          	mv	s8,a4
 32c:	00c0006f          	j	338 <main+0x1f4>
 330:	fff00c93          	li	s9,-1
 334:	00000c13          	li	s8,0
 338:	00d66633          	or	a2,a2,a3
 33c:	00061863          	bnez	a2,34c <main+0x208>
 340:	000a8663          	beqz	s5,34c <main+0x208>
 344:	00100c93          	li	s9,1
 348:	00000c13          	li	s8,0
 34c:	00e5e5b3          	or	a1,a1,a4
 350:	00059863          	bnez	a1,360 <main+0x21c>
 354:	000b0663          	beqz	s6,360 <main+0x21c>
 358:	00000c93          	li	s9,0
 35c:	fff00c13          	li	s8,-1
 360:	00e86833          	or	a6,a6,a4
 364:	00081863          	bnez	a6,374 <main+0x230>
 368:	000b8663          	beqz	s7,374 <main+0x230>
 36c:	00000c93          	li	s9,0
 370:	00100c13          	li	s8,1
 374:	01400713          	li	a4,20
 378:	01000793          	li	a5,16
 37c:	009c04b3          	add	s1,s8,s1
 380:	008c8433          	add	s0,s9,s0
 384:	02f4e4b3          	rem	s1,s1,a5
 388:	00c12783          	lw	a5,12(sp)
 38c:	02e46433          	rem	s0,s0,a4
 390:	00f4f493          	andi	s1,s1,15
 394:	00e40433          	add	s0,s0,a4
 398:	02e46433          	rem	s0,s0,a4
 39c:	00f49663          	bne	s1,a5,3a8 <main+0x264>
 3a0:	00812783          	lw	a5,8(sp)
 3a4:	12878463          	beq	a5,s0,4cc <main+0x388>
 3a8:	fff90593          	addi	a1,s2,-1
 3ac:	00000813          	li	a6,0
 3b0:	00040693          	mv	a3,s0
 3b4:	00048613          	mv	a2,s1
 3b8:	00098513          	mv	a0,s3
 3bc:	01012e23          	sw	a6,28(sp)
 3c0:	cbdff0ef          	jal	7c <is_on_snake>
 3c4:	10051a63          	bnez	a0,4d8 <main+0x394>
 3c8:	fff90713          	addi	a4,s2,-1
 3cc:	00371713          	slli	a4,a4,0x3
 3d0:	00ed0733          	add	a4,s10,a4
 3d4:	01c12803          	lw	a6,28(sp)
 3d8:	60072503          	lw	a0,1536(a4)
 3dc:	60472583          	lw	a1,1540(a4)
 3e0:	00391693          	slli	a3,s2,0x3
 3e4:	ff898713          	addi	a4,s3,-8
 3e8:	00d70733          	add	a4,a4,a3
 3ec:	ff872603          	lw	a2,-8(a4)
 3f0:	ff870713          	addi	a4,a4,-8
 3f4:	00c72423          	sw	a2,8(a4)
 3f8:	00472603          	lw	a2,4(a4)
 3fc:	00c72623          	sw	a2,12(a4)
 400:	fee996e3          	bne	s3,a4,3ec <main+0x2a8>
 404:	609d2023          	sw	s1,1536(s10)
 408:	608d2223          	sw	s0,1540(s10)
 40c:	00000613          	li	a2,0
 410:	04080e63          	beqz	a6,46c <main+0x328>
 414:	13f00713          	li	a4,319
 418:	01274a63          	blt	a4,s2,42c <main+0x2e8>
 41c:	00dd0733          	add	a4,s10,a3
 420:	60a72023          	sw	a0,1536(a4)
 424:	60b72223          	sw	a1,1540(a4)
 428:	00190913          	addi	s2,s2,1
 42c:	01012783          	lw	a5,16(sp)
 430:	01812503          	lw	a0,24(sp)
 434:	01412683          	lw	a3,20(sp)
 438:	00178793          	addi	a5,a5,1
 43c:	00090613          	mv	a2,s2
 440:	00098593          	mv	a1,s3
 444:	00f12823          	sw	a5,16(sp)
 448:	c69ff0ef          	jal	b0 <place_food>
 44c:	5f8d2783          	lw	a5,1528(s10)
 450:	001f0637          	lui	a2,0x1f0
 454:	01f60613          	addi	a2,a2,31 # 1f001f <read_pin+0x1ef9cb>
 458:	00f12623          	sw	a5,12(sp)
 45c:	5fcd2783          	lw	a5,1532(s10)
 460:	00c12503          	lw	a0,12(sp)
 464:	00f12423          	sw	a5,8(sp)
 468:	00078593          	mv	a1,a5
 46c:	bf5ff0ef          	jal	60 <draw_cell>
 470:	60cd2583          	lw	a1,1548(s10)
 474:	608d2503          	lw	a0,1544(s10)
 478:	07e00637          	lui	a2,0x7e00
 47c:	7e060613          	addi	a2,a2,2016 # 7e007e0 <read_pin+0x7e0018c>
 480:	be1ff0ef          	jal	60 <draw_cell>
 484:	fff00613          	li	a2,-1
 488:	00040593          	mv	a1,s0
 48c:	00048513          	mv	a0,s1
 490:	bd1ff0ef          	jal	60 <draw_cell>
 494:	01012503          	lw	a0,16(sp)
 498:	18c000ef          	jal	624 <seg_write_hex>
 49c:	00090513          	mv	a0,s2
 4a0:	174000ef          	jal	614 <led_write>
 4a4:	000dc537          	lui	a0,0xdc
 4a8:	ba050513          	addi	a0,a0,-1120 # dbba0 <read_pin+0xdb54c>
 4ac:	b61ff0ef          	jal	c <delay>
 4b0:	000c0713          	mv	a4,s8
 4b4:	000c8693          	mv	a3,s9
 4b8:	000b8813          	mv	a6,s7
 4bc:	000b0593          	mv	a1,s6
 4c0:	000a8613          	mv	a2,s5
 4c4:	000a0c13          	mv	s8,s4
 4c8:	df9ff06f          	j	2c0 <main+0x17c>
 4cc:	00090593          	mv	a1,s2
 4d0:	00100813          	li	a6,1
 4d4:	eddff06f          	j	3b0 <main+0x26c>
 4d8:	00600413          	li	s0,6
 4dc:	001f0537          	lui	a0,0x1f0
 4e0:	0a000713          	li	a4,160
 4e4:	08000693          	li	a3,128
 4e8:	00000613          	li	a2,0
 4ec:	00000593          	li	a1,0
 4f0:	01f50513          	addi	a0,a0,31 # 1f001f <read_pin+0x1ef9cb>
 4f4:	0a8000ef          	jal	59c <st7735_draw_rectangle>
 4f8:	00025537          	lui	a0,0x25
 4fc:	9f050513          	addi	a0,a0,-1552 # 249f0 <read_pin+0x2439c>
 500:	b0dff0ef          	jal	c <delay>
 504:	0a000713          	li	a4,160
 508:	08000693          	li	a3,128
 50c:	00000613          	li	a2,0
 510:	00000593          	li	a1,0
 514:	00000513          	li	a0,0
 518:	084000ef          	jal	59c <st7735_draw_rectangle>
 51c:	00025537          	lui	a0,0x25
 520:	9f050513          	addi	a0,a0,-1552 # 249f0 <read_pin+0x2439c>
 524:	fff40413          	addi	s0,s0,-1
 528:	ae5ff0ef          	jal	c <delay>
 52c:	fa0418e3          	bnez	s0,4dc <main+0x398>
 530:	5f4d2703          	lw	a4,1524(s10)
 534:	9e3786b7          	lui	a3,0x9e378
 538:	9b168693          	addi	a3,a3,-1615 # 9e3779b1 <read_pin+0x9e37735d>
 53c:	02d70733          	mul	a4,a4,a3
 540:	01012783          	lw	a5,16(sp)
 544:	00f70733          	add	a4,a4,a5
 548:	c89ff06f          	j	1d0 <main+0x8c>

0000054c <st7735_set_rectangle>:
 54c:	00ff07b7          	lui	a5,0xff0
 550:	01059593          	slli	a1,a1,0x10
 554:	0ff6f693          	zext.b	a3,a3
 558:	00f5f5b3          	and	a1,a1,a5
 55c:	00869693          	slli	a3,a3,0x8
 560:	01051513          	slli	a0,a0,0x10
 564:	0ff67613          	zext.b	a2,a2
 568:	00f57533          	and	a0,a0,a5
 56c:	00861613          	slli	a2,a2,0x8
 570:	00d5e5b3          	or	a1,a1,a3
 574:	2b0007b7          	lui	a5,0x2b000
 578:	00c56533          	or	a0,a0,a2
 57c:	2a000737          	lui	a4,0x2a000
 580:	00f5e5b3          	or	a1,a1,a5
 584:	f00007b7          	lui	a5,0xf0000
 588:	00e56533          	or	a0,a0,a4
 58c:	00278793          	addi	a5,a5,2 # f0000002 <read_pin+0xeffff9ae>
 590:	00a7a023          	sw	a0,0(a5)
 594:	00b7a023          	sw	a1,0(a5)
 598:	00008067          	ret

0000059c <st7735_draw_rectangle>:
 59c:	fe010113          	addi	sp,sp,-32
 5a0:	00812c23          	sw	s0,24(sp)
 5a4:	00912a23          	sw	s1,20(sp)
 5a8:	00068413          	mv	s0,a3
 5ac:	00050493          	mv	s1,a0
 5b0:	00058513          	mv	a0,a1
 5b4:	00e606b3          	add	a3,a2,a4
 5b8:	00060593          	mv	a1,a2
 5bc:	00850633          	add	a2,a0,s0
 5c0:	fff68693          	addi	a3,a3,-1
 5c4:	fff60613          	addi	a2,a2,-1
 5c8:	00112e23          	sw	ra,28(sp)
 5cc:	00e12623          	sw	a4,12(sp)
 5d0:	f7dff0ef          	jal	54c <st7735_set_rectangle>
 5d4:	00c12703          	lw	a4,12(sp)
 5d8:	2c0007b7          	lui	a5,0x2c000
 5dc:	02e40433          	mul	s0,s0,a4
 5e0:	40145413          	srai	s0,s0,0x1
 5e4:	00f46433          	or	s0,s0,a5
 5e8:	f00007b7          	lui	a5,0xf0000
 5ec:	00278793          	addi	a5,a5,2 # f0000002 <read_pin+0xeffff9ae>
 5f0:	0087a023          	sw	s0,0(a5)
 5f4:	f00007b7          	lui	a5,0xf0000
 5f8:	00178793          	addi	a5,a5,1 # f0000001 <read_pin+0xeffff9ad>
 5fc:	0097a023          	sw	s1,0(a5)
 600:	01c12083          	lw	ra,28(sp)
 604:	01812403          	lw	s0,24(sp)
 608:	01412483          	lw	s1,20(sp)
 60c:	02010113          	addi	sp,sp,32
 610:	00008067          	ret

00000614 <led_write>:
 614:	f00007b7          	lui	a5,0xf0000
 618:	00878793          	addi	a5,a5,8 # f0000008 <read_pin+0xeffff9b4>
 61c:	00a79023          	sh	a0,0(a5)
 620:	00008067          	ret

00000624 <seg_write_hex>:
 624:	f00007b7          	lui	a5,0xf0000
 628:	00478793          	addi	a5,a5,4 # f0000004 <read_pin+0xeffff9b0>
 62c:	00a79023          	sh	a0,0(a5)
 630:	00008067          	ret

00000634 <set_pin_mode>:
 634:	00151513          	slli	a0,a0,0x1
 638:	0015f593          	andi	a1,a1,1
 63c:	03e57513          	andi	a0,a0,62
 640:	f00007b7          	lui	a5,0xf0000
 644:	00b56533          	or	a0,a0,a1
 648:	01078793          	addi	a5,a5,16 # f0000010 <read_pin+0xeffff9bc>
 64c:	00a7a023          	sw	a0,0(a5)
 650:	00008067          	ret

00000654 <read_pin>:
 654:	01f57513          	andi	a0,a0,31
 658:	f00007b7          	lui	a5,0xf0000
 65c:	04078793          	addi	a5,a5,64 # f0000040 <read_pin+0xeffff9ec>
 660:	00851513          	slli	a0,a0,0x8
 664:	00f56533          	or	a0,a0,a5
 668:	00052503          	lw	a0,0(a0)
 66c:	00157513          	andi	a0,a0,1
 670:	00008067          	ret
