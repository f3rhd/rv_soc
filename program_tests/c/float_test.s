
__out_tmp.elf:     file format elf32-littleriscv


Disassembly of section .text:

00000000 <_start>:
   0:	00008137          	lui	sp,0x8
   4:	008000ef          	jal	c <main>

00000008 <halt_loop>:
   8:	0000006f          	j	8 <halt_loop>

0000000c <main>:
   c:	ff010113          	addi	sp,sp,-16 # 7ff0 <main+0x7fe4>
  10:	00912623          	sw	s1,12(sp)
  14:	01212423          	sw	s2,8(sp)
  18:	00000493          	li	s1,0
  1c:	00000913          	li	s2,0
  20:	00190913          	addi	s2,s2,1
  24:	402002b7          	lui	t0,0x40200
  28:	f0028553          	fmv.w.x	fa0,t0
  2c:	e0050353          	fmv.x.w	t1,fa0
  30:	1a629463          	bne	t0,t1,1d8 <main+0x1cc>
  34:	408002b7          	lui	t0,0x40800
  38:	f00285d3          	fmv.w.x	fa1,t0
  3c:	00190913          	addi	s2,s2,1
  40:	ff010113          	addi	sp,sp,-16
  44:	00a12027          	fsw	fa0,0(sp)
  48:	00012607          	flw	fa2,0(sp)
  4c:	01010113          	addi	sp,sp,16
  50:	e00602d3          	fmv.x.w	t0,fa2
  54:	40200337          	lui	t1,0x40200
  58:	18629063          	bne	t0,t1,1d8 <main+0x1cc>
  5c:	00190913          	addi	s2,s2,1
  60:	00b576d3          	fadd.s	fa3,fa0,fa1
  64:	e00682d3          	fmv.x.w	t0,fa3
  68:	40d00337          	lui	t1,0x40d00
  6c:	16629663          	bne	t0,t1,1d8 <main+0x1cc>
  70:	08a5f6d3          	fsub.s	fa3,fa1,fa0
  74:	e00682d3          	fmv.x.w	t0,fa3
  78:	3fc00337          	lui	t1,0x3fc00
  7c:	14629e63          	bne	t0,t1,1d8 <main+0x1cc>
  80:	10b576d3          	fmul.s	fa3,fa0,fa1
  84:	e00682d3          	fmv.x.w	t0,fa3
  88:	41200337          	lui	t1,0x41200
  8c:	14629663          	bne	t0,t1,1d8 <main+0x1cc>
  90:	18a5f6d3          	fdiv.s	fa3,fa1,fa0
  94:	e00682d3          	fmv.x.w	t0,fa3
  98:	3fccd337          	lui	t1,0x3fccd
  9c:	ccd30313          	addi	t1,t1,-819 # 3fcccccd <main+0x3fccccc1>
  a0:	12629c63          	bne	t0,t1,1d8 <main+0x1cc>
  a4:	00190913          	addi	s2,s2,1
  a8:	5805f6d3          	fsqrt.s	fa3,fa1
  ac:	e00682d3          	fmv.x.w	t0,fa3
  b0:	40000337          	lui	t1,0x40000
  b4:	12629263          	bne	t0,t1,1d8 <main+0x1cc>
  b8:	68b57743          	fmadd.s	fa4,fa0,fa1,fa3
  bc:	e00702d3          	fmv.x.w	t0,fa4
  c0:	41400337          	lui	t1,0x41400
  c4:	10629a63          	bne	t0,t1,1d8 <main+0x1cc>
  c8:	68b57747          	fmsub.s	fa4,fa0,fa1,fa3
  cc:	e00702d3          	fmv.x.w	t0,fa4
  d0:	41000337          	lui	t1,0x41000
  d4:	10629263          	bne	t0,t1,1d8 <main+0x1cc>
  d8:	68b5774f          	fnmadd.s	fa4,fa0,fa1,fa3
  dc:	e00702d3          	fmv.x.w	t0,fa4
  e0:	c1400337          	lui	t1,0xc1400
  e4:	0e629a63          	bne	t0,t1,1d8 <main+0x1cc>
  e8:	68b5774b          	fnmsub.s	fa4,fa0,fa1,fa3
  ec:	e00702d3          	fmv.x.w	t0,fa4
  f0:	c1000337          	lui	t1,0xc1000
  f4:	0e629263          	bne	t0,t1,1d8 <main+0x1cc>
  f8:	00190913          	addi	s2,s2,1
  fc:	c08002b7          	lui	t0,0xc0800
 100:	f0028653          	fmv.w.x	fa2,t0
 104:	20c506d3          	fsgnj.s	fa3,fa0,fa2
 108:	e00682d3          	fmv.x.w	t0,fa3
 10c:	c0200337          	lui	t1,0xc0200
 110:	0c629463          	bne	t0,t1,1d8 <main+0x1cc>
 114:	20c516d3          	fsgnjn.s	fa3,fa0,fa2
 118:	e00682d3          	fmv.x.w	t0,fa3
 11c:	40200337          	lui	t1,0x40200
 120:	0a629c63          	bne	t0,t1,1d8 <main+0x1cc>
 124:	20c526d3          	fsgnjx.s	fa3,fa0,fa2
 128:	e00682d3          	fmv.x.w	t0,fa3
 12c:	c0200337          	lui	t1,0xc0200
 130:	0a629463          	bne	t0,t1,1d8 <main+0x1cc>
 134:	00190913          	addi	s2,s2,1
 138:	a0b512d3          	flt.s	t0,fa0,fa1
 13c:	00100313          	li	t1,1
 140:	08629c63          	bne	t0,t1,1d8 <main+0x1cc>
 144:	a0a582d3          	fle.s	t0,fa1,fa0
 148:	00000313          	li	t1,0
 14c:	08629663          	bne	t0,t1,1d8 <main+0x1cc>
 150:	a0a522d3          	feq.s	t0,fa0,fa0
 154:	00100313          	li	t1,1
 158:	08629063          	bne	t0,t1,1d8 <main+0x1cc>
 15c:	28b506d3          	fmin.s	fa3,fa0,fa1
 160:	e00682d3          	fmv.x.w	t0,fa3
 164:	40200337          	lui	t1,0x40200
 168:	06629863          	bne	t0,t1,1d8 <main+0x1cc>
 16c:	28b516d3          	fmax.s	fa3,fa0,fa1
 170:	e00682d3          	fmv.x.w	t0,fa3
 174:	40800337          	lui	t1,0x40800
 178:	06629063          	bne	t0,t1,1d8 <main+0x1cc>
 17c:	00190913          	addi	s2,s2,1
 180:	c00512d3          	fcvt.w.s	t0,fa0,rtz
 184:	00200313          	li	t1,2
 188:	04629863          	bne	t0,t1,1d8 <main+0x1cc>
 18c:	00500293          	li	t0,5
 190:	d002f6d3          	fcvt.s.w	fa3,t0
 194:	e00682d3          	fmv.x.w	t0,fa3
 198:	40a00337          	lui	t1,0x40a00
 19c:	02629e63          	bne	t0,t1,1d8 <main+0x1cc>
 1a0:	00a00293          	li	t0,10
 1a4:	d012f6d3          	fcvt.s.wu	fa3,t0
 1a8:	e00682d3          	fmv.x.w	t0,fa3
 1ac:	41200337          	lui	t1,0x41200
 1b0:	02629463          	bne	t0,t1,1d8 <main+0x1cc>
 1b4:	c01592d3          	fcvt.wu.s	t0,fa1,rtz
 1b8:	00400313          	li	t1,4
 1bc:	00629e63          	bne	t0,t1,1d8 <main+0x1cc>
 1c0:	00190913          	addi	s2,s2,1
 1c4:	e00512d3          	fclass.s	t0,fa0
 1c8:	04000313          	li	t1,64
 1cc:	00629663          	bne	t0,t1,1d8 <main+0x1cc>
 1d0:	0abcd4b7          	lui	s1,0xabcd
 1d4:	0080006f          	j	1dc <main+0x1d0>
 1d8:	00090493          	mv	s1,s2
 1dc:	0000006f          	j	1dc <main+0x1d0>
 1e0:	00000513          	li	a0,0
 1e4:	00c12483          	lw	s1,12(sp)
 1e8:	00812903          	lw	s2,8(sp)
 1ec:	01010113          	addi	sp,sp,16
 1f0:	00008067          	ret
