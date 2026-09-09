.text 
main:

    # Task is to add the elements of two arrays a and b and store the result in array c using the unrolling loop

    
    addi x18, x0, 0x100 # base address of array a = 0x100, stored in x18
    addi x19, x0, 0x200 # base address of array b = 0x100, stored in x19 
    addi x20, x0, 0x300 # base address of array c = 0x100, stored in x20

    # i = 0
    lb x1, 0(x18)
    lh x2, 0(x19)
    add x3, x1,x2
    sw x3, 0(x20)

    # i = 1
    lb x1, 1(x18)
    lh x2, 2(x19)
    add x3, x1,x2
    sw x3, 4(x20)

    # i = 2
    lb x1, 2(x18)
    lh x2, 4(x19)
    add x3, x1,x2
    sw x3, 8(x20)

    # i = 3
    lb x1, 3(x18)
    lh x2, 6(x19)
    add x3, x1,x2
    sw x3, 12(x20)

end: 
    j end 