#!/bin/bash -l
#SBATCH --job-name=ortho
#SBATCH --partition=core192
#SBATCH -N 1
#SBATCH --ntasks-per-node=40
#SBATCH --output=%j.out
#SBATCH --error=%j.err

orthofinder -a 40 -f seq/
#orthofinder -a 40 -b ~/lixiang511/Kiwifruit/Actinidia_valvata/orthofinder2/seq_prot/OrthoFinder/Results_Jul17
#orthofinder -a 40 -M msa -T raxml-ng -f seq_prot/
