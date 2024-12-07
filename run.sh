#! /bin/bash

# module load ./modules.list
# rm -f slurm-*.out

make clean

# make gen
# sbatch sbatch_gen.sh

# make ff_original
make ff
sbatch sbatch_ff.sh
