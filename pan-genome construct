##6.pan-genome construct
#for SV calling
minimap2 -t 20 -ax asm5 --eqx ref.fa  qry.fa -o  sample.eqx.sam 
syri -c sample.eqx.sam -r ref.fa -q qry.fa -F S --nosnp --nc 10 --prefix sample

python sam2delta.py sample.eqx.sam  > sample.eqx.sam.delta
Assemblytics sample.eqx.sam.delta sample 10000 50 10000
                
#for SV merge
SURVIVOR merge sample.vcf.file.list 200 1 1 1 1 50 sample.SURVIVOR.merge.vcf

#for VG construct
bgzip -f -@ 50 All_SURVIVOR_merge_200.vcf
zcat All_SURVIVOR_merge_200.vcf.gz |grep '^#'>header_200
zcat All_SURVIVOR_merge_200.vcf.gz |grep -v '^#' |sort -k1,1d -k2,2n > body_200
cat header_200 body_200 |bgzip -c >new.All_SURVIVOR_merge_200.vcf.gz
tabix -f -p vcf new.All_SURVIVOR_merge_200.vcf.gz
vg construct -S -t 50 -v new.All_SURVIVOR_merge_200.vcf.gz -r ref.genome.fasta >All_SURVIVOR_200.vg
vg stats -z -N -E -l -p 50 All_SURVIVOR_200.vg >All_SURVIVOR_200.stat

#for gene family
orthofinder -f Mycoplasma/ -t 32
