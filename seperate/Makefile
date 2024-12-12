###########################################################

## USER SPECIFIC DIRECTORIES ##

# CUDA directory:
CUDA_ROOT_DIR=/opt/cuda-12.6

##########################################################

## CC COMPILER OPTIONS ##

# CC compiler options:
CC=gcc
CXX=g++
CC_FLAGS=-lm -O3 -march=native -mavx512f -ffast-math

##########################################################

## NVCC COMPILER OPTIONS ##

# NVCC compiler options:
NVCC=nvcc
NVCC_FLAGS=-std=c++11 -O3 -Xptxas="-v" -arch=sm_61
NVCC_LIBS=-lm

# CUDA library directory:
CUDA_LIB_DIR= -L$(CUDA_ROOT_DIR)/lib64
# CUDA include directory:
CUDA_INC_DIR= -I$(CUDA_ROOT_DIR)/include
# CUDA linking libraries:
CUDA_LINK_LIBS= -lcudart

##########################################################

## HIPCC OPTIONS ##

HIPCC=hipcc
HIPCCFLAGS=-std=c++11 -O3 --offload-arch=gfx90a

##########################################################

## Project file structure ##

# Source file directory:
SRC_DIR = src

# Object file directory:
OBJ_DIR = bin

# Include header file directory:
INC_DIR = include

##########################################################

## Make variables ##

# Target executable name:
EXE = ff

# Object files:
OBJS = $(OBJ_DIR)/main.o $(OBJ_DIR)/ff.o

##########################################################

## Compile ##

# Link C++ and CUDA compiled object files to target executable:
$(EXE) : $(OBJS)
	$(CXX) $(CC_FLAGS) -I$(INC_DIR) $(OBJS) -o $@ $(CUDA_INC_DIR) $(CUDA_LIB_DIR) $(CUDA_LINK_LIBS)

# Compile main.cc file to object files:
$(OBJ_DIR)/%.o : %.cc
	$(CXX) $(CC_FLAGS) -c $< -o $@

# Compile C++ source files to object files:
$(OBJ_DIR)/%.o : $(SRC_DIR)/%.cc $(INC_DIR)/%.h
	$(CXX) $(CC_FLAGS) -c $< -o $@

# Compile CUDA source files to object files:
$(OBJ_DIR)/%.o : $(SRC_DIR)/%.cu $(INC_DIR)/%.cuh
	$(NVCC) $(NVCC_FLAGS) -c $< -o $@ $(NVCC_LIBS)

# Clean objects in object directory:
clean:
	$(RM) bin/* *.o $(EXE)

##########################################################
