.text
main:
    # a = x5, b = x6, i = x7, j = x29, x10 = base of D
    li x10, 0x10000000        # base address of D
    li x5, 3               # a = 3
    li x6, 4               # b = 4
    li   x7, 0               # i = 0
OuterLoop:
    bge  x7, x5, Exit        # i >= a -> done
    li   x29, 0              # j = 0
InnerLoop:
    bge  x29, x6, Increment_I       # j >= b -> next i
    slli x28, x29, 4         # x28 = 16*j  (index 4*j, times 4 bytes/element)
    add  x28, x10, x28       # x28 = address of D[4*j]
    add  x30, x7, x29        # x30 = i + j
    sw   x30, 0(x28)         # D[4*j] = i + j
    addi x29, x29, 1         # j++
    beq  x0, x0, InnerLoop
Increment_I:
    addi x7, x7, 1           # i++
    beq  x0, x0, OuterLoop
Exit:
