#include "ex2.h"

double dotp_naive(double* x, double* y, int arr_size) {
    double global_sum = 0.0;
    for (int i = 0; i < arr_size; i++)
        global_sum += x[i] * y[i];
    return global_sum;
}

// Critical Keyword
double dotp_critical(double* x, double* y, int arr_size) {
    double global_sum = 0.0;
    // TODO: Implement this function
    // Use the critical keyword here!

    // Parallel for loop with a critical section to update global_sum
    #pragma omp parallel for
    for (int i = 0; i < arr_size; i++) {
        // Each thread computes a partial sum, but only one thread
        // can update global_sum at a time
        #pragma omp critical
        {
            global_sum += x[i] * y[i];
        }
    }
    return global_sum;
}

// Reduction Keyword
double dotp_reduction(double* x, double* y, int arr_size) {
    double global_sum = 0.0;
    // TODO: Implement this function
    // Use the reduction keyword here!

    // Parallel for loop with reduction on global_sum
    #pragma omp parallel for reduction(+:global_sum)
    for (int i = 0; i < arr_size; i++) {
        global_sum += x[i] * y[i];
    }
    return global_sum;
}

// Manual Reduction
double dotp_manual_reduction(double* x, double* y, int arr_size) {
    double global_sum = 0.0;
    // TODO: Implement this function
    // Do NOT use the `reduction` directive here!

    #pragma omp parallel
    {
        // Each thread has a private partial sum
        double local_sum = 0.0;

        // Each thread calculates its partial dot product
        #pragma omp for
        for (int i = 0; i < arr_size; i++) {
            local_sum += x[i] * y[i];
        }

        // Critical section to safely update the global sum
        #pragma omp critical
        {
            global_sum += local_sum;
        }
    }

    return global_sum;
}
