#! /bin/bash
#SBATCH -J hw3-1_090
#SBATCH -N 1
#SBATCH -n 1
#SBATCH --gres=gpu:1

# srun ./ff_original dataset/50v.in 50 dataset/results/50v.out
srun ./ff dataset/50v.in 50 dataset/test/50v.out