#!/bin/bash
#SBATCH --time=23:59:00
#SBATCH --partition=k2-medpri,k2-bioinf
#SBATCH --mem=20G
#SBATCH --cpus-per-task=8
#SBATCH --mail-user=l.dillon@qub.ac.uk
#SBATCH --mail-type=END,BEGIN,FAIL
#SBATCH --error=plasmid_ID-%A-%a.err
#SBATCH --job-name=plasmid_ID

source activate /mnt/scratch2/igfs-anaconda/conda-envs/plasmidid_v1.6.5
for i in $(cat ../../assembly/samples.txt); do mkdir plasmid_ID_${i}; plasmidID  -d /mnt/scratch2/igfs-databases/plasmidid/2026-01-22_plasmids.fasta -c ${i}.ffn   -s $i -T 8 -o plasmid_ID_${i}; done
