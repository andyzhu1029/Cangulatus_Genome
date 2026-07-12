#!/usr/bin/env  bash
#SBATCH --partition=smp01
#SBATCH -N 1
#SBATCH -c 30
#SBATCH -J work_switch-error.sh
#SBATCH --error=err_%J_work.sh
#SBATCH --output=out_%J_work.sh

echo =========start at : `date` ===========================================================
#STEP 1: Index
#for haplotype in A B
#do
#bwa index -a bwtsw -p  ./${haplotype}_bwa_index/Can${haplotype}_index ./Celastrus_angulatus_${haplotype}_genome.fasta
#	ls ./*.gz.clean |cut -d "/" -f 2| cut -d "_" -f 1-5 | uniq| while read  id
#	do
#	bwa mem -t 10 -R "@RG\tID:${id}\tSM:${id}\tLB:${id}"  ./${haplotype}_bwa_index/Can${haplotype}_index  \
#		./${id}_1.fq.gz.clean ./${id}_2.fq.gz.clean | \
#		samtools view -Sb - > ./${haplotype}_bam_data/${id}.bam
#		samtools sort -@ 30 -O bam -o ./${haplotype}_bam_data/${id}.sorted.bam  ./${haplotype}_bam_data/${id}.bam
#	done
#done

for haplotype in A B
do
#samtools faidx Celastrus_angulatus_${haplotype}_genome.fasta
#awk '{print$1"\t"1"\t"$2}' Celastrus_angulatus_${haplotype}_genome.fasta.fai > Cangulatus_${haplotype}.bed
/home/zhuandong/01-Biosoft/bamdst/bamdst -p Cangulatus_${haplotype}.bed -o ./${haplotype}_coverage ./${haplotype}_bam_data/merge.bam
#/home/zhuandong/01-Biosoft/bamdst/bamdst -p Cangulatus_A.bed -o ./A_coverage/ ./${haplotype}_bam_data/merge.bam
done
echo =========end at : `date` ============================================================
