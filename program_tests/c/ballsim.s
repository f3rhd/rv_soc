
__out_tmp.elf:     file format elf32-littleriscv


Disassembly of section .text:

00000000 <_start>:
   0:	00008137          	lui	sp,0x8
   4:	0f0000ef          	jal	f4 <main>

00000008 <halt_loop>:
   8:	0000006f          	j	8 <halt_loop>

0000000c <delay>:
   c:	ff010113          	addi	sp,sp,-16 # 7ff0 <seg_write_hex+0x79e8>
  10:	00012623          	sw	zero,12(sp)
  14:	00c12783          	lw	a5,12(sp)
  18:	00a7e663          	bltu	a5,a0,24 <delay+0x18>
  1c:	01010113          	addi	sp,sp,16
  20:	00008067          	ret
  24:	00c12783          	lw	a5,12(sp)
  28:	00178793          	addi	a5,a5,1
  2c:	00f12623          	sw	a5,12(sp)
  30:	fe5ff06f          	j	14 <delay+0x8>

00000034 <isqrt>:
  34:	00050713          	mv	a4,a0
  38:	400007b7          	lui	a5,0x40000
  3c:	00f76863          	bltu	a4,a5,4c <isqrt+0x18>
  40:	00000513          	li	a0,0
  44:	00079863          	bnez	a5,54 <isqrt+0x20>
  48:	00008067          	ret
  4c:	0027d793          	srli	a5,a5,0x2
  50:	fedff06f          	j	3c <isqrt+0x8>
  54:	00f506b3          	add	a3,a0,a5
  58:	00155513          	srli	a0,a0,0x1
  5c:	00d76663          	bltu	a4,a3,68 <isqrt+0x34>
  60:	40d70733          	sub	a4,a4,a3
  64:	00f50533          	add	a0,a0,a5
  68:	0027d793          	srli	a5,a5,0x2
  6c:	fd9ff06f          	j	44 <isqrt+0x10>

00000070 <wall_bounce>:
  70:	00052783          	lw	a5,0(a0)
  74:	07400713          	li	a4,116
  78:	ffa78793          	addi	a5,a5,-6 # 3ffffffa <seg_write_hex+0x3ffff9f2>
  7c:	02f77063          	bgeu	a4,a5,9c <wall_bounce+0x2c>
  80:	0005a783          	lw	a5,0(a1)
  84:	00500713          	li	a4,5
  88:	40f007b3          	neg	a5,a5
  8c:	00f5a023          	sw	a5,0(a1)
  90:	00052783          	lw	a5,0(a0)
  94:	02f74c63          	blt	a4,a5,cc <wall_bounce+0x5c>
  98:	00e52023          	sw	a4,0(a0)
  9c:	00452783          	lw	a5,4(a0)
  a0:	09400713          	li	a4,148
  a4:	ffa78793          	addi	a5,a5,-6
  a8:	04f77463          	bgeu	a4,a5,f0 <wall_bounce+0x80>
  ac:	0045a783          	lw	a5,4(a1)
  b0:	00500713          	li	a4,5
  b4:	40f007b3          	neg	a5,a5
  b8:	00f5a223          	sw	a5,4(a1)
  bc:	00452783          	lw	a5,4(a0)
  c0:	02f74063          	blt	a4,a5,e0 <wall_bounce+0x70>
  c4:	00e52223          	sw	a4,4(a0)
  c8:	00008067          	ret
  cc:	07a00713          	li	a4,122
  d0:	fcf756e3          	bge	a4,a5,9c <wall_bounce+0x2c>
  d4:	07b00793          	li	a5,123
  d8:	00f52023          	sw	a5,0(a0)
  dc:	fc1ff06f          	j	9c <wall_bounce+0x2c>
  e0:	09a00713          	li	a4,154
  e4:	00f75663          	bge	a4,a5,f0 <wall_bounce+0x80>
  e8:	09b00793          	li	a5,155
  ec:	00f52223          	sw	a5,4(a0)
  f0:	00008067          	ret

000000f4 <main>:
  f4:	fb010113          	addi	sp,sp,-80
  f8:	04812423          	sw	s0,72(sp)
  fc:	03412c23          	sw	s4,56(sp)
 100:	0a000713          	li	a4,160
 104:	08000693          	li	a3,128
 108:	00000613          	li	a2,0
 10c:	00000593          	li	a1,0
 110:	00000513          	li	a0,0
 114:	ffe00a13          	li	s4,-2
 118:	05000413          	li	s0,80
 11c:	04912223          	sw	s1,68(sp)
 120:	05212023          	sw	s2,64(sp)
 124:	03312e23          	sw	s3,60(sp)
 128:	03512a23          	sw	s5,52(sp)
 12c:	03612823          	sw	s6,48(sp)
 130:	03712623          	sw	s7,44(sp)
 134:	03812423          	sw	s8,40(sp)
 138:	04112623          	sw	ra,76(sp)
 13c:	03912223          	sw	s9,36(sp)
 140:	03a12023          	sw	s10,32(sp)
 144:	000a0a93          	mv	s5,s4
 148:	26c000ef          	jal	3b4 <st7735_draw_rectangle>
 14c:	06000493          	li	s1,96
 150:	00300c13          	li	s8,3
 154:	00200b93          	li	s7,2
 158:	00040913          	mv	s2,s0
 15c:	02000993          	li	s3,32
 160:	00a00b13          	li	s6,10
 164:	00b00713          	li	a4,11
 168:	00070693          	mv	a3,a4
 16c:	ffb90613          	addi	a2,s2,-5
 170:	ffb98593          	addi	a1,s3,-5
 174:	00000513          	li	a0,0
 178:	23c000ef          	jal	3b4 <st7735_draw_rectangle>
 17c:	00b00713          	li	a4,11
 180:	ffb40613          	addi	a2,s0,-5
 184:	00070693          	mv	a3,a4
 188:	ffb48593          	addi	a1,s1,-5
 18c:	00000513          	li	a0,0
 190:	224000ef          	jal	3b4 <st7735_draw_rectangle>
 194:	017989b3          	add	s3,s3,s7
 198:	01890933          	add	s2,s2,s8
 19c:	00810593          	addi	a1,sp,8
 1a0:	00010513          	mv	a0,sp
 1a4:	01312023          	sw	s3,0(sp)
 1a8:	01212223          	sw	s2,4(sp)
 1ac:	01712423          	sw	s7,8(sp)
 1b0:	01812623          	sw	s8,12(sp)
 1b4:	ebdff0ef          	jal	70 <wall_bounce>
 1b8:	015484b3          	add	s1,s1,s5
 1bc:	01440433          	add	s0,s0,s4
 1c0:	01010513          	addi	a0,sp,16
 1c4:	01810593          	addi	a1,sp,24
 1c8:	00012983          	lw	s3,0(sp)
 1cc:	00412903          	lw	s2,4(sp)
 1d0:	00912823          	sw	s1,16(sp)
 1d4:	00812a23          	sw	s0,20(sp)
 1d8:	01512c23          	sw	s5,24(sp)
 1dc:	01412e23          	sw	s4,28(sp)
 1e0:	00812c83          	lw	s9,8(sp)
 1e4:	00c12d03          	lw	s10,12(sp)
 1e8:	e89ff0ef          	jal	70 <wall_bounce>
 1ec:	01012483          	lw	s1,16(sp)
 1f0:	01412403          	lw	s0,20(sp)
 1f4:	01812b83          	lw	s7,24(sp)
 1f8:	41348ab3          	sub	s5,s1,s3
 1fc:	41240a33          	sub	s4,s0,s2
 200:	035a8533          	mul	a0,s5,s5
 204:	01c12c03          	lw	s8,28(sp)
 208:	034a07b3          	mul	a5,s4,s4
 20c:	00f50533          	add	a0,a0,a5
 210:	0e050463          	beqz	a0,2f8 <main+0x204>
 214:	06552793          	slti	a5,a0,101
 218:	0e078063          	beqz	a5,2f8 <main+0x204>
 21c:	e19ff0ef          	jal	34 <isqrt>
 220:	00051463          	bnez	a0,228 <main+0x134>
 224:	00100513          	li	a0,1
 228:	417c87b3          	sub	a5,s9,s7
 22c:	418d0733          	sub	a4,s10,s8
 230:	035787b3          	mul	a5,a5,s5
 234:	03470733          	mul	a4,a4,s4
 238:	00e787b3          	add	a5,a5,a4
 23c:	00f04e63          	bgtz	a5,258 <main+0x164>
 240:	000c0793          	mv	a5,s8
 244:	000d0c13          	mv	s8,s10
 248:	00078d13          	mv	s10,a5
 24c:	000b8793          	mv	a5,s7
 250:	000c8b93          	mv	s7,s9
 254:	00078c93          	mv	s9,a5
 258:	00900713          	li	a4,9
 25c:	40ab07b3          	sub	a5,s6,a0
 260:	02a74463          	blt	a4,a0,288 <main+0x194>
 264:	02fa8ab3          	mul	s5,s5,a5
 268:	00151513          	slli	a0,a0,0x1
 26c:	02fa0a33          	mul	s4,s4,a5
 270:	02aacab3          	div	s5,s5,a0
 274:	02aa4a33          	div	s4,s4,a0
 278:	415989b3          	sub	s3,s3,s5
 27c:	015484b3          	add	s1,s1,s5
 280:	41490933          	sub	s2,s2,s4
 284:	01440433          	add	s0,s0,s4
 288:	001f0537          	lui	a0,0x1f0
 28c:	00500693          	li	a3,5
 290:	00090613          	mv	a2,s2
 294:	00098593          	mv	a1,s3
 298:	01f50513          	addi	a0,a0,31 # 1f001f <seg_write_hex+0x1efa17>
 29c:	264000ef          	jal	500 <st7735_draw_circle>
 2a0:	f8010537          	lui	a0,0xf8010
 2a4:	00500693          	li	a3,5
 2a8:	00040613          	mv	a2,s0
 2ac:	00048593          	mv	a1,s1
 2b0:	80050513          	addi	a0,a0,-2048 # f800f800 <seg_write_hex+0xf800f1f8>
 2b4:	24c000ef          	jal	500 <st7735_draw_circle>
 2b8:	0ff9f793          	zext.b	a5,s3
 2bc:	00879793          	slli	a5,a5,0x8
 2c0:	0ff97513          	zext.b	a0,s2
 2c4:	00a7e533          	or	a0,a5,a0
 2c8:	340000ef          	jal	608 <seg_write_hex>
 2cc:	0ff4f793          	zext.b	a5,s1
 2d0:	00879793          	slli	a5,a5,0x8
 2d4:	0ff47513          	zext.b	a0,s0
 2d8:	00a7e533          	or	a0,a5,a0
 2dc:	31c000ef          	jal	5f8 <led_write>
 2e0:	00025537          	lui	a0,0x25
 2e4:	9f050513          	addi	a0,a0,-1552 # 249f0 <seg_write_hex+0x243e8>
 2e8:	d25ff0ef          	jal	c <delay>
 2ec:	000d0a13          	mv	s4,s10
 2f0:	000c8a93          	mv	s5,s9
 2f4:	e71ff06f          	j	164 <main+0x70>
 2f8:	000c0793          	mv	a5,s8
 2fc:	000d0c13          	mv	s8,s10
 300:	00078d13          	mv	s10,a5
 304:	000b8793          	mv	a5,s7
 308:	000c8b93          	mv	s7,s9
 30c:	00078c93          	mv	s9,a5
 310:	f79ff06f          	j	288 <main+0x194>

00000314 <st7735_set_rectangle>:
 314:	00ff07b7          	lui	a5,0xff0
 318:	01059593          	slli	a1,a1,0x10
 31c:	0ff6f693          	zext.b	a3,a3
 320:	00f5f5b3          	and	a1,a1,a5
 324:	00869693          	slli	a3,a3,0x8
 328:	01051513          	slli	a0,a0,0x10
 32c:	0ff67613          	zext.b	a2,a2
 330:	00f57533          	and	a0,a0,a5
 334:	00861613          	slli	a2,a2,0x8
 338:	00d5e5b3          	or	a1,a1,a3
 33c:	2b0007b7          	lui	a5,0x2b000
 340:	00c56533          	or	a0,a0,a2
 344:	2a000737          	lui	a4,0x2a000
 348:	00f5e5b3          	or	a1,a1,a5
 34c:	f00007b7          	lui	a5,0xf0000
 350:	00e56533          	or	a0,a0,a4
 354:	00478793          	addi	a5,a5,4 # f0000004 <seg_write_hex+0xeffff9fc>
 358:	00a7a023          	sw	a0,0(a5)
 35c:	00b7a023          	sw	a1,0(a5)
 360:	00008067          	ret

00000364 <st7735_draw_pixel>:
 364:	ff010113          	addi	sp,sp,-16
 368:	00812423          	sw	s0,8(sp)
 36c:	00050413          	mv	s0,a0
 370:	00058513          	mv	a0,a1
 374:	00060693          	mv	a3,a2
 378:	00060593          	mv	a1,a2
 37c:	00050613          	mv	a2,a0
 380:	00112623          	sw	ra,12(sp)
 384:	f91ff0ef          	jal	314 <st7735_set_rectangle>
 388:	2c0007b7          	lui	a5,0x2c000
 38c:	f0000737          	lui	a4,0xf0000
 390:	00178793          	addi	a5,a5,1 # 2c000001 <seg_write_hex+0x2bfff9f9>
 394:	00470713          	addi	a4,a4,4 # f0000004 <seg_write_hex+0xeffff9fc>
 398:	00f72023          	sw	a5,0(a4)
 39c:	f00007b7          	lui	a5,0xf0000
 3a0:	0087a023          	sw	s0,0(a5) # f0000000 <seg_write_hex+0xeffff9f8>
 3a4:	00c12083          	lw	ra,12(sp)
 3a8:	00812403          	lw	s0,8(sp)
 3ac:	01010113          	addi	sp,sp,16
 3b0:	00008067          	ret

000003b4 <st7735_draw_rectangle>:
 3b4:	fe010113          	addi	sp,sp,-32
 3b8:	00812c23          	sw	s0,24(sp)
 3bc:	00912a23          	sw	s1,20(sp)
 3c0:	00068413          	mv	s0,a3
 3c4:	00050493          	mv	s1,a0
 3c8:	00058513          	mv	a0,a1
 3cc:	00e606b3          	add	a3,a2,a4
 3d0:	00060593          	mv	a1,a2
 3d4:	00850633          	add	a2,a0,s0
 3d8:	fff68693          	addi	a3,a3,-1
 3dc:	fff60613          	addi	a2,a2,-1
 3e0:	00112e23          	sw	ra,28(sp)
 3e4:	00e12623          	sw	a4,12(sp)
 3e8:	f2dff0ef          	jal	314 <st7735_set_rectangle>
 3ec:	00c12703          	lw	a4,12(sp)
 3f0:	2c0007b7          	lui	a5,0x2c000
 3f4:	02e40433          	mul	s0,s0,a4
 3f8:	40145413          	srai	s0,s0,0x1
 3fc:	00f46433          	or	s0,s0,a5
 400:	f00007b7          	lui	a5,0xf0000
 404:	00478793          	addi	a5,a5,4 # f0000004 <seg_write_hex+0xeffff9fc>
 408:	0087a023          	sw	s0,0(a5)
 40c:	f00007b7          	lui	a5,0xf0000
 410:	0097a023          	sw	s1,0(a5) # f0000000 <seg_write_hex+0xeffff9f8>
 414:	01c12083          	lw	ra,28(sp)
 418:	01812403          	lw	s0,24(sp)
 41c:	01412483          	lw	s1,20(sp)
 420:	02010113          	addi	sp,sp,32
 424:	00008067          	ret

00000428 <st7735_draw_line>:
 428:	fc010113          	addi	sp,sp,-64
 42c:	02812c23          	sw	s0,56(sp)
 430:	40b68433          	sub	s0,a3,a1
 434:	41f45793          	srai	a5,s0,0x1f
 438:	03412423          	sw	s4,40(sp)
 43c:	0087c433          	xor	s0,a5,s0
 440:	02112e23          	sw	ra,60(sp)
 444:	02912a23          	sw	s1,52(sp)
 448:	03212823          	sw	s2,48(sp)
 44c:	03312623          	sw	s3,44(sp)
 450:	03512223          	sw	s5,36(sp)
 454:	40f40433          	sub	s0,s0,a5
 458:	00100a13          	li	s4,1
 45c:	00d5c463          	blt	a1,a3,464 <st7735_draw_line+0x3c>
 460:	fff00a13          	li	s4,-1
 464:	40c704b3          	sub	s1,a4,a2
 468:	41f4d793          	srai	a5,s1,0x1f
 46c:	0097c4b3          	xor	s1,a5,s1
 470:	40f484b3          	sub	s1,s1,a5
 474:	40900ab3          	neg	s5,s1
 478:	fff00993          	li	s3,-1
 47c:	00e65463          	bge	a2,a4,484 <st7735_draw_line+0x5c>
 480:	00100993          	li	s3,1
 484:	40940933          	sub	s2,s0,s1
 488:	00e12e23          	sw	a4,28(sp)
 48c:	00d12c23          	sw	a3,24(sp)
 490:	00c12a23          	sw	a2,20(sp)
 494:	00b12823          	sw	a1,16(sp)
 498:	00a12623          	sw	a0,12(sp)
 49c:	ec9ff0ef          	jal	364 <st7735_draw_pixel>
 4a0:	01012583          	lw	a1,16(sp)
 4a4:	01812683          	lw	a3,24(sp)
 4a8:	00c12503          	lw	a0,12(sp)
 4ac:	01412603          	lw	a2,20(sp)
 4b0:	01c12703          	lw	a4,28(sp)
 4b4:	00d59463          	bne	a1,a3,4bc <st7735_draw_line+0x94>
 4b8:	02e60263          	beq	a2,a4,4dc <st7735_draw_line+0xb4>
 4bc:	00191793          	slli	a5,s2,0x1
 4c0:	0157c863          	blt	a5,s5,4d0 <st7735_draw_line+0xa8>
 4c4:	40990933          	sub	s2,s2,s1
 4c8:	014585b3          	add	a1,a1,s4
 4cc:	faf44ee3          	blt	s0,a5,488 <st7735_draw_line+0x60>
 4d0:	00890933          	add	s2,s2,s0
 4d4:	01360633          	add	a2,a2,s3
 4d8:	fb1ff06f          	j	488 <st7735_draw_line+0x60>
 4dc:	03c12083          	lw	ra,60(sp)
 4e0:	03812403          	lw	s0,56(sp)
 4e4:	03412483          	lw	s1,52(sp)
 4e8:	03012903          	lw	s2,48(sp)
 4ec:	02c12983          	lw	s3,44(sp)
 4f0:	02812a03          	lw	s4,40(sp)
 4f4:	02412a83          	lw	s5,36(sp)
 4f8:	04010113          	addi	sp,sp,64
 4fc:	00008067          	ret

00000500 <st7735_draw_circle>:
 500:	fd010113          	addi	sp,sp,-48
 504:	03212023          	sw	s2,32(sp)
 508:	00100913          	li	s2,1
 50c:	02812423          	sw	s0,40(sp)
 510:	02912223          	sw	s1,36(sp)
 514:	01312e23          	sw	s3,28(sp)
 518:	01412c23          	sw	s4,24(sp)
 51c:	01512a23          	sw	s5,20(sp)
 520:	02112623          	sw	ra,44(sp)
 524:	00050a93          	mv	s5,a0
 528:	00058993          	mv	s3,a1
 52c:	00060a13          	mv	s4,a2
 530:	00068413          	mv	s0,a3
 534:	40d90933          	sub	s2,s2,a3
 538:	00000493          	li	s1,0
 53c:	02945463          	bge	s0,s1,564 <st7735_draw_circle+0x64>
 540:	02c12083          	lw	ra,44(sp)
 544:	02812403          	lw	s0,40(sp)
 548:	02412483          	lw	s1,36(sp)
 54c:	02012903          	lw	s2,32(sp)
 550:	01c12983          	lw	s3,28(sp)
 554:	01812a03          	lw	s4,24(sp)
 558:	01412a83          	lw	s5,20(sp)
 55c:	03010113          	addi	sp,sp,48
 560:	00008067          	ret
 564:	009a0733          	add	a4,s4,s1
 568:	408985b3          	sub	a1,s3,s0
 56c:	013406b3          	add	a3,s0,s3
 570:	00070613          	mv	a2,a4
 574:	000a8513          	mv	a0,s5
 578:	00d12623          	sw	a3,12(sp)
 57c:	00b12423          	sw	a1,8(sp)
 580:	ea9ff0ef          	jal	428 <st7735_draw_line>
 584:	00c12683          	lw	a3,12(sp)
 588:	00812583          	lw	a1,8(sp)
 58c:	409a0733          	sub	a4,s4,s1
 590:	00070613          	mv	a2,a4
 594:	000a8513          	mv	a0,s5
 598:	e91ff0ef          	jal	428 <st7735_draw_line>
 59c:	01440733          	add	a4,s0,s4
 5a0:	409985b3          	sub	a1,s3,s1
 5a4:	013486b3          	add	a3,s1,s3
 5a8:	00070613          	mv	a2,a4
 5ac:	000a8513          	mv	a0,s5
 5b0:	00d12623          	sw	a3,12(sp)
 5b4:	00b12423          	sw	a1,8(sp)
 5b8:	e71ff0ef          	jal	428 <st7735_draw_line>
 5bc:	00c12683          	lw	a3,12(sp)
 5c0:	00812583          	lw	a1,8(sp)
 5c4:	408a0733          	sub	a4,s4,s0
 5c8:	00070613          	mv	a2,a4
 5cc:	000a8513          	mv	a0,s5
 5d0:	e59ff0ef          	jal	428 <st7735_draw_line>
 5d4:	00148493          	addi	s1,s1,1
 5d8:	00149793          	slli	a5,s1,0x1
 5dc:	00094863          	bltz	s2,5ec <st7735_draw_circle+0xec>
 5e0:	fff40413          	addi	s0,s0,-1
 5e4:	408487b3          	sub	a5,s1,s0
 5e8:	00179793          	slli	a5,a5,0x1
 5ec:	00178793          	addi	a5,a5,1
 5f0:	00f90933          	add	s2,s2,a5
 5f4:	f49ff06f          	j	53c <st7735_draw_circle+0x3c>

000005f8 <led_write>:
 5f8:	f00007b7          	lui	a5,0xf0000
 5fc:	00c78793          	addi	a5,a5,12 # f000000c <seg_write_hex+0xeffffa04>
 600:	00a79023          	sh	a0,0(a5)
 604:	00008067          	ret

00000608 <seg_write_hex>:
 608:	f00007b7          	lui	a5,0xf0000
 60c:	00878793          	addi	a5,a5,8 # f0000008 <seg_write_hex+0xeffffa00>
 610:	00a79023          	sh	a0,0(a5)
 614:	00008067          	ret
