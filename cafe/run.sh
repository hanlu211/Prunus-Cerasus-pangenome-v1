#!/bin/bash -l
#SBATCH --job-name=cafe
#SBATCH --partition=core384
#SBATCH -N 1
#SBATCH --ntasks-per-node=60
#SBATCH --output=%j.out
#SBATCH --error=%j.err
#awk -v OFS="\t" '{$NF=null;print $1,$0}' Orthogroups.GeneCount.tsv |sed -E -e 's/Orthogroup/desc/' -e 's/_[^\t]+//g' >gene_families.txt
#awk 'NR==1 || $3<100 && $4<100 && $5<100 && $6<100 && $7<100 && $8<100 && $9<100 && $10<100 && $11<100 && $12<100 && $13<100 && $14<100 && $15<100 && $16<100 && $17<100 && $18<100 && $19<100 && $20<100 && $21<100 && $22<100 && $23<100 && $24<100 && $25<100 && $26<100 && $27<100 && $28<100 && $29<100 && $30<100 && $31<100 && $32<100 && $33<100  {print $0}' gene_families.txt >gene_families_filter.txt
#for i in `cat families_largest.txt`;do sed -i "/$i/d" gene_families_filter.txt;done
cafe5 -i gene_families_filter.txt -t FigTree_revise.tree --cores 60 -p -k 2 -o k2p
#cafe5 -i gene_families_filter.txt -t FigTree_revise.tree --cores 10 -p -k 5 -o k5p
