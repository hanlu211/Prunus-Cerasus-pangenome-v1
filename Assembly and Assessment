##1. genome assembly
hifiasm -o sample.asm -t 32 sample.fastq.gz

##2. genome assessment
minimap2 -x map-hifi -t 32 -a -o sample.minimap2.hifi.sam  ref.genome.fasta 
minimap2 -x map-ont -t 32 -a -o sample.minimap2.ont.sam   ref.genome.fasta
run_BUSCO.py -i genome.fasta  -l embryophyta -o genome.busco -m genome -t 32 

##3.chromosome-level assembly
bwa index contigs.genome.fa

python ~/juicer/misc/generate_site_positions.py  dpnII  sample  contigs.genome.fa

awk 'BEGIN{OFS="\t"}{print $1, $NF}' ample_dpnII.tx > sample.genome.chrom.sizes

~/juicer/scripts/juicer.sh -g draft_genome -s dpnII -z ref.genome.fa -y sample_dpnII.txt -p  sample.genome.chrom.sizes -t 8

~/3d-dna/run-asm-pipeline.sh contigs.genome.fa ./aligned/merged_nodups.txt
