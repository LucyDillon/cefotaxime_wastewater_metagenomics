#!/bin/sh
#SBATCH --time=23:59:59
#SBATCH --partition=k2-medpri,k2-bioinf
#SBATCH --mem=30G
#SBATCH --mail-user=l.dillon@qub.ac.uk
#SBATCH --mail-type=END,BEGIN,FAIL
#SBATCH --error=amrfinder-%A-%a.err
#SBATCH --job-name=amrfinder

source activate /mnt/scratch2/igfs-anaconda/conda-envs/amrfinder_v4.0.15


for i in *.faa; do
    amrfinder -p $i  > amrfinder_results/AMRFinderPlusResults_${i%%.faa}.txt;
done
