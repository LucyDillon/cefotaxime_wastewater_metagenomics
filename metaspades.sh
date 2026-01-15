for R1 in preprocess/bowtie2_decontamination/*_unmapped_R1.fq.gz; do
    SAMPLE=$(basename "$R1" _unmapped_R1.fq.gz)

    sbatch --job-name=meta_${SAMPLE} <<EOF
#!/bin/bash
#SBATCH --partition=k2-medpri,k2-bioinf
#SBATCH --time=23:59:00
#SBATCH --mem=200G
#SBATCH --cpus-per-task=32
#SBATCH --output=metaspades-${SAMPLE}.out
#SBATCH --error=metaspades-${SAMPLE}.err

source activate /mnt/scratch2/igfs-anaconda/conda-envs/spades_4.0.0

metaspades.py \
  -1 preprocess/bowtie2_decontamination/${SAMPLE}_unmapped_R1.fq.gz \
  -2 preprocess/bowtie2_decontamination/${SAMPLE}_unmapped_R2.fq.gz \
  -o assembly/metaspades/${SAMPLE} \
  -t 32 \
  -k 21,33,55
EOF

done

# NOTE: this script will submit a separate job to the slum queue
### name of script on kelvin: metaspades_medpri.sh
#### version of Metaspades: SPAdes genome assembler v4.0.0 [metaSPAdes mode]
#### citation: https://pmc.ncbi.nlm.nih.gov/articles/PMC5411777/ 
