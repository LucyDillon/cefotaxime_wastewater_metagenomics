#!/bin/sh
#SBATCH --time=23:59:59
#SBATCH --partition=k2-medpri,k2-bioinf
#SBATCH --mem=30G
#SBATCH --mail-user=l.dillon@qub.ac.uk
#SBATCH --mail-type=END,BEGIN,FAIL
#SBATCH --error=resfinder-%A-%a.err
#SBATCH --job-name=resfinder

source activate /mnt/scratch2/igfs-anaconda/conda-envs/resfinder_4.7.2

for i in $(cat ../assembly/samples.txt); do  python3 /mnt/scratch2/igfs-anaconda/conda-envs/resfinder_4.7.2/bin/run_resfinder.py -ifa prodigal_results/${i}.ffn  -o resfinder_output/$i -db_res /mnt/scratch2/igfs-databases/AMR/resfinder_db-2_4_0 -acq ; done
