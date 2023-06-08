#!/usr/bin/env bash
#================================================
#@Author: Andy_Zhu
#Date: 2nd June 2023
#===============================================
source /path/conda.sh
conda activate /path/envs/kallisto
conda info --envs

#STEP 1: obtained exon using gffread
#gffread Cangulatus_A_chr.gff3  -g Celastrus_angulatus_A_genome.fasta  -w  CaA.exon.fas
#gffread Cangulatus_B_chr.gff3  -g Celastrus_angulatus_B_genome.fasta  -w CaB.exon.fas
#cat CaA.exon.fas CaB.exon.fas > CaA_CaB.exon.fas

#STEP 2: create indes using kallisto index
#kallisto index -i CaA_CaB.exon.idx CaA_CaB.exon.fas

#STEP 4: caculate tpm
R=/path/Clean_seq

#ls $R/*.fq.gz |cut -d "/" -f 9|cut -d"_" -f 1,2 |uniq| while read  id
#do
#echo $id 
#kallisto quant -i CaA_CaB.exon.idx  -b 100 -o ${id}.kallisto_result -t 20 $R/${id}_1_val_1.fq.gz $R/${id}_2_val_2.fq.gz
#done

#STEP 5: transform tpm to int for DESeq ananlysis 
/path/software/kallisto2matrix-first/kallisto2matrix -i sample_lst.txt -o Count
