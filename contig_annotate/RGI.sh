#!/bin/sh
#SBATCH --time=23:59:59
#SBATCH --partition=k2-medpri,k2-bioinf
#SBATCH --mem=30G
#SBATCH --mail-user=l.dillon@qub.ac.uk
#SBATCH --mail-type=END,BEGIN,FAIL
#SBATCH --error=amrfinder-%A-%a.err
#SBATCH --job-name=amrfinder

source activate /mnt/scratch2/igfs-anaconda/conda-envs/rgi_6.0.3

rgi load \
  --card_json /mnt/scratch2/igfs-databases/AMR/card_db-3_3_0/card.json \
  --local

for i in $(cat ../assembly/samples.txt); do rgi main --input_sequence prodigal_results/${i}.faa \--output_file RGI_output/$i --input_type protein --local  --clean; done
