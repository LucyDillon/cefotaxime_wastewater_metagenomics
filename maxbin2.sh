#!/bin/bash
#SBATCH --time=23:59:00
#SBATCH --partition=k2-medpri,k2-bioinf
#SBATCH --mem=50G
#SBATCH --cpus-per-task=16
#SBATCH --mail-user=l.dillon@qub.ac.uk
#SBATCH --mail-type=END,BEGIN,FAIL
#SBATCH --error=maxbin2-%A-%a.err
#SBATCH --job-name=maxbin2

source activate /mnt/scratch2/igfs-anaconda/conda-envs/maxbin2_2.2.7

for i in $(cat samples.txt); do run_MaxBin.pl -contig filtered_assembly/$i/contigs_filtered.fasta -reads ../preprocess/fastp_results/${i}*R1.trimmed.fastq -reads2 ../preprocess/fastp_results/${i}*R2.trimmed.fastq -out binning/maxbin2/${i}_maxbin2 -thread 12; done
