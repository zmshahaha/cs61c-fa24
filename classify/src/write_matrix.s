.globl write_matrix

.text
# ==============================================================================
# FUNCTION: Writes a matrix of integers into a binary file
# FILE FORMAT:
#   The first 8 bytes of the file will be two 4 byte ints representing the
#   numbers of rows and columns respectively. Every 4 bytes thereafter is an
#   element of the matrix in row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is the pointer to the start of the matrix in memory
#   a2 (int)   is the number of rows in the matrix
#   a3 (int)   is the number of columns in the matrix
# Returns:
#   None
# Exceptions:
#   - If you receive an fopen error or eof,
#     this function terminates the program with error code 27
#   - If you receive an fclose error or eof,
#     this function terminates the program with error code 28
#   - If you receive an fwrite error or eof,
#     this function terminates the program with error code 30
# ==============================================================================
write_matrix:

    # Prologue
    addi sp, sp, -24
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw s3, 12(sp)
    sw s4, 16(sp)
    sw ra, 20(sp)

    # matrix buffer
    mv s1, a1
    mv s2, a2
    mv s3, a3

    # open
    li a1, 1
    jal fopen
    blt a0, zero, error_fopen
    # s0 is fd
    mv s0, a0

    # alloc mem to store row/col
    li a0, 8
    jal malloc
    beq a0, zero, error_malloc
    sw s2, 0(a0)
    sw s3, 4(a0)

    # write row/col
    mv a1, a0 # now a0 is row/col buf
    mv a0, s0 # now a0 is fd
    li a2, 2
    li a3, 4
    jal fwrite
    li t0, 2
    bne a0, t0, error_fwrite

    # write data
    mv a0, s0
    mv a1, s1
    mul s4, s2, s3
    mv a2, s4
    li a3, 4
    jal fwrite
    bne a0, s4, error_fwrite

    # close
    mv a0, s0
    jal fclose
    bne a0, zero, error_fclose








    # Epilogue
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    lw ra, 20(sp)
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

error_fwrite:
    li a0, 30
    j exit