.globl read_matrix

.text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#
# FILE FORMAT:
#   The first 8 bytes are two 4 byte ints representing the # of rows and columns
#   in the matrix. Every 4 bytes afterwards is an element of the matrix in
#   row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is a pointer to an integer, we will set it to the number of rows
#   a2 (int*)  is a pointer to an integer, we will set it to the number of columns
# Returns:
#   a0 (int*)  is the pointer to the matrix in memory
# Exceptions:
#   - If malloc returns an error,
#     this function terminates the program with error code 26
#   - If you receive an fopen error or eof,
#     this function terminates the program with error code 27
#   - If you receive an fclose error or eof,
#     this function terminates the program with error code 28
#   - If you receive an fread error or eof,
#     this function terminates the program with error code 29
# ==============================================================================
# t0
read_matrix:

    # Prologue
    addi sp, sp, -24
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    sw s2, 12(sp)
    sw s3, 16(sp)
    sw s4, 20(sp)

    # s1 store row/col addr
    mv s1, a1
    mv s2, a2

    # open
    li a1, 0
    jal fopen
    blt a0, zero, error_fopen

    # s0 store fd
    mv s0, a0

    # read row
    mv a1, s1
    li a2, 4
    jal fread
    li t0, 4
    bne a0, t0, error_fread

    # read col
    mv a0, s0
    mv a1, s2
    li a2, 4
    jal fread
    li t0, 4
    bne a0, t0, error_fread

    # s3 store size
    lw t1, 0(s1)
    lw t2, 0(s2)
    mul s3, t1, t2
    slli s3, s3, 2

    # malloc
    mv a0, s3
    jal malloc
    beq a0, zero, error_malloc
    # s4 store buffer
    mv s4, a0

    # read 
    mv a0, s0
    mv a1, s4
    mv a2, s3
    jal fread
    bne a0, s3, error_fread

    # close
    mv a0, s0
    jal fclose
    bne a0, zero, error_fclose

    # return val
    mv a0, s4

    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)
    lw s3, 16(sp)
    lw s4, 20(sp)
    addi sp, sp, 24

    jr ra

error_malloc:
    li a0, 26
    j exit

error_fopen:
    li a0, 27
    j exit

error_fclose:
    li a0, 28
    j exit

error_fread:
    li a0, 29
    j exit