#!/bin/bash
#SBATCH --time=02:59:00
#SBATCH --partition=k2-hipri,k2-bioinf
#SBATCH --mem=10G
#SBATCH --mail-user=l.dillon@qub.ac.uk
#SBATCH --mail-type=END,BEGIN,FAIL
#SBATCH --error=make_hmm-%A-%a.err
#SBATCH --job-name=make_hmm

for i in *.hmm.tigr.hit.out; do cat $i | grep -v "^#" | awk '{print $1"\t"$3"\t"$5}' > ${i%%.hmm.tigr.hit.out}.tigr; done
for i in $(cat ../samples.txt); do cat ${i}*.tigr > $i.tigr; done

for i in *.hmm.pfam.hit.out; do cat $i | grep -v "^#" | awk '{print $1"\t"$4"\t"$5}' > ${i%%.hmm.pfam.hit.out}.pfam; done
for i in $(cat ../samples.txt); do cat ${i}*.pfam > $i.pfam; done

for i in $(cat ../samples.txt); do cat ${i}.pfam ${i}.tigr > ${i}.hmm; done
