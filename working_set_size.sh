#!/bin/bash

# Exercise 3.3 Find out working set size for the benchmark programs.

BENCHMARK=vortex

for cache_lines in 128 256 512 1024 2048
do
    CACHE_LINES=$cache_lines ./simics -stall -no-stc -c ${BENCHMARK}.conf -no-win -q -p collect_cache_statistics.py
done
