# Intructions on calculating the TPM of taxonomy coverage within metagenomic samples

## Step 1: Extract read counts per contig from BAM files
```
#!/bin/bash
#SBATCH --time=18:59:00
#SBATCH --partition=k2-medpri,k2-bioinf
#SBATCH --mem=50G
#SBATCH --error=contig_counts-%A-%a.err
#SBATCH --job-name=contig_counts

module load apps/bowtie2/2.5.2/gcc-14.1.0
module load apps/samtools/1.17/gcc-14.1.0


for i in $(cat samples.txt); do  samtools idxstats alignment_data/${i}.bam > contig_counts/${i}_contigs_counts.txt; done
```

## Step 2: Get contig lengths
```
#!/bin/bash
#SBATCH --time=18:59:00
#SBATCH --partition=k2-medpri,k2-bioinf
#SBATCH --mem=50G
#SBATCH --error=contig_counts-%A-%a.err
#SBATCH --job-name=contig_counts

module load apps/bowtie2/2.5.2/gcc-14.1.0
module load apps/samtools/1.17/gcc-14.1.0


for i in $(cat samples.txt); do  samtools view -H alignment_data/${i}.bam | grep @SQ | cut -f2,3 | sed 's/SN://;s/LN://' > contig_lengths/${i}_contig_lengths.txt; done
```

## Step 3: Link Kraken2 taxonomy to contigs
This extracts the contig id and the taxonomy ID, i.e. 562 = E. coli.
```
cd Laura_metagenomics/contig_annotate/kraken_contigs
for i in kraken*txt; do cut -f2,3 $i > ${i%%.txt}.mapping_info.txt; done
```

## Step 4: Calculate the number of reads assigned to each taxonomy at the level that you choose i.e. family, genus, species.
### We are going to look at species in this example:
First, we need to understand what ID is and what is not a species:
```
# extract the species IDs from the kraken report file
cat  kreport_*.txt | awk '$4 == "S"' | cut -f5 | sort | uniq > Species_IDs.txt
```

Now we will extract those species ids from the *.mapping_info.txt files:
```
for i in $(cat Species_IDs.txt); do     awk -v id="$i" '$2 == id' kraken_*.mapping_info.txt; done > Species_contig_matches.txt
```

Now get a list of contigs for each taxonomy ID within each sample:

```
# Start a python session:
python
>>> import pandas as pd
>>> species_info = pd.read_csv("Species_contig_matches.txt", sep = '\t', names = ['contig_ID', 'species_ID']) 
>>> contig_counts = pd.read_csv("all_contig_counts.txt", sep = '\t', names = ['sample', 'contig_ID', 'contig_length', 'mapped_reads', 'unmapped_reads'])
>>> merged_data = pd.merge(species_info, contig_counts, on='contig_ID')
>>> merged_data.head()
>>> merged_data.tail()

```

Now add up the number of reads assigned for each contig, for each taxonomy:
```
```


