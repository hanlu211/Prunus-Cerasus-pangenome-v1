
#1. Selective sweep signals (SNP-indel-SV)
#(1). calculated Fst
vcftools --gzvcf cherry.vcf.gz --weir-fst-pop early_stage.txt --weir-fst-pop later_stage.txt --fst-window-size 50000 --fst-window-step 10000 --out cherry.early.later.stage
vcftools --gzvcf cherry.vcf.gz --weir-fst-pop early_stage.txt --weir-fst-pop mid_stage.txt  --fst-window-size 50000 --fst-window-step 10000 --out cherry.early.mid.stage
vcftools --gzvcf cherry.vcf.gz --weir-fst-pop mid_stage.txt --weir-fst-pop  later_stage.txt  --fst-window-size 50000 --fst-window-step 10000 --out cherry.early.mid.stage

#(2). calculated pi
for i in {later,early,mid};
	do vcftools --gzvcf cherry.${i}.vcf.gz --window-pi 50000 --window-pi-step 10000 --out cherry.${i}
	done

#(3). get selective regions.
python extract_signification.py cherry.early.later.stage.fst_pi cherry.early.later.stage.fst_pi.txt cherry.early.later.stage.fst_pi.plot 0.05
python extract_signification.py cherry.early.mid.stage.fst_pi  cherry.early.mid.stage.fst_pi.txt   cherry.early.mid.stage.fst_pi.plot 0.05
python extract_signification.py cherry.mid.later.stage.fst_pi  cherry.mid.later.stage.fst_pi.txt  cherry.mid.later.stage.fst_pi.plot 0.05


