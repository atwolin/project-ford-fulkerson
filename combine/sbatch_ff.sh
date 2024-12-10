#! /bin/bash
#SBATCH -J hw3-1_090
#SBATCH -N 1
#SBATCH -n 1
#SBATCH --gres=gpu:1

# srun ./ff_original dataset/50v.in 50 dataset/results/50v.out
# srun ./ff_original dataset/100v.in 100 dataset/results/100v.out
# srun ./ff_original dataset/500v.in 500 dataset/results/500v.out
# srun ./ff_original dataset/750v.in 750 dataset/results/750v.out
# srun ./ff_original dataset/1000v.in 1000 dataset/results/1000v.out
# srun ./ff_original dataset/2000v.in 2000 dataset/results/2000v.out
# srun ./ff_original dataset/3000v.in 3000 dataset/results/3000v.out
# srun ./ff_original dataset/4000v.in 4000 dataset/results/4000v.out
# srun ./ff_original dataset/5000v.in 5000 dataset/results/5000v.out
# srun ./ff_original dataset/10000v.in 10000 dataset/results/10000v.out

# srun ./ff dataset/100v.in 100 dataset/test/100v.no.out

srun ./ff ../dataset/50v.in 50 ../dataset/test/50v.out
# srun ./ff dataset/100v.in 100 dataset/test/100v.out
# srun ./ff dataset/500v.in 500 dataset/test/500v.out
# srun ./ff dataset/750v.in 750 dataset/test/750v.out
# srun ./ff dataset/1000v.in 1000 dataset/test/1000v.out
# srun ./ff dataset/2000v.in 2000 dataset/test/2000v.out
# srun ./ff dataset/3000v.in 3000 dataset/test/3000v.out
# srun ./ff dataset/4000v.in 4000 dataset/test/4000v.out
# srun ./ff dataset/5000v.in 5000 dataset/test/5000v.out
# srun ./ff dataset/10000v.in 10000 dataset/test/10000v.out