# This function computes greatest common divisor between two integers. 
# frame size: 0 (callee leaf-function does not need a frame)
# arguments: a0 <-> a, a1 <-> b
# return value: a0 <-> a
# register convention: t0 <-> temp
.text
.globl gcd
gcd:
        j    W1                         # jumps to W1
L1:     add  t0, zero, a1               # temp <- b
        rem  a1, a0, a1                 # b <- a % b
        add  a0, zero, t0               # a <- temp
W1:     bne  a1, zero, L1               # branches to L1 if b != 0
        add  a0, zero, a0               # a0 <- a
        jr   ra                         # return to caller

# This function computes greatest common divisor between n integers. 
# frame size: 48 bytes
#             - 16 bytes to back ra and fp up
#             - 16 bytes to back g and i local variables up 
#             - 16 bytes to back a0 and a1 up
# arguments: a0 <-> *a, a1 <-> size
# return value: a0 <-> g
# register convention: Use as few temporal registers as possible
.text
.globl n_gcd
n_gcd:
        addi sp, sp, -48                # updates sp
        sw   ra, 48(sp)                 # backs ra up
        sw   fp, 44(sp)                 # backs fp up
        addi fp, sp, 48                 # updates fp
        # int g = a[0];
        lw   t0, 0(a0)                  # t0 <- a[0]
        sw   t0, -16(fp)                # g <- t0
        # int i = 1;
        addi t0, zero, 1
        sw   t0, -20(fp)
        # for body
        j    F1
        # call function
L2:     sw   a1, -32(fp)                # backs a1 up
        sw   a0, -36(fp)                # backs a0 up
        lw   t0, -36(fp)                # t0 <- *a 
        lw   t1, -20(fp)                # t1 <- i
        slli t1, t1, 2                  # t1 <- 4*i
        add  t0, t0, t1                 # t0 <- *a + 4*i
        lw   a1, 0(t0)                  # a1 <- a[i]
        lw   a0, -16(fp)                # a0 <- g
        jal  gcd                        # calls gcd function
        sw   a0, -16(fp)                # g <- a0
        lw   a1, -32(fp)                # restores a1
        lw   a0, -36(fp)                # restores a0
        # i++;
        lw   t0, -20(fp)                # t0 <- i
        addi t0, t0, 1                  # t0 < t0 + 1
        sw   t0, -20(fp)                # i <- t0
        # loop condition
F1:     lw   t0, -20(fp)                # t0 <- i
        blt  t0, a1, L2                 # branches to L1 if i < size
        # return g
        lw   a0, -16(fp)                # a0 <- g
        lw   ra, 48(sp)                 # restores return address
        lw   fp, 44(sp)                 # restores frame pointer
        addi sp, sp, 48                # frees function frame
        jr   ra                         # return to caller

# TMain function. 
# frame size: 48 bytes
#             - 16 bytes to back ra and fp up
#             - 32 bytes to back local variables up 
# return value: a0 <-> 0
# register convention: Use as few temporal registers as possible
.text
.globl main
main:
        addi sp, sp, -48                # updates sp
        sw   ra, 48(sp)                 # backs ra up
        sw   fp, 44(sp)                 # backs fp up
        addi fp, sp, 48                 # updates fp
        # int a[6] = {416, 52, 208, 26, 13, 832};
        addi t0, fp, -36                # computes array's base address
        addi t1, zero, 416              # t1 <- 416
        sw   t1, 0(t0)                  # a[0] <- t1
        addi t1, zero, 52               # t1 <- 52
        sw   t1, 4(t0)                  # a[1] <- t1
        addi t1, zero, 208              # t1 <- 208
        sw   t1, 8(t0)                  # a[2] <- t1
        addi t1, zero, 26               # t1 <- 26
        sw   t1, 12(t0)                 # a[3] <- t1
        addi t1, zero, 13               # t1 <- 13
        sw   t1, 16(t0)                 # a[4] <- t1
        addi t1, zero, 832              # t1 <- 832
        sw   t1, 20(t0)                 # a[4] <- t1
        # int g = n_gcd(a, 6);
        # call function
        addi a1, zero, 6                # a1 <- 6
        addi a0, fp, -36                # a0 <- *a
        jal  n_gcd                      # calls n_gcd function
        sw   a0, -40(fp)                # g <- a0
        # return 0
        addi a0, zero, 0                # a0 <- 0
        lw   ra, 48(sp)                 # restores return address
        lw   fp, 44(sp)                 # restores frame pointer
        addi sp, sp, 48                 # frees function frame
        jr   ra                         # returns control to OS

