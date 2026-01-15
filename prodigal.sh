#!/bin/sh
#SBATCH --time=02:59:59
#SBATCH --partition=k2-bioinf,k2-hipri
#SBATCH --mem=10G
#SBATCH --job-name=prodigal_run

source activate /mnt/scratch2/igfs-anaconda/conda-envs/prokka

while IFS= read -r i; do
    for f in drep_"$i"/dereplicated_genomes/*.fa; do
        prodigal -i "$f" \
            -o "prodigal_results/$(basename "$f").gff" \
            -f gff \
            -d "prodigal_results/$(basename "$f").ffn" \
            -a "prodigal_results/$(basename "$f").faa"
    done
done < samples.txt
