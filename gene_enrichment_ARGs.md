# Complete gene enrichment analysis of ARGs:

You have already calculated the contig read counts and contig lengths in the TPM analysis (see that markdown file for information if needed).

## Step 1: get a list of samples with corresponding ARGs and the contigs they are on.


awk '{print FILENAME "," $0}' *.txt

