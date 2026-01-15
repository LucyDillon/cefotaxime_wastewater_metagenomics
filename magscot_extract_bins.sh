#!/bin/bash
#SBATCH --time=00:59:00
#SBATCH --partition=k2-hipri,k2-bioinf
#SBATCH --mem=10G
#SBATCH --mail-user=l.dillon@qub.ac.uk
#SBATCH --mail-type=END,BEGIN,FAIL
#SBATCH --error=extract_bins-%A-%a.err
#SBATCH --job-name=extract_bins

while IFS= read -r i; do
  mkdir -p "${i}_cleanbins"
  for f in "${i}_magscot_cleanbin_"*.contigs; do
    bin=$(basename "$f" .contigs)
    seqkit grep -f "$f" "../filtered_assembly/${i}/contigs_filtered.fasta" > "${i}_cleanbins/${bin}.fa"
  done
done < ../samples.txt
