#!/bin/sh
#SBATCH --time=23:59:59
#SBATCH --partition=k2-medpri,k2-bioinf
#SBATCH --cpus-per-task=16
#SBATCH --mem=30G
#SBATCH --mail-user=l.dillon@qub.ac.uk
#SBATCH --mail-type=END,BEGIN,FAIL
#SBATCH --error=genomad-%A-%a.err
#SBATCH --job-name=genomad

source activate /mnt/scratch2/igfs-anaconda/conda-envs/genomad_v1.11.1/

for i in $(cat ../assembly/samples.txt); do 
  genomad end-to-end ../assembly/metaspades/${i}/contigs.fasta \
  genomad_results/${i} \
  /mnt/scratch2/igfs-databases/genomad/genomad_db \
  --threads 16;
done
