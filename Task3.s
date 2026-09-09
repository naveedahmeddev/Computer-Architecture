.text
main:
    # i = x22, sum = x23
    li x28, 0x200   # base address of the array a
    li x29, 10


Loop: bge x22, x29, Reset  # i >= 10, then move to next loop
    sw x22, 0(x28)     # a[i] = i 
    addi x28, x28, 4    # i* 4
    addi, x22, x22, 1       # i ++ 
    beq x0, x0, Loop     # back to loop 

Reset: li x22, 0x0  # reseting values which are going to be used for the next loop 
    li x28, 0x200  
    beq x0, x0, Loop1

Loop1: bge x22, x29, Exit  
    lw x30, 0(x28)        # a[i]
    add x23, x23, x30   # sum = sum + a[i]
    addi x28, x28, 4   # i * 4
    addi, x22, x22, 1    # i ++ 
    beq x0, x0, Loop1  # back to loop 

Exit: 

