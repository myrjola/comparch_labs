#!/bin/bash

set -e

# Exercise 3.3 Find out working set size for the benchmark programs.

for benchmark in equake vortex parser
do
    for cache_lines in 128 256 512 1024 2048 4096 8192 16384 32768 65536 131072 262144 524288 1048576
    do
        ASSOC=1 BENCHMARK=$benchmark CACHE_LINES=$cache_lines ./simics -stall -no-stc -c ${benchmark}.conf -no-win -q -p collect_cache_statistics.py
        ASSOC=4 BENCHMARK=$benchmark CACHE_LINES=$cache_lines ./simics -stall -no-stc -c ${benchmark}.conf -no-win -q -p collect_cache_statistics.py
    done
done
