
__out_tmp.elf:     file format elf32-littleriscv


Disassembly of section .text:

00000000 <_start>:
   0:	00008137          	lui	sp,0x8
   4:	188000ef          	jal	18c <main>

00000008 <halt_loop>:
   8:	0000006f          	j	8 <halt_loop>

0000000c <delay>:
   c:	ff010113          	addi	sp,sp,-16 # 7ff0 <seg_write_hex+0x7c20>
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
  3c:	e6d70713          	addi	a4,a4,-403 # 41c64e6d <seg_write_hex+0x41c64a9d>
  40:	02e787b3          	mul	a5,a5,a4
  44:	00003737          	lui	a4,0x3
  48:	03970713          	addi	a4,a4,57 # 3039 <seg_write_hex+0x2c69>
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
  78:	2d00006f          	j	348 <st7735_draw_rectangle>

0000007c <count_neighbors>:
  7c:	00050893          	mv	a7,a0
  80:	fff00693          	li	a3,-1
  84:	00000513          	li	a0,0
  88:	02860613          	addi	a2,a2,40
  8c:	02800313          	li	t1,40
  90:	02058593          	addi	a1,a1,32
  94:	02000e13          	li	t3,32
  98:	00200e93          	li	t4,2
  9c:	00d60733          	add	a4,a2,a3
  a0:	02676733          	rem	a4,a4,t1
  a4:	fff00793          	li	a5,-1
  a8:	00571713          	slli	a4,a4,0x5
  ac:	00e88733          	add	a4,a7,a4
  b0:	00d7e833          	or	a6,a5,a3
  b4:	00081463          	bnez	a6,bc <count_neighbors+0x40>
  b8:	00100793          	li	a5,1
  bc:	00f58833          	add	a6,a1,a5
  c0:	03c86833          	rem	a6,a6,t3
  c4:	00178793          	addi	a5,a5,1
  c8:	01070833          	add	a6,a4,a6
  cc:	00084803          	lbu	a6,0(a6)
  d0:	01050533          	add	a0,a0,a6
  d4:	fdd79ee3          	bne	a5,t4,b0 <count_neighbors+0x34>
  d8:	00168693          	addi	a3,a3,1
  dc:	fcf690e3          	bne	a3,a5,9c <count_neighbors+0x20>
  e0:	00008067          	ret

000000e4 <seed_grid>:
  e4:	fe010113          	addi	sp,sp,-32
  e8:	00912a23          	sw	s1,20(sp)
  ec:	01312623          	sw	s3,12(sp)
  f0:	01412423          	sw	s4,8(sp)
  f4:	01512223          	sw	s5,4(sp)
  f8:	01612023          	sw	s6,0(sp)
  fc:	00112e23          	sw	ra,28(sp)
 100:	00812c23          	sw	s0,24(sp)
 104:	01212823          	sw	s2,16(sp)
 108:	00050a93          	mv	s5,a0
 10c:	00058b13          	mv	s6,a1
 110:	00000493          	li	s1,0
 114:	02000993          	li	s3,32
 118:	02800a13          	li	s4,40
 11c:	00549913          	slli	s2,s1,0x5
 120:	012a8933          	add	s2,s5,s2
 124:	00000413          	li	s0,0
 128:	000b0513          	mv	a0,s6
 12c:	f09ff0ef          	jal	34 <rand_next>
 130:	00157613          	andi	a2,a0,1
 134:	008907b3          	add	a5,s2,s0
 138:	00c78023          	sb	a2,0(a5)
 13c:	00060663          	beqz	a2,148 <seed_grid+0x64>
 140:	07e00637          	lui	a2,0x7e00
 144:	7e060613          	addi	a2,a2,2016 # 7e007e0 <seg_write_hex+0x7e00410>
 148:	00040513          	mv	a0,s0
 14c:	00048593          	mv	a1,s1
 150:	00140413          	addi	s0,s0,1
 154:	f0dff0ef          	jal	60 <draw_cell>
 158:	fd3418e3          	bne	s0,s3,128 <seed_grid+0x44>
 15c:	00148493          	addi	s1,s1,1
 160:	fb449ee3          	bne	s1,s4,11c <seed_grid+0x38>
 164:	01c12083          	lw	ra,28(sp)
 168:	01812403          	lw	s0,24(sp)
 16c:	01412483          	lw	s1,20(sp)
 170:	01012903          	lw	s2,16(sp)
 174:	00c12983          	lw	s3,12(sp)
 178:	00812a03          	lw	s4,8(sp)
 17c:	00412a83          	lw	s5,4(sp)
 180:	00012b03          	lw	s6,0(sp)
 184:	02010113          	addi	sp,sp,32
 188:	00008067          	ret

0000018c <main>:
 18c:	81010113          	addi	sp,sp,-2032
 190:	0000b7b7          	lui	a5,0xb
 194:	7e112623          	sw	ra,2028(sp)
 198:	7e812423          	sw	s0,2024(sp)
 19c:	7e912223          	sw	s1,2020(sp)
 1a0:	7d312e23          	sw	s3,2012(sp)
 1a4:	7d712623          	sw	s7,1996(sp)
 1a8:	7da12023          	sw	s10,1984(sp)
 1ac:	ce178793          	addi	a5,a5,-799 # ace1 <seg_write_hex+0xa911>
 1b0:	7f212023          	sw	s2,2016(sp)
 1b4:	7d412c23          	sw	s4,2008(sp)
 1b8:	7d512a23          	sw	s5,2004(sp)
 1bc:	7d612823          	sw	s6,2000(sp)
 1c0:	7d812423          	sw	s8,1992(sp)
 1c4:	7d912223          	sw	s9,1988(sp)
 1c8:	7bb12e23          	sw	s11,1980(sp)
 1cc:	0a000713          	li	a4,160
 1d0:	d9010113          	addi	sp,sp,-624
 1d4:	08000693          	li	a3,128
 1d8:	00000613          	li	a2,0
 1dc:	00000593          	li	a1,0
 1e0:	00000513          	li	a0,0
 1e4:	00f12e23          	sw	a5,28(sp)
 1e8:	02010413          	addi	s0,sp,32
 1ec:	15c000ef          	jal	348 <st7735_draw_rectangle>
 1f0:	01c10593          	addi	a1,sp,28
 1f4:	00040513          	mv	a0,s0
 1f8:	9e378bb7          	lui	s7,0x9e378
 1fc:	ee9ff0ef          	jal	e4 <seed_grid>
 200:	00000493          	li	s1,0
 204:	52010993          	addi	s3,sp,1312
 208:	9b1b8b93          	addi	s7,s7,-1615 # 9e3779b1 <seg_write_hex+0x9e3775e1>
 20c:	03100d13          	li	s10,49
 210:	00000a93          	li	s5,0
 214:	00000c93          	li	s9,0
 218:	005c9b13          	slli	s6,s9,0x5
 21c:	01640db3          	add	s11,s0,s6
 220:	00000c13          	li	s8,0
 224:	01698b33          	add	s6,s3,s6
 228:	000c8613          	mv	a2,s9
 22c:	000c0593          	mv	a1,s8
 230:	00040513          	mv	a0,s0
 234:	e49ff0ef          	jal	7c <count_neighbors>
 238:	018d87b3          	add	a5,s11,s8
 23c:	0007c603          	lbu	a2,0(a5)
 240:	0a060663          	beqz	a2,2ec <main+0x160>
 244:	ffe50793          	addi	a5,a0,-2
 248:	0027b793          	sltiu	a5,a5,2
 24c:	018b05b3          	add	a1,s6,s8
 250:	00f58023          	sb	a5,0(a1)
 254:	02c78463          	beq	a5,a2,27c <main+0xf0>
 258:	00000613          	li	a2,0
 25c:	00078663          	beqz	a5,268 <main+0xdc>
 260:	07e00637          	lui	a2,0x7e00
 264:	7e060613          	addi	a2,a2,2016 # 7e007e0 <seg_write_hex+0x7e00410>
 268:	000c8593          	mv	a1,s9
 26c:	000c0513          	mv	a0,s8
 270:	00f12623          	sw	a5,12(sp)
 274:	dedff0ef          	jal	60 <draw_cell>
 278:	00c12783          	lw	a5,12(sp)
 27c:	00fa8ab3          	add	s5,s5,a5
 280:	001c0c13          	addi	s8,s8,1
 284:	02000793          	li	a5,32
 288:	fafc10e3          	bne	s8,a5,228 <main+0x9c>
 28c:	001c8c93          	addi	s9,s9,1
 290:	02800793          	li	a5,40
 294:	f8fc92e3          	bne	s9,a5,218 <main+0x8c>
 298:	00148493          	addi	s1,s1,1
 29c:	00048513          	mv	a0,s1
 2a0:	130000ef          	jal	3d0 <seg_write_hex>
 2a4:	000a8513          	mv	a0,s5
 2a8:	118000ef          	jal	3c0 <led_write>
 2ac:	01c12783          	lw	a5,28(sp)
 2b0:	037787b3          	mul	a5,a5,s7
 2b4:	015d6e63          	bltu	s10,s5,2d0 <main+0x144>
 2b8:	00f487b3          	add	a5,s1,a5
 2bc:	01c10593          	addi	a1,sp,28
 2c0:	00098513          	mv	a0,s3
 2c4:	00f12e23          	sw	a5,28(sp)
 2c8:	00000493          	li	s1,0
 2cc:	e19ff0ef          	jal	e4 <seed_grid>
 2d0:	00014537          	lui	a0,0x14
 2d4:	88050513          	addi	a0,a0,-1920 # 13880 <seg_write_hex+0x134b0>
 2d8:	d35ff0ef          	jal	c <delay>
 2dc:	00040793          	mv	a5,s0
 2e0:	00098413          	mv	s0,s3
 2e4:	00078993          	mv	s3,a5
 2e8:	f29ff06f          	j	210 <main+0x84>
 2ec:	ffd50793          	addi	a5,a0,-3
 2f0:	0017b793          	seqz	a5,a5
 2f4:	f59ff06f          	j	24c <main+0xc0>

000002f8 <st7735_set_rectangle>:
 2f8:	00ff07b7          	lui	a5,0xff0
 2fc:	01059593          	slli	a1,a1,0x10
 300:	0ff6f693          	zext.b	a3,a3
 304:	00f5f5b3          	and	a1,a1,a5
 308:	00869693          	slli	a3,a3,0x8
 30c:	01051513          	slli	a0,a0,0x10
 310:	0ff67613          	zext.b	a2,a2
 314:	00f57533          	and	a0,a0,a5
 318:	00861613          	slli	a2,a2,0x8
 31c:	00d5e5b3          	or	a1,a1,a3
 320:	2b0007b7          	lui	a5,0x2b000
 324:	00c56533          	or	a0,a0,a2
 328:	2a000737          	lui	a4,0x2a000
 32c:	00f5e5b3          	or	a1,a1,a5
 330:	f00007b7          	lui	a5,0xf0000
 334:	00e56533          	or	a0,a0,a4
 338:	00278793          	addi	a5,a5,2 # f0000002 <seg_write_hex+0xeffffc32>
 33c:	00a7a023          	sw	a0,0(a5)
 340:	00b7a023          	sw	a1,0(a5)
 344:	00008067          	ret

00000348 <st7735_draw_rectangle>:
 348:	fe010113          	addi	sp,sp,-32
 34c:	00812c23          	sw	s0,24(sp)
 350:	00912a23          	sw	s1,20(sp)
 354:	00068413          	mv	s0,a3
 358:	00050493          	mv	s1,a0
 35c:	00058513          	mv	a0,a1
 360:	00e606b3          	add	a3,a2,a4
 364:	00060593          	mv	a1,a2
 368:	00850633          	add	a2,a0,s0
 36c:	fff68693          	addi	a3,a3,-1
 370:	fff60613          	addi	a2,a2,-1
 374:	00112e23          	sw	ra,28(sp)
 378:	00e12623          	sw	a4,12(sp)
 37c:	f7dff0ef          	jal	2f8 <st7735_set_rectangle>
 380:	00c12703          	lw	a4,12(sp)
 384:	2c0007b7          	lui	a5,0x2c000
 388:	02e40433          	mul	s0,s0,a4
 38c:	40145413          	srai	s0,s0,0x1
 390:	00f46433          	or	s0,s0,a5
 394:	f00007b7          	lui	a5,0xf0000
 398:	00278793          	addi	a5,a5,2 # f0000002 <seg_write_hex+0xeffffc32>
 39c:	0087a023          	sw	s0,0(a5)
 3a0:	f00007b7          	lui	a5,0xf0000
 3a4:	00178793          	addi	a5,a5,1 # f0000001 <seg_write_hex+0xeffffc31>
 3a8:	0097a023          	sw	s1,0(a5)
 3ac:	01c12083          	lw	ra,28(sp)
 3b0:	01812403          	lw	s0,24(sp)
 3b4:	01412483          	lw	s1,20(sp)
 3b8:	02010113          	addi	sp,sp,32
 3bc:	00008067          	ret

000003c0 <led_write>:
 3c0:	f00007b7          	lui	a5,0xf0000
 3c4:	00878793          	addi	a5,a5,8 # f0000008 <seg_write_hex+0xeffffc38>
 3c8:	00a79023          	sh	a0,0(a5)
 3cc:	00008067          	ret

000003d0 <seg_write_hex>:
 3d0:	f00007b7          	lui	a5,0xf0000
 3d4:	00478793          	addi	a5,a5,4 # f0000004 <seg_write_hex+0xeffffc34>
 3d8:	00a79023          	sh	a0,0(a5)
 3dc:	00008067          	ret
