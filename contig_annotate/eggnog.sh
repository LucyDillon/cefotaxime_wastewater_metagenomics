#!/bin/bash
#SBATCH --time=2-23:59:59
#SBATCH --partition=k2-lowpri,k2-bioinf
#SBATCH --job-name=eggnog
#SBATCH	--mem=50G
#SBATCH --ntasks=8
#SBATCH --mail-user=l.dillon@qub.ac.uk
#SBATCH --mail-type=END,BEGIN,FAIL
#SBATCH --error=eggnog-%A-%a.err
source activate /mnt/scratch2/igfs-anaconda/conda-envs/eggnog/
module add diamond/0.9


for file_list in *.faa;
do emapper.py --data_dir /mnt/scratch2/igfs-anaconda/conda-envs/eggnog/lib/python3.9/site-packages/data -i $file_list --output ${file_list::-4}_eggnog -m diamond --cpu 32 --dbmem --dmnd_iterate no;
done
