#! /bin/bash

# module load ./modules.list
rm -f slurm-*.out

make clean

# make gen
# sbatch sbatch_gen.sh

make -p ../data/seperate
make
sbatch sbatch_ff.sh
