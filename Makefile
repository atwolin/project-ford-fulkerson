CC = gcc
CXX = g++
NVCC = nvcc
HIPCC = hipcc

CFLAGS = -lm -O3 -march=native -mavx512f -ffast-math  # for ff.cc
NVFLAGS = -std=c++11 -O3 -Xptxas="-v" -arch=sm_61
# NVFLAGS = -std=c++11 -O3 -Xptxas="-v" -arch=sm_61 -Xcompiler -mcmodel=medium -Xcompiler \"-Wl,--no-relax\"
HIPCCFLAGS = -std=c++11 -O3 --offload-arch=gfx90a

LDFLAGS = -lm
EXES = gen ff_v0 ff ff_v1 ff_v2

.PHONY: all clean

all: $(EXES)

clean:
	rm -f $(EXES)

gen: graph_generator.cc
	$(CXX) $(CXXFLAGS) -o $@ $?

seq: seq.cc
	$(CXX) $(CXXFLAGS) -o $@ $?

ff_v0: ff_v0.cu
	$(NVCC) $(NVFLAGS) $(LDFLAGS) -o $@ $?

ff: ff.cu
	$(NVCC) $(NVFLAGS) $(LDFLAGS) -o $@ $?

ff_v1: ff_v1-compute-in-gpu.cu
	$(NVCC) $(NVFLAGS) $(LDFLAGS) -o $@ $?

ff_v2: ff_v2-seperate_cpp_cuda.cu
	$(NVCC) $(NVFLAGS) $(LDFLAGS) -o $@ $?