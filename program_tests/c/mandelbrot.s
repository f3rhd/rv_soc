
__out_tmp.elf:     file format elf32-littleriscv


Disassembly of section .text:

00000000 <_start>:
   0:	00001197          	auipc	gp,0x1
   4:	82018193          	addi	gp,gp,-2016 # 820 <__global_pointer$>
   8:	00020117          	auipc	sp,0x20
   c:	ff810113          	addi	sp,sp,-8 # 20000 <__stack_top>
  10:	184000ef          	jal	194 <main>

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

00000040 <draw_cell>:
  40:	00060793          	mv	a5,a2
  44:	00200713          	li	a4,2
  48:	00159613          	slli	a2,a1,0x1
  4c:	00070693          	mv	a3,a4
  50:	00151593          	slli	a1,a0,0x1
  54:	00078513          	mv	a0,a5
  58:	4440006f          	j	49c <st7735_draw_rectangle>

0000005c <mandel_iter>:
  5c:	f0000753          	fmv.w.x	fa4,zero
  60:	f0058053          	fmv.w.x	ft0,a1
  64:	20e706d3          	fmv.s	fa3,fa4
  68:	20e70653          	fmv.s	fa2,fa4
  6c:	20e707d3          	fmv.s	fa5,fa4
  70:	02002587          	flw	fa1,32(zero) # 20 <delay+0x8>
  74:	f0050553          	fmv.w.x	fa0,a0
  78:	03c00793          	li	a5,60
  7c:	00000513          	li	a0,0
  80:	00150513          	addi	a0,a0,1
  84:	02f50463          	beq	a0,a5,ac <mandel_iter+0x50>
  88:	08e6f6d3          	fsub.s	fa3,fa3,fa4
  8c:	00f7f7d3          	fadd.s	fa5,fa5,fa5
  90:	00c7f643          	fmadd.s	fa2,fa5,fa2,ft0
  94:	00a6f7d3          	fadd.s	fa5,fa3,fa0
  98:	10c67753          	fmul.s	fa4,fa2,fa2
  9c:	10f7f6d3          	fmul.s	fa3,fa5,fa5
  a0:	00e6f0d3          	fadd.s	ft1,fa3,fa4
  a4:	a0159753          	flt.s	a4,fa1,ft1
  a8:	fc070ce3          	beqz	a4,80 <mandel_iter+0x24>
  ac:	00008067          	ret

000000b0 <render>:
  b0:	f0060753          	fmv.w.x	fa4,a2
  b4:	02402787          	flw	fa5,36(zero) # 24 <delay+0xc>
  b8:	fd010113          	addi	sp,sp,-48
  bc:	03212023          	sw	s2,32(sp)
  c0:	10f777d3          	fmul.s	fa5,fa4,fa5
  c4:	02912223          	sw	s1,36(sp)
  c8:	01312e23          	sw	s3,28(sp)
  cc:	01412c23          	sw	s4,24(sp)
  d0:	01512a23          	sw	s5,20(sp)
  d4:	02112623          	sw	ra,44(sp)
  d8:	02812423          	sw	s0,40(sp)
  dc:	00a12423          	sw	a0,8(sp)
  e0:	00b12623          	sw	a1,12(sp)
  e4:	00f12027          	fsw	fa5,0(sp)
  e8:	00000493          	li	s1,0
  ec:	02800993          	li	s3,40
  f0:	03c00a13          	li	s4,60
  f4:	00000913          	li	s2,0
  f8:	04000a93          	li	s5,64
  fc:	409987b3          	sub	a5,s3,s1
 100:	d007f7d3          	fcvt.s.w	fa5,a5
 104:	00012707          	flw	fa4,0(sp)
 108:	00c12687          	flw	fa3,12(sp)
 10c:	00000413          	li	s0,0
 110:	68e7f7c3          	fmadd.s	fa5,fa5,fa4,fa3
 114:	00f12227          	fsw	fa5,4(sp)
 118:	fe040793          	addi	a5,s0,-32
 11c:	d007f7d3          	fcvt.s.w	fa5,a5
 120:	00012707          	flw	fa4,0(sp)
 124:	00812687          	flw	fa3,8(sp)
 128:	00412583          	lw	a1,4(sp)
 12c:	68e7f7c3          	fmadd.s	fa5,fa5,fa4,fa3
 130:	e0078553          	fmv.x.w	a0,fa5
 134:	f29ff0ef          	jal	5c <mandel_iter>
 138:	00000613          	li	a2,0
 13c:	01450a63          	beq	a0,s4,150 <render+0xa0>
 140:	00757513          	andi	a0,a0,7
 144:	00251513          	slli	a0,a0,0x2
 148:	00a90533          	add	a0,s2,a0
 14c:	00052603          	lw	a2,0(a0)
 150:	00040513          	mv	a0,s0
 154:	00048593          	mv	a1,s1
 158:	00140413          	addi	s0,s0,1
 15c:	ee5ff0ef          	jal	40 <draw_cell>
 160:	fb541ce3          	bne	s0,s5,118 <render+0x68>
 164:	00148493          	addi	s1,s1,1
 168:	05000793          	li	a5,80
 16c:	f8f498e3          	bne	s1,a5,fc <render+0x4c>
 170:	02c12083          	lw	ra,44(sp)
 174:	02812403          	lw	s0,40(sp)
 178:	02412483          	lw	s1,36(sp)
 17c:	02012903          	lw	s2,32(sp)
 180:	01c12983          	lw	s3,28(sp)
 184:	01812a03          	lw	s4,24(sp)
 188:	01412a83          	lw	s5,20(sp)
 18c:	03010113          	addi	sp,sp,48
 190:	00008067          	ret

00000194 <main>:
 194:	fc010113          	addi	sp,sp,-64
 198:	00000593          	li	a1,0
 19c:	00800513          	li	a0,8
 1a0:	02112e23          	sw	ra,60(sp)
 1a4:	02912a23          	sw	s1,52(sp)
 1a8:	03212823          	sw	s2,48(sp)
 1ac:	03312623          	sw	s3,44(sp)
 1b0:	03412423          	sw	s4,40(sp)
 1b4:	03512223          	sw	s5,36(sp)
 1b8:	03612023          	sw	s6,32(sp)
 1bc:	01712e23          	sw	s7,28(sp)
 1c0:	01812c23          	sw	s8,24(sp)
 1c4:	02812c23          	sw	s0,56(sp)
 1c8:	01912a23          	sw	s9,20(sp)
 1cc:	01a12823          	sw	s10,16(sp)
 1d0:	368000ef          	jal	538 <set_pin_mode>
 1d4:	00000593          	li	a1,0
 1d8:	00900513          	li	a0,9
 1dc:	35c000ef          	jal	538 <set_pin_mode>
 1e0:	00000593          	li	a1,0
 1e4:	00a00513          	li	a0,10
 1e8:	350000ef          	jal	538 <set_pin_mode>
 1ec:	00000593          	li	a1,0
 1f0:	00b00513          	li	a0,11
 1f4:	344000ef          	jal	538 <set_pin_mode>
 1f8:	02802787          	flw	fa5,40(zero) # 28 <delay+0x10>
 1fc:	00f12227          	fsw	fa5,4(sp)
 200:	04f02c27          	fsw	fa5,88(zero) # 58 <view_cx.5>
 204:	02c02787          	flw	fa5,44(zero) # 2c <delay+0x14>
 208:	04f02827          	fsw	fa5,80(zero) # 50 <view_width.3>
 20c:	03002787          	flw	fa5,48(zero) # 30 <delay+0x18>
 210:	00f12427          	fsw	fa5,8(sp)
 214:	03802787          	flw	fa5,56(zero) # 38 <delay+0x20>
 218:	04002a23          	sw	zero,84(zero) # 54 <view_cy.4>
 21c:	00100c13          	li	s8,1
 220:	00000493          	li	s1,0
 224:	00000b93          	li	s7,0
 228:	00f12627          	fsw	fa5,12(sp)
 22c:	00800513          	li	a0,8
 230:	328000ef          	jal	558 <read_pin>
 234:	00050c93          	mv	s9,a0
 238:	00900513          	li	a0,9
 23c:	31c000ef          	jal	558 <read_pin>
 240:	00050413          	mv	s0,a0
 244:	00a00513          	li	a0,10
 248:	310000ef          	jal	558 <read_pin>
 24c:	00050d13          	mv	s10,a0
 250:	00b00513          	li	a0,11
 254:	304000ef          	jal	558 <read_pin>
 258:	01a037b3          	snez	a5,s10
 25c:	00a03533          	snez	a0,a0
 260:	00803333          	snez	t1,s0
 264:	00f575b3          	and	a1,a0,a5
 268:	100c8863          	beqz	s9,378 <main+0x1e4>
 26c:	10030663          	beqz	t1,378 <main+0x1e4>
 270:	10059a63          	bnez	a1,384 <main+0x1f0>
 274:	00000693          	li	a3,0
 278:	00100613          	li	a2,1
 27c:	0016c893          	xori	a7,a3,1
 280:	00b8f5b3          	and	a1,a7,a1
 284:	000b8663          	beqz	s7,290 <main+0xfc>
 288:	fffb8b93          	addi	s7,s7,-1
 28c:	080b9463          	bnez	s7,314 <main+0x180>
 290:	00d66833          	or	a6,a2,a3
 294:	008ce433          	or	s0,s9,s0
 298:	0015c713          	xori	a4,a1,1
 29c:	00f8f7b3          	and	a5,a7,a5
 2a0:	00184813          	xori	a6,a6,1
 2a4:	00803433          	snez	s0,s0
 2a8:	00f777b3          	and	a5,a4,a5
 2ac:	00887433          	and	s0,a6,s0
 2b0:	00a8f8b3          	and	a7,a7,a0
 2b4:	0087e433          	or	s0,a5,s0
 2b8:	01177733          	and	a4,a4,a7
 2bc:	00041463          	bnez	s0,2c4 <main+0x130>
 2c0:	04070a63          	beqz	a4,314 <main+0x180>
 2c4:	05002787          	flw	fa5,80(zero) # 50 <view_width.3>
 2c8:	00812707          	flw	fa4,8(sp)
 2cc:	01037333          	and	t1,t1,a6
 2d0:	10e7f7d3          	fmul.s	fa5,fa5,fa4
 2d4:	000c8a63          	beqz	s9,2e8 <main+0x154>
 2d8:	00080863          	beqz	a6,2e8 <main+0x154>
 2dc:	05402707          	flw	fa4,84(zero) # 54 <view_cy.4>
 2e0:	00f77753          	fadd.s	fa4,fa4,fa5
 2e4:	04e02a27          	fsw	fa4,84(zero) # 54 <view_cy.4>
 2e8:	00030863          	beqz	t1,2f8 <main+0x164>
 2ec:	05402707          	flw	fa4,84(zero) # 54 <view_cy.4>
 2f0:	08f77753          	fsub.s	fa4,fa4,fa5
 2f4:	04e02a27          	fsw	fa4,84(zero) # 54 <view_cy.4>
 2f8:	00078863          	beqz	a5,308 <main+0x174>
 2fc:	05802707          	flw	fa4,88(zero) # 58 <view_cx.5>
 300:	08f77753          	fsub.s	fa4,fa4,fa5
 304:	04e02c27          	fsw	fa4,88(zero) # 58 <view_cx.5>
 308:	08071263          	bnez	a4,38c <main+0x1f8>
 30c:	00100c13          	li	s8,1
 310:	00300b93          	li	s7,3
 314:	02060863          	beqz	a2,344 <main+0x1b0>
 318:	04c02703          	lw	a4,76(zero) # 4c <prev_zoom_in.2>
 31c:	02071463          	bnez	a4,344 <main+0x1b0>
 320:	03402707          	flw	fa4,52(zero) # 34 <delay+0x1c>
 324:	05002787          	flw	fa5,80(zero) # 50 <view_width.3>
 328:	10e7f7d3          	fmul.s	fa5,fa5,fa4
 32c:	00c12707          	flw	fa4,12(sp)
 330:	a0f71753          	flt.s	a4,fa4,fa5
 334:	00070863          	beqz	a4,344 <main+0x1b0>
 338:	04f02827          	fsw	fa5,80(zero) # 50 <view_width.3>
 33c:	00148493          	addi	s1,s1,1
 340:	00060c13          	mv	s8,a2
 344:	04c02623          	sw	a2,76(zero) # 4c <prev_zoom_in.2>
 348:	08058463          	beqz	a1,3d0 <main+0x23c>
 34c:	04802603          	lw	a2,72(zero) # 48 <prev_zoom_out.1>
 350:	04060663          	beqz	a2,39c <main+0x208>
 354:	00100613          	li	a2,1
 358:	04c02423          	sw	a2,72(zero) # 48 <prev_zoom_out.1>
 35c:	04d02223          	sw	a3,68(zero) # 44 <prev_reset.0>
 360:	0a0c1063          	bnez	s8,400 <main+0x26c>
 364:	00001537          	lui	a0,0x1
 368:	38850513          	addi	a0,a0,904 # 1388 <__static_reserve+0x388>
 36c:	cadff0ef          	jal	18 <delay>
 370:	00000c13          	li	s8,0
 374:	eb9ff06f          	j	22c <main+0x98>
 378:	00000693          	li	a3,0
 37c:	00000613          	li	a2,0
 380:	efdff06f          	j	27c <main+0xe8>
 384:	00100693          	li	a3,1
 388:	ff5ff06f          	j	37c <main+0x1e8>
 38c:	05802707          	flw	fa4,88(zero) # 58 <view_cx.5>
 390:	00f777d3          	fadd.s	fa5,fa4,fa5
 394:	04f02c27          	fsw	fa5,88(zero) # 58 <view_cx.5>
 398:	f75ff06f          	j	30c <main+0x178>
 39c:	03402707          	flw	fa4,52(zero) # 34 <delay+0x1c>
 3a0:	05002787          	flw	fa5,80(zero) # 50 <view_width.3>
 3a4:	18e7f7d3          	fdiv.s	fa5,fa5,fa4
 3a8:	03c02707          	flw	fa4,60(zero) # 3c <delay+0x24>
 3ac:	00100613          	li	a2,1
 3b0:	a0e795d3          	flt.s	a1,fa5,fa4
 3b4:	fa0582e3          	beqz	a1,358 <main+0x1c4>
 3b8:	009035b3          	snez	a1,s1
 3bc:	04f02827          	fsw	fa5,80(zero) # 50 <view_width.3>
 3c0:	40b484b3          	sub	s1,s1,a1
 3c4:	04c02423          	sw	a2,72(zero) # 48 <prev_zoom_out.1>
 3c8:	00060c13          	mv	s8,a2
 3cc:	f91ff06f          	j	35c <main+0x1c8>
 3d0:	04002423          	sw	zero,72(zero) # 48 <prev_zoom_out.1>
 3d4:	f80684e3          	beqz	a3,35c <main+0x1c8>
 3d8:	04402783          	lw	a5,68(zero) # 44 <prev_reset.0>
 3dc:	f80790e3          	bnez	a5,35c <main+0x1c8>
 3e0:	00412787          	flw	fa5,4(sp)
 3e4:	00100793          	li	a5,1
 3e8:	04002a23          	sw	zero,84(zero) # 54 <view_cy.4>
 3ec:	04f02c27          	fsw	fa5,88(zero) # 58 <view_cx.5>
 3f0:	02c02787          	flw	fa5,44(zero) # 2c <delay+0x14>
 3f4:	04f02223          	sw	a5,68(zero) # 44 <prev_reset.0>
 3f8:	00000493          	li	s1,0
 3fc:	04f02827          	fsw	fa5,80(zero) # 50 <view_width.3>
 400:	05002603          	lw	a2,80(zero) # 50 <view_width.3>
 404:	05402583          	lw	a1,84(zero) # 54 <view_cy.4>
 408:	05802503          	lw	a0,88(zero) # 58 <view_cx.5>
 40c:	ca5ff0ef          	jal	b0 <render>
 410:	00048513          	mv	a0,s1
 414:	114000ef          	jal	528 <seg_write_hex>
 418:	04002707          	flw	fa4,64(zero) # 40 <draw_cell>
 41c:	05802787          	flw	fa5,88(zero) # 58 <view_cx.5>
 420:	10e7f7d3          	fmul.s	fa5,fa5,fa4
 424:	c00797d3          	fcvt.w.s	a5,fa5,rtz
 428:	05402787          	flw	fa5,84(zero) # 54 <view_cy.4>
 42c:	0ff7f793          	zext.b	a5,a5
 430:	10e7f7d3          	fmul.s	fa5,fa5,fa4
 434:	00879793          	slli	a5,a5,0x8
 438:	c0079553          	fcvt.w.s	a0,fa5,rtz
 43c:	0ff57513          	zext.b	a0,a0
 440:	00a7e533          	or	a0,a5,a0
 444:	0d4000ef          	jal	518 <led_write>
 448:	f1dff06f          	j	364 <main+0x1d0>

0000044c <st7735_set_rectangle>:
 44c:	00ff07b7          	lui	a5,0xff0
 450:	01059593          	slli	a1,a1,0x10
 454:	0ff6f693          	zext.b	a3,a3
 458:	00f5f5b3          	and	a1,a1,a5
 45c:	00869693          	slli	a3,a3,0x8
 460:	01051513          	slli	a0,a0,0x10
 464:	0ff67613          	zext.b	a2,a2
 468:	00f57533          	and	a0,a0,a5
 46c:	00861613          	slli	a2,a2,0x8
 470:	00d5e5b3          	or	a1,a1,a3
 474:	2b0007b7          	lui	a5,0x2b000
 478:	00c56533          	or	a0,a0,a2
 47c:	2a000737          	lui	a4,0x2a000
 480:	00f5e5b3          	or	a1,a1,a5
 484:	f00007b7          	lui	a5,0xf0000
 488:	00e56533          	or	a0,a0,a4
 48c:	00278793          	addi	a5,a5,2 # f0000002 <__stack_top+0xeffe0002>
 490:	00a7a023          	sw	a0,0(a5)
 494:	00b7a023          	sw	a1,0(a5)
 498:	00008067          	ret

0000049c <st7735_draw_rectangle>:
 49c:	fe010113          	addi	sp,sp,-32
 4a0:	00812c23          	sw	s0,24(sp)
 4a4:	00912a23          	sw	s1,20(sp)
 4a8:	00068413          	mv	s0,a3
 4ac:	00050493          	mv	s1,a0
 4b0:	00058513          	mv	a0,a1
 4b4:	00e606b3          	add	a3,a2,a4
 4b8:	00060593          	mv	a1,a2
 4bc:	00850633          	add	a2,a0,s0
 4c0:	fff68693          	addi	a3,a3,-1
 4c4:	fff60613          	addi	a2,a2,-1
 4c8:	00112e23          	sw	ra,28(sp)
 4cc:	00e12623          	sw	a4,12(sp)
 4d0:	f7dff0ef          	jal	44c <st7735_set_rectangle>
 4d4:	00c12703          	lw	a4,12(sp)
 4d8:	2c0007b7          	lui	a5,0x2c000
 4dc:	02e40433          	mul	s0,s0,a4
 4e0:	00140413          	addi	s0,s0,1
 4e4:	40145413          	srai	s0,s0,0x1
 4e8:	00f46433          	or	s0,s0,a5
 4ec:	f00007b7          	lui	a5,0xf0000
 4f0:	00278793          	addi	a5,a5,2 # f0000002 <__stack_top+0xeffe0002>
 4f4:	0087a023          	sw	s0,0(a5)
 4f8:	f00007b7          	lui	a5,0xf0000
 4fc:	00178793          	addi	a5,a5,1 # f0000001 <__stack_top+0xeffe0001>
 500:	0097a023          	sw	s1,0(a5)
 504:	01c12083          	lw	ra,28(sp)
 508:	01812403          	lw	s0,24(sp)
 50c:	01412483          	lw	s1,20(sp)
 510:	02010113          	addi	sp,sp,32
 514:	00008067          	ret

00000518 <led_write>:
 518:	f00007b7          	lui	a5,0xf0000
 51c:	00878793          	addi	a5,a5,8 # f0000008 <__stack_top+0xeffe0008>
 520:	00a79023          	sh	a0,0(a5)
 524:	00008067          	ret

00000528 <seg_write_hex>:
 528:	f00007b7          	lui	a5,0xf0000
 52c:	00478793          	addi	a5,a5,4 # f0000004 <__stack_top+0xeffe0004>
 530:	00a79023          	sh	a0,0(a5)
 534:	00008067          	ret

00000538 <set_pin_mode>:
 538:	00151513          	slli	a0,a0,0x1
 53c:	0015f593          	andi	a1,a1,1
 540:	03e57513          	andi	a0,a0,62
 544:	f00007b7          	lui	a5,0xf0000
 548:	00b56533          	or	a0,a0,a1
 54c:	01078793          	addi	a5,a5,16 # f0000010 <__stack_top+0xeffe0010>
 550:	00a7a023          	sw	a0,0(a5)
 554:	00008067          	ret

00000558 <read_pin>:
 558:	01f57513          	andi	a0,a0,31
 55c:	f00007b7          	lui	a5,0xf0000
 560:	04078793          	addi	a5,a5,64 # f0000040 <__stack_top+0xeffe0040>
 564:	00851513          	slli	a0,a0,0x8
 568:	00f56533          	or	a0,a0,a5
 56c:	00052503          	lw	a0,0(a0)
 570:	00157513          	andi	a0,a0,1
 574:	00008067          	ret
