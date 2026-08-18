
__out_tmp.elf:     file format elf32-littleriscv


Disassembly of section .text:

00000000 <__static_end>:
   0:	00001197          	auipc	gp,0x1
   4:	80018193          	addi	gp,gp,-2048 # 800 <__global_pointer$>
   8:	00020117          	auipc	sp,0x20
   c:	ff810113          	addi	sp,sp,-8 # 20000 <__stack_top>
  10:	188000ef          	jal	198 <main>

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
  84:	2f00006f          	j	374 <st7735_draw_rectangle>

00000088 <count_neighbors>:
  88:	00050893          	mv	a7,a0
  8c:	fff00693          	li	a3,-1
  90:	00000513          	li	a0,0
  94:	02860613          	addi	a2,a2,40
  98:	02800313          	li	t1,40
  9c:	02058593          	addi	a1,a1,32
  a0:	02000e13          	li	t3,32
  a4:	00200e93          	li	t4,2
  a8:	00d60733          	add	a4,a2,a3
  ac:	02676733          	rem	a4,a4,t1
  b0:	fff00793          	li	a5,-1
  b4:	00571713          	slli	a4,a4,0x5
  b8:	00e88733          	add	a4,a7,a4
  bc:	00d7e833          	or	a6,a5,a3
  c0:	00081463          	bnez	a6,c8 <count_neighbors+0x40>
  c4:	00100793          	li	a5,1
  c8:	00f58833          	add	a6,a1,a5
  cc:	03c86833          	rem	a6,a6,t3
  d0:	00178793          	addi	a5,a5,1
  d4:	01070833          	add	a6,a4,a6
  d8:	00084803          	lbu	a6,0(a6)
  dc:	01050533          	add	a0,a0,a6
  e0:	fdd79ee3          	bne	a5,t4,bc <count_neighbors+0x34>
  e4:	00168693          	addi	a3,a3,1
  e8:	fcf690e3          	bne	a3,a5,a8 <count_neighbors+0x20>
  ec:	00008067          	ret

000000f0 <seed_grid>:
  f0:	fe010113          	addi	sp,sp,-32
  f4:	00912a23          	sw	s1,20(sp)
  f8:	01312623          	sw	s3,12(sp)
  fc:	01412423          	sw	s4,8(sp)
 100:	01512223          	sw	s5,4(sp)
 104:	01612023          	sw	s6,0(sp)
 108:	00112e23          	sw	ra,28(sp)
 10c:	00812c23          	sw	s0,24(sp)
 110:	01212823          	sw	s2,16(sp)
 114:	00050a93          	mv	s5,a0
 118:	00058b13          	mv	s6,a1
 11c:	00000493          	li	s1,0
 120:	02000993          	li	s3,32
 124:	02800a13          	li	s4,40
 128:	00549913          	slli	s2,s1,0x5
 12c:	012a8933          	add	s2,s5,s2
 130:	00000413          	li	s0,0
 134:	000b0513          	mv	a0,s6
 138:	f09ff0ef          	jal	40 <rand_next>
 13c:	00157613          	andi	a2,a0,1
 140:	008907b3          	add	a5,s2,s0
 144:	00c78023          	sb	a2,0(a5)
 148:	00060663          	beqz	a2,154 <seed_grid+0x64>
 14c:	07e00637          	lui	a2,0x7e00
 150:	7e060613          	addi	a2,a2,2016 # 7e007e0 <__stack_top+0x7de07e0>
 154:	00040513          	mv	a0,s0
 158:	00048593          	mv	a1,s1
 15c:	00140413          	addi	s0,s0,1
 160:	f0dff0ef          	jal	6c <draw_cell>
 164:	fd3418e3          	bne	s0,s3,134 <seed_grid+0x44>
 168:	00148493          	addi	s1,s1,1
 16c:	fb449ee3          	bne	s1,s4,128 <seed_grid+0x38>
 170:	01c12083          	lw	ra,28(sp)
 174:	01812403          	lw	s0,24(sp)
 178:	01412483          	lw	s1,20(sp)
 17c:	01012903          	lw	s2,16(sp)
 180:	00c12983          	lw	s3,12(sp)
 184:	00812a03          	lw	s4,8(sp)
 188:	00412a83          	lw	s5,4(sp)
 18c:	00012b03          	lw	s6,0(sp)
 190:	02010113          	addi	sp,sp,32
 194:	00008067          	ret

00000198 <main>:
 198:	81010113          	addi	sp,sp,-2032
 19c:	0000b7b7          	lui	a5,0xb
 1a0:	7e112623          	sw	ra,2028(sp)
 1a4:	7e812423          	sw	s0,2024(sp)
 1a8:	7e912223          	sw	s1,2020(sp)
 1ac:	7d312e23          	sw	s3,2012(sp)
 1b0:	7d712623          	sw	s7,1996(sp)
 1b4:	7da12023          	sw	s10,1984(sp)
 1b8:	ce178793          	addi	a5,a5,-799 # ace1 <__static_reserve+0x9ce1>
 1bc:	7f212023          	sw	s2,2016(sp)
 1c0:	7d412c23          	sw	s4,2008(sp)
 1c4:	7d512a23          	sw	s5,2004(sp)
 1c8:	7d612823          	sw	s6,2000(sp)
 1cc:	7d812423          	sw	s8,1992(sp)
 1d0:	7d912223          	sw	s9,1988(sp)
 1d4:	7bb12e23          	sw	s11,1980(sp)
 1d8:	0a000713          	li	a4,160
 1dc:	d9010113          	addi	sp,sp,-624
 1e0:	08000693          	li	a3,128
 1e4:	00000613          	li	a2,0
 1e8:	00000593          	li	a1,0
 1ec:	00000513          	li	a0,0
 1f0:	00f12e23          	sw	a5,28(sp)
 1f4:	02010413          	addi	s0,sp,32
 1f8:	17c000ef          	jal	374 <st7735_draw_rectangle>
 1fc:	01c10593          	addi	a1,sp,28
 200:	00040513          	mv	a0,s0
 204:	9e378bb7          	lui	s7,0x9e378
 208:	ee9ff0ef          	jal	f0 <seed_grid>
 20c:	00000493          	li	s1,0
 210:	52010993          	addi	s3,sp,1312
 214:	9b1b8b93          	addi	s7,s7,-1615 # 9e3779b1 <__stack_top+0x9e3579b1>
 218:	03100d13          	li	s10,49
 21c:	00000a93          	li	s5,0
 220:	00000c93          	li	s9,0
 224:	005c9b13          	slli	s6,s9,0x5
 228:	01640db3          	add	s11,s0,s6
 22c:	00000c13          	li	s8,0
 230:	01698b33          	add	s6,s3,s6
 234:	000c8613          	mv	a2,s9
 238:	000c0593          	mv	a1,s8
 23c:	00040513          	mv	a0,s0
 240:	e49ff0ef          	jal	88 <count_neighbors>
 244:	018d87b3          	add	a5,s11,s8
 248:	0007c603          	lbu	a2,0(a5)
 24c:	0a060663          	beqz	a2,2f8 <main+0x160>
 250:	ffe50793          	addi	a5,a0,-2
 254:	0027b793          	sltiu	a5,a5,2
 258:	018b05b3          	add	a1,s6,s8
 25c:	00f58023          	sb	a5,0(a1)
 260:	02c78463          	beq	a5,a2,288 <main+0xf0>
 264:	00000613          	li	a2,0
 268:	00078663          	beqz	a5,274 <main+0xdc>
 26c:	07e00637          	lui	a2,0x7e00
 270:	7e060613          	addi	a2,a2,2016 # 7e007e0 <__stack_top+0x7de07e0>
 274:	000c8593          	mv	a1,s9
 278:	000c0513          	mv	a0,s8
 27c:	00f12623          	sw	a5,12(sp)
 280:	dedff0ef          	jal	6c <draw_cell>
 284:	00c12783          	lw	a5,12(sp)
 288:	00fa8ab3          	add	s5,s5,a5
 28c:	001c0c13          	addi	s8,s8,1
 290:	02000793          	li	a5,32
 294:	fafc10e3          	bne	s8,a5,234 <main+0x9c>
 298:	001c8c93          	addi	s9,s9,1
 29c:	02800793          	li	a5,40
 2a0:	f8fc92e3          	bne	s9,a5,224 <main+0x8c>
 2a4:	00148493          	addi	s1,s1,1
 2a8:	00048513          	mv	a0,s1
 2ac:	068000ef          	jal	314 <seg_write_hex>
 2b0:	000a8513          	mv	a0,s5
 2b4:	050000ef          	jal	304 <led_write>
 2b8:	01c12783          	lw	a5,28(sp)
 2bc:	037787b3          	mul	a5,a5,s7
 2c0:	015d6e63          	bltu	s10,s5,2dc <main+0x144>
 2c4:	00f487b3          	add	a5,s1,a5
 2c8:	01c10593          	addi	a1,sp,28
 2cc:	00098513          	mv	a0,s3
 2d0:	00f12e23          	sw	a5,28(sp)
 2d4:	00000493          	li	s1,0
 2d8:	e19ff0ef          	jal	f0 <seed_grid>
 2dc:	00014537          	lui	a0,0x14
 2e0:	88050513          	addi	a0,a0,-1920 # 13880 <__static_reserve+0x12880>
 2e4:	d35ff0ef          	jal	18 <delay>
 2e8:	00040793          	mv	a5,s0
 2ec:	00098413          	mv	s0,s3
 2f0:	00078993          	mv	s3,a5
 2f4:	f29ff06f          	j	21c <main+0x84>
 2f8:	ffd50793          	addi	a5,a0,-3
 2fc:	0017b793          	seqz	a5,a5
 300:	f59ff06f          	j	258 <main+0xc0>

00000304 <led_write>:
 304:	f00007b7          	lui	a5,0xf0000
 308:	00878793          	addi	a5,a5,8 # f0000008 <__stack_top+0xeffe0008>
 30c:	00a79023          	sh	a0,0(a5)
 310:	00008067          	ret

00000314 <seg_write_hex>:
 314:	f00007b7          	lui	a5,0xf0000
 318:	00478793          	addi	a5,a5,4 # f0000004 <__stack_top+0xeffe0004>
 31c:	00a79023          	sh	a0,0(a5)
 320:	00008067          	ret

00000324 <st7735_set_rectangle>:
 324:	00ff07b7          	lui	a5,0xff0
 328:	01059593          	slli	a1,a1,0x10
 32c:	0ff6f693          	zext.b	a3,a3
 330:	00f5f5b3          	and	a1,a1,a5
 334:	00869693          	slli	a3,a3,0x8
 338:	01051513          	slli	a0,a0,0x10
 33c:	0ff67613          	zext.b	a2,a2
 340:	00f57533          	and	a0,a0,a5
 344:	00861613          	slli	a2,a2,0x8
 348:	00d5e5b3          	or	a1,a1,a3
 34c:	2b0007b7          	lui	a5,0x2b000
 350:	00c56533          	or	a0,a0,a2
 354:	2a000737          	lui	a4,0x2a000
 358:	00f5e5b3          	or	a1,a1,a5
 35c:	f00007b7          	lui	a5,0xf0000
 360:	00e56533          	or	a0,a0,a4
 364:	00278793          	addi	a5,a5,2 # f0000002 <__stack_top+0xeffe0002>
 368:	00a7a023          	sw	a0,0(a5)
 36c:	00b7a023          	sw	a1,0(a5)
 370:	00008067          	ret

00000374 <st7735_draw_rectangle>:
 374:	fe010113          	addi	sp,sp,-32
 378:	00812c23          	sw	s0,24(sp)
 37c:	00912a23          	sw	s1,20(sp)
 380:	00068413          	mv	s0,a3
 384:	00050493          	mv	s1,a0
 388:	00058513          	mv	a0,a1
 38c:	00e606b3          	add	a3,a2,a4
 390:	00060593          	mv	a1,a2
 394:	00850633          	add	a2,a0,s0
 398:	fff68693          	addi	a3,a3,-1
 39c:	fff60613          	addi	a2,a2,-1
 3a0:	00112e23          	sw	ra,28(sp)
 3a4:	00e12623          	sw	a4,12(sp)
 3a8:	f7dff0ef          	jal	324 <st7735_set_rectangle>
 3ac:	00c12703          	lw	a4,12(sp)
 3b0:	2c0007b7          	lui	a5,0x2c000
 3b4:	02e40433          	mul	s0,s0,a4
 3b8:	40145413          	srai	s0,s0,0x1
 3bc:	00f46433          	or	s0,s0,a5
 3c0:	f00007b7          	lui	a5,0xf0000
 3c4:	00278793          	addi	a5,a5,2 # f0000002 <__stack_top+0xeffe0002>
 3c8:	0087a023          	sw	s0,0(a5)
 3cc:	f00007b7          	lui	a5,0xf0000
 3d0:	00178793          	addi	a5,a5,1 # f0000001 <__stack_top+0xeffe0001>
 3d4:	0097a023          	sw	s1,0(a5)
 3d8:	01c12083          	lw	ra,28(sp)
 3dc:	01812403          	lw	s0,24(sp)
 3e0:	01412483          	lw	s1,20(sp)
 3e4:	02010113          	addi	sp,sp,32
 3e8:	00008067          	ret
