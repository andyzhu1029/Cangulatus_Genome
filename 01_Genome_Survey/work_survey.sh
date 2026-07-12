#!/usr/bin/env  bash
#SBATCH --partition=AMD_9654
#SBATCH -N 1
#SBATCH -c 10
#SBATCH --mem=20G
#SBATCH -J work_survey.sh
#SBATCH --error=err_%J_work.sh
#SBATCH --output=out_%J_work.sh

echo =========start at : `date` ===========================================================
#=======================Genome Survey======================================================
export PATH=/vol2/share/yanjianbin/zhuandong/home-bak/01-Biosoft/jellyfish-2.3.0/bin:$PATH
export LD_LIBRARY_PATH=/vol2/share/songbo/xuelinlei/envs/envs_1/lib:$LD_LIBRARY_PATH
export LD_LIBRARY_PATH=/vol2/share/yanjianbin/zhuandong/home-bak/01-Biosoft/jellyfish-2.3.0/.libs:/vol2/share/songbo/xuelinlei/envs/envs_1/lib:$LD_LIBRARY_PATH

#jellyfish count -t 10 -m 17 -s 10G -o 17mer.jf -C 1.fq 2.fq
#jellyfish count -t 10 -m 19 -s 400M -o 19mer.jf -C 1.fq 2.fq
#jellyfish count -t 10 -m 23 -s 400M -o 23mer.jf -C 1.fq 2.fq

jellyfish histo -t 10 -o 23mer.histo 23mer.jf 
#jellyfish histo -t 10 -o 17mer_out.histo 17mer_out.jf 
#jellyfish histo -t 10 -o 54_17mer_out.histo 190103_X495_FCHVNKNCCXY_L8_wHADPI097092-54_17mer_out.jf 

#=========================Read Stats=======================================================
#export PATH=/vol2/share/yanjianbin/zhuandong/home-bak/01-Biosoft/opt/envs/SR/bin:$PATH
#ls *gz.clean >fastq.list
#for i in 'cat fastq.list'
#do
#printf $i "\t" >> fastq_reads_num.txt
#/home/zhuandong/01-Biosoft/opt/envs/SR/bin/readfq $i >> fastq_reads_num.txt
#done
#seqkit stat 181230_X495_FCHVNKNCCXY_L5_wHAXPI097093-53_1.fq.gz.clean
#seqkit stat 190103_X495_FCHVNKNCCXY_L8_wHADPI097092-54_1.fq.gz.clean
echo =========end at : `date` ============================================================
