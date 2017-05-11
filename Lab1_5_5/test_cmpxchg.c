/**
 * Implementation of test cases using atomic and non-atomic cmpxchg.
 *
 *
 * Course: Advanced Computer Architecture, Uppsala University
 * Course Part: Lab assignment 2
 *
 * Author: Andreas Sandberg <andreas.sandberg@it.uu.se>
 *
 * $Id: test_cmpxchg.c 1009 2011-07-28 15:02:57Z ansan501 $
 */

#include "lab1.5.h"

#include "lab1.5_asm.h"

static void
increase(int thread, int iterations, volatile int *data)
{
        /* TASK: Implement a loop that increments *data by 1 using
         * non-atomic compare and exchange instructions. See lab2_asm.h.
         */
}

static void
decrease(int thread, int iterations, volatile int *data)
{
        /* TASK: Implement a loop that decrements *data by 1 using
         * non-atomic compare and exchange instructions. See lab2_asm.h.
         */
}


static void
increase_atomic(int thread, int iterations, volatile int *data)
{
        /* TASK: Implement a loop that increments *data by 1 using
         * atomic compare and exchange instructions. See lab2_asm.h.
         */
}

static void
decrease_atomic(int thread, int iterations, volatile int *data)
{
        /* TASK: Implement a loop that decrements *data by 1 using
         * atomic compare and exchange instructions. See lab2_asm.h.
         */
}

test_impl_t test_impl_cmpxchg_no_atomic = {
        .name = "cmpxchg_no_atomic",
        .desc = "Modify a shared variable using compare and exchange",

        .num_threads = 2,
        .test = { &increase, &decrease }
};

test_impl_t test_impl_cmpxchg_atomic = {
        .name = "cmpxchg_atomic",
        .desc = "Modify a shared variable using atomic compare and exchange",

        .num_threads = 2,
        .test = { &increase_atomic, &decrease_atomic }
};

/*
 * Local Variables:
 * mode: c
 * c-basic-offset: 8
 * indent-tabs-mode: nil
 * c-file-style: "linux"
 * End:
 */

