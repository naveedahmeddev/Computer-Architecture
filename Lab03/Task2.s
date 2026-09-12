.text 

main:
    addi sp, sp, -32
    sw x10, 24(sp)
    sw x11, 16(sp)
    sw x12, 8(sp)
    sw x13, 0(sp)

    jal x1, leaf_example
    addi x11, x10, 0
    li x10, 1
    ecall
    j exit 

leaf_example:
    addi sp, sp, -24
    sw, x18, 16(sp)
    sw, x19, 8(sp)
    sw, x20, 0(sp)

    li x10, 3    # g 
    li x11, 4    # h
    li x12, 5    # i 
    li x13, 6    # j 

    li x20, 0
    add x18, x10, x11 
    add x19, x12, x13

    sub x20, x18, x19 
    addi x10, x20, 0

    lw, x18, 16(sp)
    lw, x19, 8(sp)
    lw, x20, 0(sp)

    jalr x0, 0(x1)



exit:
