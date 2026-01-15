#!/bin/bash
#SBATCH --time=23:59:00
#SBATCH --partition=k2-medpri,k2-bioinf
#SBATCH --mem=50G
#SBATCH --cpus-per-task=8
#SBATCH --mail-user=l.dillon@qub.ac.uk
#SBATCH --mail-type=END,BEGIN,FAIL
#SBATCH --error=build_sam_file-%A-%a.err
#SBATCH --job-name=build_sam_file

module load apps/bowtie2/2.5.2/gcc-14.1.0
module load apps/samtools/1.17/gcc-14.1.0


while read -r i; do
  R1=$(ls ../preprocess/fastp_results/${i}*R1.trimmed.fastq 2>/dev/null)
  R2=$(ls ../preprocess/fastp_results/${i}*R2.trimmed.fastq 2>/dev/null)

  bowtie2 \
    -x $i.assembly \
    -1 "$R1" \
    -2 "$R2" \
    -p 16 \
    --very-sensitive \
    --no-unal \
    2> "$i.bowtie2.log" \
  | samtools view -b - \
  | samtools sort -o "alignment_data/$i.bam"

done < samples.txt   # where samples.txt is a list of samples i.e. D8C42
