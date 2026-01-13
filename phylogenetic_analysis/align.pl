use Bio::SeqIO;
use  Bio::Seq;
($in1,$in2,$in3)=@ARGV;
open IN1,"$in1";
open IN2,"$in2";
open IN3,"$in3";
@spe=("Pavi-R"
,"Atha"
,"Parm"
,"Pavi-13"
,"Pavi-B"
,"Pavi-T"
,"Pcam-F"
,"Pcam-S"
,"Pcero"
,"Pceru-A"
,"Pceru"
,"Pcon"
,"Pdul"
,"Pfru"
,"Phum"
,"Pinc"
,"Pmah"
,"Pmuml"
,"Pper"
,"Ppse"
,"Ppus"
,"Psera"
,"Psert"
,"Pspa"
,"Pspe"
,"Psub"
,"Ptia"
,"Ptom"
,"Pyed"
,"Rchi"
,"Vvin");

my $catchseq_seqio_obj1 = Bio::SeqIO->new(-file=>"<$in1", -format=>'fasta');  
    while(my $seq_obj = $catchseq_seqio_obj1->next_seq){
        $id=$seq_obj->display_name;
        $seq=$seq_obj->seq;
        $hash{$id}=$seq;
      }
while(chomp($line=<IN2>)){
	$hash_single{$line}++;
}
while(chomp($line=<IN3>)){
	@tmp=split(" ",$line);
	if($tmp[0]=~/(.*):/){
		$group_id=$1;
	}
	if(exists($hash_single{$group_id})){
		open TMP,">tmp.fa";
		$num=scalar(@tmp)-1;
		foreach(1..$num){
			$gene=$tmp[$_];
			if($gene=~/(.*)\|(.*)/){ 
					$spe=$1;
					$seq=$hash{$gene};
					print TMP ">$spe\n";
					print TMP "$seq\n";
			}
		}
		close TMP;
		system("muscle -in tmp.fa -out tmp_align.fa");
		system("Gblocks tmp_align.fa -t=p -b4=5 -b5=h");
		open TMP2, ">tmp2.fa";
		my $catchseq_seqio_obj1 = Bio::SeqIO->new(-file=>"<tmp_align.fa-gb", -format=>'fasta');  
    while(my $seq_obj = $catchseq_seqio_obj1->next_seq){
        $id=$seq_obj->display_name;
        $seq=$seq_obj->seq;
        $len=$seq_obj->length;
        $hash_tmp{$id}=$seq;
    }
    foreach(@spe){
    	if(exists($hash_tmp{$_})){
    		print TMP2 ">$_\n";
    		print TMP2 "$hash_tmp{$_}\n";
    	}
    	else{
    		$seq='-' x int($len);
    		print "$len\n";
    		print "$seq\n";
    		print TMP2 ">$_\n";
    		print TMP2 "$seq\n";

    	}
    }
    close TMP2;
    %hash_tmp=();
		my $catchseq_seqio_obj1 = Bio::SeqIO->new(-file=>"<tmp2.fa", -format=>'fasta');  
    while(my $seq_obj = $catchseq_seqio_obj1->next_seq){
        $id=$seq_obj->display_name;
        $seq=$seq_obj->seq;
        $hash_final{$id}=$hash_final{$id}.$seq;
    }
	}
}
open OUT, ">final_align.fa";
foreach(keys(%hash_final)){
    print OUT ">$_\n";
    print OUT "$hash_final{$_}\n";
}
close OUT;
