#!/bin/bash
#SBATCH --time=23:59:00
#SBATCH --partition=k2-himem
#SBATCH --mem=1200G
#SBATCH --cpus-per-task=36
#SBATCH --mail-user=l.dillon@qub.ac.uk
#SBATCH --mail-type=END,BEGIN,FAIL
#SBATCH --error=kraken-contigs-%A-%a.err
#SBATCH --job-name=kraken_contigs

source activate /mnt/scratch2/igfs-anaconda/conda-envs/kraken2

DB=/mnt/scratch2/igfs-databases/Holoruminant/My_holor_project/resources/databases/kraken2/kraken2_RefSeqV205_Complete_500GB
ASSEMBLY_DIR=../assembly/filtered_assembly
OUTDIR=kraken_contigs

mkdir -p ${OUTDIR}

for sample in $(cat ../assembly/samples.txt); do
    contigs=${ASSEMBLY_DIR}/${sample}/contigs_filtered.fasta

    kraken2 \
        --db ${DB} \
        --threads 36 \
        --output ${OUTDIR}/kraken_${sample}.txt \
        --report ${OUTDIR}/kreport_${sample}.txt \
        ${contigs}
done
