#!/bin/bash

#SBATCH --job-name=BREAN_BRCA_PERTURB
#SBATCH --nodes 1
#SBATCH --tasks-per-node 1
#SBATCH --cpus-per-task 4
#SBATCH --gpus a100:1
#SBATCH --mem 32gb
#SBATCH --time 04:00:00

#load modules
module load anaconda3/2023.09-0

#Go to working directory
cd /scratch/mdh2/gemdiff-brca-2/GEMDiff/

#Activate the created conda environment
source activate GEMDiffEnv

#Perturb samples
###Make sure to change the model path which is found in the train log file.###
python scripts/perturb.py --config datasets/brean-brca-config.yml --dir log  --model_path log/2025-05-04-10-14/model10000.pt --valid --gene_set datasets/mechanotransduction-genes-v2.txt
