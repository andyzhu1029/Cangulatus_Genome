#!/usr/bin/env  bash
#SBATCH --partition=low
#SBATCH -N 1
#SBATCH -c 20
#SBATCH -J work_switch-error.sh
#SBATCH --error=err_%J_work.sh
#SBATCH --output=out_%J_work.sh

#bwa index -a bwtsw -p  ./012_GATK_index_data/CanB_index ./Celastrus_angulatus_B_genome.fasta
ls ./*.clean.gz |cut -d "/" -f 2| cut -d "_" -f 1-5 | uniq| while read  id
do
#bwa mem -t 20 -R "@RG\tID:${id}\tSM:${id}\tLB:${id}"  ./012_GATK_index_data/CanB_index  \
#./${id}_1.fq.gz.clean.gz ./${id}_2.fq.gz.clean.gz | \
#samtools view -Sb - > ./022_GATK_bam_data/${id}.bam 
samtools sort -@ 20 -O bam -o ./022_GATK_bam_data/${id}.sorted.bam  ./022_GATK_bam_data/${id}.bam
done


