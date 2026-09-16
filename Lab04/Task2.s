.text:


main:
    li x10, 5    # num = 5
    li x11, 0
    jal x1, ntri
    addi x11, x10, 0
    li x10, 1
    ecall          # printing the value for the Recursive version 
    j exit 

ntri: 
    
    addi sp, sp, -8       # adjust stack for 2 items
    sw x1, 4(sp)          # save return address
    sw x10, 0(sp)         # save argument num

    addi x5, x10, 0      # x5 = num
    li x7, 2      
    bge x5, x7, L1        # if (num - 1) > 1, go to L1

    addi x10, x0, 1       # return 1
    addi sp, sp, 8        # pop stack
    jalr x0, 0(x1)        # return

L1:
    addi x10, x10, -1     # argument = num - 1
    jal x1, ntri          # recursive call

    addi x6, x10, 0       # save result of ntri(num-1)
    lw x10, 0(sp)         # restore original num 
    lw x1, 4(sp)          # restore return address
    addi sp, sp, 8        # pop stack

    add x10, x10, x6      # num + ntri(num-1)
    jalr x0, 0(x1)        # return

exit:
