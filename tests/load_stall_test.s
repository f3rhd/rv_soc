addi x2,x0,1023
addi x1,x0,69
sw   x1,0(x2)
lw   x3,0(x2)
add x4,x3,x0 # dependency exists here we should have a stall
addi x5,x0,31
addi x6,x0,42
addi x7,x0,69