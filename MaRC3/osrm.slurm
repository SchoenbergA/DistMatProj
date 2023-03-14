#!/bin/bash

#SBATCH --time=2-00:00:00
#SBATCH --cpus-per-task=64
#SBATCH --nodes=1
#SBATCH --mem=250000
#SBATCH --mail-user=oedm@staff.uni-marburg.de
#SBATCH --mail-type=ALL


module purge
module load singularity/3.7.1


echo $HOSTNAME
singularity run osrm-backend-start.sif







