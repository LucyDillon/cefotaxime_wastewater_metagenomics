#!/bin/bash
#SBATCH --time=23:59:00
#SBATCH --partition=k2-medpri,k2-bioinf
#SBATCH --mem=50G
#SBATCH --cpus-per-task=16
#SBATCH --mail-user=l.dillon@qub.ac.uk
#SBATCH --mail-type=END,BEGIN,FAIL
#SBATCH --error=concoct4-%A-%a.err
#SBATCH --job-name=concoct4

source activate /mnt/scratch2/igfs-anaconda/conda-envs/concoct_1.1.0

for i in $(cat samples.txt); do merge_cutup_clustering.py binning/concoct/${i}_concoct_output/clustering_gt1000.csv > binning/concoct/${i}_concoct_output/clustering_merged.csv ; done
