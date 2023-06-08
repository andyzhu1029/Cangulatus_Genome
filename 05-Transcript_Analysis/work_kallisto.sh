#!/usr/bin/env bash
#
#
#
source /public/agis/yanjianbin_group/zhuandong/Biosofts/anaconda3/etc/profile.d/conda.sh
conda activate /vol3/agis/yanjianbin_group/zhuandong/opt/envs/kallisto
conda info --envs

#STEP 1
#gffread Cangulatus_A_chr.gff3  -g Celastrus_angulatus_A_genome.fasta  -w  CaA.exon.fas
#gffread Cangulatus_B_chr.gff3  -g Celastrus_angulatus_B_genome.fasta  -w CaB.exon.fas
#cat CaA.exon.fas CaB.exon.fas > CaA_CaB.exon.fas
#kallisto index -i CaA_CaB.exon.idx CaA_CaB.exon.fas

#STEP 2
R=/vol3/agis/yanjianbin_group/zhuandong/02-Cangulatus/06-Transcriptome_analysis/Clean_seq

#ls $R/*.fq.gz |cut -d "/" -f 9|cut -d"_" -f 1,2 |uniq| while read  id
#do
#echo $id 
#kallisto quant -i CaA_CaB.exon.idx  -b 100 -o ${id}.kallisto_result -t 20 $R/${id}_1_val_1.fq.gz $R/${id}_2_val_2.fq.gz
#done

#STEP 3
/vol3/agis/yanjianbin_group/zhuandong/software/kallisto2matrix-first/kallisto2matrix -i sample_lst.txt -o Count
