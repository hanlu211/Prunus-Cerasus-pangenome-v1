#7.gene expression
##for build index 
hisat2build -p 20 genome.fasta genome.hisat2.index

##for RNA-seq mapping
#for RNA-seq
hisat2 -x genome.hisat2.index -1 sample.R1.clean.fq.gz -2 sample.R2.clean.fq.gz -p 16 -S sample.genome.sorted.sam 

#for sam2bam and sort
samtools vies -bS -@ 16 -o sample.bam sample.sam
samtools sort -@ 16 -o sample.sorted.bam sample.bam

#for expression
stringtie sample.sorted.bam -p 16 -o sample.transcripts.gtf -l sample.label

#for WGCNA
wgcna.R
