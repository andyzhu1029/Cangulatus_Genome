#!/usr/bin/env  bash
#SBATCH --partition=AMD_9654
#SBATCH -N 1
#SBATCH -c 20
#SBATCH --mem=60G
#SBATCH -J work_hic.sh
#SBATCH --error=err_%J_work.sh
#SBATCH --output=out_%J_work.sh

echo =========start at : `date` ===========================================================
#=======================Genome Survey======================================================
export PATH=/vol2/share/yanjianbin/zhuandong/home-bak/01-Biosoft/bwa-0.7.17:$PATH
export PATH=/vol3/share/yanjianbin/zhuandong/opt/envs/samtools/bin:$PATH

#ln -s /vol2/share/yanjianbin/zhuandong/home-bak/03-Cangulatus/01-Cangulatus_A/Celastrus_angulatus_A_genome.fasta
#ln -s /vol2/share/yanjianbin/zhuandong/home-bak/03-Cangulatus/02-Cangulatus_B/Celastrus_angulatus_B_genome.fasta
#cat Celastrus_angulatus_A_genome.fasta Celastrus_angulatus_B_genome.fasta > diploid_genome.fasta

#/vol2/share/yanjianbin/zhuandong/home-bak/01-Biosoft/bwa-0.7.17/bwa index diploid_genome.fasta
#samtools faidx diploid_genome.fasta #samtools env
#cut -f1,2 diploid_genome.fasta.fai > diploid.chrom.sizes
#/vol2/share/yanjianbin/zhuandong/home-bak/01-Biosoft/juicer-main/misc/generate_site_positions.py MboI diploid diploid_genome.fasta

#/vol2/share/yanjianbin/zhuandong/home-bak/01-Biosoft/juicer-main/CPU/juicer.sh \
#	-D /vol2/share/yanjianbin/zhuandong/home-bak/01-Biosoft/juicer-main \
#	-g diploid -s MboI -z ./diploid_genome.fasta -y ./diploid_MboI.txt -p ./diploid.chrom.sizes -t 20

#samtools view -@ 8 -O SAM -F 1024 ./aligned/merged_dedup.bam | \
#  awk -v mnd=1 -f /vol2/share/yanjianbin/zhuandong/home-bak/01-Biosoft/juicer-main/CPU/common/sam_to_pre.awk > ./aligned/merged_nodups.txt

java -Xmx72g -jar /vol2/share/yanjianbin/zhuandong/home-bak/01-Biosoft/juicer_tools_1.22.01.jar pre \
  ./aligned/merged_nodups.txt \
  ./aligned/inter_30.hic \
  diploid.chrom.sizes

#ls ./*.gz.clean |cut -d "/" -f 2| cut -d "_" -f 1-5 | uniq| while read  id
#do
#jellyfish count -t 20 -m 17 -s 1G -o ${id}_17mer_out.jf -C ./${id}_1.fq.gz.clean ./${id}_2.fq.gz.clean 
#done
#jellyfish count -t 20 -m 17 -s 120G -o 53_17mer_out.jf -C ./181230_X495_FCHVNKNCCXY_L5_wHAXPI097093-53_1.fq.gz.clean ./181230_X495_FCHVNKNCCXY_L5_wHAXPI097093-53_2.fq.gz.clean
#jellyfish count -t 20 -m 17 -s 1G -o 17mer_out.jf -C ./wgs_1.fq.gz.clean ./wgs_2.fq.gz.clean
#jellyfish histo -t 10 -o 53_17mer_out.histo 53_17mer_out.jf
#jellyfish histo -t 10 -o 17mer_out.histo 17mer_out.jf 
#jellyfish histo -t 10 -o 54_17mer_out.histo 190103_X495_FCHVNKNCCXY_L8_wHADPI097092-54_17mer_out.jf 

#=========================Read Stats=======================================================
#export PATH=/home/zhuandong/01-Biosoft/opt/envs/SR/bin:$PATH
#ls *gz.clean >fastq.list
#for i in 'cat fastq.list'
#do
#printf $i "\t" >> fastq_reads_num.txt
#/home/zhuandong/01-Biosoft/opt/envs/SR/bin/readfq $i >> fastq_reads_num.txt
#done
#seqkit stat FCH2LKLCCX2_L1_1.fq.gz >stat.txt
#seqkit stat FCH2LKLCCX2_L1_2.fq.gz >>stat.txt
echo =========end at : `date` ============================================================
