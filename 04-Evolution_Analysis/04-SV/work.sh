#!/usr/bin/env bash

#reference:https://github.com/schneebergerlab/plotsr#visualising-tracks
ref=/vol3/agis/yanjianbin_group/zhuandong/02-Cangulatus/01-Cangulatus_A/Celastrus_angulatus_A_genome.fasta
query=/vol3/agis/yanjianbin_group/zhuandong/02-Cangulatus/02-Cangulatus_B/Celastrus_angulatus_B_genome.fasta

echo ===================Start at `date` =========================================================================================
# STEP 1 Using minimap2 for generating alignment.
#/vol3/agis/yanjianbin_group/zhuandong/software/minimap2-2.17/minimap2 -t 15 -ax asm5 --eqx ${ref} ${query} > Can_hapA_hapB.sam


#samtools  sort -o Can_hapA_hapB.bam Can_hapA_hapB.sam

# STEP 2 Using syri for finding structural rearrangements between genome
#source /public/agis/yanjianbin_group/zhuandong/Biosofts/anaconda3/etc/profile.d/conda.sh
#conda activate /vol3/agis/yanjianbin_group/zhuandong/opt/envs/syri
#conda info --envs
#syri -c Can_hapA_hapB.sam -r $ref -q $query -k -F S
#awk -v OFS="\t" '$11=="SNP"{print $1, $2-1, $3, "SNP", "0", "."}' syri.out > snp.bed
#awk -v OFS="\t" '($11=="INS" || $11=="DEL") && ($3-$2 < 50) {print $1, $2-1, $3, "INDEL", $3-$2, "."}' syri.out > indel.bed

#/vol3/agis/yanjianbin_group/zhuandong/opt/envs/syri/bin/plotsr --sr syri.out \
#	--genomes genomes.txt  \
#	--tracks tracks.txt \
#	--chr CanChrA1 \
#	--chr CanChrA2 \
#	--chr CanChrA3 \
#	--chr CanChrA4 \
#	--cfg base.cfg \
#	-H 8 -W 3 -o Variation_plot1_v2.pdf

#

# syri_to_snpeff_pipeline.sh

echo === From SyRI to SnpEff Pipeline ===

# S1: Variation Extraction
cat > syri_variants_filtered.vcf << 'EOF'
##fileformat=VCFv4.2
##source=SyRI
##reference=CanChrA1
##INFO=<ID=SYRI_TYPE,Number=1,Type=String,Description="Variant type from SyRI">
##INFO=<ID=LEN,Number=1,Type=Integer,Description="Variant length">
#CHROM	POS	ID	REF	ALT	QUAL	FILTER	INFO
EOF

# 使用单个 awk 命令处理所有变异类型
awk 'BEGIN {OFS="\t"} 
     $11 == "SNP" {
         print $1, $2, ".", $4, $5, ".", "PASS", "SYRI_TYPE=SNP"
     }
     $11 == "INS" {
         len = length($5)
         if (len < 50) {
             print $1, $2, ".", $4, $5, ".", "PASS", "SYRI_TYPE=INS;LEN=" len
         }
     }
     $11 == "DEL" {
         len = length($4) 
         if (len < 50) {
             print $1, $2, ".", $4, $5, ".", "PASS", "SYRI_TYPE=DEL;LEN=" len
         }
     }' syri.out >> sequence_variants.vcf

#CaTPS6基因区域，调整参数以显示小变异
#plotsr \
 # --sr CaTPS16_sv.out \
  #--genomes genomes.txt \
  #--reg "CanChrA3:11038571-11040157" \
  #-o CaTPS6_detailed_SVs.png 
echo ==================End at `date` ===========================================================================================
