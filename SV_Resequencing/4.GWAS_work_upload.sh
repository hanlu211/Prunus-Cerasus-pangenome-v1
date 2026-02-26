#1. run gwas (SNP-indel-SV)
# tassel software
run_pipeline.pl -Xms512m -Xmx100g   -fork1 -vcf cherry.vcf    -fork2  -t trait.txt  -fork3 -q  Qdata.txt  -combine4 -input1 -input2 -input3 -intersect   -FixedEffectLMPlugin -endPlugin    -export glm_output

# Gemma software
plink --vcf cherry.vcf  --pheno  trait.txt  --make-bed --out cherry.vcf --set-missing-var-ids @:# --allow-extra-chr  --allow-no-sex
gemma  -bfile cherry.vcf  -c covariate.txt  -outdir  ./ -o  gemma_lm  -lm 1  -miss 0.2 -maf 0.01 -hwe 0