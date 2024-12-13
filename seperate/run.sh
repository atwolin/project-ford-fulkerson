#! /bin/bash

# module load ./modules.list
# rm -f slurm-*.out

make clean

# make gen
# sbatch sbatch_gen.sh

mkdir -p ../data/v2
make
sbatch sbatch_ff.sh
