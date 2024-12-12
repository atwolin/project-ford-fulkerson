#! /bin/bash
#SBATCH -J hw3-1_090
#SBATCH -N 1
#SBATCH -n 1
#SBATCH --gres=gpu:1

# srun ./ff_original dataset/50v.in 50 data/results/50v.out
# srun ./ff_original dataset/100v.in 100 data/results/100v.out
# srun ./ff_original dataset/500v.in 500 data/results/500v.out
# srun ./ff_original dataset/750v.in 750 data/results/750v.out
# srun ./ff_original dataset/1000v.in 1000 data/results/1000v.out
# srun ./ff_original dataset/2000v.in 2000 data/results/2000v.out
# srun ./ff_original dataset/3000v.in 3000 data/results/3000v.out
# srun ./ff_original dataset/4000v.in 4000 data/results/4000v.out
# srun ./ff_original dataset/5000v.in 5000 data/results/5000v.out
# srun ./ff_original dataset/10000v.in 10000 data/results/10000v.out

# srun ./ff dataset/100v.in 100 data/seperate/100v.no.out

srun ./ff ../dataset/50v.in 50 ../dataset/seperate/50v.out
# srun ./ff dataset/100v.in 100 data/seperate/100v.out
# srun ./ff dataset/500v.in 500 data/seperate/500v.out
# srun ./ff dataset/750v.in 750 data/seperate/750v.out
# srun ./ff dataset/1000v.in 1000 data/seperate/1000v.out
# srun ./ff dataset/2000v.in 2000 data/seperate/2000v.out
# srun ./ff dataset/3000v.in 3000 data/seperate/3000v.out
# srun ./ff dataset/4000v.in 4000 data/seperate/4000v.out
# srun ./ff dataset/5000v.in 5000 data/seperate/5000v.out
# srun ./ff dataset/10000v.in 10000 data/seperate/10000v.out