
__out_tmp.elf:     file format elf32-littleriscv


Disassembly of section .text:

00000000 <__static_end>:
   0:	00001197          	auipc	gp,0x1
   4:	80018193          	addi	gp,gp,-2048 # 800 <__global_pointer$>
   8:	00020117          	auipc	sp,0x20
   c:	ff810113          	addi	sp,sp,-8 # 20000 <__stack_top>
  10:	008000ef          	jal	18 <main>

00000014 <halt_loop>:
  14:	0000006f          	j	14 <halt_loop>

00000018 <main>:
  18:	ff010113          	addi	sp,sp,-16
  1c:	00912623          	sw	s1,12(sp)
  20:	01212423          	sw	s2,8(sp)
  24:	00000493          	li	s1,0
  28:	00000913          	li	s2,0
  2c:	00190913          	addi	s2,s2,1
  30:	402002b7          	lui	t0,0x40200
  34:	f0028553          	fmv.w.x	fa0,t0
  38:	e0050353          	fmv.x.w	t1,fa0
  3c:	1a629463          	bne	t0,t1,1e4 <main+0x1cc>
  40:	408002b7          	lui	t0,0x40800
  44:	f00285d3          	fmv.w.x	fa1,t0
  48:	00190913          	addi	s2,s2,1
  4c:	ff010113          	addi	sp,sp,-16
  50:	00a12027          	fsw	fa0,0(sp)
  54:	00012607          	flw	fa2,0(sp)
  58:	01010113          	addi	sp,sp,16
  5c:	e00602d3          	fmv.x.w	t0,fa2
  60:	40200337          	lui	t1,0x40200
  64:	18629063          	bne	t0,t1,1e4 <main+0x1cc>
  68:	00190913          	addi	s2,s2,1
  6c:	00b576d3          	fadd.s	fa3,fa0,fa1
  70:	e00682d3          	fmv.x.w	t0,fa3
  74:	40d00337          	lui	t1,0x40d00
  78:	16629663          	bne	t0,t1,1e4 <main+0x1cc>
  7c:	08a5f6d3          	fsub.s	fa3,fa1,fa0
  80:	e00682d3          	fmv.x.w	t0,fa3
  84:	3fc00337          	lui	t1,0x3fc00
  88:	14629e63          	bne	t0,t1,1e4 <main+0x1cc>
  8c:	10b576d3          	fmul.s	fa3,fa0,fa1
  90:	e00682d3          	fmv.x.w	t0,fa3
  94:	41200337          	lui	t1,0x41200
  98:	14629663          	bne	t0,t1,1e4 <main+0x1cc>
  9c:	18a5f6d3          	fdiv.s	fa3,fa1,fa0
  a0:	e00682d3          	fmv.x.w	t0,fa3
  a4:	3fccd337          	lui	t1,0x3fccd
  a8:	ccd30313          	addi	t1,t1,-819 # 3fcccccd <__stack_top+0x3fcacccd>
  ac:	12629c63          	bne	t0,t1,1e4 <main+0x1cc>
  b0:	00190913          	addi	s2,s2,1
  b4:	5805f6d3          	fsqrt.s	fa3,fa1
  b8:	e00682d3          	fmv.x.w	t0,fa3
  bc:	40000337          	lui	t1,0x40000
  c0:	12629263          	bne	t0,t1,1e4 <main+0x1cc>
  c4:	68b57743          	fmadd.s	fa4,fa0,fa1,fa3
  c8:	e00702d3          	fmv.x.w	t0,fa4
  cc:	41400337          	lui	t1,0x41400
  d0:	10629a63          	bne	t0,t1,1e4 <main+0x1cc>
  d4:	68b57747          	fmsub.s	fa4,fa0,fa1,fa3
  d8:	e00702d3          	fmv.x.w	t0,fa4
  dc:	41000337          	lui	t1,0x41000
  e0:	10629263          	bne	t0,t1,1e4 <main+0x1cc>
  e4:	68b5774f          	fnmadd.s	fa4,fa0,fa1,fa3
  e8:	e00702d3          	fmv.x.w	t0,fa4
  ec:	c1400337          	lui	t1,0xc1400
  f0:	0e629a63          	bne	t0,t1,1e4 <main+0x1cc>
  f4:	68b5774b          	fnmsub.s	fa4,fa0,fa1,fa3
  f8:	e00702d3          	fmv.x.w	t0,fa4
  fc:	c1000337          	lui	t1,0xc1000
 100:	0e629263          	bne	t0,t1,1e4 <main+0x1cc>
 104:	00190913          	addi	s2,s2,1
 108:	c08002b7          	lui	t0,0xc0800
 10c:	f0028653          	fmv.w.x	fa2,t0
 110:	20c506d3          	fsgnj.s	fa3,fa0,fa2
 114:	e00682d3          	fmv.x.w	t0,fa3
 118:	c0200337          	lui	t1,0xc0200
 11c:	0c629463          	bne	t0,t1,1e4 <main+0x1cc>
 120:	20c516d3          	fsgnjn.s	fa3,fa0,fa2
 124:	e00682d3          	fmv.x.w	t0,fa3
 128:	40200337          	lui	t1,0x40200
 12c:	0a629c63          	bne	t0,t1,1e4 <main+0x1cc>
 130:	20c526d3          	fsgnjx.s	fa3,fa0,fa2
 134:	e00682d3          	fmv.x.w	t0,fa3
 138:	c0200337          	lui	t1,0xc0200
 13c:	0a629463          	bne	t0,t1,1e4 <main+0x1cc>
 140:	00190913          	addi	s2,s2,1
 144:	a0b512d3          	flt.s	t0,fa0,fa1
 148:	00100313          	li	t1,1
 14c:	08629c63          	bne	t0,t1,1e4 <main+0x1cc>
 150:	a0a582d3          	fle.s	t0,fa1,fa0
 154:	00000313          	li	t1,0
 158:	08629663          	bne	t0,t1,1e4 <main+0x1cc>
 15c:	a0a522d3          	feq.s	t0,fa0,fa0
 160:	00100313          	li	t1,1
 164:	08629063          	bne	t0,t1,1e4 <main+0x1cc>
 168:	28b506d3          	fmin.s	fa3,fa0,fa1
 16c:	e00682d3          	fmv.x.w	t0,fa3
 170:	40200337          	lui	t1,0x40200
 174:	06629863          	bne	t0,t1,1e4 <main+0x1cc>
 178:	28b516d3          	fmax.s	fa3,fa0,fa1
 17c:	e00682d3          	fmv.x.w	t0,fa3
 180:	40800337          	lui	t1,0x40800
 184:	06629063          	bne	t0,t1,1e4 <main+0x1cc>
 188:	00190913          	addi	s2,s2,1
 18c:	c00512d3          	fcvt.w.s	t0,fa0,rtz
 190:	00200313          	li	t1,2
 194:	04629863          	bne	t0,t1,1e4 <main+0x1cc>
 198:	00500293          	li	t0,5
 19c:	d002f6d3          	fcvt.s.w	fa3,t0
 1a0:	e00682d3          	fmv.x.w	t0,fa3
 1a4:	40a00337          	lui	t1,0x40a00
 1a8:	02629e63          	bne	t0,t1,1e4 <main+0x1cc>
 1ac:	00a00293          	li	t0,10
 1b0:	d012f6d3          	fcvt.s.wu	fa3,t0
 1b4:	e00682d3          	fmv.x.w	t0,fa3
 1b8:	41200337          	lui	t1,0x41200
 1bc:	02629463          	bne	t0,t1,1e4 <main+0x1cc>
 1c0:	c01592d3          	fcvt.wu.s	t0,fa1,rtz
 1c4:	00400313          	li	t1,4
 1c8:	00629e63          	bne	t0,t1,1e4 <main+0x1cc>
 1cc:	00190913          	addi	s2,s2,1
 1d0:	e00512d3          	fclass.s	t0,fa0
 1d4:	04000313          	li	t1,64
 1d8:	00629663          	bne	t0,t1,1e4 <main+0x1cc>
 1dc:	0abcd4b7          	lui	s1,0xabcd
 1e0:	0080006f          	j	1e8 <main+0x1d0>
 1e4:	00090493          	mv	s1,s2
 1e8:	0000006f          	j	1e8 <main+0x1d0>
 1ec:	00000513          	li	a0,0
 1f0:	00c12483          	lw	s1,12(sp)
 1f4:	00812903          	lw	s2,8(sp)
 1f8:	01010113          	addi	sp,sp,16
 1fc:	00008067          	ret
