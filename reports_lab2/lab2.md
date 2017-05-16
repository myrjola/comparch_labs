---
title: Laboratory 2
author:
- Yrkkö Äkkijyrkkä <yrkko@kth.se>
- Martin Yrjölä <yrjola@kth.se>
bibliography: references.bib
output: pdf_document
---

Introduction
============

We have been collaborating with a group of other students to automate the Simics
benchmarking in the git repository published at
https://github.com/myrjola/comparch_labs. The data used for our figures and
tables and the code to generate them are published in the same repository. The
majority of the lab time has been spent developing the automation and doing data
gathering. We have discussed our findings actively with the repository
collaborators, but also took care to conduct our own benchmarks and write our
own analysis.

2.3 Collecting IPC statistics using the MAI
===========================================

The recorded IPCs of each benchmark is presented in @tbl:ipc_stats. The equake
benchmark has the highest IPC of almost 2 and the vortex benchmark has the worst
IPC of under 0.9.

| Benchmark | Instructions per cycle |
|-----------|------------------------|
| vortex    |              0.8933801 |
| parser    |              1.1425188 |
| equake    |              1.9896457 |
: Instructions per cycle performance for the benchmarks {#tbl:ipc_stats}

2.5 Collecting data about the effect of memory latency on OoO efficiency
========================================================================

We chose the equake benchmark for this task. The IPC statistics for different
penalties is given in @tbl:ipc_penalty_stats. We can clearly see that increasing
the penalties will have a negative impact on performance. The impact of
increasing cache penalty is higher than that of increasing the memory penalty.
The results suggest that out-of-order processing masks small penalties very well
because it's likely there is always a couple of instructions not dependent on
the load instructions. Once the penalties get long enough the cpu starts
stalling to wait on the memory transactions to finish.

| Read penalty | Write penalty | Memory penalty | Instructions per cycle |
|--------------|---------------|----------------|------------------------|
|            1 |             1 |             10 |              1.9979500 |
|            2 |             2 |             10 |              1.6909622 |
|            5 |             5 |             10 |              1.2146641 |
|            1 |             1 |             20 |              1.8118661 |
|            1 |             1 |             50 |              1.4248578 |
: IPC performance for the equake benchmark with different penalties {#tbl:ipc_penalty_stats}

Bibliography
============

<!-- The bibliography gets populated here automatically thanks to
pandoc-citeproc. -->
