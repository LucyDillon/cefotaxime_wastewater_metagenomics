#!/bin/sh
#SBATCH --time=23:59:59
#SBATCH --partition=k2-medpri,k2-bioinf
#SBATCH --mem=30G
#SBATCH --mail-user=l.dillon@qub.ac.uk
#SBATCH --mail-type=END,BEGIN,FAIL
#SBATCH --error=VFDB-%A-%a.err
#SBATCH --job-name=VFDB


module load apps/ncbiblast/2.15.0/gcc-14.1.0

for i in $(cat ../assembly/samples.txt); do blastn -query prodigal_results/${i}.ffn        -db ../VFDB_core_db        -out ${i}_vfdb_results.txt        -outfmt "6 qseqid sseqid pident length mismatch gapopen qstart qend sstart send evalue bitscore"        -perc_identity 80        -qcov_hsp_perc 60        -num_threads 2; done
