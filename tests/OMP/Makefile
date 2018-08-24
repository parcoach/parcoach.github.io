
# OpenMP SPECIFIC
OMP_DIR=$(HOME)/Documents/TOOLS/LLVM_391/build
OMP_INC=$(OMP_DIR)/projects/openmp/runtime/src/
OMP_LIB=$(OMP_DIR)/lib/

CFLAGS= -fopenmp=libomp -I$(OMP_INC) 
LDFLAGS= -fopenmp=libomp -I$(OMP_INC) -L $(OMP_LIB) -Wl,-rpath,$(OMP_LIB)/libomp.dylib 


# PARCOACH SPECIFIC
PARCOACH_DIR=$(PWD)/../../
PARCOACH_PASS_DIR=${PARCOACH_DIR}/build/lib
PARCOACH_DYNLIB_DIR=${PARCOACH_DIR}/src/lib

#PASSLIB=LLVMaSSA.so 
PASSLIB=LLVMaSSA.dylib # MACOS 
REQUIREDPASS= -postdomtree -loweratomic
PASS=-parcoach --check-omp

CC=clang
CXX=clang++
OPT=opt
LLVMDIS=llvm-dis
LLVMLINK=llvm-link


# Program to test
SRC=example.c
EXEC=test_parcoach

LLFILES = $(SRC:.c=.ll)
LLREGFILES = $(SRC:.c=-reg.bc)
LLREGDIS = $(SRC:.c=-reg.ll)
EXECREGFILES = $(SRC:.c=-reg.o)

all: $(EXEC)




$(LLFILES) : %.ll : %.c
	$(CC) -g -S -emit-llvm $^ $(CFLAGS)

$(LLREGFILES): %-reg.bc : %.ll
	$(OPT) -mem2reg < $^ > $@

$(EXECREGFILES): %-reg.o : %-reg.bc
	$(CC) -c $^
	$(CC) $@ OMP_DynamicCheck.o $(LDFLAGS) 


$(LLREGDIS): %-reg.ll : %-reg.bc
	$(OPT) -load $(PARCOACH_PASS_DIR)/$(PASSLIB) $(REQUIREDPASS) $(PASS) $^
	$(LLVMDIS) $^

merge.bc: $(LLREGFILES)
	$(LLVMLINK) -v $^ -o $@
	$(OPT) -load $(PARCOACH_PASS_DIR)/$(PASSLIB) $(REQUIREDPASS) $(PASS) < merge.bc > ./merge_parcoach.bc
	llvm-dis -o merge-readable.ll merge_parcoach.bc
	@echo "===> See Parcoach modifications in merge-readable.ll <==="
  

$(EXEC): $(LLFILES) $(LLREGFILES) $(LLREGDIS) merge.bc
	$(CC) $(CFLAGS) -c $(PARCOACH_DYNLIB_DIR)/OMP_DynamicCheck.c -DDEBUG
	$(CC) -c merge_parcoach.bc
	$(CC) merge_parcoach.o  OMP_DynamicCheck.o -o $@ $(LDFLAGS)



#######
# RUN #
#######

run:
	./$(EXEC)

#########
# CLEAN #
#########

clean:
	rm -rf *.o rm -rf *.ll
	rm -rf *.bc
	rm -rf *.dot
	rm -rf $(EXEC)
