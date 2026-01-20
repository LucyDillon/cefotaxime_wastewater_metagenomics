# cefotaxime_wastewater_metagenomics

# Preprocess reads
## You need to upload:
- bowtie2 script (version number in comments)
- fastp script (version number in comments)
- fastqc and multiqc scripts (version number in comments)
  
## Step 1: FastQC
#### Version of FastQC: version 0.12.1
#### Citation: Andrews, S. (2010). FastQC: A Quality Control Tool for High Throughput Sequence Data. Available online at: http://www.bioinformatics.babraham.ac.uk/projects/fastqc
#### Version of parallel: GNU Parallel 20230722
#### Citation: https://zenodo.org/records/1146014

```
module load FastQC/0.12.1-Java-11
module load parallel
mkdir fastqc_results
ls *.fastq | parallel fastqc -o fastqc_results {}

```
## Step 1: MultiQC
#### Version of MultiQC: version 1.22.3 
#### citation: http://dx.doi.org/10.1093/bioinformatics/btw354

```
module load MultiQC/1.22.3-foss-2023b 
multiqc fastqc_results/ -o multiqc_report
 
```
## Step 3: fastp
### Name of script: run_fastp.sh
#### Version of fastp: version 0.23.4
#### citation: https://doi.org/10.1002/imt2.107 
You wil then need to QC Trimmed reads with FastQC and MultiQC

```
module load FastQC/0.12.1-Java-11 
module load parallel 
ls *.fastq | parallel fastqc -o fastqc_results {} 
mkdir fastqc_results 
ls *.fastq | parallel fastqc -o fastqc_results {}
module load MultiQC/1.22.3-foss-2023b #load most recent multi qc version
multiqc fastqc_results/ -o multiqc_report

```
## Step 4: Bowtie2
### Build index
First, build an index of host contaminants (i.e. human, rat, mouse, anything sewage related), aligns reads to host contamination, used for cleaning reads

get host contamination genomes using wget: 
```
Wget ftp://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/001/635/GCF_000001635.27_GRCm39/GCF_000001635.27_GRCm39_genomic.fna.gz
wget ftp://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/001/635/GCF_000001635.27_GRCm39/GCF_000001635.27_GRCm39_genomic.fna.gz
wget ftp://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/001/405/GCF_000001405.40_GRCh38.p14/GCF_000001405.40_GRCh38.p14_genomic.fna.gz 
```
unzip the files
```
gunzip *.gz
```
Concatonate all ending.fna (combine the contamination genome files)
```
cat *.fna > reference_genomes.fna
```

### run bowtie2-build to build index
#### Bowtie 2 version: version 2.5.1
#### citation: https://bowtie-bio.sourceforge.net/bowtie2/manual.shtml
#### name of scipt: build_index.sh

### Remove host contamination with bowtie2
#for one sample:
```
module load Bowtie2/2.5.1-GCC-12.3.0
bowtie2 -x ../reference_genomes/reference_genome \
  -1 D8C01_S1_R1.trimmed.fastq -2 D8C01_S1_R2.trimmed.fastq \
  --very-sensitive --threads 8 \
  --un-conc-gz D8C01_unmapped_R%.fq.gz \
  -S /dev/null
```
<20 % is usable
<5 % common and acceptable
<1 % alignment is the best  

Once all samples have had host contamination removed, QC everything again

```
module load FastQC/0.12.1-Java-11 
module load parallel 
mkdir fastqc_results 
ls *.gz | parallel fastqc -o fastqc_results {} 
module load MultiQC/1.22.3-foss-2023b 
multiqc fastqc_results/ -o multiqc_report
 
```

# Assembly
## Step 5: Assemble the reads into contigs using Metaspades
### name of script: metaspades.sh
#### version of Metaspades: SPAdes genome assembler v4.0.0 [metaSPAdes mode]
#### citation: https://pmc.ncbi.nlm.nih.gov/articles/PMC5411777/ 

## Step 6: Remove contigs <1000bp (i.e. remove poor quality contigs)
### name of script: filter_reads.py
Note: if you need to run this as a bash script to submit to the queue use filter_contigs.sh script


Now the assembly should be complete and we will move onto the binning process, starting with Metabat2.

# Binning
## Step 7: MetaBat2
##### version of Metabat2: version 2:2.15
##### citation: https://pmc.ncbi.nlm.nih.gov/articles/PMC6662567/ 
#### Step 1: Make the bam files
##### name of script: make_bam_files.sh
#### Step 2: Create binning directories
##### name of script: make_binning_dirs.sh 
#### Step 3: Run JGI for metabat2
##### name of script: jgi.sh
#### Step 4: Run Metabat2
##### name of script: metabat2.sh


## Step 8: run MaxBin2
### name of script: maxbin2.sh

## Step 9: Run Concoct
#### Step 1
##### name of script: concoct_step_1.sh
#### Step 2:
##### name of script: concoct_step_2.sh
#### Step 3:
##### name of script: concoct_step_3.sh
#### Step 4:
##### name of script: concoct_step_4.sh
#### Step 5:
##### name of script: concoct_step_5.sh

# Process bins
## Step 10: Run magscot
#### Step 1:
##### name of script: magscot_step1_prodigal.sh
#### Step 2:
##### name of script: magscot_step2_hmmer.sh
#### Step 3:
##### name of script: magscot_step3_make_hmm.sh
#### Step 4:
##### name of script: magscot_step4_make_tsv.sh
#### Step 5:
##### name of script: magscot_step5_finalised_tsv.sh
#### Step 6:
##### name of script: magscot_step6_run_magscot.sh
Now lets extract the bins for drep from the magscot. 
You will need to install seqkit into your conda environment
#### Step 7:
##### name of script: magscot_step7_extract_info.sh
#### Step 8:
##### name of script: magscot_step8_contig_info.sh
#### Step 9:
##### name of script: magscot_step9_extract_bins.sh

## Step 11: Run dRep:
### name of script: drep.sh
dRep v3.5.0

# Annotations
## Step 12:
### name of script: genomad.sh


## Step 13:
### name of script: prodigal.sh


## Step 14:
### name of script: checkm2.sh


## Step 15:
### name of script: gtdbtk.sh


## Step 16:
### name of script: ncbi_amrfinder.sh
