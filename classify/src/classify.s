.globl classify

.text
# =====================================
# COMMAND LINE ARGUMENTS
# =====================================
# Args:
#   a0 (int)        argc
#   a1 (char**)     argv
#   a1[1] (char*)   pointer to the filepath string of m0
#   a1[2] (char*)   pointer to the filepath string of m1
#   a1[3] (char*)   pointer to the filepath string of input matrix
#   a1[4] (char*)   pointer to the filepath string of output file
#   a2 (int)        silent mode, if this is 1, you should not print
#                   anything. Otherwise, you should print the
#                   classification and a newline.
# Returns:
#   a0 (int)        Classification
# Exceptions:
#   - If there are an incorrect number of command line args,
#     this function terminates the program with exit code 31
#   - If malloc fails, this function terminates the program with exit code 26
#
# Usage:
#   main.s <M0_PATH> <M1_PATH> <INPUT_PATH> <OUTPUT_PATH>
classify:
    li t0, 5
    bne a0, t0, error_argc

    addi sp, sp, -40
    sw s1, 0(sp)
    sw s2, 4(sp)
    sw s3, 8(sp)
    sw s4, 12(sp)
    sw s5, 16(sp)
    sw s6, 20(sp)
    sw s7, 24(sp)
    sw s8, 28(sp)
    sw s9, 32(sp)
    sw ra, 36(sp)

    mv s1, a1
    mv s2, a2

    # malloc row/col
    # [m0[row,col], m1[], input[], output[]]
    li a0, 32
    jal malloc
    beq a0, zero, error_malloc
    # s3 is row/col buf
    mv s3, a0

    # Read pretrained m0
    lw a0, 4(s1)
    addi a1, s3, 0
    addi a2, s3, 4
    jal read_matrix
    # s4 is m0
    mv s4, a0

    # Read pretrained m1
    lw a0, 8(s1)
    addi a1, s3, 8
    addi a2, s3, 12
    jal read_matrix
    # s5 is m1
    mv s5, a0

    # Read input matrix
    lw a0, 12(s1)
    addi a1, s3, 16
    addi a2, s3, 20
    jal read_matrix
    # s6 is input
    mv s6, a0

    # Compute h = matmul(m0, input)
    lw t0, 0(s3)
    lw t1, 20(s3)
    mul t0, t0, t1
    slli a0, t0, 2
    jal malloc
    beq a0, zero, error_malloc
    mv s7, a0
    # s7 is m0*input
    mv a0, s4
    lw a1, 0(s3)
    lw a2, 4(s3)
    mv a3, s6
    lw a4, 16(s3)
    lw a5, 20(s3)
    mv a6, s7
    jal matmul

    # Compute h = relu(h)
    mv a0, s7
    lw t0, 0(s3)
    lw t1, 20(s3)
    mul a1, t0, t1
    jal relu

    # Compute o = matmul(m1, h)
    lw t0, 8(s3)
    lw t1, 20(s3)
    mul t0, t0, t1
    slli a0, t0, 2
    jal malloc
    beq a0, zero, error_malloc
    mv s8, a0
    # s8 is o
    mv a0, s5
    lw a1, 8(s3)
    lw a2, 12(s3)
    mv a3, s7
    lw a4, 0(s3)
    lw a5, 20(s3)
    mv a6, s8
    jal matmul

    # Write output matrix o
    lw a0, 16(s1)
    mv a1, s8
    lw a2, 8(s3)
    lw a3, 20(s3)
    jal write_matrix

    # Compute and return argmax(o)
    mv a0, s8
    lw t0, 8(s3)
    lw t1, 20(s3)
    mul a1, t0, t1
    jal argmax
    # s9 is result
    mv s9, a0

    # If enabled, print argmax(o) and newline
    bne s2, zero, classify_return
    jal print_int
    li a0, '\n'
    jal print_char
    mv a0,s9

classify_return:
    lw s1, 0(sp)
    lw s2, 4(sp)
    lw s3, 8(sp)
    lw s4, 12(sp)
    lw s5, 16(sp)
    lw s6, 20(sp)
    lw s7, 24(sp)
    lw s8, 28(sp)
    lw s9, 32(sp)
    lw ra, 36(sp)
    addi sp, sp, 40

    jr ra

error_argc:
    li a0, 31
    j exit

error_malloc:
    li a0, 26
    j exit
