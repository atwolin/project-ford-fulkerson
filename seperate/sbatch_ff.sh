#! /bin/bash
#SBATCH -J hw3-1_090
#SBATCH -N 1
#SBATCH -n 1
#SBATCH --gres=gpu:1

# srun ./ff_v0 ../data/50v.in 50 ../data/results/50v.out
# srun ./ff_v0 ../data/100v.in 100 ../data/results/100v.out
# srun ./ff_v0 ../data/500v.in 500 ../data/results/500v.out
# srun ./ff_v0 ../data/750v.in 750 ../data/results/750v.out
# srun ./ff_v0 ../data/1000v.in 1000 ../data/results/1000v.out
# srun ./ff_v0 ../data/2000v.in 2000 ../data/results/2000v.out
# srun ./ff_v0 ../data/3000v.in 3000 ../data/results/3000v.out
# srun ./ff_v0 ../data/4000v.in 4000 ../data/results/4000v.out
# srun ./ff_v0 ../data/5000v.in 5000 ../data/results/5000v.out
# srun ./ff_v0 ../data/10000v.in 10000 ../data/results/10000v.out

# srun ./ff ../data/100v.in 100 ../data/seperate/100v.no.out

# srun ./ff ../data/50v.in 50 ../data/seperate/50v.out
# srun ./ff ../data/100v.in 100 ../data/seperate/100v.out
# srun ./ff ../data/250v.in 250 ../data/seperate/250v.out
# srun ./ff ../data/500v.in 500 ../data/seperate/500v.out
# srun ./ff ../data/750v.in 750 ../data/seperate/750v.out
# srun ./ff ../data/1000v.in 1000 ../data/seperate/1000v.out
# srun ./ff ../data/1500v.in 1500 ../data/seperate/1500v.out
# srun ./ff ../data/2000v.in 2000 ../data/seperate/2000v.out
# srun ./ff ../data/3000v.in 3000 ../data/seperate/3000v.out
# srun ./ff ../data/4000v.in 4000 ../data/seperate/4000v.out
# srun ./ff ../data/5000v.in 5000 ../data/seperate/5000v.out
# srun ./ff ../data/10000v.in 10000 ../data/seperate/10000v.out

srun ./ff ../data/50v.in 50 ../data/v2/50v.out
srun ./ff ../data/100v.in 100 ../data/v2/100v.out
srun ./ff ../data/250v.in 250 ../data/v2/250v.out
srun ./ff ../data/500v.in 500 ../data/v2/500v.out
srun ./ff ../data/750v.in 750 ../data/v2/750v.out
srun ./ff ../data/1000v.in 1000 ../data/v2/1000v.out
srun ./ff ../data/1500v.in 1500 ../data/v2/1500v.out
srun ./ff ../data/2000v.in 2000 ../data/v2/2000v.out
srun ./ff ../data/3000v.in 3000 ../data/v2/3000v.out
srun ./ff ../data/4000v.in 4000 ../data/v2/4000v.out
srun ./ff ../data/5000v.in 5000 ../data/v2/5000v.out
srun ./ff ../data/10000v.in 10000 ../data/v2/10000v.out