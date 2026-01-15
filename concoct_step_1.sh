#!/bin/bash
#SBATCH --time=2:59:00
#SBATCH --partition=k2-hipri,k2-bioinf
#SBATCH --mem=10G
#SBATCH --mail-user=l.dillon@qub.ac.uk
#SBATCH --mail-type=END,BEGIN,FAIL
#SBATCH --error=concoct_cutup-%A-%a.err
#SBATCH --job-name=concoct_cutup

for i in $(cat samples.txt); do 
  python cut_up_fasta.py filtered_assembly/$i/contigs_filtered_10k.fasta -c 10000 -o 0 --merge_last -b binning/concoct/${i}_contigs_10K.bed > binning/concoct/${i}_contigs_10K.fa; 
done
