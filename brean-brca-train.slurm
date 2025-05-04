#!/bin/bash

#SBATCH --job-name=BREAN_BRCA_TRAIN
#SBATCH --nodes 1
#SBATCH --tasks-per-node 1
#SBATCH --cpus-per-task 4
#SBATCH --gpus a100:1
#SBATCH --mem 32gb
#SBATCH --time 23:00:00

#Load modules
module load anaconda3/2023.09-0

#Go to working directory
cd /scratch/mdh2/gemdiff-brca-2/

#Activate the created conda environment
source activate GEMDiffEnv

#Clone the package
rm -rf GEMDiff
git clone https://github.com/xai990/GEMDiff.git
cd GEMDiff
pip install -e .

#Move datasets to GEMDiff
cp ../datasets . -r

#Train the model
python scripts/train.py --config datasets/brean-brca-config.yml --dir log --gene_set datasets/mechanotransduction-genes-v2.txt
