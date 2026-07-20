_start: li x5, 0       
    jal x1, target_jal 
    li x5, 0x31      
    j end 
target_jal:jalr x2, 20(x1)      
    li x5, 0x69  
    j end 
target_jalr: li x5, 0x42      
end: j end