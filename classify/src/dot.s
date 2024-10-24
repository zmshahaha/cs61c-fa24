.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int arrays
# Arguments:
#   a0 (int*) is the pointer to the start of arr0
#   a1 (int*) is the pointer to the start of arr1
#   a2 (int)  is the number of elements to use
#   a3 (int)  is the stride of arr0
#   a4 (int)  is the stride of arr1
# Returns:
#   a0 (int)  is the dot product of arr0 and arr1
# Exceptions:
#   - If the number of elements to use is less than 1,
#     this function terminates the program with error code 36
#   - If the stride of either array is less than 1,
#     this function terminates the program with error code 37
# =======================================================
dot:
    # check exceptions
    ble a2, zero, exit_36
    ble a3, zero, exit_37
    ble a4, zero, exit_37
    # Prologue
	addi sp, sp, -12
    # init values
    slli a3, a3, 2 # array0's stride
    slli a4, a4, 2 # array1's stride
    li t2, 0 # i = 0
    li t0, 0 # sum = 0
loop_start:
	lw t1 0(a0) # iter of a0
    lw t4, 0(a1) # iter of a1
    mul t3, t1, t4
    add t0, t0, t3
	addi t2, t2, 1
    beq t2, a2, loop_end
    add a0, a0, a3
    add a1, a1, a4
    j loop_start
loop_end:
	mv a0, t0
    # Epilogue
    addi sp, sp, 12
    ret

exit_36:
	li a0, 36
    j exit
   
exit_37:
    li a0, 37
    j exit