#SV calling, validation, and annotation

#1. raw reads filtering
~/bin/fastp -i sample_1.clean.fq.gz -o sample_1.filtered.fq.gz -I sample_2.clean.fq.gz -O sample_2.filtered.fq.gz -q 20 -u 40 -l 70

~/bin/trimmomatic  PE  sample_1.clean.fq.gz  sample_2.clean.fq.gz    sample_1.fq   sample.R1U.fq    sample_2.fq      sample.R2U.fq     -threads 100 \
    ILLUMINACLIP:trimmomatic-0.39-2/adapters/TruSeq3-PE-2.fa:2:30:10:1:TRUE     SLIDINGWINDOW:4:20 LEADING:3 TRAILING:3 MINLEN:40

#2. Reads mapping
python /data/leiyh/cherry/soft/scripts/combinefastq.py     --R1 sample_1.fq --R2 sample_2.fq     --out sample.comb.fastq

vg index -t 10 --temp-dir ./    -x graph.xg    -g graph.gcsa    All_SURVIVOR_200.vg
vg map -m short  -t 10  -x graph.xg  -g  graph.gcsa  -f  sample_1.fq    -f sample}_2.fq > sample.gam
vg stats   -p  1  -a sample.gam > sample.gam.stats 
vg pack -t 10 -x  graph.xg  -g sample.gam  -Q 5  -s 5  -o sample.pack

#4. Variant calling 
vg call -t 2 -a  -s sample  -k sample.pack  graph.xg > sample.SV.vcf 2>sample.SV.log 

#5. Variant processing
ls *.SV.vcf|while read id 
do 
arr=(${id})
sample=${arr[0]}
bgzip  $sample
tabix  $sample.gz
done

ls *.SV.vcf.gz > vcf.list
bcftools merge   -m all   -Oz   -o all.SV.vcf.gz   -l vcf.list
tabix -p vcf all.SV.vcf.gz

#6. Variant  filtering
## 6.1 Variant filtering for population analysis
bash filter_sv_for_popgen.sh

##6.2 Variant filtering for GWAS analysis
gunzip all.SV.vcf.gz
plink --vcf  all.SV.vcf  --recode --out all.SV --set-missing-var-ids @:#  --allow-extra-chr   1>vcf_to_ped.log  2>&1
plink --vcf  all.SV.vcf  --make-bed --out  all.SV --set-missing-var-ids @:# --allow-extra-chr 1>vcf_to_bed.log  2>&1 

plink  --vcf   all.SV.vcf   --missing --allow-extra-chr  --out all.SV.missrate 1>sample_SV_missrate.log  2>&1
awk '$NF>0.8 &&  NR > 1 {print $1"\t"$2}' all.SV.missrate.imiss > all.SV.fail_missing.samples
plink --bfile  all.SV  --out all.SV.het  --het  -allow-extra-chr 1>sample_hetrate.log 2>&1

plink --bfile  all.SV   --out  all.SV.ld    --allow-extra-chr  --indep-pairwise 50 10 0.2  1> all.SV.ld.log  2>&1
plink --bfile all.SV --out all.SV.ld  --extract all.SV.ld.prune.in  --genome --min 0.95   --allow-extra-chr  1>sample_pihat_filter.log 2>&1
awk 'FNR==NR{A[$1"\t"$2]=$NF}; FNR!=NR && FNR >1 { m1 = A[$1"\t"$2]; m2 = A[$3"\t"$4] ; print $0"\t"m1"\t"m2}'   all.SV.missrate.imiss    all.SV.ld.genome | awk  '{if($(NF-1)>$NF){print $1"\t"$2}else{print $3"\t"$4}}' |sort -u> all.SV.fail_pihat.samples
cat all.SV.fail_missing.samples   all.SV.fail_pihat.samples  |sort -u >  all.SV.fail.samples
plink --vcf all.SV.vcf  --out all.SV.final_clean  --recode vcf-iid  --remove  all.SV.fail.samples  --make-bed --geno 0.1   --biallelic-only strict  --hwe 1e-6  -set-missing-var-ids @:#  --allow-extra-chr   1>all.SV.final_clean.log 2>&1

plink --vcf all.SV.vcf  --out all.SV.final_clean  --recode vcf-iid  --remove  all.SV.fail.samples  --make-bed --geno 0.9 --maf 0.01  --biallelic-only strict  --hwe 1e-6  -set-missing-var-ids @:#  --allow-extra-chr   1>all.SV.final_clean.log 2>&1


#7. Variant Validation
bash extract_by_clean_sites.sh
bash pick_top100_by_QUAL.sh

#8. Variant annotation
java -jar  /opt/snpEff/snpEff.jar ann -c ./snpEff.config  -i vcf -ud 5000  -csvStats ann.csv -htmlStats ann.html -o vcf  newGenome  all.SV.final_clean.vcf >all.SV.final_clean.ann.vcf






