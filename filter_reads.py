from Bio import SeqIO
import glob
import os

def filter_fasta(input_files_pattern, output_base_dir, min_length):
    input_files = glob.glob(input_files_pattern)  # Expand wildcard to get all files

    if not input_files:
        print("No input files found.")
        return

    for input_file in input_files:
        # Extract subdirectory name from input_file path
        sub_dir = os.path.basename(os.path.dirname(input_file))  # Gets PN0204xxx

        # Construct specific output directory
        output_dir = os.path.join(output_base_dir, sub_dir)
        os.makedirs(output_dir, exist_ok=True)  # Ensure subdirectory exists

        output_file = os.path.join(output_dir, os.path.basename(input_file).replace(".fasta", "_filtered.fasta"))

        with open(output_file, "w") as output_handle:
            for record in SeqIO.parse(input_file, "fasta"):
                if len(record.seq) >= min_length:
                    SeqIO.write(record, output_handle, "fasta")

        print(f"Filtered: {input_file} → {output_file}")

input_files_pattern = "metaspades/D8C*/contigs.fasta"
output_base_dir = "filtered_assembly/"  # Base output directory
min_length = 1000

filter_fasta(input_files_pattern, output_base_dir, min_length)
