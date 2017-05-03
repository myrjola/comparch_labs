#!/bin/bash

# Exercise 3.3 Find out working set size for the benchmark programs.

BENCHMARK=vortex

for CACHE_LINES in 128 256 512 1024 2048
do
    ./simics -stall -no-stc -c ${BENCHMARK}.conf -no-win -q -p collect_cache_statistics.py
done
