

# PARCOACH SPECIFIC
PARCOACH_DIR=$(PWD)/../../
PARCOACH_PASS_DIR=${PARCOACH_DIR}/build/lib
PARCOACH_DYNLIB_DIR=${PARCOACH_DIR}/src/lib

#PASSLIB=LLVMaSSA.so
PASSLIB=LLVMaSSA.dylib #MACOS

REQUIREDPASS = -postdomtree
PASS = -parcoach --check-mpi -compare-all -no-dataflow 
# see the documentation for possible PARCOACH analyses


MPI_INC = -I/opt/local/include/mpich-mp/
MPI_LIB = -lmpi -Wl,-L/opt/local/lib/mpich-mp/

CFLAGS = $(MPI_INC) 
LDFLAGS = $(MPI_LIB)


MPICC=mpicc
MPIRUN=mpirun
CC=clang
CXX=clang++
OPT=opt
LLVMDIS=llvm-dis
LLVMLINK=llvm-link



SRC=main.c func.c

EXEC=test_parcoach 
		

MPI_PROCS=4

LLFILES = $(SRC:.c=.ll)
LLREGFILES = $(SRC:.c=-reg.bc)
LLREGDIS = $(SRC:.c=-reg.ll)


all: $(EXEC)



$(LLFILES) : %.ll : %.c
	$(CC) -g -S -emit-llvm $^ $(CFLAGS)

$(LLREGFILES): %-reg.bc : %.ll
	$(OPT) -mem2reg < $^ > $@

$(LLREGDIS): %-reg.ll : %-reg.bc
	$(LLVMDIS) $^
	

merge.bc: $(LLREGFILES)
	$(LLVMLINK) -v $^ -o $@
	$(OPT) -load $(PARCOACH_PASS_DIR)/$(PASSLIB) $(REQUIREDPASS) $(PASS) < merge.bc > ./merge_parcoach.bc
	llvm-dis -o merge-readable.ll merge_parcoach.bc
	@echo "===> See Parcoach modifications in merge-readable.ll <==="

$(EXEC): $(LLFILES) $(LLREGFILES) $(LLREGDIS) merge.bc 
	$(MPICC) $(CFLAGS) -c $(PARCOACH_DYNLIB_DIR)/MPI_DynamicCheck.c -DDEBUG
	$(CC) -c merge_parcoach.bc
	$(MPICC) merge_parcoach.o  MPI_DynamicCheck.o -o $@ $(LDFLAGS)






###########################################
## ONE DETAILED COMPILATION WITH PARCOACH #
###########################################


example-parcoach: example.c
	@echo "  COMPILING MPI_DynamicCheck.c ..."
	$(MPICC) $(CFLAGS) -c $(PARCOACH_DYNLIB_DIR)/MPI_DynamicCheck.c #-DDEBUG
	@echo "  COMPILING $@ with PARCOACH ..."
	$(CC) -g -emit-llvm -c -o example.bc  $^ $(CFLAGS)
	$(OPT) -load $(PARCOACH_PASS_DIR)/$(PASSLIB) $(REQUIREDPASS) $(PASS) < example.bc > ./example_checked.bc
	$(LLVMDIS) -o example_checked-readable.ll example_checked.bc
	@echo "===> See Parcoach modifications in example_checked-readable.ll <==="
	$(CC) -c example_checked.bc
	$(MPICC) example_checked.o MPI_DynamicCheck.o -o $@ $(LDFLAGS)

## COMPILATION WITHOUT PARCOACH

example: example.c
	$(MPICC) -o $@ $^ $(LDFLAGS)



#######
# RUN #
#######

run:
	$(MPIRUN) -np $(MPI_PROCS) ./$(EXEC)

#########
# CLEAN #
#########

clean:
	rm -rf *.o rm -rf *.ll
	rm -rf *.bc
	rm -rf *.dot
	rm -rf $(EXEC)
