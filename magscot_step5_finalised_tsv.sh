#!/bin/bash
#SBATCH --time=02:59:00
#SBATCH --partition=k2-hipri,k2-bioinf
#SBATCH --mem=10G
#SBATCH --mail-user=l.dillon@qub.ac.uk
#SBATCH --mail-type=END,BEGIN,FAIL
#SBATCH --error=concat_tsv-%A-%a.err
#SBATCH --job-name=concat_tsv

for i in $(cat ../../samples.txt); do
    awk 'FNR==1 && NR!=1 {next} {print}' ${i}*contigs_to_bin.tsv \
        > ${i}_all_bins.contigs_to_bin.tsv
done
