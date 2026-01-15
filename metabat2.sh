#!/bin/bash
#SBATCH --time=18:59:00
#SBATCH --partition=k2-medpri,k2-bioinf
#SBATCH --mem=50G
#SBATCH --cpus-per-task=16
#SBATCH --mail-user=l.dillon@qub.ac.uk
#SBATCH --mail-type=END,BEGIN,FAIL
#SBATCH --error=metabat-%A-%a.err
#SBATCH --job-name=metabat

source activate /mnt/scratch2/igfs-anaconda/conda-envs/metabat2_2.15

for i in $(cat samples.txt); do metabat2 -m 1500 \
         -t 16 \
         --unbinned \
         --seed 0 \
       	 -i filtered_assembly/$i/contigs_filtered.fasta \
         -a binning/$i/depth.txt \
         -o binning/$i/bins/bin;
done

### name of script: metabat2.sh
#### version of Metabat2: version 2:2.15
#### citation: https://pmc.ncbi.nlm.nih.gov/articles/PMC6662567/ 
