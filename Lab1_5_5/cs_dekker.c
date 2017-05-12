/**
 * Experimenting with synchronization and memory consistency. Dekker's
 * algorithm version of critical sections.
 *
 * 
 * Course: Advanced Computer Architecture, Uppsala University
 * Course Part: Lab assignment 2
 *
 * Author: Andreas Sandberg <andreas.sandberg@it.uu.se>
 *
 * $Id: cs_dekker.c 1009 2011-07-28 15:02:57Z ansan501 $
 */

#include <assert.h>
#include <stdbool.h>
#include <stdio.h>

#include "lab1.5.h"

#if defined(__GNUC__) && defined(__SSE2__)
/** Macro to insert memory fences */
#define MFENCE() __builtin_ia32_mfence()
#else
#error Memory fence macros not implemented for this platform.
#endif

static volatile int flag[2] = {false, false};
static volatile int turn = 0;

/**
 * Enter a critical section. Implementation using Dekker's algorithm.
 *
 * \param thread Thread ID, either 0 or 1.
 */
static void
impl_enter_critical(int thread) {
    assert(thread == 0 || thread == 1);

    /* HINT: Since Dekker's algorithm only works for 2 threads,
     * with the ID 0 and 1, you may use !thread to get the ID the
     * other thread. */

    /* TASK: Implement entry code for Dekker's algorithm here */

    if(thread == 0){
        flag[0] = true;
        while(flag[1]){
            if(turn != 0){
                flag[0] = false;
                while(turn != 0){
                    //Busy wait
                    printf("0\n");
                }
                flag[0] = true;
            }
        }
    }
    if(thread == 1){
        flag[1] = true;
        while(flag[0]){
            if(turn != 1){
                flag[1] = false;
                while(turn != 1){
                    //Busy wait
                    printf("1\n");
                }
                flag[1] = true;
            }
        }
    }
}

/**
 * Exit from a critical section.
 *
 * \param thread Thread ID, either 0 or 1.
 */
static void
impl_exit_critical(int thread) {
    assert(thread == 0 || thread == 1);
    /* TASK: Implement exit code for Dekker's algorithm here */
    if(thread == 0){
        turn = 1;
        flag[0] = false;
    }
    if(thread == 1){
        turn = 0;
        flag[1] = false;
    }

}


critical_section_impl_t cs_impl_dekker = {
        .name = "dekker",
        .desc = "Dekker's algorithm",

        .max_threads = 2,

        .enter = &impl_enter_critical,
        .exit = &impl_exit_critical
};

/*
 * Local Variables:
 * mode: c
 * c-basic-offset: 8
 * indent-tabs-mode: nil
 * c-file-style: "linux"
 * End:
 */
