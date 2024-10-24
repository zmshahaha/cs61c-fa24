.globl argmax

.text
# =================================================================
# FUNCTION: Given a int array, return the index of the largest
#   element. If there are multiple, return the one
#   with the smallest index.
# Arguments:
#   a0 (int*) is the pointer to the start of the array
#   a1 (int)  is the # of elements in the array
# Returns:
#   a0 (int)  is the first index of the largest element
# Exceptions:
#   - If the length of the array is less than 1,
#     this function terminates the program with error code 36
# =================================================================
argmax:
    # Prologue
    bgt a1, zero, .Lstart
    li a0, 36
    j exit

.Lstart:
    li t3, 0  # curr index 
    li t0, 0  # max index
    lw t1, 0(a0) # max val
    addi t3, t3, 1
loop_start:
    bge t3, a1, loop_end
    addi a0, a0, 4
    lw t2, 0(a0) # current val
    ble t2, t1, .Lnext_loop
    mv t0, t3  # max index
    lw t1, 0(a0) # max val
.Lnext_loop:
    addi t3, t3, 1
    j loop_start

loop_end:
    # Epilogue
    mv a0, t0
    jr ra
