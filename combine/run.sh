#! /bin/bash

# module load ./modules.list
# rm -f slurm-*.out

make clean

# make gen
# sbatch sbatch_gen.sh

# make ff_original
# make ff
# make ff_v2
make
sbatch sbatch_ff.sh
