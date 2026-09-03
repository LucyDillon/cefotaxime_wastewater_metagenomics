#!/bin/bash
#SBATCH --job-name=run_fastp
#SBATCH --output=fastp_%A_%a.out
#SBATCH --error=fastp_%A_%a.err
#SBATCH --array=1-11 #edit_this
#SBATCH --cpus-per-task=8
#SBATCH --mem=16G
#SBATCH --time=02:00:00
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user= #insert_email


# Load module
module load fastp

# Make output directories
mkdir -p fastp_results fastp_reports

# Get list of all R1 files and pick the one for this array index
R1=$(ls *_R1.fastq | sed -n "${SLURM_ARRAY_TASK_ID}p")
R2=${R1/_R1.fastq/_R2.fastq}
sample=${R1%%_R1.fastq}
fastp \
    -i "$R1" \
    -I "$R2" \
    -o "fastp_results/${sample}_R1.trimmed.fastq" \
    -O "fastp_results/${sample}_R2.trimmed.fastq" \
--adapter_sequence=CTGTCTCTTATACACATCT \
       	 --detect_adapter_for_pe \
    -h "fastp_reports/${sample}_fastp.html" \
    -j "fastp_reports/${sample}_fastp.json" \
    -w $SLURM_CPUS_PER_TASK
