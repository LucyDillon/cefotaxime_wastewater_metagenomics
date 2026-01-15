#!/bin/bash
#SBATCH --time=02:59:00
#SBATCH --partition=k2-hipri,k2-bioinf
#SBATCH --mem=50G
#SBATCH --cpus-per-task=8
#SBATCH --mail-user=l.dillon@qub.ac.uk
#SBATCH --mail-type=END,BEGIN,FAIL
#SBATCH --error=drep-%A-%a.err
#SBATCH --job-name=drep

source activate /mnt/scratch2/igfs-anaconda/conda-envs/drep3.5.0
for i in $(cat samples.txt); do
    dRep dereplicate drep_${i}  --processors 8    --completeness 50    --contamination 50  --genomes magscot/${i}_cleanbins/*.fa;
done

# dRep v3.5.0
