int main(void) {
    register int result __asm__("s1"); // s1 = 0xABCD0000 on SUCCESS, or failing step number
    register int step   __asm__("s2"); // s2 = step tracker

    __asm__ volatile (
        "li      s1, 0\n\t"
        "li      s2, 0\n\t"

        // Register Moves (fmv.w.x, fmv.x.w)
        "addi    s2, s2, 1\n\t"
        "lui     t0, 0x40200\n\t"         // Build 2.5f (0x40200000)
        "fmv.w.x fa0, t0\n\t"             // fa0 = 2.5f
        "fmv.x.w t1, fa0\n\t"             // t1 = 0x40200000
        "bne     t0, t1, 1f\n\t"

        "lui     t0, 0x40800\n\t"         // Build 4.0f (0x40800000)
        "fmv.w.x fa1, t0\n\t"             // fa1 = 4.0f

        // STEP 2: Memory Store & Load (fsw, flw)
        "addi    s2, s2, 1\n\t"
        "addi    sp, sp, -16\n\t"         // Allocate stack space
        "fsw     fa0, 0(sp)\n\t"          // Store 2.5f onto stack
        "flw     fa2, 0(sp)\n\t"          // Load back into fa2
        "addi    sp, sp, 16\n\t"          // Restore stack pointer
        "fmv.x.w t0, fa2\n\t"
        "lui     t1, 0x40200\n\t"
        "bne     t0, t1, 1f\n\t"

        // Basic Arithmetic (fadd.s, fsub.s, fmul.s, fdiv.s)
        "addi    s2, s2, 1\n\t"
        // fadd.s: 2.5 + 4.0 = 6.5f (0x40D00000)
        "fadd.s  fa3, fa0, fa1\n\t"
        "fmv.x.w t0, fa3\n\t"
        "lui     t1, 0x40D00\n\t"
        "bne     t0, t1, 1f\n\t"

        // fsub.s: 4.0 - 2.5 = 1.5f (0x3FC00000)
        "fsub.s  fa3, fa1, fa0\n\t"
        "fmv.x.w t0, fa3\n\t"
        "lui     t1, 0x3FC00\n\t"
        "bne     t0, t1, 1f\n\t"

        // fmul.s: 2.5 * 4.0 = 10.0f (0x41200000)
        "fmul.s  fa3, fa0, fa1\n\t"
        "fmv.x.w t0, fa3\n\t"
        "lui     t1, 0x41200\n\t"
        "bne     t0, t1, 1f\n\t"

        // fdiv.s: 4.0 / 2.5 = 1.6f (0x3FCCCCCD)
        "fdiv.s  fa3, fa1, fa0\n\t"
        "fmv.x.w t0, fa3\n\t"
        "li      t1, 0x3FCCCCCD\n\t"      // FIXED: Using 'li' pseudo-instruction
        "bne     t0, t1, 1f\n\t"

        // Square Root & Fused Operations (fsqrt.s, fmadd.s, fmsub.s...)
        "addi    s2, s2, 1\n\t"
        // fsqrt.s: sqrt(4.0) = 2.0f (0x40000000)
        "fsqrt.s fa3, fa1\n\t"
        "fmv.x.w t0, fa3\n\t"
        "lui     t1, 0x40000\n\t"
        "bne     t0, t1, 1f\n\t"

        // fmadd.s: (2.5 * 4.0) + 2.0 = 12.0f (0x41400000)
        "fmadd.s fa4, fa0, fa1, fa3\n\t"
        "fmv.x.w t0, fa4\n\t"
        "lui     t1, 0x41400\n\t"
        "bne     t0, t1, 1f\n\t"

        // fmsub.s: (2.5 * 4.0) - 2.0 = 8.0f (0x41000000)
        "fmsub.s fa4, fa0, fa1, fa3\n\t"
        "fmv.x.w t0, fa4\n\t"
        "lui     t1, 0x41000\n\t"
        "bne     t0, t1, 1f\n\t"

        // fnmadd.s: -((2.5 * 4.0) + 2.0) = -12.0f (0xC1400000)
        "fnmadd.s fa4, fa0, fa1, fa3\n\t"
        "fmv.x.w t0, fa4\n\t"
        "lui     t1, 0xC1400\n\t"
        "bne     t0, t1, 1f\n\t"

        // fnmsub.s: -((2.5 * 4.0) - 2.0) = -8.0f (0xC1000000)
        "fnmsub.s fa4, fa0, fa1, fa3\n\t"
        "fmv.x.w t0, fa4\n\t"
        "lui     t1, 0xC1000\n\t"
        "bne     t0, t1, 1f\n\t"

        //  Sign Injection (fsgnj.s, fsgnjn.s, fsgnjx.s)
        "addi    s2, s2, 1\n\t"
        "lui     t0, 0xC0800\n\t"         // Build -4.0f (0xC0800000)
        "fmv.w.x fa2, t0\n\t"

        // fsgnj.s: Copy sign of fa2 (-) to fa0 (2.5) -> -2.5f (0xC0200000)
        "fsgnj.s fa3, fa0, fa2\n\t"
        "fmv.x.w t0, fa3\n\t"
        "lui     t1, 0xC0200\n\t"
        "bne     t0, t1, 1f\n\t"

        // fsgnjn.s: Invert sign of fa2 (+) and put on fa0 -> +2.5f (0x40200000)
        "fsgnjn.s fa3, fa0, fa2\n\t"
        "fmv.x.w t0, fa3\n\t"
        "lui     t1, 0x40200\n\t"
        "bne     t0, t1, 1f\n\t"

        // fsgnjx.s: XOR signs (+ XOR - = -) -> -2.5f (0xC0200000)
        "fsgnjx.s fa3, fa0, fa2\n\t"
        "fmv.x.w t0, fa3\n\t"
        "lui     t1, 0xC0200\n\t"
        "bne     t0, t1, 1f\n\t"

        // Comparisons & Min/Max (flt.s, fle.s, feq.s, fmin.s, fmax.s)
        "addi    s2, s2, 1\n\t"
        // flt.s: 2.5 < 4.0 (1)
        "flt.s   t0, fa0, fa1\n\t"
        "li      t1, 1\n\t"
        "bne     t0, t1, 1f\n\t"

        // fle.s: 4.0 <= 2.5 (0)
        "fle.s   t0, fa1, fa0\n\t"
        "li      t1, 0\n\t"
        "bne     t0, t1, 1f\n\t"

        // feq.s: 2.5 == 2.5 (1)
        "feq.s   t0, fa0, fa0\n\t"
        "li      t1, 1\n\t"
        "bne     t0, t1, 1f\n\t"

        // fmin.s: min(2.5, 4.0) = 2.5f
        "fmin.s  fa3, fa0, fa1\n\t"
        "fmv.x.w t0, fa3\n\t"
        "lui     t1, 0x40200\n\t"
        "bne     t0, t1, 1f\n\t"

        // fmax.s: max(2.5, 4.0) = 4.0f
        "fmax.s  fa3, fa0, fa1\n\t"
        "fmv.x.w t0, fa3\n\t"
        "lui     t1, 0x40800\n\t"
        "bne     t0, t1, 1f\n\t"

        // Conversions (fcvt.w.s, fcvt.wu.s, fcvt.s.w, fcvt.s.wu)
        "addi    s2, s2, 1\n\t"
        // Float to Signed Int: 2.5f -> 2
        "fcvt.w.s t0, fa0, rtz\n\t"
        "li       t1, 2\n\t"
        "bne      t0, t1, 1f\n\t"

        // Signed Int to Float: 5 -> 5.0f (0x40A00000)
        "li       t0, 5\n\t"
        "fcvt.s.w fa3, t0\n\t"
        "fmv.x.w  t0, fa3\n\t"
        "lui      t1, 0x40A00\n\t"
        "bne      t0, t1, 1f\n\t"

        // Unsigned Int to Float: 10 -> 10.0f (0x41200000)
        "li        t0, 10\n\t"
        "fcvt.s.wu fa3, t0\n\t"
        "fmv.x.w   t0, fa3\n\t"
        "lui       t1, 0x41200\n\t"
        "bne       t0, t1, 1f\n\t"

        // Float to Unsigned Int: 4.0f -> 4
        "fcvt.wu.s t0, fa1, rtz\n\t"
        "li        t1, 4\n\t"
        "bne       t0, t1, 1f\n\t"

        // STEP 8: Classify (fclass.s)
        "addi    s2, s2, 1\n\t"
        // Classify 2.5f (Positive Normal number = bit 6 / 0x040)
        "fclass.s t0, fa0\n\t"
        "li       t1, 0x040\n\t"
        "bne      t0, t1, 1f\n\t"

        // PASS / FAIL HANDLERS
        "lui     s1, 0x0ABCD\n\t"        // s1 = 0xABCD0000 means all passed
        "j       2f\n\t"

        "1:\n\t"                          // Fail label
        "mv      s1, s2\n\t"             // Put failing step number into s1

        "2:\n\t"                          // End/Halt loop
        "j       2b\n\t"
        :
        :
        : "t0", "t1", "s1", "s2", 
          "fa0", "fa1", "fa2", "fa3", "fa4", "memory"   
    );

    return 0;
}