#!/bin/bash
#SBATCH --time=02:59:00
#SBATCH --partition=k2-hipri,k2-bioinf
#SBATCH --mem=10G
#SBATCH --mail-user=l.dillon@qub.ac.uk
#SBATCH --mail-type=END,BEGIN,FAIL
#SBATCH --error=make_tsv-%A-%a.err
#SBATCH --job-name=make_tsv

for file in *concoct*.fa; do   {     printf "File\tContigID\tBinner\n";     grep '^>' "$file" |     awk -v f="$file" '{print f "\t" $1 "\tconcoct"}' |     sed 's/>//g' | sed 's/.fa//g';   } > "${file%%.fa}.contigs_to_bin.tsv"; done

for file in *maxbin2*.fa; do   {     printf "File\tContigID\tBinner\n";     grep '^>' "$file" |     awk -v f="$file" '{print f "\t" $1 "\tmaxbin2"}' |     sed 's/>//g' | sed 's/.fa//g';   } > "${file%%.fa}.contigs_to_bin.tsv"; done

for file in *metabat2*.fa; do   {     printf "File\tContigID\tBinner\n";     grep '^>' "$file" |     awk -v f="$file" '{print f "\t" $1 "\tmetabat2"}' |     sed 's/>//g' | sed 's/.fa//g';   } > "${file%%.fa}.contigs_to_bin.tsv"; done
