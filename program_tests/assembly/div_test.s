_start:
    li      t0, -100        
    li      t1, 7           
    div     t2, t0, t1       # Expected: -14 (0xFFFFFFF2)

    rem     t3, t0, t1       # Expected: -2 (0xFFFFFFFE)

    divu    t4, t0, t1      # Expected: 613566742 (0x24924916)

    remu    t5, t0, t1      # Expected: 2 (0x00000002)

    li      t0, 42          # Dividend
    li      t1, 0           # Divisor = 0

    div     s0, t0, t1      # Expected: -1 (0xFFFFFFFF)
    divu    s1, t0, t1      # Expected: All 1s (0xFFFFFFFF)
    rem     s2, t0, t1      # Expected: Dividend itself (42)
    remu    s3, t0, t1      # Expected: Dividend itself (42)