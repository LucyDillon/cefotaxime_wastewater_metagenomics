# I run this interactively just with 10GB on the k2-hipri node
source activate /mnt/scratch2/igfs-anaconda/conda-envs/plasmidfinder_v2.1.6

for i in $(cat ../../assembly/samples.txt); do mkdir plasmid_finder_${i}; plasmidfinder.py -i ${i}.ffn -o plasmid_finder_${i} -x -mp /mnt/scratch2/igfs-anaconda/conda-envs/ncbi-blast/bin/blastn; done
# -x option produces nice clean tsv files and fasta files 
