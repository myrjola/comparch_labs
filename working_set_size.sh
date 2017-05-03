#!/bin/bash

# Exercise 3.3 Find out working set size for the benchmark programs.

echo "benchmark,cache_lines,read_hit_rate,write_hit_rate" > cache_statistics_excercise3.csv

for benchmark in vortex equake parser
do
    for cache_lines in 128 256 512 1024 2048 4096 8192 16384
    do
        BENCHMARK=$benchmark CACHE_LINES=$cache_lines ./simics -stall -no-stc -c ${benchmark}.conf -no-win -q -p collect_cache_statistics.py
    done
done
