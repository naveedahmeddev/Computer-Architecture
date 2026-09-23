
.text
main:
    #Finding Sum of the numbers in the array using recursion
    
    li x10, 0x1000  # array base address                    
    li x18, 5
    li x19, 6
    li x20, 7
    li x21, 3
    sw x18, 12(x10)   # creating array in the memory
    sw x19, 8(x10) 
    sw x20, 4(x10)
    sw x21, 0(x10)

    addi x11, x0, 4  # x11 = n = 4
    jal x1, arraySum  # x10 = sum
    addi x11, x10, 0
    li x10, 1
    ecall 
    j exit

arraySum:
    addi sp, sp, -16  # store in stack
    sw x1, 12(sp)  # save return address, non-leaf
    sw x8, 8(sp)  # save x8, callee-saved register
    sw x10, 4(sp)  # save base address
    beq x11, x0, base  # if n == 0 return 0
    addi x5, x11, -1  # x5 = n - 1
    slli x5, x5, 2  # x5 = (n-1) * 4
    add x5, x10, x5  # x5 = &a[n-1]
    lw x8, 0(x5)  # x8 = a[n-1], must survive the call
    addi x11, x11, -1  # n = n - 1
    jal x1, arraySum  # x10 = arraySum(a, n-1)
    add x10, x10, x8  # a[n-1] + sum of the rest
    beq x0, x0, done  # return

base:
    addi x10, x0, 0  # base case returns 0

done:
    lw x1, 12(x2)  # restore return address
    lw x8, 8(x2)  # restore x8
    addi x2, x2, 16  # deallocate stack memory
    jalr x0, 0(x1)  # return


exit:
