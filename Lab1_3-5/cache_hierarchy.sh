#!/bin/bash

set -e

# Exercise 3.3 Find out working set size for the benchmark programs.

for benchmark in equake vortex parser
do
    for cache_lines in 64 4096 8192
    do
        BENCHMARK=$benchmark CACHE_LINES=$cache_lines ./simics -stall -no-stc -c ${benchmark}.conf -no-win -q -p Lab1_3-5/cache_hierarchy.py
    done
done
