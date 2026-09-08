.text
main:

    
    li x1, 5  # a = 5 
    li x2, 0 # b = 0
    addi x1, x2, 32   # a = b + 32
    add x3, x1, x2  # temp1 = a + b 
    addi x4, x3, -5  # d = (a+b)-5
    sub x5, x1, x4 # temp2 = a-d 
    sub x6, x2, x1 # temp3 = b-a
    add x7, x5, x6   # temp4 = (a-d)+(b-a)
    add x8, x7, x4   # e = (((a-d)+(b-a))+d)
    add x9, x1, x2   # x = a+b
    add x10, x4, x8  # y = d+e 
    add x8, x9, x10  # e = a+b+d+e 

end:
    j end 
