
__out_tmp.elf:     file format elf32-littleriscv


Disassembly of section .text:

00000000 <_start>:
   0:	00001197          	auipc	gp,0x1
   4:	8c018193          	addi	gp,gp,-1856 # 8c0 <__global_pointer$>
   8:	00020117          	auipc	sp,0x20
   c:	ff810113          	addi	sp,sp,-8 # 20000 <__stack_top>
  10:	604000ef          	jal	614 <main>

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
 178:	06051463          	bnez	a0,1e0 <g_col_color+0xa8>
 17c:	0e802787          	flw	fa5,232(zero) # e8 <my_cosf+0x40>
 180:	00c12707          	flw	fa4,12(sp)
 184:	00812583          	lw	a1,8(sp)
 188:	00f77753          	fadd.s	fa4,fa4,fa5
 18c:	c00717d3          	fcvt.w.s	a5,fa4,rtz
 190:	00078513          	mv	a0,a5
 194:	00078493          	mv	s1,a5
 198:	f61ff0ef          	jal	f8 <map_is_wall>
 19c:	04051263          	bnez	a0,1e0 <g_col_color+0xa8>
 1a0:	00412707          	flw	fa4,4(sp)
 1a4:	0e802787          	flw	fa5,232(zero) # e8 <my_cosf+0x40>
 1a8:	00040513          	mv	a0,s0
 1ac:	00f777d3          	fadd.s	fa5,fa4,fa5
 1b0:	c00795d3          	fcvt.w.s	a1,fa5,rtz
 1b4:	00b12223          	sw	a1,4(sp)
 1b8:	f41ff0ef          	jal	f8 <map_is_wall>
 1bc:	02051263          	bnez	a0,1e0 <g_col_color+0xa8>
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

000002ec <compute_column>:
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
 32c:	c00016d3          	fcvt.w.s	a3,ft0,rtz
 330:	d00776d3          	fcvt.s.w	fa3,a4
 334:	18061063          	bnez	a2,4b4 <g_draw_end+0x17c>
 338:	0e002607          	flw	fa2,224(zero) # e0 <my_cosf+0x38>
 33c:	18167653          	fdiv.s	fa2,fa2,ft1
 340:	a0b61653          	flt.s	a2,fa2,fa1
 344:	00060463          	beqz	a2,34c <g_draw_end+0x14>
 348:	20c61653          	fneg.s	fa2,fa2
 34c:	a0b52653          	feq.s	a2,fa0,fa1
 350:	06061663          	bnez	a2,3bc <g_draw_end+0x84>
 354:	0e002707          	flw	fa4,224(zero) # e0 <my_cosf+0x38>
 358:	18a77753          	fdiv.s	fa4,fa4,fa0
 35c:	a0b71653          	flt.s	a2,fa4,fa1
 360:	00060463          	beqz	a2,368 <g_draw_end+0x30>
 364:	20e71753          	fneg.s	fa4,fa4
 368:	a0b09653          	flt.s	a2,ft1,fa1
 36c:	14060c63          	beqz	a2,4c4 <g_draw_end+0x18c>
 370:	08d7f7d3          	fsub.s	fa5,fa5,fa3
 374:	fff00593          	li	a1,-1
 378:	10c7f6d3          	fmul.s	fa3,fa5,fa2
 37c:	a0b51653          	flt.s	a2,fa0,fa1
 380:	d006f7d3          	fcvt.s.w	fa5,a3
 384:	04060063          	beqz	a2,3c4 <g_draw_end+0x8c>
 388:	08f07053          	fsub.s	ft0,ft0,fa5
 38c:	fff00893          	li	a7,-1
 390:	10e077d3          	fmul.s	fa5,ft0,fa4
 394:	01800613          	li	a2,24
 398:	00c00313          	li	t1,12
 39c:	a0f697d3          	flt.s	a5,fa3,fa5
 3a0:	02079e63          	bnez	a5,3dc <g_draw_end+0xa4>
 3a4:	00e7f7d3          	fadd.s	fa5,fa5,fa4
 3a8:	011686b3          	add	a3,a3,a7
 3ac:	00100813          	li	a6,1
 3b0:	0380006f          	j	3e8 <g_draw_end+0xb0>
 3b4:	0fc02607          	flw	fa2,252(zero) # fc <map_is_wall+0x4>
 3b8:	f9dff06f          	j	354 <g_draw_end+0x1c>
 3bc:	0fc02707          	flw	fa4,252(zero) # fc <map_is_wall+0x4>
 3c0:	fa9ff06f          	j	368 <g_draw_end+0x30>
 3c4:	0e002587          	flw	fa1,224(zero) # e0 <my_cosf+0x38>
 3c8:	00100893          	li	a7,1
 3cc:	00b7f7d3          	fadd.s	fa5,fa5,fa1
 3d0:	0807f7d3          	fsub.s	fa5,fa5,ft0
 3d4:	10e7f7d3          	fmul.s	fa5,fa5,fa4
 3d8:	fbdff06f          	j	394 <g_draw_end+0x5c>
 3dc:	00c6f6d3          	fadd.s	fa3,fa3,fa2
 3e0:	00b70733          	add	a4,a4,a1
 3e4:	00000813          	li	a6,0
 3e8:	00c6b793          	sltiu	a5,a3,12
 3ec:	0a078863          	beqz	a5,49c <g_draw_end+0x164>
 3f0:	00c73793          	sltiu	a5,a4,12
 3f4:	0a078463          	beqz	a5,49c <g_draw_end+0x164>
 3f8:	026687b3          	mul	a5,a3,t1
 3fc:	00f607b3          	add	a5,a2,a5
 400:	00e787b3          	add	a5,a5,a4
 404:	0007c783          	lbu	a5,0(a5)
 408:	f8078ae3          	beqz	a5,39c <g_draw_end+0x64>
 40c:	08081c63          	bnez	a6,4a4 <g_draw_end+0x16c>
 410:	08c6f7d3          	fsub.s	fa5,fa3,fa2
 414:	10802707          	flw	fa4,264(zero) # 108 <map_is_wall+0x10>
 418:	a0e79753          	flt.s	a4,fa5,fa4
 41c:	00070463          	beqz	a4,424 <g_draw_end+0xec>
 420:	20e707d3          	fmv.s	fa5,fa4
 424:	10c02707          	flw	fa4,268(zero) # 10c <map_is_wall+0x14>
 428:	00200713          	li	a4,2
 42c:	18f777d3          	fdiv.s	fa5,fa4,fa5
 430:	c00795d3          	fcvt.w.s	a1,fa5,rtz
 434:	02e5c733          	div	a4,a1,a4
 438:	40e00733          	neg	a4,a4
 43c:	05070613          	addi	a2,a4,80
 440:	fff64693          	not	a3,a2
 444:	41f6d693          	srai	a3,a3,0x1f
 448:	00d67633          	and	a2,a2,a3
 44c:	09f00693          	li	a3,159
 450:	00b6c663          	blt	a3,a1,45c <g_draw_end+0x124>
 454:	05000693          	li	a3,80
 458:	40e686b3          	sub	a3,a3,a4
 45c:	00251593          	slli	a1,a0,0x2
 460:	53800713          	li	a4,1336
 464:	00b70733          	add	a4,a4,a1
 468:	00c72023          	sw	a2,0(a4)
 46c:	33800713          	li	a4,824
 470:	00b70733          	add	a4,a4,a1
 474:	00d72023          	sw	a3,0(a4)
 478:	00279793          	slli	a5,a5,0x2
 47c:	02080863          	beqz	a6,4ac <g_draw_end+0x174>
 480:	00000713          	li	a4,0
 484:	00f707b3          	add	a5,a4,a5
 488:	0007a783          	lw	a5,0(a5)
 48c:	13800513          	li	a0,312
 490:	00b50533          	add	a0,a0,a1
 494:	00f52023          	sw	a5,0(a0)
 498:	00008067          	ret
 49c:	00100793          	li	a5,1
 4a0:	f6dff06f          	j	40c <g_draw_end+0xd4>
 4a4:	08e7f7d3          	fsub.s	fa5,fa5,fa4
 4a8:	f6dff06f          	j	414 <g_draw_end+0xdc>
 4ac:	00c00713          	li	a4,12
 4b0:	fd5ff06f          	j	484 <g_draw_end+0x14c>
 4b4:	a0b525d3          	feq.s	a1,fa0,fa1
 4b8:	ee058ee3          	beqz	a1,3b4 <g_draw_end+0x7c>
 4bc:	0fc02707          	flw	fa4,252(zero) # fc <map_is_wall+0x4>
 4c0:	20e70653          	fmv.s	fa2,fa4
 4c4:	0e002087          	flw	ft1,224(zero) # e0 <my_cosf+0x38>
 4c8:	00100593          	li	a1,1
 4cc:	0016f6d3          	fadd.s	fa3,fa3,ft1
 4d0:	08f6f6d3          	fsub.s	fa3,fa3,fa5
 4d4:	10c6f6d3          	fmul.s	fa3,fa3,fa2
 4d8:	ea5ff06f          	j	37c <g_draw_end+0x44>

000004dc <render_row>:
 4dc:	fd010113          	addi	sp,sp,-48
 4e0:	01412c23          	sw	s4,24(sp)
 4e4:	53802783          	lw	a5,1336(zero) # 538 <g_draw_start>
 4e8:	03212023          	sw	s2,32(sp)
 4ec:	01312e23          	sw	s3,28(sp)
 4f0:	00050613          	mv	a2,a0
 4f4:	02112623          	sw	ra,44(sp)
 4f8:	f8010537          	lui	a0,0xf8010
 4fc:	02812423          	sw	s0,40(sp)
 500:	02912223          	sw	s1,36(sp)
 504:	01512a23          	sw	s5,20(sp)
 508:	80050513          	addi	a0,a0,-2048 # f800f800 <__stack_top+0xf7fef800>
 50c:	00f64a63          	blt	a2,a5,520 <render_row+0x44>
 510:	33802783          	lw	a5,824(zero) # 338 <g_draw_end>
 514:	00000513          	li	a0,0
 518:	00c7c463          	blt	a5,a2,520 <render_row+0x44>
 51c:	13802503          	lw	a0,312(zero) # 138 <g_col_color>
 520:	53800a13          	li	s4,1336
 524:	13800993          	li	s3,312
 528:	33800913          	li	s2,824
 52c:	00100493          	li	s1,1
 530:	00000593          	li	a1,0
 534:	08000a93          	li	s5,128
 538:	004a2783          	lw	a5,4(s4)
 53c:	f8010437          	lui	s0,0xf8010
 540:	80040413          	addi	s0,s0,-2048 # f800f800 <__stack_top+0xf7fef800>
 544:	00f64a63          	blt	a2,a5,558 <g_draw_start+0x20>
 548:	00492783          	lw	a5,4(s2)
 54c:	00000413          	li	s0,0
 550:	00c7c463          	blt	a5,a2,558 <g_draw_start+0x20>
 554:	0049a403          	lw	s0,4(s3)
 558:	00a40e63          	beq	s0,a0,574 <g_draw_start+0x3c>
 55c:	40b486b3          	sub	a3,s1,a1
 560:	00100713          	li	a4,1
 564:	00c12623          	sw	a2,12(sp)
 568:	1b4000ef          	jal	71c <rv_soc_draw_rectangle>
 56c:	00c12603          	lw	a2,12(sp)
 570:	00048593          	mv	a1,s1
 574:	00148493          	addi	s1,s1,1
 578:	004a0a13          	addi	s4,s4,4
 57c:	00498993          	addi	s3,s3,4
 580:	00490913          	addi	s2,s2,4
 584:	03549a63          	bne	s1,s5,5b8 <g_draw_start+0x80>
 588:	00040513          	mv	a0,s0
 58c:	02812403          	lw	s0,40(sp)
 590:	02c12083          	lw	ra,44(sp)
 594:	02012903          	lw	s2,32(sp)
 598:	01c12983          	lw	s3,28(sp)
 59c:	01812a03          	lw	s4,24(sp)
 5a0:	01412a83          	lw	s5,20(sp)
 5a4:	40b486b3          	sub	a3,s1,a1
 5a8:	02412483          	lw	s1,36(sp)
 5ac:	00100713          	li	a4,1
 5b0:	03010113          	addi	sp,sp,48
 5b4:	1680006f          	j	71c <rv_soc_draw_rectangle>
 5b8:	00040513          	mv	a0,s0
 5bc:	f7dff06f          	j	538 <g_draw_start>

000005c0 <render_frame>:
 5c0:	fe010113          	addi	sp,sp,-32
 5c4:	00812c23          	sw	s0,24(sp)
 5c8:	00112e23          	sw	ra,28(sp)
 5cc:	00000513          	li	a0,0
 5d0:	08000413          	li	s0,128
 5d4:	00a12623          	sw	a0,12(sp)
 5d8:	d15ff0ef          	jal	2ec <compute_column>
 5dc:	00c12503          	lw	a0,12(sp)
 5e0:	00150513          	addi	a0,a0,1
 5e4:	fe8518e3          	bne	a0,s0,5d4 <render_frame+0x14>
 5e8:	00000513          	li	a0,0
 5ec:	0a000413          	li	s0,160
 5f0:	00a12623          	sw	a0,12(sp)
 5f4:	ee9ff0ef          	jal	4dc <render_row>
 5f8:	00c12503          	lw	a0,12(sp)
 5fc:	00150513          	addi	a0,a0,1
 600:	fe8518e3          	bne	a0,s0,5f0 <render_frame+0x30>
 604:	01c12083          	lw	ra,28(sp)
 608:	01812403          	lw	s0,24(sp)
 60c:	02010113          	addi	sp,sp,32
 610:	00008067          	ret

00000614 <main>:
 614:	11002787          	flw	fa5,272(zero) # 110 <map_is_wall+0x18>
 618:	fe010113          	addi	sp,sp,-32
 61c:	00912a23          	sw	s1,20(sp)
 620:	01212823          	sw	s2,16(sp)
 624:	10002e23          	sw	zero,284(zero) # 11c <g_angle>
 628:	00100713          	li	a4,1
 62c:	00812c23          	sw	s0,24(sp)
 630:	12f02a27          	fsw	fa5,308(zero) # 134 <g_pos_x>
 634:	12f02827          	fsw	fa5,304(zero) # 130 <would_collide>
 638:	10e02c23          	sw	a4,280(zero) # 118 <g_turn_bias>
 63c:	00112e23          	sw	ra,28(sp)
 640:	bb9ff0ef          	jal	1f8 <recompute_direction_vectors>
 644:	11402787          	flw	fa5,276(zero) # 114 <map_is_wall+0x1c>
 648:	00000413          	li	s0,0
 64c:	00f12627          	fsw	fa5,12(sp)
 650:	f71ff0ef          	jal	5c0 <render_frame>
 654:	bfdff0ef          	jal	250 <auto_move>
 658:	00140413          	addi	s0,s0,1
 65c:	00040513          	mv	a0,s0
 660:	154000ef          	jal	7b4 <seg_write_hex>
 664:	00c12707          	flw	fa4,12(sp)
 668:	13402787          	flw	fa5,308(zero) # 134 <g_pos_x>
 66c:	10e7f7d3          	fmul.s	fa5,fa5,fa4
 670:	c01797d3          	fcvt.wu.s	a5,fa5,rtz
 674:	13002787          	flw	fa5,304(zero) # 130 <would_collide>
 678:	00879793          	slli	a5,a5,0x8
 67c:	10e7f7d3          	fmul.s	fa5,fa5,fa4
 680:	c0179553          	fcvt.wu.s	a0,fa5,rtz
 684:	00a7e533          	or	a0,a5,a0
 688:	11c000ef          	jal	7a4 <led_write>
 68c:	fc5ff06f          	j	650 <main+0x3c>

00000690 <rv_soc_draw_triangle>:
 690:	00004337          	lui	t1,0x4
 694:	0fffce37          	lui	t3,0xfffc
 698:	fff30313          	addi	t1,t1,-1 # 3fff <__static_reserve+0x2fff>
 69c:	00e61613          	slli	a2,a2,0xe
 6a0:	0066f6b3          	and	a3,a3,t1
 6a4:	01c67633          	and	a2,a2,t3
 6a8:	01f59593          	slli	a1,a1,0x1f
 6ac:	00d66633          	or	a2,a2,a3
 6b0:	f00006b7          	lui	a3,0xf0000
 6b4:	00b66633          	or	a2,a2,a1
 6b8:	00168693          	addi	a3,a3,1 # f0000001 <__stack_top+0xeffe0001>
 6bc:	00c6a023          	sw	a2,0(a3)
 6c0:	00e71713          	slli	a4,a4,0xe
 6c4:	0067f7b3          	and	a5,a5,t1
 6c8:	01c77733          	and	a4,a4,t3
 6cc:	00f76733          	or	a4,a4,a5
 6d0:	00b76733          	or	a4,a4,a1
 6d4:	200007b7          	lui	a5,0x20000
 6d8:	00f76733          	or	a4,a4,a5
 6dc:	00e6a023          	sw	a4,0(a3)
 6e0:	00e81813          	slli	a6,a6,0xe
 6e4:	01c87833          	and	a6,a6,t3
 6e8:	0068f8b3          	and	a7,a7,t1
 6ec:	01186833          	or	a6,a6,a7
 6f0:	00b86833          	or	a6,a6,a1
 6f4:	400007b7          	lui	a5,0x40000
 6f8:	00f86833          	or	a6,a6,a5
 6fc:	0106a023          	sw	a6,0(a3)
 700:	00851513          	slli	a0,a0,0x8
 704:	00855513          	srli	a0,a0,0x8
 708:	00b56533          	or	a0,a0,a1
 70c:	600007b7          	lui	a5,0x60000
 710:	00f56533          	or	a0,a0,a5
 714:	00a6a023          	sw	a0,0(a3)
 718:	00008067          	ret

0000071c <rv_soc_draw_rectangle>:
 71c:	08e05263          	blez	a4,7a0 <__static_end+0x68>
 720:	08d05063          	blez	a3,7a0 <__static_end+0x68>
 724:	00068313          	mv	t1,a3
 728:	00b30333          	add	t1,t1,a1
 72c:	00060693          	mv	a3,a2
 730:	fe010113          	addi	sp,sp,-32
 734:	00d708b3          	add	a7,a4,a3
 738:	fff30713          	addi	a4,t1,-1
 73c:	00058613          	mv	a2,a1
 740:	fff88893          	addi	a7,a7,-1
 744:	00070813          	mv	a6,a4
 748:	00068793          	mv	a5,a3
 74c:	00b12023          	sw	a1,0(sp)
 750:	00000593          	li	a1,0
 754:	00812c23          	sw	s0,24(sp)
 758:	00112e23          	sw	ra,28(sp)
 75c:	00050413          	mv	s0,a0
 760:	01112623          	sw	a7,12(sp)
 764:	00e12423          	sw	a4,8(sp)
 768:	00d12223          	sw	a3,4(sp)
 76c:	f25ff0ef          	jal	690 <rv_soc_draw_triangle>
 770:	00c12883          	lw	a7,12(sp)
 774:	00012603          	lw	a2,0(sp)
 778:	00040513          	mv	a0,s0
 77c:	01812403          	lw	s0,24(sp)
 780:	00812703          	lw	a4,8(sp)
 784:	00412683          	lw	a3,4(sp)
 788:	01c12083          	lw	ra,28(sp)
 78c:	00060813          	mv	a6,a2
 790:	00088793          	mv	a5,a7
 794:	00000593          	li	a1,0
 798:	02010113          	addi	sp,sp,32
 79c:	ef5ff06f          	j	690 <rv_soc_draw_triangle>
 7a0:	00008067          	ret

000007a4 <led_write>:
 7a4:	f00007b7          	lui	a5,0xf0000
 7a8:	00878793          	addi	a5,a5,8 # f0000008 <__stack_top+0xeffe0008>
 7ac:	00a79023          	sh	a0,0(a5)
 7b0:	00008067          	ret

000007b4 <seg_write_hex>:
 7b4:	f00007b7          	lui	a5,0xf0000
 7b8:	00478793          	addi	a5,a5,4 # f0000004 <__stack_top+0xeffe0004>
 7bc:	00a79023          	sh	a0,0(a5)
 7c0:	00008067          	ret
