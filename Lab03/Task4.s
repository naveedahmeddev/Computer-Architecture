
.text
main:
    li   x10, 0x10000000     #  base of x
    li   x11, 0x10000020     #  base of y
    jal  x1, strcpy 
    beq  x0, x0, End

strcpy:
    addi sp, sp, -8          # adjust stack for one more item
    sw   x19, 0(sp)          # save x19
    li   x19, 0              # i = 0
Loop:
    add  x5, x19, x11        # x5 = address of y[i] as chars are 1 byte so no shift required 
    lbu  x6, 0(x5)           # x6 = y[i]
    add  x7, x19, x10        # x7 = address of x[i]
    sb   x6, 0(x7)           # x[i] = y[i]   
    beq  x6, x0, Done        # if the byte = '\0', then done
    addi x19, x19, 1         # i++
    beq  x0, x0, Loop
Done:
    lw   x19, 0(sp)          # restore x19
    addi sp, sp, 8           # pop the stack
    jalr x0, 0(x1)           # return

End:
