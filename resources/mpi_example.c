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
