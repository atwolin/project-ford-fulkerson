#! /bin/bash
#SBATCH -J hw3-1_090
#SBATCH -N 1
#SBATCH -n 1
#SBATCH --gres=gpu:1

########################################
###                v0                ###
########################################
# srun ./ff_v0 data/50v.in 50 data/results/50v.out
# srun ./ff_v0 data/100v.in 100 data/results/100v.out
# srun ./ff_v0 data/250v.in 250 data/results/250v.out
# srun ./ff_v0 data/500v.in 500 data/results/500v.out
# srun ./ff_v0 data/750v.in 750 data/results/750v.out
# srun ./ff_v0 data/1000v.in 1000 data/results/1000v.out
# srun ./ff_v0 data/1500v.in 1500 data/results/1500v.out
# srun ./ff_v0 data/2000v.in 2000 data/results/2000v.out
# srun ./ff_v0 data/3000v.in 3000 data/results/3000v.out
# srun ./ff_v0 data/4000v.in 4000 data/results/4000v.out
# srun ./ff_v0 data/5000v.in 5000 data/results/5000v.out
# srun ./ff_v0 data/10000v.in 10000 data/results/10000v.out

# srun ./ff data/100v.in 100 data/test/100v.no.out


########################################
###                v1                ###
########################################
# srun ./ff_v1 data/50v.in 50 data/v1/50v.out
# srun ./ff_v1 data/100v.in 100 data/v1/100v.out
# srun ./ff_v1 data/250v.in 250 data/v1/250v.out
# srun ./ff_v1 data/500v.in 500 data/v1/500v.out
# srun ./ff_v1 data/750v.in 750 data/v1/750v.out
# srun ./ff_v1 data/1000v.in 1000 data/v1/1000v.out
# srun ./ff_v1 data/1500v.in 1500 data/v1/1500v.out
# srun ./ff_v1 data/2000v.in 2000 data/v1/2000v.out
# srun ./ff_v1 data/3000v.in 3000 data/v1/3000v.out
# srun ./ff_v1 data/4000v.in 4000 data/v1/4000v.out
# srun ./ff_v1 data/5000v.in 5000 data/v1/5000v.out
# srun ./ff_v1 data/10000v.in 10000 data/v1/10000v.out


########################################
###              v2-test             ###
########################################
srun ./ff_v2 data/50v.in 50 data/test/50v.out
srun ./ff_v2 data/250v.in 250 data/test/250v.out