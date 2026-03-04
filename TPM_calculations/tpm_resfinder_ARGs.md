# Calculate the TPM for the ARGs detected by ResFinder

```python
import pandas as pd
gene_counts = pd.read_csv("feature_counts_all.txt", sep='\t', names=['sample', 'Geneid', 'Chr', 'Start', 'End', 'Strand', 'Length', 'mapped_reads'])
gene_counts['full_gene_id'] = gene_counts['Chr'] + '_' + gene_counts['Geneid'].str.split('_').str[-1]
gene_counts = gene_counts[['sample', 'full_gene_id', 'Length', 'mapped_reads']]
gene_counts.columns = ['sample', 'gene_id', 'gene_length', 'mapped_reads']
amr_annotations = pd.read_csv("combined_all_resfinder_cleaned2.txt", sep='\t')
merged_data = pd.merge(amr_annotations, gene_counts, on=['gene_id', 'sample'])
amr_sample_grouped = merged_data.groupby(['Resistance gene', 'sample'], as_index=False)[['mapped_reads', 'gene_length']].sum()
amr_sample_grouped['RPK_gene'] = amr_sample_grouped['mapped_reads'] / (amr_sample_grouped['gene_length']/1000)
scaling_factor = amr_sample_grouped.groupby(['sample'], as_index=False)['RPK_gene'].sum()
scaling_factor['scaling_factor'] = scaling_factor['RPK_gene'] / 1000000
scaling_factor.rename(columns={'RPK_gene':'RPK_gene_total'}, inplace=True)
tpm = pd.merge(amr_sample_grouped, scaling_factor, on='sample')
tpm['tpm'] = tpm['RPK_gene'] / tpm['scaling_factor']
tpm.to_csv("amr_gene_tpm_within_samples.csv", index=False)
tpm.to_csv("amr_resfinder_gene_tpm_within_samples.csv", index=False)
tpm.groupby('sample')['tpm'].sum()
```
