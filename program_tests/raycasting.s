
__out_tmp.elf:     file format elf32-littleriscv


Disassembly of section .text:

00000000 <_start>:
   0:	00001197          	auipc	gp,0x1
   4:	8c018193          	addi	gp,gp,-1856 # 8c0 <__global_pointer$>
   8:	00020117          	auipc	sp,0x20
   c:	ff810113          	addi	sp,sp,-8 # 20000 <__stack_top>
  10:	580000ef          	jal	590 <main>

00000014 <halt_loop>:
  14:	0000006f          	j	14 <halt_loop>

00000018 <wrap_angle>:
  18:	0c402707          	flw	fa4,196(zero) # c4 <my_cosf+0x1c>
  1c:	f00507d3          	fmv.w.x	fa5,a0
  20:	0c002687          	flw	fa3,192(zero) # c0 <my_cosf+0x18>
  24:	a0f717d3          	flt.s	a5,fa4,fa5
  28:	00079e63          	bnez	a5,44 <wrap_angle+0x2c>
  2c:	0c802707          	flw	fa4,200(zero) # c8 <my_cosf+0x20>
  30:	0c002687          	flw	fa3,192(zero) # c0 <my_cosf+0x18>
  34:	a0e797d3          	flt.s	a5,fa5,fa4
  38:	00079a63          	bnez	a5,4c <wrap_angle+0x34>
  3c:	e0078553          	fmv.x.w	a0,fa5
  40:	00008067          	ret
  44:	08d7f7d3          	fsub.s	fa5,fa5,fa3
  48:	fddff06f          	j	24 <wrap_angle+0xc>
  4c:	00d7f7d3          	fadd.s	fa5,fa5,fa3
  50:	fe5ff06f          	j	34 <wrap_angle+0x1c>

00000054 <my_sinf>:
  54:	ff010113          	addi	sp,sp,-16
  58:	00112623          	sw	ra,12(sp)
  5c:	fbdff0ef          	jal	18 <wrap_angle>
  60:	f00507d3          	fmv.w.x	fa5,a0
  64:	0cc02587          	flw	fa1,204(zero) # cc <my_cosf+0x24>
  68:	10f7f753          	fmul.s	fa4,fa5,fa5
  6c:	00c12083          	lw	ra,12(sp)
  70:	10e7f6d3          	fmul.s	fa3,fa5,fa4
  74:	10d77653          	fmul.s	fa2,fa4,fa3
  78:	18b6f6d3          	fdiv.s	fa3,fa3,fa1
  7c:	10c77753          	fmul.s	fa4,fa4,fa2
  80:	08d7f7d3          	fsub.s	fa5,fa5,fa3
  84:	0d002687          	flw	fa3,208(zero) # d0 <my_cosf+0x28>
  88:	18d676d3          	fdiv.s	fa3,fa2,fa3
  8c:	00d7f7d3          	fadd.s	fa5,fa5,fa3
  90:	0d402687          	flw	fa3,212(zero) # d4 <my_cosf+0x2c>
  94:	01010113          	addi	sp,sp,16
  98:	18d77753          	fdiv.s	fa4,fa4,fa3
  9c:	08e7f7d3          	fsub.s	fa5,fa5,fa4
  a0:	e0078553          	fmv.x.w	a0,fa5
  a4:	00008067          	ret

000000a8 <my_cosf>:
  a8:	ff010113          	addi	sp,sp,-16
  ac:	00112623          	sw	ra,12(sp)
  b0:	f69ff0ef          	jal	18 <wrap_angle>
  b4:	f00507d3          	fmv.w.x	fa5,a0
  b8:	0d802607          	flw	fa2,216(zero) # d8 <my_cosf+0x30>
  bc:	10f7f7d3          	fmul.s	fa5,fa5,fa5
  c0:	0dc02587          	flw	fa1,220(zero) # dc <my_cosf+0x34>
  c4:	00c12083          	lw	ra,12(sp)
  c8:	10f7f753          	fmul.s	fa4,fa5,fa5
  cc:	10e7f6d3          	fmul.s	fa3,fa5,fa4
  d0:	18c77753          	fdiv.s	fa4,fa4,fa2
  d4:	0e002607          	flw	fa2,224(zero) # e0 <my_cosf+0x38>
  d8:	60b7f7cb          	fnmsub.s	fa5,fa5,fa1,fa2
  dc:	00f77753          	fadd.s	fa4,fa4,fa5
  e0:	0e402787          	flw	fa5,228(zero) # e4 <my_cosf+0x3c>
  e4:	01010113          	addi	sp,sp,16
  e8:	18f6f7d3          	fdiv.s	fa5,fa3,fa5
  ec:	08f777d3          	fsub.s	fa5,fa4,fa5
  f0:	e0078553          	fmv.x.w	a0,fa5
  f4:	00008067          	ret

000000f8 <map_is_wall>:
  f8:	00c53793          	sltiu	a5,a0,12
  fc:	02078663          	beqz	a5,128 <g_dir_y>
 100:	00c5b793          	sltiu	a5,a1,12
 104:	02078263          	beqz	a5,128 <g_dir_y>
 108:	00c00713          	li	a4,12
 10c:	02e585b3          	mul	a1,a1,a4
 110:	01800793          	li	a5,24
 114:	00b787b3          	add	a5,a5,a1
 118:	00a787b3          	add	a5,a5,a0
 11c:	0007c503          	lbu	a0,0(a5)
 120:	00a03533          	snez	a0,a0
 124:	00008067          	ret
 128:	00100513          	li	a0,1
 12c:	00008067          	ret

00000130 <would_collide>:
 130:	f0050753          	fmv.w.x	fa4,a0
 134:	0e802787          	flw	fa5,232(zero) # e8 <my_cosf+0x40>
 138:	fe010113          	addi	sp,sp,-32
 13c:	00b12223          	sw	a1,4(sp)
 140:	08f776d3          	fsub.s	fa3,fa4,fa5
 144:	f0058753          	fmv.w.x	fa4,a1
 148:	00a12623          	sw	a0,12(sp)
 14c:	00812c23          	sw	s0,24(sp)
 150:	00112e23          	sw	ra,28(sp)
 154:	c00697d3          	fcvt.w.s	a5,fa3,rtz
 158:	08f776d3          	fsub.s	fa3,fa4,fa5
 15c:	00912a23          	sw	s1,20(sp)
 160:	00078513          	mv	a0,a5
 164:	01212823          	sw	s2,16(sp)
 168:	00078413          	mv	s0,a5
 16c:	c00695d3          	fcvt.w.s	a1,fa3,rtz
 170:	00b12423          	sw	a1,8(sp)
 174:	f85ff0ef          	jal	f8 <map_is_wall>
 178:	06051463          	bnez	a0,1e0 <__static_end+0xa8>
 17c:	0e802787          	flw	fa5,232(zero) # e8 <my_cosf+0x40>
 180:	00c12707          	flw	fa4,12(sp)
 184:	00812583          	lw	a1,8(sp)
 188:	00f77753          	fadd.s	fa4,fa4,fa5
 18c:	c00717d3          	fcvt.w.s	a5,fa4,rtz
 190:	00078513          	mv	a0,a5
 194:	00078493          	mv	s1,a5
 198:	f61ff0ef          	jal	f8 <map_is_wall>
 19c:	04051263          	bnez	a0,1e0 <__static_end+0xa8>
 1a0:	00412707          	flw	fa4,4(sp)
 1a4:	0e802787          	flw	fa5,232(zero) # e8 <my_cosf+0x40>
 1a8:	00040513          	mv	a0,s0
 1ac:	00f777d3          	fadd.s	fa5,fa4,fa5
 1b0:	c00795d3          	fcvt.w.s	a1,fa5,rtz
 1b4:	00b12223          	sw	a1,4(sp)
 1b8:	f41ff0ef          	jal	f8 <map_is_wall>
 1bc:	02051263          	bnez	a0,1e0 <__static_end+0xa8>
 1c0:	01812403          	lw	s0,24(sp)
 1c4:	00412583          	lw	a1,4(sp)
 1c8:	01c12083          	lw	ra,28(sp)
 1cc:	01012903          	lw	s2,16(sp)
 1d0:	00048513          	mv	a0,s1
 1d4:	01412483          	lw	s1,20(sp)
 1d8:	02010113          	addi	sp,sp,32
 1dc:	f1dff06f          	j	f8 <map_is_wall>
 1e0:	01c12083          	lw	ra,28(sp)
 1e4:	01812403          	lw	s0,24(sp)
 1e8:	01412483          	lw	s1,20(sp)
 1ec:	01012903          	lw	s2,16(sp)
 1f0:	02010113          	addi	sp,sp,32
 1f4:	00008067          	ret

000001f8 <recompute_direction_vectors>:
 1f8:	11c02787          	flw	fa5,284(zero) # 11c <g_angle>
 1fc:	fe010113          	addi	sp,sp,-32
 200:	00112e23          	sw	ra,28(sp)
 204:	e0078553          	fmv.x.w	a0,fa5
 208:	00f12427          	fsw	fa5,8(sp)
 20c:	e9dff0ef          	jal	a8 <my_cosf>
 210:	12a02623          	sw	a0,300(zero) # 12c <g_dir_x>
 214:	00a12623          	sw	a0,12(sp)
 218:	00812503          	lw	a0,8(sp)
 21c:	e39ff0ef          	jal	54 <my_sinf>
 220:	f00507d3          	fmv.w.x	fa5,a0
 224:	12a02423          	sw	a0,296(zero) # 128 <g_dir_y>
 228:	0ec02687          	flw	fa3,236(zero) # ec <my_cosf+0x44>
 22c:	20f797d3          	fneg.s	fa5,fa5
 230:	00c12707          	flw	fa4,12(sp)
 234:	01c12083          	lw	ra,28(sp)
 238:	10d7f7d3          	fmul.s	fa5,fa5,fa3
 23c:	10d77753          	fmul.s	fa4,fa4,fa3
 240:	12f02227          	fsw	fa5,292(zero) # 124 <g_plane_x>
 244:	12e02027          	fsw	fa4,288(zero) # 120 <g_plane_y>
 248:	02010113          	addi	sp,sp,32
 24c:	00008067          	ret

00000250 <auto_move>:
 250:	fe010113          	addi	sp,sp,-32
 254:	12c02707          	flw	fa4,300(zero) # 12c <g_dir_x>
 258:	00912a23          	sw	s1,20(sp)
 25c:	0f802687          	flw	fa3,248(zero) # f8 <map_is_wall>
 260:	13402787          	flw	fa5,308(zero) # 134 <g_pos_x>
 264:	00812c23          	sw	s0,24(sp)
 268:	78d77743          	fmadd.s	fa4,fa4,fa3,fa5
 26c:	13002607          	flw	fa2,304(zero) # 130 <would_collide>
 270:	12802787          	flw	fa5,296(zero) # 128 <g_dir_y>
 274:	00112e23          	sw	ra,28(sp)
 278:	60d7f7c3          	fmadd.s	fa5,fa5,fa3,fa2
 27c:	e0070553          	fmv.x.w	a0,fa4
 280:	00e12427          	fsw	fa4,8(sp)
 284:	e00785d3          	fmv.x.w	a1,fa5
 288:	00f12627          	fsw	fa5,12(sp)
 28c:	ea5ff0ef          	jal	130 <would_collide>
 290:	02051463          	bnez	a0,2b8 <auto_move+0x68>
 294:	00c12787          	flw	fa5,12(sp)
 298:	00812707          	flw	fa4,8(sp)
 29c:	01c12083          	lw	ra,28(sp)
 2a0:	12f02827          	fsw	fa5,304(zero) # 130 <would_collide>
 2a4:	01812403          	lw	s0,24(sp)
 2a8:	12e02a27          	fsw	fa4,308(zero) # 134 <g_pos_x>
 2ac:	01412483          	lw	s1,20(sp)
 2b0:	02010113          	addi	sp,sp,32
 2b4:	00008067          	ret
 2b8:	11802783          	lw	a5,280(zero) # 118 <g_turn_bias>
 2bc:	02078463          	beqz	a5,2e4 <auto_move+0x94>
 2c0:	0f002707          	flw	fa4,240(zero) # f0 <my_cosf+0x48>
 2c4:	11c02787          	flw	fa5,284(zero) # 11c <g_angle>
 2c8:	01812403          	lw	s0,24(sp)
 2cc:	01c12083          	lw	ra,28(sp)
 2d0:	00e7f7d3          	fadd.s	fa5,fa5,fa4
 2d4:	01412483          	lw	s1,20(sp)
 2d8:	10f02e27          	fsw	fa5,284(zero) # 11c <g_angle>
 2dc:	02010113          	addi	sp,sp,32
 2e0:	f19ff06f          	j	1f8 <recompute_direction_vectors>
 2e4:	0f402707          	flw	fa4,244(zero) # f4 <my_cosf+0x4c>
 2e8:	fddff06f          	j	2c4 <auto_move+0x74>

000002ec <render_column>:
 2ec:	d00577d3          	fcvt.s.w	fa5,a0
 2f0:	10002687          	flw	fa3,256(zero) # 100 <map_is_wall+0x8>
 2f4:	00f7f7d3          	fadd.s	fa5,fa5,fa5
 2f8:	10402707          	flw	fa4,260(zero) # 104 <map_is_wall+0xc>
 2fc:	12402087          	flw	ft1,292(zero) # 124 <g_plane_x>
 300:	70d7f7c3          	fmadd.s	fa5,fa5,fa3,fa4
 304:	12c02707          	flw	fa4,300(zero) # 12c <g_dir_x>
 308:	12002507          	flw	fa0,288(zero) # 120 <g_plane_y>
 30c:	70f0f0c3          	fmadd.s	ft1,ft1,fa5,fa4
 310:	12802707          	flw	fa4,296(zero) # 128 <g_dir_y>
 314:	f00005d3          	fmv.w.x	fa1,zero
 318:	70f57543          	fmadd.s	fa0,fa0,fa5,fa4
 31c:	13402787          	flw	fa5,308(zero) # 134 <g_pos_x>
 320:	13002007          	flw	ft0,304(zero) # 130 <would_collide>
 324:	c0079753          	fcvt.w.s	a4,fa5,rtz
 328:	a0b0a653          	feq.s	a2,ft1,fa1
 32c:	fe010113          	addi	sp,sp,-32
 330:	00112e23          	sw	ra,28(sp)
 334:	00812c23          	sw	s0,24(sp)
 338:	00912a23          	sw	s1,20(sp)
 33c:	01212823          	sw	s2,16(sp)
 340:	c00016d3          	fcvt.w.s	a3,ft0,rtz
 344:	d00776d3          	fcvt.s.w	fa3,a4
 348:	00050593          	mv	a1,a0
 34c:	1c061663          	bnez	a2,518 <render_column+0x22c>
 350:	0e002607          	flw	fa2,224(zero) # e0 <my_cosf+0x38>
 354:	18167653          	fdiv.s	fa2,fa2,ft1
 358:	a0b61653          	flt.s	a2,fa2,fa1
 35c:	00060463          	beqz	a2,364 <render_column+0x78>
 360:	20c61653          	fneg.s	fa2,fa2
 364:	a0b52653          	feq.s	a2,fa0,fa1
 368:	06061663          	bnez	a2,3d4 <render_column+0xe8>
 36c:	0e002707          	flw	fa4,224(zero) # e0 <my_cosf+0x38>
 370:	18a77753          	fdiv.s	fa4,fa4,fa0
 374:	a0b71653          	flt.s	a2,fa4,fa1
 378:	00060463          	beqz	a2,380 <render_column+0x94>
 37c:	20e71753          	fneg.s	fa4,fa4
 380:	a0b09653          	flt.s	a2,ft1,fa1
 384:	1a060263          	beqz	a2,528 <render_column+0x23c>
 388:	08d7f7d3          	fsub.s	fa5,fa5,fa3
 38c:	fff00813          	li	a6,-1
 390:	10c7f6d3          	fmul.s	fa3,fa5,fa2
 394:	a0b51653          	flt.s	a2,fa0,fa1
 398:	d006f7d3          	fcvt.s.w	fa5,a3
 39c:	04060063          	beqz	a2,3dc <render_column+0xf0>
 3a0:	08f07053          	fsub.s	ft0,ft0,fa5
 3a4:	fff00893          	li	a7,-1
 3a8:	10e077d3          	fmul.s	fa5,ft0,fa4
 3ac:	01800513          	li	a0,24
 3b0:	00c00313          	li	t1,12
 3b4:	a0f697d3          	flt.s	a5,fa3,fa5
 3b8:	02079e63          	bnez	a5,3f4 <render_column+0x108>
 3bc:	00e7f7d3          	fadd.s	fa5,fa5,fa4
 3c0:	011686b3          	add	a3,a3,a7
 3c4:	00100613          	li	a2,1
 3c8:	0380006f          	j	400 <render_column+0x114>
 3cc:	0fc02607          	flw	fa2,252(zero) # fc <map_is_wall+0x4>
 3d0:	f9dff06f          	j	36c <render_column+0x80>
 3d4:	0fc02707          	flw	fa4,252(zero) # fc <map_is_wall+0x4>
 3d8:	fa9ff06f          	j	380 <render_column+0x94>
 3dc:	0e002587          	flw	fa1,224(zero) # e0 <my_cosf+0x38>
 3e0:	00100893          	li	a7,1
 3e4:	00b7f7d3          	fadd.s	fa5,fa5,fa1
 3e8:	0807f7d3          	fsub.s	fa5,fa5,ft0
 3ec:	10e7f7d3          	fmul.s	fa5,fa5,fa4
 3f0:	fbdff06f          	j	3ac <render_column+0xc0>
 3f4:	00c6f6d3          	fadd.s	fa3,fa3,fa2
 3f8:	01070733          	add	a4,a4,a6
 3fc:	00000613          	li	a2,0
 400:	00c6b793          	sltiu	a5,a3,12
 404:	0e078e63          	beqz	a5,500 <render_column+0x214>
 408:	00c73793          	sltiu	a5,a4,12
 40c:	0e078a63          	beqz	a5,500 <render_column+0x214>
 410:	026687b3          	mul	a5,a3,t1
 414:	00f507b3          	add	a5,a0,a5
 418:	00e787b3          	add	a5,a5,a4
 41c:	0007c783          	lbu	a5,0(a5)
 420:	f8078ae3          	beqz	a5,3b4 <render_column+0xc8>
 424:	0e061263          	bnez	a2,508 <render_column+0x21c>
 428:	08c6f7d3          	fsub.s	fa5,fa3,fa2
 42c:	10802707          	flw	fa4,264(zero) # 108 <map_is_wall+0x10>
 430:	a0e79753          	flt.s	a4,fa5,fa4
 434:	00070463          	beqz	a4,43c <render_column+0x150>
 438:	20e707d3          	fmv.s	fa5,fa4
 43c:	10c02707          	flw	fa4,268(zero) # 10c <map_is_wall+0x14>
 440:	00200713          	li	a4,2
 444:	09f00413          	li	s0,159
 448:	18f777d3          	fdiv.s	fa5,fa4,fa5
 44c:	c00796d3          	fcvt.w.s	a3,fa5,rtz
 450:	02e6c733          	div	a4,a3,a4
 454:	40e00733          	neg	a4,a4
 458:	05070493          	addi	s1,a4,80
 45c:	fff4c513          	not	a0,s1
 460:	41f55513          	srai	a0,a0,0x1f
 464:	00a4f4b3          	and	s1,s1,a0
 468:	00d44663          	blt	s0,a3,474 <render_column+0x188>
 46c:	05000413          	li	s0,80
 470:	40e40433          	sub	s0,s0,a4
 474:	00279793          	slli	a5,a5,0x2
 478:	08060c63          	beqz	a2,510 <render_column+0x224>
 47c:	00000713          	li	a4,0
 480:	00f707b3          	add	a5,a4,a5
 484:	0007a903          	lw	s2,0(a5)
 488:	09f00793          	li	a5,159
 48c:	02d7c263          	blt	a5,a3,4b0 <render_column+0x1c4>
 490:	f8010537          	lui	a0,0xf8010
 494:	00048713          	mv	a4,s1
 498:	00100693          	li	a3,1
 49c:	00000613          	li	a2,0
 4a0:	80050513          	addi	a0,a0,-2048 # f800f800 <__stack_top+0xf7fef800>
 4a4:	00b12623          	sw	a1,12(sp)
 4a8:	1e4000ef          	jal	68c <st7735_draw_rectangle>
 4ac:	00c12583          	lw	a1,12(sp)
 4b0:	40940733          	sub	a4,s0,s1
 4b4:	00170713          	addi	a4,a4,1
 4b8:	00100693          	li	a3,1
 4bc:	00048613          	mv	a2,s1
 4c0:	00090513          	mv	a0,s2
 4c4:	00b12623          	sw	a1,12(sp)
 4c8:	1c4000ef          	jal	68c <st7735_draw_rectangle>
 4cc:	09f00713          	li	a4,159
 4d0:	06e40863          	beq	s0,a4,540 <render_column+0x254>
 4d4:	00100693          	li	a3,1
 4d8:	40870733          	sub	a4,a4,s0
 4dc:	00d40633          	add	a2,s0,a3
 4e0:	01812403          	lw	s0,24(sp)
 4e4:	00c12583          	lw	a1,12(sp)
 4e8:	01c12083          	lw	ra,28(sp)
 4ec:	01412483          	lw	s1,20(sp)
 4f0:	01012903          	lw	s2,16(sp)
 4f4:	00000513          	li	a0,0
 4f8:	02010113          	addi	sp,sp,32
 4fc:	1900006f          	j	68c <st7735_draw_rectangle>
 500:	00100793          	li	a5,1
 504:	f21ff06f          	j	424 <render_column+0x138>
 508:	08e7f7d3          	fsub.s	fa5,fa5,fa4
 50c:	f21ff06f          	j	42c <render_column+0x140>
 510:	00c00713          	li	a4,12
 514:	f6dff06f          	j	480 <render_column+0x194>
 518:	a0b52553          	feq.s	a0,fa0,fa1
 51c:	ea0508e3          	beqz	a0,3cc <render_column+0xe0>
 520:	0fc02707          	flw	fa4,252(zero) # fc <map_is_wall+0x4>
 524:	20e70653          	fmv.s	fa2,fa4
 528:	0e002087          	flw	ft1,224(zero) # e0 <my_cosf+0x38>
 52c:	00100813          	li	a6,1
 530:	0016f6d3          	fadd.s	fa3,fa3,ft1
 534:	08f6f6d3          	fsub.s	fa3,fa3,fa5
 538:	10c6f6d3          	fmul.s	fa3,fa3,fa2
 53c:	e59ff06f          	j	394 <render_column+0xa8>
 540:	01c12083          	lw	ra,28(sp)
 544:	01812403          	lw	s0,24(sp)
 548:	01412483          	lw	s1,20(sp)
 54c:	01012903          	lw	s2,16(sp)
 550:	02010113          	addi	sp,sp,32
 554:	00008067          	ret

00000558 <render_frame>:
 558:	fe010113          	addi	sp,sp,-32
 55c:	00812c23          	sw	s0,24(sp)
 560:	00112e23          	sw	ra,28(sp)
 564:	00000513          	li	a0,0
 568:	08000413          	li	s0,128
 56c:	00a12623          	sw	a0,12(sp)
 570:	d7dff0ef          	jal	2ec <render_column>
 574:	00c12503          	lw	a0,12(sp)
 578:	00150513          	addi	a0,a0,1
 57c:	fe8518e3          	bne	a0,s0,56c <render_frame+0x14>
 580:	01c12083          	lw	ra,28(sp)
 584:	01812403          	lw	s0,24(sp)
 588:	02010113          	addi	sp,sp,32
 58c:	00008067          	ret

00000590 <main>:
 590:	11002787          	flw	fa5,272(zero) # 110 <map_is_wall+0x18>
 594:	fe010113          	addi	sp,sp,-32
 598:	00912a23          	sw	s1,20(sp)
 59c:	01212823          	sw	s2,16(sp)
 5a0:	10002e23          	sw	zero,284(zero) # 11c <g_angle>
 5a4:	00100713          	li	a4,1
 5a8:	00812c23          	sw	s0,24(sp)
 5ac:	12f02a27          	fsw	fa5,308(zero) # 134 <g_pos_x>
 5b0:	12f02827          	fsw	fa5,304(zero) # 130 <would_collide>
 5b4:	10e02c23          	sw	a4,280(zero) # 118 <g_turn_bias>
 5b8:	00112e23          	sw	ra,28(sp)
 5bc:	c3dff0ef          	jal	1f8 <recompute_direction_vectors>
 5c0:	11402787          	flw	fa5,276(zero) # 114 <map_is_wall+0x1c>
 5c4:	00000413          	li	s0,0
 5c8:	00f12627          	fsw	fa5,12(sp)
 5cc:	f8dff0ef          	jal	558 <render_frame>
 5d0:	c81ff0ef          	jal	250 <auto_move>
 5d4:	00140413          	addi	s0,s0,1
 5d8:	00040513          	mv	a0,s0
 5dc:	050000ef          	jal	62c <seg_write_hex>
 5e0:	00c12707          	flw	fa4,12(sp)
 5e4:	13402787          	flw	fa5,308(zero) # 134 <g_pos_x>
 5e8:	10e7f7d3          	fmul.s	fa5,fa5,fa4
 5ec:	c01797d3          	fcvt.wu.s	a5,fa5,rtz
 5f0:	13002787          	flw	fa5,304(zero) # 130 <would_collide>
 5f4:	00879793          	slli	a5,a5,0x8
 5f8:	10e7f7d3          	fmul.s	fa5,fa5,fa4
 5fc:	c0179553          	fcvt.wu.s	a0,fa5,rtz
 600:	00a7e533          	or	a0,a5,a0
 604:	018000ef          	jal	61c <led_write>
 608:	05f5e5b7          	lui	a1,0x5f5e
 60c:	10058593          	addi	a1,a1,256 # 5f5e100 <__stack_top+0x5f3e100>
 610:	01e00513          	li	a0,30
 614:	0f4000ef          	jal	708 <delay>
 618:	fb5ff06f          	j	5cc <main+0x3c>

0000061c <led_write>:
 61c:	f00007b7          	lui	a5,0xf0000
 620:	00878793          	addi	a5,a5,8 # f0000008 <__stack_top+0xeffe0008>
 624:	00a79023          	sh	a0,0(a5)
 628:	00008067          	ret

0000062c <seg_write_hex>:
 62c:	f00007b7          	lui	a5,0xf0000
 630:	00478793          	addi	a5,a5,4 # f0000004 <__stack_top+0xeffe0004>
 634:	00a79023          	sh	a0,0(a5)
 638:	00008067          	ret

0000063c <st7735_set_rectangle>:
 63c:	00ff07b7          	lui	a5,0xff0
 640:	01059593          	slli	a1,a1,0x10
 644:	0ff6f693          	zext.b	a3,a3
 648:	00f5f5b3          	and	a1,a1,a5
 64c:	00869693          	slli	a3,a3,0x8
 650:	01051513          	slli	a0,a0,0x10
 654:	0ff67613          	zext.b	a2,a2
 658:	00f57533          	and	a0,a0,a5
 65c:	00861613          	slli	a2,a2,0x8
 660:	00d5e5b3          	or	a1,a1,a3
 664:	2b0007b7          	lui	a5,0x2b000
 668:	00c56533          	or	a0,a0,a2
 66c:	2a000737          	lui	a4,0x2a000
 670:	00f5e5b3          	or	a1,a1,a5
 674:	f00007b7          	lui	a5,0xf0000
 678:	00e56533          	or	a0,a0,a4
 67c:	00278793          	addi	a5,a5,2 # f0000002 <__stack_top+0xeffe0002>
 680:	00a7a023          	sw	a0,0(a5)
 684:	00b7a023          	sw	a1,0(a5)
 688:	00008067          	ret

0000068c <st7735_draw_rectangle>:
 68c:	fe010113          	addi	sp,sp,-32
 690:	00812c23          	sw	s0,24(sp)
 694:	00912a23          	sw	s1,20(sp)
 698:	00068413          	mv	s0,a3
 69c:	00050493          	mv	s1,a0
 6a0:	00058513          	mv	a0,a1
 6a4:	00e606b3          	add	a3,a2,a4
 6a8:	00060593          	mv	a1,a2
 6ac:	00850633          	add	a2,a0,s0
 6b0:	fff68693          	addi	a3,a3,-1
 6b4:	fff60613          	addi	a2,a2,-1
 6b8:	00112e23          	sw	ra,28(sp)
 6bc:	00e12623          	sw	a4,12(sp)
 6c0:	f7dff0ef          	jal	63c <st7735_set_rectangle>
 6c4:	00c12703          	lw	a4,12(sp)
 6c8:	2c0007b7          	lui	a5,0x2c000
 6cc:	02e40433          	mul	s0,s0,a4
 6d0:	00140413          	addi	s0,s0,1
 6d4:	40145413          	srai	s0,s0,0x1
 6d8:	00f46433          	or	s0,s0,a5
 6dc:	f00007b7          	lui	a5,0xf0000
 6e0:	00278793          	addi	a5,a5,2 # f0000002 <__stack_top+0xeffe0002>
 6e4:	0087a023          	sw	s0,0(a5)
 6e8:	f00007b7          	lui	a5,0xf0000
 6ec:	00178793          	addi	a5,a5,1 # f0000001 <__stack_top+0xeffe0001>
 6f0:	0097a023          	sw	s1,0(a5)
 6f4:	01c12083          	lw	ra,28(sp)
 6f8:	01812403          	lw	s0,24(sp)
 6fc:	01412483          	lw	s1,20(sp)
 700:	02010113          	addi	sp,sp,32
 704:	00008067          	ret

00000708 <delay>:
 708:	f0000737          	lui	a4,0xf0000
 70c:	f0000637          	lui	a2,0xf0000
 710:	10070713          	addi	a4,a4,256 # f0000100 <__stack_top+0xeffe0100>
 714:	08060613          	addi	a2,a2,128 # f0000080 <__stack_top+0xeffe0080>
 718:	00072683          	lw	a3,0(a4)
 71c:	00062783          	lw	a5,0(a2)
 720:	00072803          	lw	a6,0(a4)
 724:	ff069ae3          	bne	a3,a6,718 <delay+0x10>
 728:	3e800713          	li	a4,1000
 72c:	02e5d5b3          	divu	a1,a1,a4
 730:	f0000637          	lui	a2,0xf0000
 734:	08060613          	addi	a2,a2,128 # f0000080 <__stack_top+0xeffe0080>
 738:	02a58733          	mul	a4,a1,a0
 73c:	02a5b5b3          	mulhu	a1,a1,a0
 740:	00e78733          	add	a4,a5,a4
 744:	00f737b3          	sltu	a5,a4,a5
 748:	00b686b3          	add	a3,a3,a1
 74c:	00d787b3          	add	a5,a5,a3
 750:	f00006b7          	lui	a3,0xf0000
 754:	10068693          	addi	a3,a3,256 # f0000100 <__stack_top+0xeffe0100>
 758:	0006a583          	lw	a1,0(a3)
 75c:	00062503          	lw	a0,0(a2)
 760:	0006a803          	lw	a6,0(a3)
 764:	ff059ae3          	bne	a1,a6,758 <delay+0x50>
 768:	fef5e8e3          	bltu	a1,a5,758 <delay+0x50>
 76c:	00b79463          	bne	a5,a1,774 <delay+0x6c>
 770:	fee564e3          	bltu	a0,a4,758 <delay+0x50>
 774:	00008067          	ret
