#1.Phylogenetic tree
bcftools view -Oz   -o all.SV.final.vcf.gz all.SV.final.vcf
tabix -f -p vcf all.SV.final.vcf.gz
perl SV_vcf_to_phylip.pl vcf all.SV.final.vcf.gz  SV01.raw.phy
iqtree2 -s SV01.raw.phy   -st MORPH     -m MK+ASC     -bb 1000    -nt 64   -pre SV01_MK_ASC 
iqtree2 -s SV01_MK_ASC.varsites.phy   -st MORPH   -m MK+ASC   -bb 1000   -bnni   -nt 32   -pre SV01_MK_ASC_FINAL_bnni 

#2. VCF to bed  and LD pruning 
plink --vcf  all.SV.final.vcf  --make-bed --out  all.SV.final   --allow-extra-chr --set-missing-var-ids @:#  
plink --bfile  all.SV.final   --indep-pairwise 50 10 0.2 --out  all.SV.final_clean.filterld   --allow-extra-chr --set-missing-var-ids @:#
plink --bfile  all.SV.final  --make-bed --extract all.SV.final_clean.filterld.prune.in  --out  all.SV.final_clean.final_clean.LD   --allow-extra-chr --set-missing-var-ids @:#  

#3.ADMIXTURE
awk '{print $1}'   all.SV.final_clean.final_clean.LD.bim |sort -u |awk  '{print $1"\t"NR}'  > chrom.mapid
awk  'NR==FNR{A[$1] = $2}; NR>FNR{if( $1 in A){$1=A[$1]};  print $0}'  chrom.mapid   all.SV.final_clean.final_clean.LD.bim  > all.SV.final_clean.final_clean.LD.sort.bim
seq 2 5 | awk '{print "nohup admixture --cv -j2 all.SV.final_clean.final_clean.LD.sort.bed  "$1" 1>admix."$1".log 2>&1 &" }' > admixture.sh
bash  admixture.sh

#4. Principal Component Analysis
plink --bfile all.SV.final_clean  --pca 10 --out  plink_PCA  --allow-extra-chr --set-missing-var-ids @:#  
awk '{print $1 "\tgroup1"}' plink_PCA.nosex > sample.pop
Rscript  draw_PCA.R  plink_PCA.eigenvec 1 2  sample.pop  plink_PCA.figure













