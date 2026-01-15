# cefotaxime_wastewater_metagenomics


## You need to upload:
- bowtie2 script (version number in comments)
- fastp script (version number in comments)
- fastqc and multiqc scripts (version number in comments)
## Step 1: FastQC
## Step 1: MultiQC
## Step 3: fastp
## Step 4: Bowtie2


## Step 5: Assemble the reads into contigs using Metaspades
### name of script: metaspades.sh
#### version of Metaspades: SPAdes genome assembler v4.0.0 [metaSPAdes mode]
#### citation: https://pmc.ncbi.nlm.nih.gov/articles/PMC5411777/ 

## Step 6: Remove contigs <1000bp (i.e. remove poor quality contigs)
### name of script: filter_reads.py
Note: if you need to run this as a bash script to submit to the queue use filter_contigs.sh script


Now the assembly should be complete and we will move onto the binning process, starting with Metabat2.

## Step 7: MetaBat2
##### version of Metabat2: version 2:2.15
##### citation: https://pmc.ncbi.nlm.nih.gov/articles/PMC6662567/ 
### Step 1: Make the bam files
#### name of script: make_bam_files.sh
### Step 2: Create binning directories
#### name of script: make_binning_dirs.sh 
### Step 3: Run JGI for metabat2
#### name of script: jgi.sh
### Step 4: Run Metabat2
#### name of script: metabat2.sh


## Step 8: run MaxBin2
### name of script: maxbin2.sh

## Step 9: Run Concoct
### Step 1
#### name of script: concoct_step_1.sh
### Step 2:
#### name of script: concoct_step_2.sh
### Step 3:
#### name of script: concoct_step_3.sh
### Step 4:
#### name of script: concoct_step_4.sh
### Step 5:
#### name of script: concoct_step_5.sh

## Step 10: Run magscot
### Step 1:
#### name of script: magscot_step1_prodigal.sh
### Step 2:
#### name of script: magscot_step2_hmmer.sh
### Step 3:
#### name of script: magscot_step3_make_hmm.sh
### Step 4:
#### name of script: magscot_step4_make_tsv.sh
### Step 5:
#### name of script: magscot_step5_finalised_tsv.sh
### Step 6:
#### name of script: magscot_step6_run_magscot.sh
Now lets extract the bins for drep from the magscot. 
You will need to install seqkit into your conda environment
### Step 7:
#### name of script: magscot_step7_extract_info.sh
### Step 8:
#### name of script: magscot_step8_contig_info.sh
### Step 9:
#### name of script: magscot_step9_extract_bins.sh

## Step 11: Run dRep:
### name of script: drep.sh
dRep v3.5.0

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
