#!/bin/bash

set -e

# Exercise 3.6 Brute force best cache settings for gemm benchmark

# for l2_replacement_policy in lru random cyclic
# do
#     for l1_replacement_policy in lru random cyclic
#     do
        for l1d_cache_lines in 1 2 4 8 16
        do
            for l1i_cache_lines in 1 2 4 8
            do
                for l2_cache_lines in 4 8 16 32
                do
                    for l1d_cache_size in 16 32 64
                    do
                        for l1d_cache_assoc in 4
                        do
                            for l2_cache_assoc in 1
                            do
                                # L2_REPLACEMENT_POLICY=$l2_replacement_policy \
                                # L1_REPLACEMENT_POLICY=$l1_replacement_policy \
                                time \
                                    L2_CACHE_LINES=$l2_cache_lines \
                                    L1D_CACHE_LINES=$l1d_cache_lines \
                                    L1I_CACHE_LINES=$l1i_cache_lines \
                                    L1D_CACHE_SIZE=$l1d_cache_size \
                                    L1D_CACHE_ASSOC=$l1d_cache_assoc \
                                    L2_CACHE_ASSOC=$l2_cache_assoc \
                                    ./simics -stall -no-stc -c gemm.conf \
                                    -no-win -q -p Lab1_3-6/gemm_cache.py
                            done
                        done
                    done
                done
            done
        done
#     done
# done
