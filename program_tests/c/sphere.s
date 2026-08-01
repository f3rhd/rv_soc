
__out_tmp.elf:     file format elf32-littleriscv


Disassembly of section .text:

00000000 <_start>:
   0:	00008137          	lui	sp,0x8
   4:	3c8000ef          	jal	3cc <main>

00000008 <halt_loop>:
   8:	0000006f          	j	8 <halt_loop>

0000000c <transform_vertex>:
   c:	05a70893          	addi	a7,a4,90
  10:	2208de63          	bgez	a7,24c <transform_vertex+0x240>
  14:	16888893          	addi	a7,a7,360
  18:	fe08cee3          	bltz	a7,14 <transform_vertex+0x8>
  1c:	0b400313          	li	t1,180
  20:	00100e93          	li	t4,1
  24:	01135663          	bge	t1,a7,30 <transform_vertex+0x24>
  28:	f4c88893          	addi	a7,a7,-180
  2c:	fff00e93          	li	t4,-1
  30:	0b400313          	li	t1,180
  34:	41130333          	sub	t1,t1,a7
  38:	03130333          	mul	t1,t1,a7
  3c:	000018b7          	lui	a7,0x1
  40:	fa088893          	addi	a7,a7,-96 # fa0 <st7735_draw_line+0x990>
  44:	0000ae37          	lui	t3,0xa
  48:	e34e0e13          	addi	t3,t3,-460 # 9e34 <st7735_draw_line+0x9824>
  4c:	031308b3          	mul	a7,t1,a7
  50:	406e0333          	sub	t1,t3,t1
  54:	0268c8b3          	div	a7,a7,t1
  58:	03d888b3          	mul	a7,a7,t4
  5c:	1c075e63          	bgez	a4,238 <transform_vertex+0x22c>
  60:	16870713          	addi	a4,a4,360
  64:	fe074ee3          	bltz	a4,60 <transform_vertex+0x54>
  68:	0b400313          	li	t1,180
  6c:	00100f93          	li	t6,1
  70:	00e35663          	bge	t1,a4,7c <transform_vertex+0x70>
  74:	f4c70713          	addi	a4,a4,-180
  78:	fff00f93          	li	t6,-1
  7c:	0b400e13          	li	t3,180
  80:	40ee0e33          	sub	t3,t3,a4
  84:	02ee0e33          	mul	t3,t3,a4
  88:	00001337          	lui	t1,0x1
  8c:	fa030313          	addi	t1,t1,-96 # fa0 <st7735_draw_line+0x990>
  90:	0000aeb7          	lui	t4,0xa
  94:	e34e8e93          	addi	t4,t4,-460 # 9e34 <st7735_draw_line+0x9824>
  98:	10625f37          	lui	t5,0x10625
  9c:	dd3f0f13          	addi	t5,t5,-557 # 10624dd3 <st7735_draw_line+0x106247c3>
  a0:	05a68713          	addi	a4,a3,90
  a4:	026e0333          	mul	t1,t3,t1
  a8:	41ce8e33          	sub	t3,t4,t3
  ac:	03c34333          	div	t1,t1,t3
  b0:	03f30333          	mul	t1,t1,t6
  b4:	03150e33          	mul	t3,a0,a7
  b8:	02660eb3          	mul	t4,a2,t1
  bc:	02650533          	mul	a0,a0,t1
  c0:	41de0333          	sub	t1,t3,t4
  c4:	41f35e13          	srai	t3,t1,0x1f
  c8:	03160633          	mul	a2,a2,a7
  cc:	00c50533          	add	a0,a0,a2
  d0:	03e31333          	mulh	t1,t1,t5
  d4:	41f55893          	srai	a7,a0,0x1f
  d8:	03e51633          	mulh	a2,a0,t5
  dc:	40635313          	srai	t1,t1,0x6
  e0:	41c30333          	sub	t1,t1,t3
  e4:	40665613          	srai	a2,a2,0x6
  e8:	41160633          	sub	a2,a2,a7
  ec:	12075c63          	bgez	a4,224 <transform_vertex+0x218>
  f0:	16870713          	addi	a4,a4,360
  f4:	fe074ee3          	bltz	a4,f0 <transform_vertex+0xe4>
  f8:	0b400513          	li	a0,180
  fc:	00100e13          	li	t3,1
 100:	00e55663          	bge	a0,a4,10c <transform_vertex+0x100>
 104:	f4c70713          	addi	a4,a4,-180
 108:	fff00e13          	li	t3,-1
 10c:	0b400513          	li	a0,180
 110:	40e50533          	sub	a0,a0,a4
 114:	02e50733          	mul	a4,a0,a4
 118:	00001537          	lui	a0,0x1
 11c:	fa050513          	addi	a0,a0,-96 # fa0 <st7735_draw_line+0x990>
 120:	0000a8b7          	lui	a7,0xa
 124:	e3488893          	addi	a7,a7,-460 # 9e34 <st7735_draw_line+0x9824>
 128:	02a70533          	mul	a0,a4,a0
 12c:	40e88733          	sub	a4,a7,a4
 130:	02e54533          	div	a0,a0,a4
 134:	03c50533          	mul	a0,a0,t3
 138:	0c06dc63          	bgez	a3,210 <transform_vertex+0x204>
 13c:	16868693          	addi	a3,a3,360
 140:	fe06cee3          	bltz	a3,13c <transform_vertex+0x130>
 144:	0b400713          	li	a4,180
 148:	00100f93          	li	t6,1
 14c:	00d75663          	bge	a4,a3,158 <transform_vertex+0x14c>
 150:	f4c68693          	addi	a3,a3,-180
 154:	fff00f93          	li	t6,-1
 158:	0b400e93          	li	t4,180
 15c:	40de8eb3          	sub	t4,t4,a3
 160:	02de8eb3          	mul	t4,t4,a3
 164:	000016b7          	lui	a3,0x1
 168:	fa068693          	addi	a3,a3,-96 # fa0 <st7735_draw_line+0x990>
 16c:	0000af37          	lui	t5,0xa
 170:	e34f0f13          	addi	t5,t5,-460 # 9e34 <st7735_draw_line+0x9824>
 174:	10625737          	lui	a4,0x10625
 178:	dd370713          	addi	a4,a4,-557 # 10624dd3 <st7735_draw_line+0x106247c3>
 17c:	00009e37          	lui	t3,0x9
 180:	600e0e13          	addi	t3,t3,1536 # 9600 <st7735_draw_line+0x8ff0>
 184:	02de86b3          	mul	a3,t4,a3
 188:	41df08b3          	sub	a7,t5,t4
 18c:	0316c6b3          	div	a3,a3,a7
 190:	03f686b3          	mul	a3,a3,t6
 194:	02a608b3          	mul	a7,a2,a0
 198:	02d58eb3          	mul	t4,a1,a3
 19c:	011e8eb3          	add	t4,t4,a7
 1a0:	02ee98b3          	mulh	a7,t4,a4
 1a4:	41fede93          	srai	t4,t4,0x1f
 1a8:	4068d893          	srai	a7,a7,0x6
 1ac:	41d888b3          	sub	a7,a7,t4
 1b0:	09688893          	addi	a7,a7,150
 1b4:	031e48b3          	div	a7,t3,a7
 1b8:	02d60633          	mul	a2,a2,a3
 1bc:	02a585b3          	mul	a1,a1,a0
 1c0:	40c585b3          	sub	a1,a1,a2
 1c4:	02e59733          	mulh	a4,a1,a4
 1c8:	41f5d593          	srai	a1,a1,0x1f
 1cc:	03130333          	mul	t1,t1,a7
 1d0:	40675713          	srai	a4,a4,0x6
 1d4:	40b70733          	sub	a4,a4,a1
 1d8:	03170733          	mul	a4,a4,a7
 1dc:	41f35693          	srai	a3,t1,0x1f
 1e0:	0ff6f693          	zext.b	a3,a3
 1e4:	006686b3          	add	a3,a3,t1
 1e8:	4086d693          	srai	a3,a3,0x8
 1ec:	04068693          	addi	a3,a3,64
 1f0:	00d7a023          	sw	a3,0(a5)
 1f4:	41f75793          	srai	a5,a4,0x1f
 1f8:	0ff7f793          	zext.b	a5,a5
 1fc:	00e787b3          	add	a5,a5,a4
 200:	4087d793          	srai	a5,a5,0x8
 204:	05078793          	addi	a5,a5,80
 208:	00f82023          	sw	a5,0(a6)
 20c:	00008067          	ret
 210:	16700713          	li	a4,359
 214:	f2d758e3          	bge	a4,a3,144 <transform_vertex+0x138>
 218:	e9868693          	addi	a3,a3,-360
 21c:	fed74ee3          	blt	a4,a3,218 <transform_vertex+0x20c>
 220:	f25ff06f          	j	144 <transform_vertex+0x138>
 224:	16700513          	li	a0,359
 228:	ece558e3          	bge	a0,a4,f8 <transform_vertex+0xec>
 22c:	e9870713          	addi	a4,a4,-360
 230:	fee54ee3          	blt	a0,a4,22c <transform_vertex+0x220>
 234:	ec5ff06f          	j	f8 <transform_vertex+0xec>
 238:	16700313          	li	t1,359
 23c:	e2e356e3          	bge	t1,a4,68 <transform_vertex+0x5c>
 240:	e9870713          	addi	a4,a4,-360
 244:	fee34ee3          	blt	t1,a4,240 <transform_vertex+0x234>
 248:	e21ff06f          	j	68 <transform_vertex+0x5c>
 24c:	16700313          	li	t1,359
 250:	dd1356e3          	bge	t1,a7,1c <transform_vertex+0x10>
 254:	e9888893          	addi	a7,a7,-360
 258:	ff134ee3          	blt	t1,a7,254 <transform_vertex+0x248>
 25c:	dc1ff06f          	j	1c <transform_vertex+0x10>

00000260 <sphere_point>:
 260:	05a50813          	addi	a6,a0,90
 264:	0b400793          	li	a5,180
 268:	410787b3          	sub	a5,a5,a6
 26c:	030787b3          	mul	a5,a5,a6
 270:	00001837          	lui	a6,0x1
 274:	fa080813          	addi	a6,a6,-96 # fa0 <st7735_draw_line+0x990>
 278:	0000a8b7          	lui	a7,0xa
 27c:	e3488893          	addi	a7,a7,-460 # 9e34 <st7735_draw_line+0x9824>
 280:	00100e93          	li	t4,1
 284:	03078833          	mul	a6,a5,a6
 288:	40f888b3          	sub	a7,a7,a5
 28c:	03184833          	div	a6,a6,a7
 290:	00055663          	bgez	a0,29c <sphere_point+0x3c>
 294:	0b450513          	addi	a0,a0,180
 298:	fff00e93          	li	t4,-1
 29c:	0b400f93          	li	t6,180
 2a0:	40af88b3          	sub	a7,t6,a0
 2a4:	000017b7          	lui	a5,0x1
 2a8:	fa078793          	addi	a5,a5,-96 # fa0 <st7735_draw_line+0x990>
 2ac:	0000a2b7          	lui	t0,0xa
 2b0:	e3428293          	addi	t0,t0,-460 # 9e34 <st7735_draw_line+0x9824>
 2b4:	05a58e13          	addi	t3,a1,90
 2b8:	16700f13          	li	t5,359
 2bc:	02a88533          	mul	a0,a7,a0
 2c0:	02f50333          	mul	t1,a0,a5
 2c4:	40a28533          	sub	a0,t0,a0
 2c8:	02a34533          	div	a0,t1,a0
 2cc:	03d50533          	mul	a0,a0,t4
 2d0:	0bcf5a63          	bge	t5,t3,384 <sphere_point+0x124>
 2d4:	ef258893          	addi	a7,a1,-270
 2d8:	411f8333          	sub	t1,t6,a7
 2dc:	03130333          	mul	t1,t1,a7
 2e0:	02f307b3          	mul	a5,t1,a5
 2e4:	40628333          	sub	t1,t0,t1
 2e8:	0267c7b3          	div	a5,a5,t1
 2ec:	f4c58593          	addi	a1,a1,-180
 2f0:	fff00f13          	li	t5,-1
 2f4:	0b400893          	li	a7,180
 2f8:	40b888b3          	sub	a7,a7,a1
 2fc:	0000a337          	lui	t1,0xa
 300:	e3430313          	addi	t1,t1,-460 # 9e34 <st7735_draw_line+0x9824>
 304:	02a00e93          	li	t4,42
 308:	10625e37          	lui	t3,0x10625
 30c:	dd3e0e13          	addi	t3,t3,-557 # 10624dd3 <st7735_draw_line+0x106247c3>
 310:	02b888b3          	mul	a7,a7,a1
 314:	000015b7          	lui	a1,0x1
 318:	fa058593          	addi	a1,a1,-96 # fa0 <st7735_draw_line+0x990>
 31c:	02b885b3          	mul	a1,a7,a1
 320:	411308b3          	sub	a7,t1,a7
 324:	0315c5b3          	div	a1,a1,a7
 328:	03d80833          	mul	a6,a6,t4
 32c:	03c83833          	mulhu	a6,a6,t3
 330:	03e585b3          	mul	a1,a1,t5
 334:	00685813          	srli	a6,a6,0x6
 338:	02f807b3          	mul	a5,a6,a5
 33c:	03d50533          	mul	a0,a0,t4
 340:	41f7d313          	srai	t1,a5,0x1f
 344:	030585b3          	mul	a1,a1,a6
 348:	41f55893          	srai	a7,a0,0x1f
 34c:	03c797b3          	mulh	a5,a5,t3
 350:	41f5d813          	srai	a6,a1,0x1f
 354:	03c51533          	mulh	a0,a0,t3
 358:	4067d793          	srai	a5,a5,0x6
 35c:	406787b3          	sub	a5,a5,t1
 360:	00f62023          	sw	a5,0(a2)
 364:	03c595b3          	mulh	a1,a1,t3
 368:	40655513          	srai	a0,a0,0x6
 36c:	41150533          	sub	a0,a0,a7
 370:	00a6a023          	sw	a0,0(a3)
 374:	4065d593          	srai	a1,a1,0x6
 378:	410585b3          	sub	a1,a1,a6
 37c:	00b72023          	sw	a1,0(a4)
 380:	00008067          	ret
 384:	03cfd663          	bge	t6,t3,3b0 <sphere_point+0x150>
 388:	fa658893          	addi	a7,a1,-90
 38c:	411f8e33          	sub	t3,t6,a7
 390:	031e0e33          	mul	t3,t3,a7
 394:	00100f13          	li	t5,1
 398:	02fe07b3          	mul	a5,t3,a5
 39c:	41c288b3          	sub	a7,t0,t3
 3a0:	0317c7b3          	div	a5,a5,a7
 3a4:	40f007b3          	neg	a5,a5
 3a8:	f4bfd6e3          	bge	t6,a1,2f4 <sphere_point+0x94>
 3ac:	f41ff06f          	j	2ec <sphere_point+0x8c>
 3b0:	41cf88b3          	sub	a7,t6,t3
 3b4:	03c888b3          	mul	a7,a7,t3
 3b8:	00100f13          	li	t5,1
 3bc:	02f887b3          	mul	a5,a7,a5
 3c0:	411288b3          	sub	a7,t0,a7
 3c4:	0317c7b3          	div	a5,a5,a7
 3c8:	f2dff06f          	j	2f4 <sphere_point+0x94>

000003cc <main>:
 3cc:	fa010113          	addi	sp,sp,-96 # 7fa0 <st7735_draw_line+0x7990>
 3d0:	04812c23          	sw	s0,88(sp)
 3d4:	04912a23          	sw	s1,84(sp)
 3d8:	05412423          	sw	s4,72(sp)
 3dc:	05512223          	sw	s5,68(sp)
 3e0:	04112e23          	sw	ra,92(sp)
 3e4:	05212823          	sw	s2,80(sp)
 3e8:	05312623          	sw	s3,76(sp)
 3ec:	05612023          	sw	s6,64(sp)
 3f0:	03712e23          	sw	s7,60(sp)
 3f4:	03812c23          	sw	s8,56(sp)
 3f8:	00000413          	li	s0,0
 3fc:	00000493          	li	s1,0
 400:	16800a93          	li	s5,360
 404:	06400a13          	li	s4,100
 408:	0a000713          	li	a4,160
 40c:	08000693          	li	a3,128
 410:	00000613          	li	a2,0
 414:	00000593          	li	a1,0
 418:	00000513          	li	a0,0
 41c:	178000ef          	jal	594 <st7735_draw_rectangle>
 420:	fb000993          	li	s3,-80
 424:	00000c13          	li	s8,0
 428:	00000b93          	li	s7,0
 42c:	00100b13          	li	s6,1
 430:	00000913          	li	s2,0
 434:	0180006f          	j	44c <main+0x80>
 438:	01490913          	addi	s2,s2,20
 43c:	09590063          	beq	s2,s5,4bc <main+0xf0>
 440:	00068b93          	mv	s7,a3
 444:	00070c13          	mv	s8,a4
 448:	00000b13          	li	s6,0
 44c:	02410713          	addi	a4,sp,36
 450:	02010693          	addi	a3,sp,32
 454:	01c10613          	addi	a2,sp,28
 458:	00090593          	mv	a1,s2
 45c:	00098513          	mv	a0,s3
 460:	e01ff0ef          	jal	260 <sphere_point>
 464:	02412603          	lw	a2,36(sp)
 468:	02012583          	lw	a1,32(sp)
 46c:	01c12503          	lw	a0,28(sp)
 470:	00040713          	mv	a4,s0
 474:	00048693          	mv	a3,s1
 478:	02c10813          	addi	a6,sp,44
 47c:	02810793          	addi	a5,sp,40
 480:	b8dff0ef          	jal	c <transform_vertex>
 484:	02812683          	lw	a3,40(sp)
 488:	02c12703          	lw	a4,44(sp)
 48c:	fa0b16e3          	bnez	s6,438 <main+0x6c>
 490:	ffe10537          	lui	a0,0xffe10
 494:	000c0613          	mv	a2,s8
 498:	000b8593          	mv	a1,s7
 49c:	fe050513          	addi	a0,a0,-32 # ffe0ffe0 <st7735_draw_line+0xffe0f9d0>
 4a0:	00e12623          	sw	a4,12(sp)
 4a4:	00d12423          	sw	a3,8(sp)
 4a8:	01490913          	addi	s2,s2,20
 4ac:	164000ef          	jal	610 <st7735_draw_line>
 4b0:	00812683          	lw	a3,8(sp)
 4b4:	00c12703          	lw	a4,12(sp)
 4b8:	f95914e3          	bne	s2,s5,440 <main+0x74>
 4bc:	01498993          	addi	s3,s3,20
 4c0:	f74992e3          	bne	s3,s4,424 <main+0x58>
 4c4:	00000993          	li	s3,0
 4c8:	00000c13          	li	s8,0
 4cc:	00000b93          	li	s7,0
 4d0:	00100b13          	li	s6,1
 4d4:	fb000913          	li	s2,-80
 4d8:	0180006f          	j	4f0 <main+0x124>
 4dc:	01490913          	addi	s2,s2,20
 4e0:	09490063          	beq	s2,s4,560 <main+0x194>
 4e4:	00068b93          	mv	s7,a3
 4e8:	00070c13          	mv	s8,a4
 4ec:	00000b13          	li	s6,0
 4f0:	02410713          	addi	a4,sp,36
 4f4:	02010693          	addi	a3,sp,32
 4f8:	01c10613          	addi	a2,sp,28
 4fc:	00098593          	mv	a1,s3
 500:	00090513          	mv	a0,s2
 504:	d5dff0ef          	jal	260 <sphere_point>
 508:	02412603          	lw	a2,36(sp)
 50c:	02012583          	lw	a1,32(sp)
 510:	01c12503          	lw	a0,28(sp)
 514:	00040713          	mv	a4,s0
 518:	00048693          	mv	a3,s1
 51c:	02c10813          	addi	a6,sp,44
 520:	02810793          	addi	a5,sp,40
 524:	ae9ff0ef          	jal	c <transform_vertex>
 528:	02812683          	lw	a3,40(sp)
 52c:	02c12703          	lw	a4,44(sp)
 530:	fa0b16e3          	bnez	s6,4dc <main+0x110>
 534:	07ff0537          	lui	a0,0x7ff0
 538:	000c0613          	mv	a2,s8
 53c:	000b8593          	mv	a1,s7
 540:	7ff50513          	addi	a0,a0,2047 # 7ff07ff <st7735_draw_line+0x7ff01ef>
 544:	00e12623          	sw	a4,12(sp)
 548:	00d12423          	sw	a3,8(sp)
 54c:	01490913          	addi	s2,s2,20
 550:	0c0000ef          	jal	610 <st7735_draw_line>
 554:	00812683          	lw	a3,8(sp)
 558:	00c12703          	lw	a4,12(sp)
 55c:	f94914e3          	bne	s2,s4,4e4 <main+0x118>
 560:	01498993          	addi	s3,s3,20
 564:	f75992e3          	bne	s3,s5,4c8 <main+0xfc>
 568:	00348713          	addi	a4,s1,3
 56c:	16700693          	li	a3,359
 570:	00240793          	addi	a5,s0,2
 574:	e9b48493          	addi	s1,s1,-357
 578:	00e6c463          	blt	a3,a4,580 <main+0x1b4>
 57c:	00070493          	mv	s1,a4
 580:	16700713          	li	a4,359
 584:	00f75463          	bge	a4,a5,58c <main+0x1c0>
 588:	e9a40793          	addi	a5,s0,-358
 58c:	00078413          	mv	s0,a5
 590:	e79ff06f          	j	408 <main+0x3c>

00000594 <st7735_draw_rectangle>:
 594:	00e60833          	add	a6,a2,a4
 598:	00d587b3          	add	a5,a1,a3
 59c:	fff80813          	addi	a6,a6,-1
 5a0:	00ff08b7          	lui	a7,0xff0
 5a4:	fff78793          	addi	a5,a5,-1
 5a8:	01061613          	slli	a2,a2,0x10
 5ac:	0ff87813          	zext.b	a6,a6
 5b0:	01167633          	and	a2,a2,a7
 5b4:	0ff7f793          	zext.b	a5,a5
 5b8:	01059593          	slli	a1,a1,0x10
 5bc:	00881813          	slli	a6,a6,0x8
 5c0:	0115f5b3          	and	a1,a1,a7
 5c4:	00c86833          	or	a6,a6,a2
 5c8:	00879793          	slli	a5,a5,0x8
 5cc:	2b000637          	lui	a2,0x2b000
 5d0:	00b7e7b3          	or	a5,a5,a1
 5d4:	00c86833          	or	a6,a6,a2
 5d8:	2a0005b7          	lui	a1,0x2a000
 5dc:	f0000637          	lui	a2,0xf0000
 5e0:	00b7e7b3          	or	a5,a5,a1
 5e4:	00460613          	addi	a2,a2,4 # f0000004 <st7735_draw_line+0xeffff9f4>
 5e8:	f00005b7          	lui	a1,0xf0000
 5ec:	00f62023          	sw	a5,0(a2)
 5f0:	01062023          	sw	a6,0(a2)
 5f4:	02e686b3          	mul	a3,a3,a4
 5f8:	2c0007b7          	lui	a5,0x2c000
 5fc:	4016d693          	srai	a3,a3,0x1
 600:	00f6e6b3          	or	a3,a3,a5
 604:	00d62023          	sw	a3,0(a2)
 608:	00a5a023          	sw	a0,0(a1) # f0000000 <st7735_draw_line+0xeffff9f0>
 60c:	00008067          	ret

00000610 <st7735_draw_line>:
 610:	40b68eb3          	sub	t4,a3,a1
 614:	fd010113          	addi	sp,sp,-48
 618:	41fed793          	srai	a5,t4,0x1f
 61c:	01512c23          	sw	s5,24(sp)
 620:	01612a23          	sw	s6,20(sp)
 624:	01712823          	sw	s7,16(sp)
 628:	00068a93          	mv	s5,a3
 62c:	01d7ceb3          	xor	t4,a5,t4
 630:	02812623          	sw	s0,44(sp)
 634:	02912423          	sw	s1,40(sp)
 638:	03212223          	sw	s2,36(sp)
 63c:	03312023          	sw	s3,32(sp)
 640:	01412e23          	sw	s4,28(sp)
 644:	01812623          	sw	s8,12(sp)
 648:	01912423          	sw	s9,8(sp)
 64c:	00050693          	mv	a3,a0
 650:	00070b13          	mv	s6,a4
 654:	40fe8eb3          	sub	t4,t4,a5
 658:	00100b93          	li	s7,1
 65c:	0155c463          	blt	a1,s5,664 <st7735_draw_line+0x54>
 660:	fff00b93          	li	s7,-1
 664:	40cb0433          	sub	s0,s6,a2
 668:	41f45793          	srai	a5,s0,0x1f
 66c:	0087c433          	xor	s0,a5,s0
 670:	40f40433          	sub	s0,s0,a5
 674:	40800a33          	neg	s4,s0
 678:	fff00c13          	li	s8,-1
 67c:	01665463          	bge	a2,s6,684 <st7735_draw_line+0x74>
 680:	00100c13          	li	s8,1
 684:	f0000337          	lui	t1,0xf0000
 688:	2c000737          	lui	a4,0x2c000
 68c:	00430313          	addi	t1,t1,4 # f0000004 <st7735_draw_line+0xeffff9f4>
 690:	00170713          	addi	a4,a4,1 # 2c000001 <st7735_draw_line+0x2bfff9f1>
 694:	408e88b3          	sub	a7,t4,s0
 698:	01059293          	slli	t0,a1,0x10
 69c:	00859f93          	slli	t6,a1,0x8
 6a0:	01061513          	slli	a0,a2,0x10
 6a4:	00861393          	slli	t2,a2,0x8
 6a8:	41558f33          	sub	t5,a1,s5
 6ac:	00ff0e37          	lui	t3,0xff0
 6b0:	2a0009b7          	lui	s3,0x2a000
 6b4:	2b000937          	lui	s2,0x2b000
 6b8:	f00004b7          	lui	s1,0xf0000
 6bc:	010f9813          	slli	a6,t6,0x10
 6c0:	01085813          	srli	a6,a6,0x10
 6c4:	01039c93          	slli	s9,t2,0x10
 6c8:	01c2f7b3          	and	a5,t0,t3
 6cc:	010cdc93          	srli	s9,s9,0x10
 6d0:	0107e7b3          	or	a5,a5,a6
 6d4:	01c57833          	and	a6,a0,t3
 6d8:	01986833          	or	a6,a6,s9
 6dc:	0137e7b3          	or	a5,a5,s3
 6e0:	01286833          	or	a6,a6,s2
 6e4:	00f32023          	sw	a5,0(t1)
 6e8:	01032023          	sw	a6,0(t1)
 6ec:	00e32023          	sw	a4,0(t1)
 6f0:	00d4a023          	sw	a3,0(s1) # f0000000 <st7735_draw_line+0xeffff9f0>
 6f4:	00189793          	slli	a5,a7,0x1
 6f8:	000f1463          	bnez	t5,700 <st7735_draw_line+0xf0>
 6fc:	03660a63          	beq	a2,s6,730 <st7735_draw_line+0x120>
 700:	0147ce63          	blt	a5,s4,71c <st7735_draw_line+0x10c>
 704:	017585b3          	add	a1,a1,s7
 708:	408888b3          	sub	a7,a7,s0
 70c:	01059293          	slli	t0,a1,0x10
 710:	00859f93          	slli	t6,a1,0x8
 714:	41558f33          	sub	t5,a1,s5
 718:	fafec2e3          	blt	t4,a5,6bc <st7735_draw_line+0xac>
 71c:	01860633          	add	a2,a2,s8
 720:	01d888b3          	add	a7,a7,t4
 724:	01061513          	slli	a0,a2,0x10
 728:	00861393          	slli	t2,a2,0x8
 72c:	f91ff06f          	j	6bc <st7735_draw_line+0xac>
 730:	02c12403          	lw	s0,44(sp)
 734:	02812483          	lw	s1,40(sp)
 738:	02412903          	lw	s2,36(sp)
 73c:	02012983          	lw	s3,32(sp)
 740:	01c12a03          	lw	s4,28(sp)
 744:	01812a83          	lw	s5,24(sp)
 748:	01412b03          	lw	s6,20(sp)
 74c:	01012b83          	lw	s7,16(sp)
 750:	00c12c03          	lw	s8,12(sp)
 754:	00812c83          	lw	s9,8(sp)
 758:	03010113          	addi	sp,sp,48
 75c:	00008067          	ret
