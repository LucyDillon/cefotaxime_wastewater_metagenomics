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

## Step 7: Make the bam files
### name of script: make_bam_files.sh

## Step 8: Create binning directories
### name of script: make_binning_dirs.sh 

## Step 9: Run JGI for metabat2
### name of script: jgi.sh

## Step 10: Run Metabat2
### name of script: metabat2.sh
#### version of Metabat2: version 2:2.15
#### citation: https://pmc.ncbi.nlm.nih.gov/articles/PMC6662567/ 

## Step 11: run MaxBin2
### name of script: maxbin2.sh

## Step 12: Run Concoct
### name of script: concoct_step_1.sh

## Step 13:
### name of script: concoct_step_2.sh

## Step 14:
### name of script: concoct_step_3.sh

## Step 15:
### name of script: concoct_step_4.sh

## Step 16:
### name of script: concoct_step_5.sh

## Step 17: Run magscot
### name of script: magscot_step1_prodigal.sh

## Step 18:
### name of script: magscot_step2_hmmer.sh

## Step 19:
### name of script: magscot_step3_x.sh
```
for i in *.hmm.tigr.hit.out; do cat $i | grep -v "^#" | awk '{print $1"\t"$3"\t"$5}' > ${i%%.hmm.tigr.hit.out}.tigr; done
for i in $(cat ../samples.txt); do cat ${i}*.tigr > $i.tigr; done

for i in *.hmm.pfam.hit.out; do cat $i | grep -v "^#" | awk '{print $1"\t"$4"\t"$5}' > ${i%%.hmm.pfam.hit.out}.pfam; done
for i in $(cat ../samples.txt); do cat ${i}*.pfam > $i.pfam; done

for i in $(cat ../samples.txt); do cat ${i}.pfam ${i}.tigr > ${i}.hmm; done

```
## Step 20:
### name of script: magscot_step4_make_tsv.sh
```

for file in *concoct*.fa; do   {     printf "File\tContigID\tBinner\n";     grep '^>' "$file" |     awk -v f="$file" '{print f "\t" $1 "\tconcoct"}' |     sed 's/>//g' | sed 's/.fa//g';   } > "${file%%.fa}.contigs_to_bin.tsv"; done

for file in *maxbin2*.fa; do   {     printf "File\tContigID\tBinner\n";     grep '^>' "$file" |     awk -v f="$file" '{print f "\t" $1 "\tmaxbin2"}' |     sed 's/>//g' | sed 's/.fa//g';   } > "${file%%.fa}.contigs_to_bin.tsv"; done

for file in *metabat2*.fa; do   {     printf "File\tContigID\tBinner\n";     grep '^>' "$file" |     awk -v f="$file" '{print f "\t" $1 "\tmetabat2"}' |     sed 's/>//g' | sed 's/.fa//g';   } > "${file%%.fa}.contigs_to_bin.tsv"; done

```

## Step 20:
### name of script: magscot_step5_finalised_tsv.sh
```
for i in $(cat ../../samples.txt); do
    awk 'FNR==1 && NR!=1 {next} {print}' ${i}*contigs_to_bin.tsv \
        > ${i}_all_bins.contigs_to_bin.tsv
done

```
## Step 21:
### name of script: magscot_step6_run_magscot.sh
```
#!/bin/bash
#SBATCH --time=23:59:00
#SBATCH --partition=k2-medpri,k2-bioinf
#SBATCH --mem=50G
#SBATCH --cpus-per-task=8
#SBATCH --mail-user=l.dillon@qub.ac.uk
#SBATCH --mail-type=END,BEGIN,FAIL
#SBATCH --error=magscot-%A-%a.err
#SBATCH --job-name=magscot

source activate /mnt/scratch2/igfs-anaconda/conda-envs/MAGScoT_env_v1.1

for f in $(cat samples.txt);
    do Rscript $MAGScoT_folder/MAGScoT.R \
        -i magscot/${i}_all_bins.contigs_to_bin.tsv \
        --hmm magscot_prodigal_results/${i}.hmm \
        --out magscot/${i}_magscot;
done
```

Now lets extract the bins for drep from the magscot. 
You will need to install seqkit into your conda environment

## Step 22:
### name of script: magscot_step7_extract_info.sh
```
for i in $(cat samples.txt); do tail -n +2 magscot/${i}_magscot.refined.contig_to_bin.out | cut -f1 | sed 's#.*/##' | sort -u > magscot/${i}_cleanbins.txt; done

```
## Step 23:
### name of script: magscot_step8_contig_info.sh
```
for i in $(cat ../samples.txt); do awk '{split($1,a,"/");bin=a[length(a)];print $2 > (bin ".contigs")}' ${i}_magscot.refined.contig_to_bin.out; done 

```
## Step 24:
### name of script: magscot_step9_extract_bins.sh

## Step 25: Run dRep:
### name of script: drep.sh
dRep v3.5.0

## Step 26:
### name of script: genomad.sh


## Step 27:
### name of script: prodigal.sh


## Step 28:
### name of script: checkm2.sh


## Step 29:
### name of script: gtdbtk.sh


## Step 30:
### name of script: ncbi_amrfinder.sh
