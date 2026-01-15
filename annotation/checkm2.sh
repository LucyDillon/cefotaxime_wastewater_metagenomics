#!/bin/sh
#SBATCH --time=23:59:59
#SBATCH --partition=k2-medpri,k2-bioinf
#SBATCH --mem=100GB
#SBATCH --cpus-per-task=16
#SBATCH --job-name=Checkm2
#SBATCH --mail-user=l.dillon@qub.ac.uk
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --error=Checkm2-%A-%a.err

source activate /mnt/scratch2/igfs-anaconda/conda-envs/checkm2_1.1.0

checkm2 predict --database_path /mnt/scratch2/igfs-databases/CheckM2_database/uniref100.KO.1.dmnd  -t 16 -x fa --input dereplicated_genomes/ --output-directory checkm-results/ > BV_BRC.checkm.log --force
