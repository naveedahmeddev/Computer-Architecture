.text

main: 
    # assume x10 = base address, x11 = index of the element which gets swapped
    add sp, sp, -8   # pushing to stack the contents of the argument registers
    sw x10, 4(sp)
    sw x11, 0(sp)

    jal x1, swap 


swap: 
    
    li x28, 0  # i 
    addi x29, x11, 0 # x29 = k 
    li x30, 0
    slli, x30, x29, 2
    add x31, x30 + x10   # address of kth element 
    addi x5, x31, 4 
    lw x6, 0(x31) 
    lw x7, 0(x5) 
    sw x7, 0(x31)
    

