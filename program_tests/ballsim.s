
__out_tmp.elf:     file format elf32-littleriscv


Disassembly of section .text:

00000000 <__static_end>:
   0:	00001197          	auipc	gp,0x1
   4:	80018193          	addi	gp,gp,-2048 # 800 <__global_pointer$>
   8:	00020117          	auipc	sp,0x20
   c:	ff810113          	addi	sp,sp,-8 # 20000 <__stack_top>
  10:	0f0000ef          	jal	100 <main>

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

00000040 <isqrt>:
  40:	00050713          	mv	a4,a0
  44:	400007b7          	lui	a5,0x40000
  48:	00f76863          	bltu	a4,a5,58 <isqrt+0x18>
  4c:	00000513          	li	a0,0
  50:	00079863          	bnez	a5,60 <isqrt+0x20>
  54:	00008067          	ret
  58:	0027d793          	srli	a5,a5,0x2
  5c:	fedff06f          	j	48 <isqrt+0x8>
  60:	00f506b3          	add	a3,a0,a5
  64:	00155513          	srli	a0,a0,0x1
  68:	00d76663          	bltu	a4,a3,74 <isqrt+0x34>
  6c:	40d70733          	sub	a4,a4,a3
  70:	00f50533          	add	a0,a0,a5
  74:	0027d793          	srli	a5,a5,0x2
  78:	fd9ff06f          	j	50 <isqrt+0x10>

0000007c <wall_bounce>:
  7c:	00052783          	lw	a5,0(a0)
  80:	07400713          	li	a4,116
  84:	ffa78793          	addi	a5,a5,-6 # 3ffffffa <__stack_top+0x3ffdfffa>
  88:	02f77063          	bgeu	a4,a5,a8 <wall_bounce+0x2c>
  8c:	0005a783          	lw	a5,0(a1)
  90:	00500713          	li	a4,5
  94:	40f007b3          	neg	a5,a5
  98:	00f5a023          	sw	a5,0(a1)
  9c:	00052783          	lw	a5,0(a0)
  a0:	02f74c63          	blt	a4,a5,d8 <wall_bounce+0x5c>
  a4:	00e52023          	sw	a4,0(a0)
  a8:	00452783          	lw	a5,4(a0)
  ac:	09400713          	li	a4,148
  b0:	ffa78793          	addi	a5,a5,-6
  b4:	04f77463          	bgeu	a4,a5,fc <wall_bounce+0x80>
  b8:	0045a783          	lw	a5,4(a1)
  bc:	00500713          	li	a4,5
  c0:	40f007b3          	neg	a5,a5
  c4:	00f5a223          	sw	a5,4(a1)
  c8:	00452783          	lw	a5,4(a0)
  cc:	02f74063          	blt	a4,a5,ec <wall_bounce+0x70>
  d0:	00e52223          	sw	a4,4(a0)
  d4:	00008067          	ret
  d8:	07a00713          	li	a4,122
  dc:	fcf756e3          	bge	a4,a5,a8 <wall_bounce+0x2c>
  e0:	07b00793          	li	a5,123
  e4:	00f52023          	sw	a5,0(a0)
  e8:	fc1ff06f          	j	a8 <wall_bounce+0x2c>
  ec:	09a00713          	li	a4,154
  f0:	00f75663          	bge	a4,a5,fc <wall_bounce+0x80>
  f4:	09b00793          	li	a5,155
  f8:	00f52223          	sw	a5,4(a0)
  fc:	00008067          	ret

00000100 <main>:
 100:	fb010113          	addi	sp,sp,-80
 104:	04812423          	sw	s0,72(sp)
 108:	03412c23          	sw	s4,56(sp)
 10c:	0a000713          	li	a4,160
 110:	08000693          	li	a3,128
 114:	00000613          	li	a2,0
 118:	00000593          	li	a1,0
 11c:	00000513          	li	a0,0
 120:	ffe00a13          	li	s4,-2
 124:	05000413          	li	s0,80
 128:	04912223          	sw	s1,68(sp)
 12c:	05212023          	sw	s2,64(sp)
 130:	03312e23          	sw	s3,60(sp)
 134:	03512a23          	sw	s5,52(sp)
 138:	03612823          	sw	s6,48(sp)
 13c:	03712623          	sw	s7,44(sp)
 140:	03812423          	sw	s8,40(sp)
 144:	04112623          	sw	ra,76(sp)
 148:	03912223          	sw	s9,36(sp)
 14c:	03a12023          	sw	s10,32(sp)
 150:	000a0a93          	mv	s5,s4
 154:	290000ef          	jal	3e4 <st7735_draw_rectangle>
 158:	06000493          	li	s1,96
 15c:	00300c13          	li	s8,3
 160:	00200b93          	li	s7,2
 164:	00040913          	mv	s2,s0
 168:	02000993          	li	s3,32
 16c:	00a00b13          	li	s6,10
 170:	00b00713          	li	a4,11
 174:	00070693          	mv	a3,a4
 178:	ffb90613          	addi	a2,s2,-5
 17c:	ffb98593          	addi	a1,s3,-5
 180:	00000513          	li	a0,0
 184:	260000ef          	jal	3e4 <st7735_draw_rectangle>
 188:	00b00713          	li	a4,11
 18c:	ffb40613          	addi	a2,s0,-5
 190:	00070693          	mv	a3,a4
 194:	ffb48593          	addi	a1,s1,-5
 198:	00000513          	li	a0,0
 19c:	248000ef          	jal	3e4 <st7735_draw_rectangle>
 1a0:	017989b3          	add	s3,s3,s7
 1a4:	01890933          	add	s2,s2,s8
 1a8:	00810593          	addi	a1,sp,8
 1ac:	00010513          	mv	a0,sp
 1b0:	01312023          	sw	s3,0(sp)
 1b4:	01212223          	sw	s2,4(sp)
 1b8:	01712423          	sw	s7,8(sp)
 1bc:	01812623          	sw	s8,12(sp)
 1c0:	ebdff0ef          	jal	7c <wall_bounce>
 1c4:	015484b3          	add	s1,s1,s5
 1c8:	01440433          	add	s0,s0,s4
 1cc:	01010513          	addi	a0,sp,16
 1d0:	01810593          	addi	a1,sp,24
 1d4:	00012983          	lw	s3,0(sp)
 1d8:	00412903          	lw	s2,4(sp)
 1dc:	00912823          	sw	s1,16(sp)
 1e0:	00812a23          	sw	s0,20(sp)
 1e4:	01512c23          	sw	s5,24(sp)
 1e8:	01412e23          	sw	s4,28(sp)
 1ec:	00812c83          	lw	s9,8(sp)
 1f0:	00c12d03          	lw	s10,12(sp)
 1f4:	e89ff0ef          	jal	7c <wall_bounce>
 1f8:	01012483          	lw	s1,16(sp)
 1fc:	01412403          	lw	s0,20(sp)
 200:	01812b83          	lw	s7,24(sp)
 204:	41348ab3          	sub	s5,s1,s3
 208:	41240a33          	sub	s4,s0,s2
 20c:	035a8533          	mul	a0,s5,s5
 210:	01c12c03          	lw	s8,28(sp)
 214:	034a07b3          	mul	a5,s4,s4
 218:	00f50533          	add	a0,a0,a5
 21c:	0e050463          	beqz	a0,304 <main+0x204>
 220:	06552793          	slti	a5,a0,101
 224:	0e078063          	beqz	a5,304 <main+0x204>
 228:	e19ff0ef          	jal	40 <isqrt>
 22c:	00051463          	bnez	a0,234 <main+0x134>
 230:	00100513          	li	a0,1
 234:	417c87b3          	sub	a5,s9,s7
 238:	418d0733          	sub	a4,s10,s8
 23c:	035787b3          	mul	a5,a5,s5
 240:	03470733          	mul	a4,a4,s4
 244:	00e787b3          	add	a5,a5,a4
 248:	00f04e63          	bgtz	a5,264 <main+0x164>
 24c:	000c0793          	mv	a5,s8
 250:	000d0c13          	mv	s8,s10
 254:	00078d13          	mv	s10,a5
 258:	000b8793          	mv	a5,s7
 25c:	000c8b93          	mv	s7,s9
 260:	00078c93          	mv	s9,a5
 264:	00900713          	li	a4,9
 268:	40ab07b3          	sub	a5,s6,a0
 26c:	02a74463          	blt	a4,a0,294 <main+0x194>
 270:	02fa8ab3          	mul	s5,s5,a5
 274:	00151513          	slli	a0,a0,0x1
 278:	02fa0a33          	mul	s4,s4,a5
 27c:	02aacab3          	div	s5,s5,a0
 280:	02aa4a33          	div	s4,s4,a0
 284:	415989b3          	sub	s3,s3,s5
 288:	015484b3          	add	s1,s1,s5
 28c:	41490933          	sub	s2,s2,s4
 290:	01440433          	add	s0,s0,s4
 294:	001f0537          	lui	a0,0x1f0
 298:	00500693          	li	a3,5
 29c:	00090613          	mv	a2,s2
 2a0:	00098593          	mv	a1,s3
 2a4:	01f50513          	addi	a0,a0,31 # 1f001f <__stack_top+0x1d001f>
 2a8:	28c000ef          	jal	534 <st7735_draw_circle>
 2ac:	f8010537          	lui	a0,0xf8010
 2b0:	00500693          	li	a3,5
 2b4:	00040613          	mv	a2,s0
 2b8:	00048593          	mv	a1,s1
 2bc:	80050513          	addi	a0,a0,-2048 # f800f800 <__stack_top+0xf7fef800>
 2c0:	274000ef          	jal	534 <st7735_draw_circle>
 2c4:	0ff9f793          	zext.b	a5,s3
 2c8:	00879793          	slli	a5,a5,0x8
 2cc:	0ff97513          	zext.b	a0,s2
 2d0:	00a7e533          	or	a0,a5,a0
 2d4:	05c000ef          	jal	330 <seg_write_hex>
 2d8:	0ff4f793          	zext.b	a5,s1
 2dc:	00879793          	slli	a5,a5,0x8
 2e0:	0ff47513          	zext.b	a0,s0
 2e4:	00a7e533          	or	a0,a5,a0
 2e8:	038000ef          	jal	320 <led_write>
 2ec:	00025537          	lui	a0,0x25
 2f0:	9f050513          	addi	a0,a0,-1552 # 249f0 <__stack_top+0x49f0>
 2f4:	d25ff0ef          	jal	18 <delay>
 2f8:	000d0a13          	mv	s4,s10
 2fc:	000c8a93          	mv	s5,s9
 300:	e71ff06f          	j	170 <main+0x70>
 304:	000c0793          	mv	a5,s8
 308:	000d0c13          	mv	s8,s10
 30c:	00078d13          	mv	s10,a5
 310:	000b8793          	mv	a5,s7
 314:	000c8b93          	mv	s7,s9
 318:	00078c93          	mv	s9,a5
 31c:	f79ff06f          	j	294 <main+0x194>

00000320 <led_write>:
 320:	f00007b7          	lui	a5,0xf0000
 324:	00878793          	addi	a5,a5,8 # f0000008 <__stack_top+0xeffe0008>
 328:	00a79023          	sh	a0,0(a5)
 32c:	00008067          	ret

00000330 <seg_write_hex>:
 330:	f00007b7          	lui	a5,0xf0000
 334:	00478793          	addi	a5,a5,4 # f0000004 <__stack_top+0xeffe0004>
 338:	00a79023          	sh	a0,0(a5)
 33c:	00008067          	ret

00000340 <st7735_set_rectangle>:
 340:	00ff07b7          	lui	a5,0xff0
 344:	01059593          	slli	a1,a1,0x10
 348:	0ff6f693          	zext.b	a3,a3
 34c:	00f5f5b3          	and	a1,a1,a5
 350:	00869693          	slli	a3,a3,0x8
 354:	01051513          	slli	a0,a0,0x10
 358:	0ff67613          	zext.b	a2,a2
 35c:	00f57533          	and	a0,a0,a5
 360:	00861613          	slli	a2,a2,0x8
 364:	00d5e5b3          	or	a1,a1,a3
 368:	2b0007b7          	lui	a5,0x2b000
 36c:	00c56533          	or	a0,a0,a2
 370:	2a000737          	lui	a4,0x2a000
 374:	00f5e5b3          	or	a1,a1,a5
 378:	f00007b7          	lui	a5,0xf0000
 37c:	00e56533          	or	a0,a0,a4
 380:	00278793          	addi	a5,a5,2 # f0000002 <__stack_top+0xeffe0002>
 384:	00a7a023          	sw	a0,0(a5)
 388:	00b7a023          	sw	a1,0(a5)
 38c:	00008067          	ret

00000390 <st7735_draw_pixel>:
 390:	ff010113          	addi	sp,sp,-16
 394:	00812423          	sw	s0,8(sp)
 398:	00050413          	mv	s0,a0
 39c:	00058513          	mv	a0,a1
 3a0:	00060693          	mv	a3,a2
 3a4:	00060593          	mv	a1,a2
 3a8:	00050613          	mv	a2,a0
 3ac:	00112623          	sw	ra,12(sp)
 3b0:	f91ff0ef          	jal	340 <st7735_set_rectangle>
 3b4:	2c0007b7          	lui	a5,0x2c000
 3b8:	f0000737          	lui	a4,0xf0000
 3bc:	00178793          	addi	a5,a5,1 # 2c000001 <__stack_top+0x2bfe0001>
 3c0:	00270713          	addi	a4,a4,2 # f0000002 <__stack_top+0xeffe0002>
 3c4:	00f72023          	sw	a5,0(a4)
 3c8:	f00007b7          	lui	a5,0xf0000
 3cc:	00178793          	addi	a5,a5,1 # f0000001 <__stack_top+0xeffe0001>
 3d0:	0087a023          	sw	s0,0(a5)
 3d4:	00c12083          	lw	ra,12(sp)
 3d8:	00812403          	lw	s0,8(sp)
 3dc:	01010113          	addi	sp,sp,16
 3e0:	00008067          	ret

000003e4 <st7735_draw_rectangle>:
 3e4:	fe010113          	addi	sp,sp,-32
 3e8:	00812c23          	sw	s0,24(sp)
 3ec:	00912a23          	sw	s1,20(sp)
 3f0:	00068413          	mv	s0,a3
 3f4:	00050493          	mv	s1,a0
 3f8:	00058513          	mv	a0,a1
 3fc:	00e606b3          	add	a3,a2,a4
 400:	00060593          	mv	a1,a2
 404:	00850633          	add	a2,a0,s0
 408:	fff68693          	addi	a3,a3,-1
 40c:	fff60613          	addi	a2,a2,-1
 410:	00112e23          	sw	ra,28(sp)
 414:	00e12623          	sw	a4,12(sp)
 418:	f29ff0ef          	jal	340 <st7735_set_rectangle>
 41c:	00c12703          	lw	a4,12(sp)
 420:	2c0007b7          	lui	a5,0x2c000
 424:	02e40433          	mul	s0,s0,a4
 428:	40145413          	srai	s0,s0,0x1
 42c:	00f46433          	or	s0,s0,a5
 430:	f00007b7          	lui	a5,0xf0000
 434:	00278793          	addi	a5,a5,2 # f0000002 <__stack_top+0xeffe0002>
 438:	0087a023          	sw	s0,0(a5)
 43c:	f00007b7          	lui	a5,0xf0000
 440:	00178793          	addi	a5,a5,1 # f0000001 <__stack_top+0xeffe0001>
 444:	0097a023          	sw	s1,0(a5)
 448:	01c12083          	lw	ra,28(sp)
 44c:	01812403          	lw	s0,24(sp)
 450:	01412483          	lw	s1,20(sp)
 454:	02010113          	addi	sp,sp,32
 458:	00008067          	ret

0000045c <st7735_draw_line>:
 45c:	fc010113          	addi	sp,sp,-64
 460:	02812c23          	sw	s0,56(sp)
 464:	40b68433          	sub	s0,a3,a1
 468:	41f45793          	srai	a5,s0,0x1f
 46c:	03412423          	sw	s4,40(sp)
 470:	0087c433          	xor	s0,a5,s0
 474:	02112e23          	sw	ra,60(sp)
 478:	02912a23          	sw	s1,52(sp)
 47c:	03212823          	sw	s2,48(sp)
 480:	03312623          	sw	s3,44(sp)
 484:	03512223          	sw	s5,36(sp)
 488:	40f40433          	sub	s0,s0,a5
 48c:	00100a13          	li	s4,1
 490:	00d5c463          	blt	a1,a3,498 <st7735_draw_line+0x3c>
 494:	fff00a13          	li	s4,-1
 498:	40c704b3          	sub	s1,a4,a2
 49c:	41f4d793          	srai	a5,s1,0x1f
 4a0:	0097c4b3          	xor	s1,a5,s1
 4a4:	40f484b3          	sub	s1,s1,a5
 4a8:	40900ab3          	neg	s5,s1
 4ac:	fff00993          	li	s3,-1
 4b0:	00e65463          	bge	a2,a4,4b8 <st7735_draw_line+0x5c>
 4b4:	00100993          	li	s3,1
 4b8:	40940933          	sub	s2,s0,s1
 4bc:	00e12e23          	sw	a4,28(sp)
 4c0:	00d12c23          	sw	a3,24(sp)
 4c4:	00c12a23          	sw	a2,20(sp)
 4c8:	00b12823          	sw	a1,16(sp)
 4cc:	00a12623          	sw	a0,12(sp)
 4d0:	ec1ff0ef          	jal	390 <st7735_draw_pixel>
 4d4:	01012583          	lw	a1,16(sp)
 4d8:	01812683          	lw	a3,24(sp)
 4dc:	00c12503          	lw	a0,12(sp)
 4e0:	01412603          	lw	a2,20(sp)
 4e4:	01c12703          	lw	a4,28(sp)
 4e8:	00d59463          	bne	a1,a3,4f0 <st7735_draw_line+0x94>
 4ec:	02e60263          	beq	a2,a4,510 <st7735_draw_line+0xb4>
 4f0:	00191793          	slli	a5,s2,0x1
 4f4:	0157c863          	blt	a5,s5,504 <st7735_draw_line+0xa8>
 4f8:	40990933          	sub	s2,s2,s1
 4fc:	014585b3          	add	a1,a1,s4
 500:	faf44ee3          	blt	s0,a5,4bc <st7735_draw_line+0x60>
 504:	00890933          	add	s2,s2,s0
 508:	01360633          	add	a2,a2,s3
 50c:	fb1ff06f          	j	4bc <st7735_draw_line+0x60>
 510:	03c12083          	lw	ra,60(sp)
 514:	03812403          	lw	s0,56(sp)
 518:	03412483          	lw	s1,52(sp)
 51c:	03012903          	lw	s2,48(sp)
 520:	02c12983          	lw	s3,44(sp)
 524:	02812a03          	lw	s4,40(sp)
 528:	02412a83          	lw	s5,36(sp)
 52c:	04010113          	addi	sp,sp,64
 530:	00008067          	ret

00000534 <st7735_draw_circle>:
 534:	fd010113          	addi	sp,sp,-48
 538:	03212023          	sw	s2,32(sp)
 53c:	00100913          	li	s2,1
 540:	02812423          	sw	s0,40(sp)
 544:	02912223          	sw	s1,36(sp)
 548:	01312e23          	sw	s3,28(sp)
 54c:	01412c23          	sw	s4,24(sp)
 550:	01512a23          	sw	s5,20(sp)
 554:	02112623          	sw	ra,44(sp)
 558:	00050a93          	mv	s5,a0
 55c:	00058993          	mv	s3,a1
 560:	00060a13          	mv	s4,a2
 564:	00068413          	mv	s0,a3
 568:	40d90933          	sub	s2,s2,a3
 56c:	00000493          	li	s1,0
 570:	02945463          	bge	s0,s1,598 <st7735_draw_circle+0x64>
 574:	02c12083          	lw	ra,44(sp)
 578:	02812403          	lw	s0,40(sp)
 57c:	02412483          	lw	s1,36(sp)
 580:	02012903          	lw	s2,32(sp)
 584:	01c12983          	lw	s3,28(sp)
 588:	01812a03          	lw	s4,24(sp)
 58c:	01412a83          	lw	s5,20(sp)
 590:	03010113          	addi	sp,sp,48
 594:	00008067          	ret
 598:	009a0733          	add	a4,s4,s1
 59c:	408985b3          	sub	a1,s3,s0
 5a0:	013406b3          	add	a3,s0,s3
 5a4:	00070613          	mv	a2,a4
 5a8:	000a8513          	mv	a0,s5
 5ac:	00d12623          	sw	a3,12(sp)
 5b0:	00b12423          	sw	a1,8(sp)
 5b4:	ea9ff0ef          	jal	45c <st7735_draw_line>
 5b8:	00c12683          	lw	a3,12(sp)
 5bc:	00812583          	lw	a1,8(sp)
 5c0:	409a0733          	sub	a4,s4,s1
 5c4:	00070613          	mv	a2,a4
 5c8:	000a8513          	mv	a0,s5
 5cc:	e91ff0ef          	jal	45c <st7735_draw_line>
 5d0:	01440733          	add	a4,s0,s4
 5d4:	409985b3          	sub	a1,s3,s1
 5d8:	013486b3          	add	a3,s1,s3
 5dc:	00070613          	mv	a2,a4
 5e0:	000a8513          	mv	a0,s5
 5e4:	00d12623          	sw	a3,12(sp)
 5e8:	00b12423          	sw	a1,8(sp)
 5ec:	e71ff0ef          	jal	45c <st7735_draw_line>
 5f0:	00c12683          	lw	a3,12(sp)
 5f4:	00812583          	lw	a1,8(sp)
 5f8:	408a0733          	sub	a4,s4,s0
 5fc:	00070613          	mv	a2,a4
 600:	000a8513          	mv	a0,s5
 604:	e59ff0ef          	jal	45c <st7735_draw_line>
 608:	00148493          	addi	s1,s1,1
 60c:	00149793          	slli	a5,s1,0x1
 610:	00094863          	bltz	s2,620 <st7735_draw_circle+0xec>
 614:	fff40413          	addi	s0,s0,-1
 618:	408487b3          	sub	a5,s1,s0
 61c:	00179793          	slli	a5,a5,0x1
 620:	00178793          	addi	a5,a5,1
 624:	00f90933          	add	s2,s2,a5
 628:	f49ff06f          	j	570 <st7735_draw_circle+0x3c>
