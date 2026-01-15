#!/bin/bash
#SBATCH --time=2:59:00
#SBATCH --partition=k2-hipri,k2-bioinf
#SBATCH --mem=10G
#SBATCH --mail-user=l.dillon@qub.ac.uk
#SBATCH --mail-type=END,BEGIN,FAIL
#SBATCH --error=concoct_2-%A-%a.err
#SBATCH --job-name=concoct_2

module load apps/bowtie2/2.5.2/gcc-14.1.0
module load apps/samtools/1.17/gcc-14.1.0

for i in $(cat samples.txt); do python concoct_coverage_table.py binning/concoct/${i}_contigs_10K.bed alignment_data/${i}_sorted_10k.bam > ${i}_coverage_table.tsv; done
