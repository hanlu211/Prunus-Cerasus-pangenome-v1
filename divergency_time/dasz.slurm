#!/bin/bash -l
#SBATCH --job-name=mcmc2
#SBATCH --partition=core112
#SBATCH -N 1
#SBATCH --ntasks-per-node=10
#SBATCH --output=%j.out
#SBATCH --error=%j.err

#echo $(seqkit seq -w 0 ../final_align.fa) |sed "s/ >/\n/g" |sed "s/>//g"|sed "s/ /  /g" >input.phy
#首行加上物种数量和序列长度
~/software/paml-4.10.7/bin/mcmctree mcmctree.ctl
