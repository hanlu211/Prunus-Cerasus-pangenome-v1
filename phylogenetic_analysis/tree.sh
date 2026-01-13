#!/bin/bash -l
#SBATCH --job-name=dasz
#SBATCH --partition=core112
#SBATCH -N 1
#SBATCH --ntasks-per-node=20
#SBATCH --output=%j.out
#SBATCH --error=%j.err
#muscle -in final_align.fa -out final_align2.fa
#~/software/clustalw-2.1-linux-x86_64-libcppstatic/clustalw2 convert -infile=final_align.fa -convert -type=DNA -outfile=final_align.phy -output=PHY
#modeltest-ng -i final_align.phy -d nt -p 10
raxml-ng  --bs-trees 200 --model GTR+I+G4 --outgroup Atha -msa final_align.phy  --thread 5  --all
