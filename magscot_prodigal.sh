#!/bin/sh
#SBATCH --time=13-23:59:59
#SBATCH --partition=k2-bioinf
#SBATCH --mem=100G
#SBATCH --job-name=prodigal_run

source activate /mnt/scratch2/igfs-anaconda/conda-envs/prokka

for i in binning/all_bins_before_drep/*.fa; do
  base=$(basename "$i" .fa)
  prodigal \
    -i "$i" \
    -o "magscot_prodigal_results/${base}.gff" \
    -f gff \
    -d "magscot_prodigal_results/${base}.ffn" \
    -a "magscot_prodigal_results/${base}.faa"
done
