#!/bin/bash
#SBATCH --time=2:59:00
#SBATCH --partition=k2-hipri,k2-bioinf
#SBATCH --mem=10G
#SBATCH --mail-user=l.dillon@qub.ac.uk
#SBATCH --mail-type=END,BEGIN,FAIL
#SBATCH --error=make_dirs-%A-%a.err
#SBATCH --job-name=make_dirs

for i in $(cat samples.txt); do mkdir -p binning/$i; mkdir -p binning/$i/bins; done
