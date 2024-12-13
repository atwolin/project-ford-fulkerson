#! /bin/bash
#SBATCH -J hw3-1_090
#SBATCH -N 1
#SBATCH -n 1
#SBATCH --gres=gpu:1

# srun ./gen 50 data/50v.in
# srun ./gen 100 data/100v.in
# srun ./gen 250 data/250.in
# srun ./gen 500 data/500v.in
# srun ./gen 750 data/750v.in
# srun ./gen 1000 data/1000v.in
# srun ./gen 1500 data/1500v.in
# srun ./gen 2000 data/2000v.in
# srun ./gen 3000 data/3000v.in
# srun ./gen 4000 data/4000v.in
# srun ./gen 5000 data/5000v.in
srun ./gen 10000 data/10000v.in
