#!/bin/bash
#SBATCH --time=00:59:00
#SBATCH --partition=k2-hipri,k2-bioinf
#SBATCH --mem=10G
#SBATCH --mail-user=l.dillon@qub.ac.uk
#SBATCH --mail-type=END,BEGIN,FAIL
#SBATCH --error=get_contig_info-%A-%a.err
#SBATCH --job-name=get_contig_info

for i in $(cat ../samples.txt); do awk '{split($1,a,"/");bin=a[length(a)];print $2 > (bin ".contigs")}' ${i}_magscot.refined.contig_to_bin.out; done 
