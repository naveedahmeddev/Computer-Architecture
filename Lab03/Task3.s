.text

main: 
    # assume x10 = base address, x11 = index of the element which gets swapped
    addi sp, sp, -8   # pushing to stack the contents of the argument registers
    sw x10, 4(sp)
    sw x11, 0(sp)

    jal x1, swap 
    lw x10, 4(sp)
    lw x11, 0(sp)
    addi sp, sp, 8   # restore the stack pointer
    beq x0, x0, Exit

swap: 
    
    li x28, 0  # i 
    addi x29, x11, 0 # x29 = k 
    li x30, 0
    slli, x30, x29, 2
    add x31, x30, x10   # address of kth element 
    addi x5, x31, 4   # address of (k+1)th element
    lw x6, 0(x31)   # temp = D[k]
    lw x7, 0(x5)  # D[k+1]
    sw x7, 0(x31)   # D[k] = D[k+1]
    sw x6, 0(x5)    # D[k+1] = temp 
    jalr x0, 0(x1)  

Exit: 
