
_start:
    li      a0, 1234
    li      a1, 5678
    mul     a2, a0, a1                  # Expected : 0x006ae9bc

    # Test: -50 * 20 = -1000 (0xFFFFFCF8)
    li      a0, -50
    li      a1, 20
    mul     a2, a0, a1                  # Expected : 0xFFFFFCF8

    li      a0, 2000000000
    li      a1, 2000000000
    mulh    a2, a0, a1                  # Expected : 0x3782DACE

    li      a0, -2000000000
    li      a1, 2000000000
    mulh    a2, a0, a1                  # Expected : 0xC87D2532

    li      a0, 0xFFFFFFFF
    li      a1, 0xFFFFFFFF
    mulhu   a2, a0, a1                  # Expected : 0xFFFFFFFE

    li      a0, -1
    li      a1, 0xFFFFFFFF
    mulhsu  a2, a0, a1                  # Expected : 0xFFFFFFFF
    li      t0, 0xFFFFFFFF
