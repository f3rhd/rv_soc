addi x1,x0,2047
addi x2,x0,31
addi x4,x0,69
sw x2, 0(x1)        
nop                
nop
nop
nop

lw x3, 0(x1)        
nop                 
nop
nop
nop

sb x4, 4(x1)        
nop
nop
nop
nop

lb x5, 4(x1)        
nop
nop
nop
nop