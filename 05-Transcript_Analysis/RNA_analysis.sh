#!/usr/bin/env  bash
#============================================================================================================================
#Andy_Zhu
#16th April 2023
#===========================================================================================================================
#SBATCH --partition=amd
#SBATCH -N 1
#SBATCH -c 6
#SBATCH -J work.sh
#SBATCH --error=err_%J_work.sh
#SBATCH --output=out_%J_work.sh
export PATH=~/mysoftware/anaconda2/envs/np/bin:$PATH #python3
export PATH=/public/home/zhuandong/.local/bin:$PATH #cutadpter v2.10

echo =========start at : `date` ===========================================================
#for id in $(cat sample_list)
#do
#quick_qsub =trim= {-q queue1 -l nodes=1:ppn=10} trim_galore -o ./Clean_seq --paired ./$id/${id}_1.fq.gz ./$id/${id}_2.fq.gz
#done

#STEP 1 HISAT2 creat index
#mkdir A_hisat2_index B_hisat2_index
#for species in A B
#do
#quick_qsub =index= {-q queue1 -l nodes=1:ppn=10} hisat2-build Celastrus_angulatus_${species}_genome.fasta ./${species}_hisat2_index/Can${species}_index 
#done

#STEP 2 Map the RNA-seq reads of each sample to the reference geome using HISAT2
#mkdir A_alignment_data B_alignment_data
#for species in A B
#do
#	for id in $(cat sample_list)
#	do 
#	quick_qsub =aligment= {-q queue1 -l nodes=1:ppn=20} hisat2 --dta -p 20 -x ./${species}_hisat2_index/Can${species}_index \
# 			     -1 ./Clean_seq/${id}_1_val_1.fq.gz -2 ./Clean_seq/${id}_2_val_2.fq.gz \
#			    -S ./${species}_alignment_data/${id}_output.sam
#	done
#done

#STEP 3 Sort and convert the SAM files to BAM
#for species in A B
#do
#	for id in $(cat sample_list)
#	do
#	quick_qsub =samtools= {-q queue1 -l nodes=1:ppn=20} /public/agis/yanjianbin_group/zhuandong/Biosofts/samtools-1.9/samtools sort -@ 20 \
#					-o ./${species}_alignment_data/${id}_output.bam ./${species}_alignment_data/${id}_output.sam
#	done
#done

#STEP 4 Asembly and quantify transcripts for each sample
#--Asembly-----creat gtf file for each bam file using stringtie------------------------------

#mkdir A_assembly_data B_assembly_data A_tab_data B_tab_data
#for species in A B
#do
#	for id in $(cat sample_list)
#	do
#	quick_qsub =asembly= {-q queue1 -l nodes=1:ppn=20} stringtie -p 20 -e -B -G ./Cangulatus_${species}_chr.gff3 -l $id \
#		./${species}_alignment_data/${id}_output.bam -o ./${species}_assembly_data/${id}.gtf -A ./${species}_tab_data/$id.tab 
#	done
#done
#-e只分析已知转录本,不分>析新转录本;-B Ballgown inputdata;-G 参考注释基因文件指导组装; -l prefix;

#STEP 6 Extract FPKM value	
#for species in A B
#do
#	for id in $(cat sample_list)
#	do 
#	cut -f 1,8 ./${species}_tab_data/$id.tab|sed 's/Gene ID/Gene_ID/g'|sed 's/FPKM/'$id'/g'|sort -k 1.4n >./${species}_tab_data/${id}.tab_fpkm
#	done
#done

#STEP 7  Extract Count value
for species in A B
do
	for id in $(cat sample_list)
	do
#	echo $id ./${species}_assembly_data/${id}.gtf >> ${species}-sample.list
	python prepDE.py3 -i ${species}-sample.list -g ./${species}_count_data/${species}-gene_count.csv \
			-t ./${species}_count_data/${species}-transcript.csv
	done
done
#for i in $(ls A_assembly_data)
#do
#echo './A_assembly_data/'$i'' >> mergelist.txt
#done

#quick_qsub =merge= {-q queue1 -l nodes=1:ppn=10} stringtie --merge -p 10 -G Cangulatus_A_chr.gff3 -o ./A_assembly_data/CanA_merged.gtf ./mergelist.txt

echo =========end at : `date` ============================================================
 
#echo $id ./${species}-05_assembly_data/${id}.gtf >> ${species}-sample.list
#python prepDE.py -i ${species}-sample.list -g ./${species}-07_count_data/${species}-gene_count.csv -t ./${species}-07_count_data/${species}-transcript.csv

#STEP 6 Extract FPKM value
#join ./A-06_tab_data/${id}.tab_fpkm

#echo $id ./07_ballgown_data/${id}.gtf >> sample_lst.txt 
#python2.7 prepDE.py -i sample_lst.txt -g ./08_count_data/${id}_count.csv -t ./08_count_data/${id}_transcript.csv
#done
#htseq-count -f bam -r name -s no -a 10 -t exon -i gene_id -m union ./lignment_data/DRR064061_output.bam 171026_klebsormidium_v1.1.gff >counts.txt

