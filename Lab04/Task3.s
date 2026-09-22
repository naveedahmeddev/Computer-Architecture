.text
main:
    li x10, 0x1000  # a = base address       
    li x11, 4 # len = 4              

    beq x10, x0, exit # if (a == NULL) return
    beq x11, x0, exit  # if (len == 0)  return

    li x5, 0  # i = 0

Loop_I:
    bgeu x5, x11, exit   # if (i >= len) done      
    slli x6, x5, 2      # i * 4
    add  x7, x10, x6   # x7 = &a[i]
    lw   x8, 0(x7)   # x8 = a[i]
    addi x28, x5, 0    # j = i                 

Loop_J:
    bgeu x28, x11, Next_I   # if (j >= len) end inner loop 
    slli x29, x28, 2    # j * 4
    add x30, x10, x29    # x30 = &a[j]
    lw  x31, 0(x30)  # x31 = a[j]
    bge x8, x31, No_Swap   # if (a[i] >= a[j]) skip  
    sw   x31, 0(x7)  # a[i] = a[j]
    sw   x8,  0(x30)      # a[j] = temp
    addi x8,  x31, 0    # x8 = a[j] which is the new value of a[i] after swap

No_Swap:
    addi x28, x28, 1 # j++
    beq  x0, x0, Loop_J

Next_I:
    addi x5, x5, 1 # i++                 
    beq  x0, x0, Loop_I

exit:
   