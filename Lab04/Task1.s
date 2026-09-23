.text:


main:
    li x10, 5
    li x11, 0
    jal x1, fact
    addi x11, x10, 0
    li x10, 1
    ecall          # printing the value for the Recursive version 
    jal x1, fact
    addi x11, x10, 0
    li x10, 1
    ecall    # printing the value for Iterative version
    j exit 

fact: 
    
    addi sp, sp, -8       # adjust stack for 2 items
    sw x1, 4(sp)          # save return address
    sw x10, 0(sp)         # save argument n

    addi x5, x10, -1      # x5 = n - 1
    bge x5, x0, L1        # if (n - 1) >= 0, go to L1

    addi x10, x0, 1       # return 1
    addi sp, sp, 8        # pop stack
    jalr x0, 0(x1)        # return

L1:
    addi x10, x10, -1     # argument = n - 1
    jal x1, fact          # recursive call

    addi x6, x10, 0       # save result of fact(n-1)
    lw x10, 0(sp)         # restore original n
    lw x1, 4(sp)          # restore return address
    addi sp, sp, 8        # pop stack

    mul x10, x10, x6      # n * fact(n-1)
    jalr x0, 0(x1)        # return



factIterative:
    addi sp, sp, -4       # adjust stack for 2 items
    sw x1, 0(sp)          # save return address    
    li x10 , 5      # n = 5
    li x6, 1     # acc = 1
    
Loop:
    beq x10, x0, done 
    mul x6, x6, x10    # acc = acc*n
    addi x10, x10, -1   # n = n - 1
    beq x0,x0, Loop
done:

    lw x1, 0(sp)          # reload return address
    addi sp, sp, 4
    addi x10, x6, 0
    jalr x0, 0(x1)

    
exit: