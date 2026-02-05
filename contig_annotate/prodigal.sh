#!/bin/sh
#SBATCH --time=02:59:59
#SBATCH --partition=k2-bioinf,k2-hipri
#SBATCH --mem=10G
#SBATCH --job-name=prodigal_run

source activate /mnt/scratch2/igfs-anaconda/conda-envs/prokka

for i in $(cat ../assembly/samples.txt); do
  prodigal \
    -i ../assembly/filtered_assembly/${i}/contigs_filtered.fasta \
    -o prodigal_results/${i}.gff \
    -f gff \
    -d prodigal_results/${i}.ffn \
    -a prodigal_results/${i}.faa
done
