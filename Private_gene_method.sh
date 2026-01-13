#1.RNA-seq QC 
fastp -i R1.fq.gz -o clean.r1.fq.gz -I R2.fq.gz -O clean.r2.fq.gz -w 16 -j fastp.json -h fastp.html -z 4

#2.RNA-seq clean reads mapping
hisat2build -p 20 genome.fasta genome.hisat2.index

hisat2 -x genome.hisat2.index -1 sample.R1.clean.fq.gz -2 sample.R2.clean.fq.gz -p 16 -S sample.genome.sorted.sam 

#3. TPM calculater
samtools vies -bS -@ 16 -o sample.bam sample.sam
samtools sort -@ 16 -o sample.sorted.bam sample.bam
stringtie sample.sorted.bam -p 16 -o sample.transcripts.gtf -l label

#4. stat private genes
