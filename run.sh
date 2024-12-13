#! /bin/bash

# module load ./modules.list
# rm -f slurm-*.out

make clean

# make gen
# sbatch sbatch_gen.sh

# mkdir -p ./data/results
# make ff_v0

# make ff

# mkdir -p ./data/v1
# make ff_v1

# mkdir -p ./data/test
make ff_v2

sbatch sbatch_ff.sh
