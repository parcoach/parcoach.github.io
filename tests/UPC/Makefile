#
# You may need to do "export UPC_SHARED_HEAP_SIZE=1GB" before executing the code


# PARCOACH SPECIFIC
PARCOACH_DIR=$(PWD)/../../
PARCOACH_PASS_DIR=${PARCOACH_DIR}/build/lib
PARCOACH_DYNLIB_DIR=${PARCOACH_DIR}/src/lib

#PASSLIB=LLVMaSSA.so
PASSLIB=LLVMaSSA.dylib #MACOS

REQUIREDPASS = -postdomtree -loweratomic
PASS = -parcoach -no-dataflow --check-upc
# see the documentation for possible PARCOACH analyses



CC=clang
CXX=clang++
LLVMDIS=llvm-dis
LLVMLINK=llvm-link


NETWORK=udp
OPT=dbg

## UPC translator built with LLVM 3.7.1 ##
UPC_INST?=$(shell upcc -print-include-dir)/build
UPC_DIR?=$(shell upcc -print-include-dir)

CONDUIT = $(NETWORK)
MAK_VER?=seq
include $(UPC_INST)/$(OPT)/gasnet/$(CONDUIT)-conduit/$(CONDUIT)-$(MAK_VER).mak
C_INCL =  -I$(UPC_INST) -I$(UPC_INST)/upcr_geninclude  -I$(UPC_INST)/upcr_postinclude -I. $(GASNET_CPPFLAGS)
UPCC=$(shell which upcc) -network  $(CONDUIT) ##-Wc,-g

UPC_THREADS=4


## Obtained when you compile with -vv option (compiling section) 
PASS_UPC_INCL=-O0 -Wno-empty-body -Wno-unused-value       -v  -D__BERKELEY_UPC_RUNTIME__=1 -D__BERKELEY_UPC_RUNTIME_RELEASE__=2 -D__BERKELEY_UPC_RUNTIME_RELEASE_MINOR__=22 -D__BERKELEY_UPC_RUNTIME_RELEASE_PATCHLEVEL__=0 -D__BERKELEY_UPC_UDP_CONDUIT__=1 -D__UPC_COLLECTIVE__=1 -D__UPC_PUPC__=1 -D__UPC_IO__=2 -D__UPC_TICK__=1 -D__UPC_CASTABLE__=1 -D__UPC_NB__=1 -D__BERKELEY_UPC__=2 -D__BERKELEY_UPC_MINOR__=22 -D__BERKELEY_UPC_PATCHLEVEL__=0 -DUPC_MAX_BLOCK_SIZE=1048576 -D__UPC__=1 -D__UPC_VERSION__=201311L -D__UPC_STATIC_THREADS__=1 -DTHREADS=$(UPC_THREADS) -DGASNET_SEQ    -I$(UPC_INST)/$(OPT)/upcr_geninclude -I$(UPC_DIR)/gasnet -I$(UPC_DIR)/gasnet/udp-conduit -I$(UPC_DIR)/gasnet/other -I$(UPC_DIR)/gasnet/other/amudp            -I$(UPC_DIR)/gasnet/extended-ref -I$(UPC_INST)/$(OPT)/gasnet   -I$(UPC_DIR) -I$(UPC_INST)/$(OPT)    -I$(UPC_DIR)/upcr_postinclude -D__BERKELEY_UPC_SECOND_PREPROCESS__=1 -DUPCRI_CC="/Users/emmanuellesaillard/Documents/LLVM_390/build/bin/clang" -DUPCRI_LD="/Users/emmanuellesaillard/Documents/LLVM_390/build/bin/clang@2B@2B" 

#-O0 -Wall -Wno-unused -Wno-address -Wpointer-arith -Wnested-externs -Wwrite-strings -Wdeclaration-after-statement -Wmissing-format-attribute -Wno-empty-body       -v  -D__BERKELEY_UPC_RUNTIME__=1 -D__BERKELEY_UPC_RUNTIME_DEBUG__=1 -D__BERKELEY_UPC_RUNTIME_RELEASE__=2 -D__BERKELEY_UPC_RUNTIME_RELEASE_MINOR__=22 -D__BERKELEY_UPC_RUNTIME_RELEASE_PATCHLEVEL__=0 -D__BERKELEY_UPC_UDP_CONDUIT__=1 -D__UPC_COLLECTIVE__=1 -D__UPC_PUPC__=1 -D__UPC_IO__=2 -D__UPC_TICK__=1 -D__UPC_CASTABLE__=1 -D__UPC_NB__=1 -D__BERKELEY_UPC__=2 -D__BERKELEY_UPC_MINOR__=22 -D__BERKELEY_UPC_PATCHLEVEL__=0 -DUPC_MAX_BLOCK_SIZE=1048576 -D__UPC__=1 -D__UPC_VERSION__=201311L -D__UPC_STATIC_THREADS__=1 -DTHREADS=$(UPC_THREADS) -DGASNET_SEQ    -I$(UPC_INST)/dbg/upcr_geninclude -I$(UPC_DIR)/gasnet -I$(UPC_DIR)/gasnet/udp-conduit -I$(UPC_DIR)/gasnet/other -I$(UPC_DIR)/gasnet/other/amudp            -I$(UPC_DIR)/gasnet/extended-ref -I$(UPC_INST)/dbg/gasnet   -I$(UPC_DIR) -I$(UPC_INST)/dbg    -I$(UPC_DIR)/upcr_postinclude -D__BERKELEY_UPC_SECOND_PREPROCESS__=1 -DUPCRI_CC="/Users/emmanuellesaillard/Documents/LLVM_371/build/bin/clang" -DUPCRI_LD="/Users/emmanuellesaillard/Documents/LLVM_371/build/bin/clang@2B@2B"



CFLAGS=-g #-I$(UPC_DIR)/upcr_preinclude/
LDFLAGS=-g

EXEC=mismatch_barrier_parcoach


all: $(EXEC)

mismatch_barrier: mismatch_barrier.upc
	$(UPCC) -v -T $(UPC_THREADS) -o $@ $^ -save-all-temps 

mismatch_barrier_parcoach:mismatch_barrier.upc
	$(UPCC)  -T $(UPC_THREADS) -trans $^ $(CFLAGS)
	$(CC) $(CFLAGS) -emit-llvm $(PASS_UPC_INCL) -c -o mismatch_barrier.trans.bc mismatch_barrier.trans.c
	@echo "USING PARCOACH ..."
	opt -load $(PARCOACH_PASS_DIR)/$(PASSLIB) $(REQUIREDPASS) $(PASS) < mismatch_barrier.trans.bc > ./mismatch_barrier.bc
	llvm-dis -o mismatch_barrier-readable.ll mismatch_barrier.bc
	@echo "===> See Parcoach modifications in mismatch_barrier-readable.ll <==="
	$(CC) -c mismatch_barrier.bc
	$(UPCC) --link-with=c++ $(LDFLAGS) -T $(UPC_THREADS) mismatch_barrier.o -o $@ -lstdc++
	

	#$(CC) $(CFLAGS) $(PASS_UPC_INCL) -c $(LIB_DIR)/UPC_DynamicCheck.c

ex_broadcast_parcoach:ex_broadcast.upc
	#$(CC) $(CFLAGS) $(PASS_UPC_INCL) -c $(LIB_DIR)/UPC_DynamicCheck.c -D_DEBUG_INFO
	$(UPCC) -T $(UPC_THREADS) $(CFLAGS) -c $(PARCOACH_DYNLIB_DIR)/UPC_DynamicCheck.upc -save-all-temps 
	$(UPCC)  -T $(UPC_THREADS) -trans $^ $(CFLAGS)
	$(CC) $(CFLAGS) -emit-llvm $(PASS_UPC_INCL) -c -o ex_broadcast.trans.bc ex_broadcast.trans.c
	opt -load $(PARCOACH_PASS_DIR)/LLVMParcoach.dylib -postdomtree -parcoach --no-instrumentation -debug < ex_broadcast.trans.bc > ./ex_broadcast.bc
	llvm-dis -o ex_broadcast_modified-readable.ll ex_broadcast.bc
	@echo "===> See Parcoach modifications in ex_broadcast_modified-readable.ll <==="
	$(CC) -c ex_broadcast.bc
	$(UPCC) --link-with=c++ -T $(UPC_THREADS) ex_broadcast.o UPC_DynamicCheck.o -o $@ -lstdc++

run:
	GASNET_BACKTRACE=1 upcrun -localhost -n $(UPC_THREADS) ./$(EXEC)



clean:
	rm -rf *.o rm -rf *.ll *.i *.B
	rm -rf *.bc *.t *.N *.trans.c
	rm -rf *.dot
	rm -rf $(EXEC)
