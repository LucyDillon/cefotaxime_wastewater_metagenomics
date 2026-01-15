#!/bin/bash
#SBATCH --time=0:59:00
#SBATCH --partition=k2-hipri,k2-bioinf
#SBATCH --mem=10G
#SBATCH --mail-user=l.dillon@qub.ac.uk
#SBATCH --mail-type=END,BEGIN,FAIL
#SBATCH --error=filter_contigs-%A-%a.err
#SBATCH --job-name=filter_contigs

# Do you need to load a python module?
# Do you need to load biopython?

python filter_reads.py
