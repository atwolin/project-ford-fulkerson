#! /bin/bash
#SBATCH -J hw3-1_090
#SBATCH -N 1
#SBATCH -n 1
#SBATCH --gres=gpu:1

# srun ./gen 50 dataset/50v.in
srun ./gen 100 dataset/100v.in
# srun ./gen 500 dataset/509v.in
# srun ./gen 750 dataset/750v.in
# srun ./gen 1000 dataset/1000v.in
# srun ./gen 2000 dataset/2000v.in
# srun ./gen 3000 dataset/3000v.in
# srun ./gen 4000 dataset/4000v.in
# srun ./gen 5000 dataset/5000v.in
# srun ./gen 10000 dataset/10000v.in