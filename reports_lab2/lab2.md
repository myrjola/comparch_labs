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
IPC below 0.1.

| Benchmark | Instructions per cycle |
|-----------|------------------------|
| vortex    |              0.0847821 |
| parser    |              1.1425188 |
| equake    |              1.9896457 |
: Instructions per cycle performance for the benchmarks {#tbl:ipc_stats}

Bibliography
============

<!-- The bibliography gets populated here automatically thanks to
pandoc-citeproc. -->
