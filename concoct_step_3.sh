#!/bin/bash
#SBATCH --time=23:59:00
#SBATCH --partition=k2-medpri,k2-bioinf
#SBATCH --mem=50G
#SBATCH --cpus-per-task=16
#SBATCH --mail-user=l.dillon@qub.ac.uk
#SBATCH --mail-type=END,BEGIN,FAIL
#SBATCH --error=concoct3-%A-%a.err
#SBATCH --job-name=concoct3


source activate /mnt/scratch2/igfs-anaconda/conda-envs/concoct_1.1.0

for i in $(cat samples.txt); do
    concoct --composition_file binning/concoct/${i}_contigs_10K.fa --coverage_file ${i}_coverage_table.tsv -b binning/concoct/${i}_concoct_output/;
done
