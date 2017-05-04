#!/bin/bash

set -e

# Exercise 3.3 Find out working set size for the benchmark programs.

for benchmark in parser
do
    for cache_lines in 1048576
    do
        ASSOC=1 BENCHMARK=$benchmark CACHE_LINES=$cache_lines ./simics -stall -no-stc -c ${benchmark}.conf -no-win -q -p collect_cache_statistics.py
        ASSOC=4 BENCHMARK=$benchmark CACHE_LINES=$cache_lines ./simics -stall -no-stc -c ${benchmark}.conf -no-win -q -p collect_cache_statistics.py
    done
done
