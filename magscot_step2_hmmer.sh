#!/bin/bash
#SBATCH --time=4-23:59:00
#SBATCH --partition=k2-lowpri,k2-bioinf
#SBATCH --mem=50G
#SBATCH --cpus-per-task=8
#SBATCH --mail-user=l.dillon@qub.ac.uk
#SBATCH --mail-type=END,BEGIN,FAIL
#SBATCH --error=hmmer-%A-%a.err
#SBATCH --job-name=hmmer

source activate /mnt/scratch2/igfs-anaconda/conda-envs/MAGScoT_env_v1.1/

for i in $(cat samples.txt); do
  for faa in magscot_prodigal_results/${i}_*.faa; do
    hmmsearch \
      -o ${faa}.hmm.tigr.out \
      --tblout ${faa}.hmm.tigr.hit.out \
      --noali --notextw --cut_nc \
      $MAGScoT_folder/hmm/gtdbtk_rel207_tigrfam.hmm \
      "$faa"
  done
done

for i in $(cat samples.txt); do
  for faa in magscot_prodigal_results/${i}_*.faa; do
    hmmsearch \
      -o ${faa}.hmm.pfam.out \
      --tblout ${faa}.hmm.pfam.hit.out \
      --noali --notextw --cut_nc \
      $MAGScoT_folder/hmm/gtdbtk_rel207_tigrfam.hmm \
      "$faa"
  done
done
