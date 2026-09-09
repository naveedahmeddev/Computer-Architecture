.text 
main:
    # Assume that the variables x, a, b & c are signed integers and stored in x20, x21, x22, x23 respectively
    # x28 = 1, x29 = 2, x30 = 3, x31 = 4
    li x28, 1
    li x29, 2
    li x30, 3
    li x31, 4
    # assigning 2 to b and 3 to c
    li x22, 2
    li x23, 3

    # assigning x = 1
    li x20, 1

    beq x20, x28, Case1
    beq x20, x29, Case2
    beq x20, x30, Case3
    beq x20, x31, Case4

    beq x0, x0, Default

Case1:
    add x21, x22, x23
    beq x0, x0, Exit  

Case2:
    sub x21, x22, x23
    beq x0, x0, Exit
Case3:
    slli x21, x22, 1
    beq x0, x0, Exit
Case4:
    srli x21, x22, 1
    beq x0, x0, Exit
Default: 
    li x21, 0
    beq x0, x0, Exit

Exit: 
