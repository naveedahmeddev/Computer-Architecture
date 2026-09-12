.text
main:
<<<<<<< HEAD
    li x20, 5  # a = 5
    li x21, 0  # b = 0

    addi x20, x21, 32 # a = b + 32 

    add x22, x20, x21  # x22 = a + b 
    addi x23, x22, -5  # d = (a+b)-5

    sub x24, x20, x23  # x24 = a - d 
    sub x25, x21, x20  # x25 = b - a

    add x26, x24, x25 # x26 = ((a-d)+(b-a))
    add x27, x26, x23 # e = (((a-d)+(b-a)) + d) 

    add x28, x20, x21   # x28 = a + b 
    add x28, x28, x23   # x28 = a + b + d
    add x28, x28, x27   # x28 = a + b + d + e
    
    
=======

    
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

>>>>>>> e243539c751542c66bbb0fa7575aa36bf20c89d5
end:
    j end 
