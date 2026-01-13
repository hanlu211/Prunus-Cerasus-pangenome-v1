#!/bin/bash -l
#SBATCH --job-name=dasz
#SBATCH --partition=core128
#SBATCH -N 1
#SBATCH --ntasks-per-node=1
#SBATCH --output=%j.out
#SBATCH --error=%j.err

perl align.pl cds_all.fasta Orthogroups_SingleCopyOrthologues.txt Orthogroups.txt
#~/software/clustalw-2.1-linux-x86_64-libcppstatic/clustalw2 convert -infile=final_align.fa -convert -type=aa -outfile=final_align.phy -output=PHY
#/public/soft/BLAST/ncbi-blast-2.14.1+/bin/blastp -query /public/home/teach/xiaeh/HGT/DASZ/DASZ.protein.fa -db /public/home/data/nr20230910/nr -outfmt '6 std staxids' -seg no -evalue 1e-5 -num_threads 120 -out /public/home/teach/xiaeh/HGT/DASZ/DASZ_NR.blast 
