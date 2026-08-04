    # -------------------------------------------------------------------------
    # 1. SETUP: Initialize Source Registers with Independent Test Data
    # -------------------------------------------------------------------------
    # Using 'addi' to prime our source registers.
    addi sp,  zero, 15    # sp  (x2)  = rs1 for basic arithmetic
    addi gp,  zero, 5     # gp  (x3)  = rs2 for basic arithmetic
    addi tp,  zero, -10   # tp  (x4)  = Negative value for signed ops
    addi t0,  zero, 4     # t0  (x5)  = Shift amount
    addi t1,  zero, 0x55  # t1  (x6)  = Bitmask 1 (01010101)
    addi t2,  zero, 0x3A  # t2  (x7)  = Bitmask 2 (00111010)
    addi s0,  zero, 20    # s0  (x8)  = rs1 for M-extension
    addi s1,  zero, 6     # s1  (x9)  = rs2 for M-extension

    # -------------------------------------------------------------------------
    # 2. RV32I Immediate Instructions (I-Type)
    # -------------------------------------------------------------------------
    slli a0, sp,  2         # a0  (x10) = 15 << 2 = 60
    srli a1, t1,  1         # a1  (x11) = 0x55 >> 1 = 0x2A (42)
    srai a2, tp,  1         # a2  (x12) = -10 >> 1 = -5
    andi a3, t1,  0x0F      # a3  (x13) = 0x55 & 0x0F = 0x05
    ori  a4, t2,  0xF0      # a4  (x14) = 0x3A | 0xF0 = 0xFA (250)
    xori a5, t1,  0xFF      # a5  (x15) = 0x55 ^ 0xFF = 0xAA (170)
    slti a6, tp,  0         # a6  (x16) = (-10 < 0) = 1
    sltiu a7, tp, 5         # a7  (x17) = (0xFFFFFFF6 < 5) = 0

    # -------------------------------------------------------------------------
    # 3. RV32I Register-Register Instructions (R-Type)
    # -------------------------------------------------------------------------
    add  s2, sp,  gp        # s2  (x18) = 15 + 5 = 20
    sub  s3, sp,  gp        # s3  (x19) = 15 - 5 = 10
    sll  s4, sp,  t0        # s4  (x20) = 15 << 4 = 240
    srl  s5, t1,  t0        # s5  (x21) = 0x55 >> 4 = 5
    sra  s6, tp,  t0        # s6  (x22) = -10 >> 4 = -1
    and  s7, t1,  t2        # s7  (x23) = 0x55 & 0x3A = 0x10 (16)
    or   s8, t1,  t2        # s8  (x24) = 0x55 | 0x3A = 0x7F (127)
    xor  s9, t1,  t2        # s9  (x25) = 0x55 ^ 0x3A = 0x6F (111)
    slt  s10, tp, sp        # s10 (x26) = (-10 < 15) = 1
    sltu s11, tp, sp        # s11 (x27) = (0xFFFFFFF6 < 15) = 0

    # -------------------------------------------------------------------------
    # 4. RV32M Extension Instructions (Multiply/Divide R-Type)
    # -------------------------------------------------------------------------
    mul    t3, s0,  s1      # t3  (x28) = 20 * 6 = 120
    mulh   t4, tp,  s0      # t4  (x29) = upper half of (-10 * 20) = -1
    div    t5, s0,  s1      # t5  (x30) = 20 / 6 = 3
    
    # -------------------------------------------------------------------------
    # 5. FINAL AGGREGATION: Accumulate into t6 (x31)
    # -------------------------------------------------------------------------
    
    add t6, zero, a0       
    add t6, t6,   a1
    add t6, t6,   a2
    add t6, t6,   a3
    add t6, t6,   a4
    add t6, t6,   a5
    add t6, t6,   a6
    add t6, t6,   a7
    add t6, t6,   s2
    add t6, t6,   s3
    add t6, t6,   s4
    add t6, t6,   s5
    add t6, t6,   s6
    add t6, t6,   s7
    add t6, t6,   s8
    add t6, t6,   s9
    add t6, t6,   s10
    add t6, t6,   s11
    add t6, t6,   t3
    add t6, t6,   t4
    add t6, t6,   t5