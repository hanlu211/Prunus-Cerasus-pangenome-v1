#Paired-end reads
fastp -i R1.fq.gz -o clean.r1.fq.gz -I R2.fq.gz -O clean.r2.fq.gz -w 16 -j fastp.json -h fastp.html -z 4
#HiFi & Nanopore reads：
fastplong -i reads.fastq.gz -o reads.clean.fastq.gz -w 16 -j fastp.json -h fastp.html
