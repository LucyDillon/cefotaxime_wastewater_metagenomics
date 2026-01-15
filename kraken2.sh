#!/bin/bash
#SBATCH --time=2-23:59:00
#SBATCH --partition=k2-himem
#SBATCH --mem=1200G
#SBATCH --cpus-per-task=36
#SBATCH --mail-user=l.dillon@qub.ac.uk
#SBATCH --mail-type=END,BEGIN,FAIL
#SBATCH --error=kraken-%A-%a.err
#SBATCH --job-name=kraken

source activate /mnt/scratch2/igfs-anaconda/conda-envs/kraken2

for r1 in *_R1.trimmed.fastq; do
    # Extract sample name (everything before _R1.trimmed.fastq)
    name=${r1%_R1.trimmed.fastq}

    # Define the R2 file based on the R1 file
    r2=${name}_R2.trimmed.fastq

    # Run kraken2
    kraken2 \
        --db /mnt/scratch2/igfs-databases/Holoruminant/My_holor_project/resources/databases/kraken2/kraken2_RefSeqV205_Complete_500GB \
        --paired "$r1" "$r2" \
        --classified-out classified-${name}.R#.fq \
        --unclassified-out unclassified-${name}.R#.fq \
        --output kraken_output_${name}.txt \
        --report kreport_${name}.txt \
        --threads 36
done
