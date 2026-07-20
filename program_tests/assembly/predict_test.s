#lui x2, 0xF4        
#addi x2, x2, 0x240  
li x2,500
addi x1, x0, 0      # x1 = 0
addi x3, x0, 1      # x3 = 1

predictable_loop:
    addi x1, x1, 1      # x1 = x1 + 1 

    # Branch 1 (B1): Highly Not-Taken (Conditional)
    # BNE (Branch Not Equal) is often used for loop continuation.
    # If x1 IS NOT equal to x2, continue the loop (branch is NOT TAKEN here).
    # We will use BEQ x1, x2, pattern_test to preserve the structure.
    beq x1, x2, pattern_test # if (x1 == x2) goto pattern_test (B1 is PREDOMINANTLY NOT TAKEN)

    # Branch 2 (B2): Always Taken (Unconditional Jump)
    # We use BEQ x0, x0, which is the standard bare-metal instruction for JUMP.
    beq x0, x0, predictable_loop # if (0 == 0) goto predictable_loop (B2 is ALWAYS TAKEN)


# P2: Pattern-History Dependent Branch (B3 and B4)
pattern_test:
    # Reset Counter and New Limit
    addi x1, x0, 0      # x1 = 0
    
    # Load new limit (1000) into x2. 1000 is small enough for one ADDI.
    addi x2, x0, 1000   # x2 = 1,000 (New loop limit)

pattern_loop:
    addi x1, x1, 1      # x1 = x1 + 1 

    # Branch 3 (B3): Predictable Pattern (Conditional based on x3) 
    # If x3 (Pattern Tracker) is non-zero, take the branch.
    bne x3, x0, branch_taken  # if (x3 != 0) goto branch_taken

branch_not_taken:
    # Branch 4 (B4): Highly Unpredictable Branch (50/50 toss) 
    # Check LSB of the counter (x1) using ANDI.
    addi x4, x0, 1      # x4 = 1 (Immediate for AND operation)
    and x4, x1, x4     # x4 = x1 & 1 (x4 is 0 if x1 is even, 1 if x1 is odd)
    
    bne x4, x0, pattern_check_loop # If LSB is 1 (Odd), skip the next block and go to check_loop

    # Logic to switch the pattern tracker to NOT TAKEN for the next time
    addi x3, x0, 0      # x3 = 0 
    beq x0, x0, pattern_check_loop # Unconditional jump to check loop

branch_taken:
    # Logic to switch the pattern tracker to TAKEN for the next time
    addi x3, x0, 1      # x3 = 1
    
    # Unconditional jump to check loop (No need for a second jump here, B4 handles the path)
    # Just let execution fall through to pattern_check_loop

pattern_check_loop:
    # Branch 5 (B5): Loop Check (Conditional)
    # Jump back to the start of the pattern loop, until the limit is reached.
    blt x1, x2, pattern_loop # if (x1 < x2) goto pattern_loop

end_program:
    addi a7, x0, 93  