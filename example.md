---
layout: default
title: Usage example
permalink: example.html
---

# Basic PARCOACH example

Let's take a look at a very basic MPI example to illustrate PARCOACH's usage:
```c
#include "mpi.h"

int main(int argc, char **argv) {
  int r;
  MPI_Init(&argc, &argv);
  MPI_Comm_rank(MPI_COMM_WORLD, &r);

  if (r % 2) {
    r++;
  } else {
    MPI_Barrier(MPI_COMM_WORLD);
  }

  MPI_Finalize();

  return 0;
}
```

In this example, not all processes call the `MPI_Barrier`, which will lead to a deadlock during the execution.
If needed you can download this example [here](./resources/mpi_example.c).

PARCOACH works on the LLVM Intermediate Representation (IR), therefore the first step would be to generate the IR, which can be done with a command like this:

```
clang mpi_example.c -I/usr/lib/x86_64-linux-gnu/openmpi/include -S -emit-llvm -g -O3
```

Compiling the example does require one flavour of MPI being installed, and you may have to adjust the `-I` flag to point to the appropriate `mpi.h` location.
The options `-S -emit-llvm` are used to generate a humanly-readable LLVM IR (the output will be emitted in the `mpi_example.ll` file), and the `-g` option is required to include the debug information in the IR.

For convenience we provide the corresponding IR file: [mpi_example.ll](./resources/mpi_example.ll); it can be used as-is for the following step.

Now that we have an IR file we can run PARCOACH on it, which is done with the following command:
```
parcoach -check=mpi mpi_example.ll
```
which gives the following output:
```
PARCOACH: mpi_example.c: warning: MPI_Barrier line 11 possibly not called by all processes because of conditional(s) line(s)  8 (mpi_example.c) (full-inter)
==========================================
===  PARCOACH INTER WITH DEP ANALYSIS  ===
==========================================
Module name: mpi_example.ll
2 collective(s) found
1 collective(s) conditionally called
1 warning(s) issued
1 cond(s)
1 different cond(s)
0 condition(s) added and 0 condition(s) removed with dep analysis.
0 warning(s) added and 0 warning(s) removed with dep analysis.
==========================================
```
