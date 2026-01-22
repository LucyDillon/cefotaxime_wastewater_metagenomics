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
#### Step 4a: We need to understand what ID is and what is not a species
```
# extract the species IDs from the kraken report file
cat  kreport_*.txt | awk '$4 == "S"' | cut -f5 | sort | uniq > Species_IDs.txt
```

#### Step 4b: We will extract those species ids from the *.mapping_info.txt files
```
for i in $(cat Species_IDs.txt); do     awk -v id="$i" '$2 == id' kraken_*.mapping_info.txt; done > Species_contig_matches.txt
```

#### Step 4c: Get a list of contigs for each taxonomy ID within each sample
```
# Start a python session:
python
>>> import pandas as pd
>>> species_info = pd.read_csv("Species_contig_matches.txt", sep = '\t', names = ['contig_ID', 'species_ID']) 
>>> contig_counts = pd.read_csv("all_contig_counts.txt", sep = '\t', names = ['sample', 'contig_ID', 'contig_length', 'mapped_reads', 'unmapped_reads'])
>>> merged_data = pd.merge(species_info, contig_counts, on='contig_ID')
>>> merged_data.head()
>>> merged_data.tail()
# continued below ...
```

#### Step 4d: Add up the number of reads assigned for each contig, for each taxonomy
```
# continuing from the python code above, we will group by species_ID, sample, and sum the mapped_reads and contig length:
>>> species_sample_grouped = merged_data.groupby(['species_ID', 'sample'], as_index=False)[['mapped_reads', 'contig_length']].sum()
>>> species_sample_grouped.head()
   species_ID sample  mapped_reads  contig_length
0          56  D8C82            14           1188
1         274  D8C61            24           1030
2         287  D8C01            42           1032
3         287  D8C03            30           1986
4         287  D8C44            50           4629
# continued below ...
```
#### Step 4e: Now we need to calculate RPK for each taxonomy
RPK_taxon = total_reads_for_taxon / (total_length_for_taxon / 1000)

```
# following the python code above
>>> species_sample_grouped['RPK_taxon'] = species_sample_grouped['mapped_reads'] / (species_sample_grouped['contig_length']/1000)
>>> species_sample_grouped.head()
   species_ID sample  mapped_reads  contig_length  RPK_taxon
0          56  D8C82            14           1188  11.784512
1         274  D8C61            24           1030  23.300971
2         287  D8C01            42           1032  40.697674
3         287  D8C03            30           1986  15.105740
4         287  D8C44            50           4629  10.801469
# continued below ...
```

#### Step 4f: Calculate the scaling factor within samples
scaling_factor = (sum of all RPK values across all taxa) / 1,000,000
```
# group by sample and sum the RPK_taxon value
>>> scaling_factor = species_sample_grouped.groupby(['sample'], as_index=False)['RPK_taxon'].sum()
>>> scaling_factor['scaling_factor'] = scaling_factor['RPK_taxon'] / 1000000
```
#### Step 4g: Calculate TPM
TPM_taxon = RPK_taxon / scaling_factor

```
# you need to rename 'RPK_taxon' in your scaling_factor df
>>> scaling_factor.rename(columns={'RPK_taxon':'RPK_taxon_total'}, inplace=True)
>>> scaling_factor.head()
# merge the scaling_factor df with the species_sample_grouped df
>>> tpm = pd.merge(species_sample_grouped, scaling_factor, on='sample')
# calculate the tpm for each taxon within each sample
>>> tpm['tpm'] = tpm['RPK_taxon'] / tpm['scaling_factor']
>>> tpm.head()
   species_ID sample  mapped_reads  contig_length  RPK_taxon  RPK_taxon_total  scaling_factor          tpm
0          56  D8C82            14           1188  11.784512      4384.416536        0.004384  2687.817567
1         274  D8C61            24           1030  23.300971      6852.457715        0.006852  3400.381563
2         287  D8C01            42           1032  40.697674     17494.414399        0.017494  2326.323905
3         287  D8C03            30           1986  15.105740      7177.425611        0.007177  2104.618146
4         287  D8C44            50           4629  10.801469      1881.931407        0.001882  5739.565726
```

Finally, save the file for records:
```
>>> tpm.to_csv("taxon_tpm_within_samples.csv", index=False)
```

Note: you can check if this is correct by seeing if your tpm == 1,000,000 by
```
>>> tpm.groupby('sample')['tpm'].sum()
sample
D8C01    1000000.0
D8C03    1000000.0
D8C05    1000000.0
D8C42    1000000.0
D8C43    1000000.0
D8C44    1000000.0
D8C61    1000000.0
D8C63    1000000.0
D8C65    1000000.0
D8C82    1000000.0
D8C84    1000000.0
D8C85    1000000.0
Name: tpm, dtype: float64
```







