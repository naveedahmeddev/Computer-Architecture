.text 
main:

# Listing 3 
# assuming that variables f to j are in registers x19-x23
    bne x22, x23, Else
    add x19, x20, x21
    beq x0, x0, Exit1     # unconditional jump
Else: sub x19, x20, x21
Exit1: 

# Listing 4 
# assuming i and k in x22 and x24, and the base address of Save in x25
Loop: slli x10, x22, 2    # Temp reg x10 = i * 4
    add x10, x10, x25     # x10 = address of save[i]
    lw x9, 0(x10)         # Temp reg x9 = save[i]
    bne x9, x24, Exit2    # go to Exit2 if save[i] != k
    addi x22, x22, 1      # i = i + 1
    beq x0, x0, Loop      # go to Loop
Exit2: 
