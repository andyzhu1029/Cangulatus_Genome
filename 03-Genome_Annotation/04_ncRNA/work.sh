#!/usr/bin/env  bash
#SBATCH --partition=low
#SBATCH -N 1
#SBATCH -c 10
#SBATCH -J work.sh
#SBATCH --error=err_%J_work.sh
#SBATCH --output=out_%J_work.sh

#R=/home/zhuandong/02-Database/03-Rfam
#ln -s /home/zhuandong/02-Database/03-Rfam/Rfam_anno.txt
#ln -s /home/zhuandong/02-Database/03-Rfam/Rfam_anno-snRNA.txt

#tRNA Annotation using tRNAscan
#source /home/zhuandong/01-Biosoft/miniconda3/etc/profile.d/conda.sh
#conda activate /home/zhuandong/01-Biosoft/opt/envs/tRNAscan
#conda info --envs
#tRNAscan-SE -o CanA_tRNA.out -f CanA_tRNA.ss -m CanA_tRNA.stats ../../Celastrus_angulatus_A_genome.fasta
#python count.py

#snRNA & miRNA & rRNA Annotation using cmscan
#esl-seqstat --dna Celastrus_angulatus_A_genome.fasta
#less $R/Rfam.cm|grep 'NAME'|sort|wc -l > CMnumber
#Z=total * 2 * CMnumber/e-6
#/home/zhuandong/01-Biosoft/infernal-1.1.4/src/cmscan --cpu 10 -Z 5271121.81 --cut_ga --rfam --nohmmonly --fmt 2 --tblout CanA_ncRNA.tblout -o CanA_ncRNA.result --clanin $R/Rfam.clanin $R/Rfam.cm ../../Celastrus_angulatus_A_genome.fasta

#Count the number of each type of ncRNA
#awk 'BEGIN{OFS="\t";}{if(FNR==1) print "target_name\taccession\tquery_name\tquery_start\tquery_end\tstrand\tscore\tEvalue"; if(FNR>2 && $20!="=" && $0!~/^#/) print $2,$3,$4,$10,$11,$12,$17,$18; }' CanA_ncRNA.tblout >CanA_ncRNA.final.txt 

#awk 'BEGIN{OFS=FS="\t"} ARGIND==1{a[$2]=$4;} ARGIND==2{type=a[$1];if(type=="") type="Others";count[type]+=1;} END{for(type in count) print type, count[type];}' Rfam_anno.txt CanA_ncRNA.final.txt > CanA_ncRNA_count.txt

#awk 'BEGIN{OFS=FS="\t"}ARGIND==1{a[$2]=$4;}ARGIND==2{type=a[$1]; if(type=="") type="Others"; if($6=="-")len[type]+=$4-$5+1;if($6=="+")len[type]+=$5-$4+1}END{for(type in len) print type, len[type];}' Rfam_anno.txt CanA_ncRNA.final.txt > CanA_ncRNA.len.txt

#Count the length of each type of ncRNA
#awk 'BEGIN{OFS=FS="\t"} ARGIND==1{a[$2]=$4;} ARGIND==2{type=a[$1];if(type=="") type="Others";count[type]+=1;} END{for(type in count) print type, count[type];}' Rfam_anno-snRNA.txt CanA_ncRNA.final.txt > Others_snRNA_count.txt

#awk 'BEGIN{OFS=FS="\t"}ARGIND==1{a[$2]=$4;}ARGIND==2{type=a[$1]; if(type=="") type="Others"; if($6=="-")len[type]+=$4-$5+1;if($6=="+")len[type]+=$5-$4+1}END{for(type in len) print type, len[type];}' Rfam_anno-snRNA.txt CanA_ncRNA.final.txt > Others_snRNA_len.txt


#rRNA Annotation using barrnap
#/home/zhuandong/01-Biosoft/barrnap/bin/barrnap --kingdom euk --threads 10 --outseq CanA_rRNA.fa  CanA_genome.tmp.fasta > CanA_rRNA.gff3

#rRNA Annotation based on cmscan
grep 'RF00001' CanA_ncRNA.tblout >> CanA-rRNA.tblout #5S_rRNA
grep 'RF00002' CanA_ncRNA.tblout >> CanA-rRNA.tblout #5.8S_rRNA
grep 'RF01960' CanA_ncRNA.tblout >> CanA-rRNA.tblout #SSU_rRNA_eukarya
grep 'RF02543' CanA_ncRNA.tblout >> CanA-rRNA.tblout #LSU_rRNA_eukarya

awk -F " " '{if($12=="+")print $4"\t""'Rfam'""\t""'rRNA'""\t"$10"\t"$11"\t"$17"\t"$12"\t""'.'""\t"$2}' CanA-rRNA.tblout  >> CanA-rRNA.gff
awk -F " " '{if($12=="-")print $4"\t""'Rfam'""\t""'rRNA'""\t"$11"\t"$10"\t"$17"\t"$12"\t""'.'""\t"$2}' CanA-rRNA.tblout  >> CanA-rRNA.gff
sort CanA-rRNA.gff > CanA-rRNA-sort.gff
grep -v '#' CanA-rRNA-sort.gff | awk -F '\t' '{print $1"\t"$4"\t"$5"\t"$9}' > CanA_rRNA_cmscan.bed

#barrnap
grep -v '#' CanA_rRNA.gff3 | awk -F '\t' '{print $1"\t"$4"\t"$5"\t"$9}' > CanA_rRNA_barrnap.bed

#barnap + rnammer
bedtools intersect -a CanA_rRNA_barrnap.bed -b CanA-rnammer.bed -wao > CanA_barrnap_rnammer.out
awk -F '\t' '{if($9==0)print $1"\t"$2"\t"$3"\t"$4}' CanA_barrnap_rnammer.out >> CanA_barrnap_rnammer.bed
cat CanA-rnammer.bed >> CanA_barrnap_rnammer.bed

#barnap + rnammer + cmscan
bedtools intersect -a CanA_rRNA_cmscan.bed  -b CanA_barrnap_rnammer.bed  -wao > CanA_barrnap_rnammer_cmscan.out
awk -F '\t' '{if($9==0)print $1"\t"$2"\t"$3"\t"$4}' CanA_barrnap_rnammer_cmscan.out >> CanA_barrnap_rnammer_cmscan.bed
cat CanA_barrnap_rnammer.bed >> CanA_barrnap_rnammer_cmscan.bed

grep '5S_' CanA_barrnap_rnammer_cmscan.bed > CanA_5S.bed
grep '5s_' CanA_barrnap_rnammer_cmscan.bed >> CanA_5S.bed
grep  '8s_' CanA_barrnap_rnammer_cmscan.bed | grep -v '18s_' | grep -v '28s_'  >> CanA_5S.bed

grep '18S_' CanA_barrnap_rnammer_cmscan.bed > CanA_18S.bed
grep '18s_' CanA_barrnap_rnammer_cmscan.bed >> CanA_18S.bed
grep 'SSU_' CanA_barrnap_rnammer_cmscan.bed >> CanA_18S.bed

grep '28S_' CanA_barrnap_rnammer_cmscan.bed > CanA_28S.bed
grep '28s_' CanA_barrnap_rnammer_cmscan.bed >> CanA_28S.bed
grep 'LSU_' CanA_barrnap_rnammer_cmscan.bed >> CanA_28S.bed

grep '5_8S' CanA_rRNA_barrnap.bed > CanA_5.8S.bed
cat CanA_5S.bed CanA_5.8S.bed CanA_18S.bed CanA_28S.bed | awk -F ";" '{print $1}' |sed 's/Name=//g' > CanA_all_rRNA.bed

#/home/zhuandong/01-Biosoft/RNAmmer/rnammer -S euk -multi -m tsu,ssu,lsu -xml CanA.xml -gff CanA.gff -h CanA.hmmereport -f rRNA.fast ../../Celastrus_angulatus_A_genome.fasta
