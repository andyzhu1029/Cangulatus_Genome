#/usr/bin/env bash

#=======================================================================================================================
# Author: Andy_Zhu
#Date: 24th August 2023
#=======================================================================================================================

#STEP 1: Repeat Annotation & ab initio
#======================================================================================================================
#STEP 1.1: Create a database for RepeatModeler
#source /public/agis/yanjianbin_group/zhuandong/Biosofts/anaconda3/etc/profile.d/conda.sh
#conda activate /public/agis/yanjianbin_group/zhuandong/Biosofts/anaconda3/envs/py3.8
#conda info --envs

#cd /vol3/agis/yanjianbin_group/zhuandong/02-Cangulatus/02-Cangulatus_B/01_Repeat/032-modeler2masker
#BuildDatabase -name Cangulatus_B_database -engine ncbi ../../Celastrus_angulatus_B_genome.fasta

#STEP 1.2: Run RepeatModeler
#RepeatModeler -database Cangulatus_B_database -pa 24 -engine ncbi 

#STEP 1.3: Run RepeatMasker
#cd ./RM_37480.ThuAug241743292023
#RepeatMasker ../../../Celastrus_angulatus_B_genome.fasta -pa 10 -e ncbi -lib consensi.fa.classified -poly \
#        -dir Repeat_result -gff 
#Run ltrharvest
R=/vol3/agis/yanjianbin_group/zhuandong/software/genometools-1.6.2/bin

#$R/gt suffixerator -db ../../Celastrus_angulatus_B_genome.fasta -indexname CanB \
#		-tis -suf -lcp -des -ssp -sds -dna
#$R/gt ltrharvest -index CanB -similar 90 -vic 10 -seed 20 -seqids yes \
#	      -minlenltr 100 -maxlenltr 7000 -mintsd 4 -maxtsd 6 \
#	      -motif TGCA -motifmis 1 > CanB.harvest.scn
#/vol3/agis/yanjianbin_group/zhuandong/opt/envs/LTR_retriever/bin/ltr_finder -D 20000 -d 1000 -L 3500 -l 100 -p 20 -C -M 0.9 ../../Celastrus_angulatus_B_genome.fasta >CanB.finder.scn 
#LTR_retriever
#source /public/agis/yanjianbin_group/zhuandong/Biosofts/anaconda3/etc/profile.d/conda.sh
#conda activate /vol3/agis/yanjianbin_group/zhuandong/opt/envs/LTR_retriever
#conda info --envs

#mkdir ltr_retriever
#route=`pwd`
#cd ltr_retriever
#LTR_retriever -genome ../../../Celastrus_angulatus_B_genome.fasta -inharvest ../CanB.harvest.scn -infinder ../CanB.finder.scn -threads 10
#cd $route

#
#!/usr/bin/env bash
ln -s /vol3/agis/yanjianbin_group/zhuandong/02-Cangulatus/02-Cangulatus_B/Cangulatus_B-genome.repeat.gff3

awk '{print$1,$4,$5,$9}' OFS='\t' Cangulatus_B-genome.repeat.gff3 > CanB_repeat.bed













