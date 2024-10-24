.globl matmul

.text
# =======================================================
# FUNCTION: Matrix Multiplication of 2 integer matrices
#   d = matmul(m0, m1)
# Arguments:
#   a0 (int*)  is the pointer to the start of m0
#   a1 (int)   is the # of rows (height) of m0
#   a2 (int)   is the # of columns (width) of m0
#   a3 (int*)  is the pointer to the start of m1
#   a4 (int)   is the # of rows (height) of m1
#   a5 (int)   is the # of columns (width) of m1
#   a6 (int*)  is the pointer to the the start of d
# Returns:
#   None (void), sets d = matmul(m0, m1)
# Exceptions:
#   Make sure to check in top to bottom order!
#   - If the dimensions of m0 do not make sense,
#     this function terminates the program with exit code 38
#   - If the dimensions of m1 do not make sense,
#     this function terminates the program with exit code 38
#   - If the dimensions of m0 and m1 don't match,
#     this function terminates the program with exit code 38
# =======================================================
# t0: loop iter of output row(outer iter)
# t1: loop iter of output col(inner iter)
# t2: loop iter of a data in a2
# t3: result
# t4: t5*t6 
# t5: a0 to mul
# t6: a3 to mul
# s0: pos in a0
# s1: pos in a3
# s2: pos in a6
matmul:

    # Error checks
    ble a1, zero, exit_38
    ble a2, zero, exit_38
    ble a4, zero, exit_38
    ble a5, zero, exit_38
    bne a2, a4, exit_38

    # Prologue
    li t0, 0
    li t1, 0

    addi sp, sp, -12
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)

outer_loop_start:
    # Check loop end condition
    beq t0, a1, outer_loop_end
    li t1, 0

inner_loop_start:
    beq t1, a5, inner_loop_end
    li t2, 0
    li t3, 0

data_loop_start:
    beq t2, a2, data_loop_end
    # pos in a0: a0[t0 * a2 + t2]
    mul s0, t0, a2
    add s0, s0, t2
    slli s0, s0, 2 # sizeof(int) = 4
    add s0, s0, a0
    lw t5, 0(s0)
    # pos in a3: a3[t1 + t2 * a5]
    mul s1, t2, a5
    add s1, s1, t1
    slli s1, s1, 2 # sizeof(int) = 4
    add s1, s1, a3
    lw t6, 0(s1)
    # t3 += t5*t6
    mul t4, t5, t6
    add t3, t3, t4
    # data loop
    addi t2, t2, 1
    j data_loop_start

data_loop_end:
    # pos in a6: a6[t1 + t0 * a5]
    mul s2, t0, a5
    add s2, s2, t1
    slli s2, s2, 2 # sizeof(int) = 4
    add s2, s2, a6
    sw t3, 0(s2)
    # inner loop
    addi t1, t1, 1
    j inner_loop_start

inner_loop_end:
    # outer loop
    addi t0, t0, 1
    j outer_loop_start

outer_loop_end:


    # Epilogue
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    addi sp, sp, 12
    li a0, 0

    jr ra

exit_38:
    li a0, 38
    j exit