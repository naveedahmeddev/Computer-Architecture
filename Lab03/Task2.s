.text 

main:
    addi sp, sp, -32
    sw x10, 24(sp)     # store the parameter registers and x1 in the stack
    sw x11, 16(sp)    
    sw x12, 8(sp)
    sw x13, 0(sp)

    jal x1, leaf_example
    addi x11, x10, 0      # store the return value in x11 
    addi sp, sp, 32        # restore the stack pointer
    li x10, 1      
    ecall
    j exit 

leaf_example:
    addi sp, sp, -24    # store the saved registers in the stack
    sw, x18, 16(sp)
    sw, x19, 8(sp)
    sw, x20, 0(sp)

    li x10, 3    # g 
    li x11, 4    # h
    li x12, 5    # i 
    li x13, 6    # j 

    li x20, 0         # f = 0
    add x18, x10, x11   # g + h
    add x19, x12, x13  # i + j

    sub x20, x18, x19 # f = g + h - (i + j)
    addi x10, x20, 0   # store the return value in x10

    lw, x18, 16(sp)
    lw, x19, 8(sp)
    lw, x20, 0(sp)
    addi sp, sp, 24   # restore the stack pointer
    jalr x0, 0(x1)



exit:
