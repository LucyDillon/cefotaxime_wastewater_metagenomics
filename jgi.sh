#!/bin/bash
#SBATCH --time=18:59:00
#SBATCH --partition=k2-medpri,k2-bioinf
#SBATCH --mem=10G
#SBATCH --mail-user=l.dillon@qub.ac.uk
#SBATCH --mail-type=END,BEGIN,FAIL
#SBATCH --error=jgi-%A-%a.err
#SBATCH --job-name=jgi

source activate /mnt/scratch2/igfs-anaconda/conda-envs/metabat2_2.15

for i in $(cat samples.txt); do
	jgi_summarize_bam_contig_depths --outputDepth binning/$i/depth.txt alignment_data/$i.bam;
done
