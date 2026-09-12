.text
main:
    # a = x5, b = x6 , i = x7, j = x29
    li x5, 2
    li x6, 2 
    li x7, 0
    li x29, 0
Outerloop: 
    bge x7, x5, Exit
    beq x0, x0, InnerLoop
    InnerLoop: 
        bge x29, x6, Increment_i
        slli x29, x29, 2   # 4*j 
        add x28, x7, x29  # i+ j 
        sw x28 , 0(x29)
        addi x29, x29, 1   # j ++ 
        beq x0,x0, InnerLoop
    
Increment_i: 
    li x29, 0
    addi x7, x7, 1   # i++ 
    beq x0, x0, Outerloop

Exit:
