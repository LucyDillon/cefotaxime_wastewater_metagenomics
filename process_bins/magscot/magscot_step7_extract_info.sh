#!/bin/bash
#SBATCH --time=00:59:00
#SBATCH --partition=k2-hipri,k2-bioinf
#SBATCH --mem=10G
#SBATCH --mail-user=l.dillon@qub.ac.uk
#SBATCH --mail-type=END,BEGIN,FAIL
#SBATCH --error=extract_results-%A-%a.err
#SBATCH --job-name=extract_results

for i in $(cat samples.txt); do tail -n +2 magscot/${i}_magscot.refined.contig_to_bin.out | cut -f1 | sed 's#.*/##' | sort -u > magscot/${i}_cleanbins.txt; done
