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

#include "lab1.5.h"

#if defined(__GNUC__) && defined(__SSE2__)
/** Macro to insert memory fences */
#define MFENCE() __builtin_ia32_mfence()
#else
#error Memory fence macros not implemented for this platform.
#endif

static volatile int flag[2] = { 0, 0 };
static volatile int turn = 0;

/**
 * Enter a critical section. Implementation using Dekker's algorithm.
 *
 * \param thread Thread ID, either 0 or 1.
 */
static void
impl_enter_critical(int thread)
{
        assert(thread == 0 || thread == 1);

        /* HINT: Since Dekker's algorithm only works for 2 threads,
         * with the ID 0 and 1, you may use !thread to get the ID the
         * other thread. */

        /* TASK: Implement entry code for Dekker's algorithm here */
}

/**
 * Exit from a critical section.
 *
 * \param thread Thread ID, either 0 or 1.
 */
static void
impl_exit_critical(int thread)
{
        assert(thread == 0 || thread == 1);

        /* TASK: Implement exit code for Dekker's algorithm here */
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
