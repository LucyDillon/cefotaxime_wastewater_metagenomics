# Complete gene enrichment analysis of ARGs:

You will need now to calculate the read counts per gene NOT contig (that you did to calculate the TPM for taxonomy).

Step 1: Build indexes for predicted genes
```bash
module load apps/bowtie2/2.5.2/gcc-14.1.0
module load apps/samtools/1.17/gcc-14.1.0

for i in $(cat ../../assembly/samples.txt); do bowtie2-build ${i}.ffn ${i}_db; done 
```
Step 2: Create bam files 
```bash
for i in $(cat ../../assembly/samples.txt); do bowtie2 -x ${i}_db -1 ../../preprocess/fastp_results/${i}_*_R1.trimmed.fastq -2 ../../preprocess/fastp_results/${i}_*_R2.trimmed.fastq | samtools view -bS - > ${i}.bam; done 
```

Step 3: calculate feature counts per gene
Note: use the BAM file from the original assemblies not from prodigal 
```bash
source activate /mnt/scratch2/igfs-anaconda/conda-envs/subread
# featureCounts -v
# featureCounts v2.0.1

for i in $(cat ../../assembly/samples.txt); do featureCounts -a ${i}.gff -o ${i}_counts.txt ../../assembly/alignment_data/${i}.bam; done
```

Step 1: Parse featureCounts Output
We will use python for the following steps.
```python

import pandas as pd

# featureCounts output has this structure:
# Geneid  Chr  Start  End  Strand  Length  sample1.bam
# gene1   contig1  100  500  +  400  150
# gene2   contig1  600  1200  +  600  75

#this example will be for sample D8C01
gene_counts = pd.read_csv("D8C01_counts.txt", sep='\t', comment='#', 
                          usecols=['Geneid', 'Length', 'D8C01.bam'])
gene_counts.columns = ['gene_id', 'gene_length', 'mapped_reads']
gene_counts['sample'] = 'D8C01'
```

Step 2: Link to AMR Annotations

```python
amr_annotations = pd.read_csv("amr_annotations.txt", sep='\t',
                              names=['sample', 'gene_id', 'ARG', 'DrugClass', 'Subclass'])


merged_data = pd.merge(amr_annotations, gene_counts, on=['gene_id', 'sample'])
```


Step 3: Aggregate by AMR Gene 
```python
# group by amr_gene
amr_sample_grouped = merged_data.groupby(['ARG', 'sample'], as_index=False)[['mapped_reads', 'gene_length']].sum()

```

Step 4: Calculate RPK 
```python
amr_sample_grouped['RPK_gene'] = amr_sample_grouped['mapped_reads'] / (amr_sample_grouped['gene_length']/1000)
```
Step 5: Calculate Scaling Factor 
```python
scaling_factor = amr_sample_grouped.groupby(['sample'], as_index=False)['RPK_gene'].sum()
scaling_factor['scaling_factor'] = scaling_factor['RPK_gene'] / 1000000
scaling_factor.rename(columns={'RPK_gene':'RPK_gene_total'}, inplace=True)
```
Step 6: Calculate TPM 
```python
tpm = pd.merge(amr_sample_grouped, scaling_factor, on='sample')
tpm['tpm'] = tpm['RPK_gene'] / tpm['scaling_factor']

# Save
tpm.to_csv("amr_gene_tpm_within_samples.csv", index=False)

# Verify
tpm.groupby('sample')['tpm'].sum()  # Should be 1,000,000 for each sample
```

