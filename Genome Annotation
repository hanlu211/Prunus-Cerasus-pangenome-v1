##4.repeat annotation
EDTA.pl --threads 30 --genome genome.fasta --overwrite 1 --sensitive 1 --anno 1 --evaluate 1 --force 1

##5.gene structure annotation
#for Augustus
export PATH=/path/Augustus/bin/:$PATH
export AUGUSTUS_CONFIG_PATH=/path/Augustus/config/
perl ./Augustus/scripts/autoAugTrain.pl --cpus=16 --genome=genome.fasta --trainingset=trainingset.gff3 --species=sample --est=sample.transcriptome.psl --workingdir=./01_Augustus/01_training 
perl ./Augustus/scripts/autoAugPred.pl --species=sample  --cpus=32 --workingdir=./01_Augustus/02_prediction --genome=genome.fasta

#for genemark-etp
gmetp.pl --cores 32 --clean --bam ./transcriptome_mapping_dir --workdir prediction_dir --cfg config_file.ymal --softmask

#for gemoma
./pipeline.sh tblastn <target-genome> <ref-anno> <ref-genome> 32 <out-dir> FR_UNSTRANDED <mapped-reads>

#for PASA
PASApipeline.v2.5.3/bin/seqclean sample.transcripts.fasta -v database/UniVec/UniVec
PASApipeline.v2.5.3/Launch_PASA_pipeline.pl -c Tmai.pasa.alignAssembly.config -C -R -g genome.fasta -t Tsample.transcripts.fasta.clean -T -u sample.transcripts.fasta --ALIGNERS gmap,minimap2 --CPU 64

#for evidencemodeler
$EVM_HOME/EVidenceModeler --sample_id mySampleID --genome genome.fasta --gene_predictions gene_predictions.gff3 --protein_alignments protein_alignments.gff3 --transcript_alignments transcript_alignments.gff3 --segmentSize 100000 --overlapSize 10000 
