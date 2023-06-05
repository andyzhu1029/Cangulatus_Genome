#!/usr/bin/env  bash
#SBATCH --partition=smp01
#SBATCH -N 1
#SBATCH -c 5
#SBATCH -J work_survey.sh
#SBATCH --error=err_%J_work.sh
#SBATCH --output=out_%J_work.sh

echo =========start at : `date` ===========================================================
#=======================Genome Survey======================================================
export PATH=/home/zhuandong/00-Biosoft/jellyfish-2.3.0/bin:$PATH
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
ls *gz.clean >fastq.list
for i in 'cat fastq.list'
do
printf $i "\t" >> fastq_reads_num.txt
/home/zhuandong/01-Biosoft/opt/envs/SR/bin/readfq $i >> fastq_reads_num.txt
done
seqkit stat 181230_X495_FCHVNKNCCXY_L5_wHAXPI097093-53_1.fq.gz.clean
seqkit stat 190103_X495_FCHVNKNCCXY_L8_wHADPI097092-54_1.fq.gz.clean
echo =========end at : `date` ============================================================
