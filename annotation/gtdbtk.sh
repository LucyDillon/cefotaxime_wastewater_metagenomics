#!/bin/sh
#SBATCH --time=23:59:59
#SBATCH --partition=k2-medpri,k2-bioinf
#SBATCH --mem=100GB
#SBATCH --cpus-per-task=16
#SBATCH --job-name=gtdbtk
#SBATCH --mail-user=l.dillon@qub.ac.uk
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --error=gtdbtk-%A-%a.err

source activate /mnt/scratch2/igfs-anaconda/conda-envs/gtdbtk-2.1.1

gtdbtk classify_wf --genome_dir dereplicated_genomes --out_dir gtdbtk_results/ --extension fa --cpus 16  --skip_ani_screen
