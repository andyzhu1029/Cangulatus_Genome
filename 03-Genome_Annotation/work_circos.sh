#!/usr/bin/env bash
#Andy_Zhu
#8th August 2023
#==========================Pipeline for Circos===================

R=/path/bedtools2/bin

#Data preparation

ln -s /path/Celastrus_angulatus_A_genome.fasta
ln -s /path/Celastrus_angulatus_B_genome.fasta
ln -s /path/Cangulatus_A_chr.gff3
ln -s /path/Cangulatus_B_chr.gff3
ln -s /path/CanA_Copia.gff3
ln -s /path/CanA_Gypsy.gff3
ln -s /path/CanB_Copia.gff3
ln -s /path/CanB_Gypsy.gff3
ln -s /path/Cangulatus_A-genome.repeat.gff3
ln -s /path/Cangulatus_B-genome.repeat.gff3
ln -s /path/Cangulatus_A_longest_protein.faa
ln -s /path/Cangulatus_B_longest_protein.faa

#STEP 1: Karyotype
samtools faidx Celastrus_angulatus_A_genome.fasta 
samtools faidx Celastrus_angulatus_B_genome.fasta
cat Celastrus_angulatus_A_genome.fasta.fai|awk '{print"chrA""\t""-""\t"$1"\t"$1"\t""0""\t"$2"\t""set1-9-qual-9"}'|less >CanA_karyotype.txt
cat Celastrus_angulatus_B_genome.fasta.fai|awk '{print"chrB""\t""-""\t"$1"\t"$1"\t""0""\t"$2"\t""set1-9-qual-9"}'|less >CanB_karyotype.txt
cat CanA_karyotype.txt CanB_karyotype.txt > karyotype.txt #vim

for haplotype in A B
do
cut -f1-2 Celastrus_angulatus_${haplotype}_genome.fasta.fai > Cangulatus_${haplotype}_chr.len
$R/bedtools makewindows -g Cangulatus_${haplotype}_chr.len -w 500000 > Can_${haplotype}_chr_win500k.bed

python -m jcvi.formats.gff bed --type=gene --key=Name Cangulatus_${haplotype}_chr.gff3 -o Can_${haplotype}.bed
awk '{print$1,$2,$3}' OFS='\t' Can_${haplotype}.bed > Can_${haplotype}_gene.bed #for gene
awk '{print$1,$4,$5}' OFS='\t' Cangulatus_${haplotype}-genome.repeat.gff3 > Can_${haplotype}_repeat.bed #for repeat
awk '{print$1,$4,$5}' OFS='\t' Can${haplotype}_Copia.gff3 > Can_${haplotype}_copia.bed #for copia
awk '{print$1,$4,$5}' OFS='\t' Can${haplotype}_Gypsy.gff3 > Can_${haplotype}_gypsy.bed #for gypsy

$R/bedtools intersect -b Can_${haplotype}_gene.bed -a Can_${haplotype}_chr_win500k.bed -c > Can_${haplotype}_gene_density_500k #gene density
$R/bedtools intersect -b Can_${haplotype}_repeat.bed -a Can_${haplotype}_chr_win500k.bed -c > Can_${haplotype}_repeat_density_500k #repeat density
$R/bedtools intersect -b Can_${haplotype}_copia.bed -a Can_${haplotype}_chr_win500k.bed -c > Can_${haplotype}_copia_density_500k #copia density
$R/bedtools intersect -b Can_${haplotype}_gypsy.bed -a Can_${haplotype}_chr_win500k.bed -c > Can_${haplotype}_gypsy_density_500k #gypsy density
$R/bedtools nuc -fi Celastrus_angulatus_${haplotype}_genome.fasta -bed Can_${haplotype}_chr_win500k.bed | cut -f 1-3,5 > Can_${haplotype}_gc_win500k.bed
done

sed 's/CanChr/chr/g' Can_A_gene_density_500k > Can_A_gene_density_500k.txt
sed 's/CanChr/chr/g' Can_B_gene_density_500k > Can_B_gene_density_500k.txt
cat Can_A_gene_density_500k.txt Can_B_gene_density_500k.txt > CanA-CanB-gene_500k_heat.txt
cat CanA-CanB-gene_500k_heat.txt| awk 'BEGIN{max=0}{if ($4+0>max+0) max=$4 fi} END {print "Max of gene density is",max}'
cat CanA-CanB-gene_500k_heat.txt| awk 'BEGIN{min=65536}{if($4+0 <min+0) min=$4 fi} END{print "Min of gene density is",min}'


sed 's/CanChr/chr/g' Can_A_gc_win500k.bed >Can_A_gc_win500k_line.txt
sed 's/CanChr/chr/g' Can_B_gc_win500k.bed > Can_B_gc_win500k_line.txt
cat Can_A_gc_win500k_line.txt Can_B_gc_win500k_line.txt > CanA-CanB-gc_500k_line.txt
cat CanA-CanB-gc_500k_line.txt| awk 'BEGIN{max=0}{if ($4+0>max+0) max=$4 fi} END {print "Max of gc is",max}'
cat CanA-CanB-gc_500k_line.txt| awk 'BEGIN{min=65536}{if($4+0 <min+0) min=$4 fi} END{print "Min of gc is",min}'

sed 's/CanChr/chr/g' Can_A_copia_density_500k > Can_A_copia_win500k_line.txt
sed 's/CanChr/chr/g' Can_B_copia_density_500k > Can_B_copia_win500k_line.txt
cat Can_A_copia_win500k_line.txt Can_B_copia_win500k_line.txt > CanA-CanB-copia_500k_line.txt
cat CanA-CanB-copia_500k_line.txt| awk 'BEGIN{max=0}{if ($4+0>max+0) max=$4 fi} END {print "Max of copia is",max}'
cat CanA-CanB-copia_500k_line.txt| awk 'BEGIN{min=65536}{if($4+0 <min+0) min=$4 fi} END{print "Min of copia is",min}'

sed 's/CanChr/chr/g' Can_A_gypsy_density_500k >Can_A_gypsy_win500k_line.txt
sed 's/CanChr/chr/g' Can_B_gypsy_density_500k >Can_B_gypsy_win500k_line.txt
cat Can_A_gypsy_win500k_line.txt Can_B_gypsy_win500k_line.txt > CanA-CanB-gypsy_500k_line.txt
cat CanA-CanB-gypsy_500k_line.txt| awk 'BEGIN{max=0}{if ($4+0>max+0) max=$4 fi} END {print "Max of gypsy is",max}'
cat CanA-CanB-gypsy_500k_line.txt| awk 'BEGIN{min=65536}{if($4+0 <min+0) min=$4 fi} END{print "Min of gypsy is",min}'

sed 's/CanChr/chr/g' Can_A_repeat_density_500k >Can_A_repeat_win500k_line.txt
sed 's/CanChr/chr/g' Can_B_repeat_density_500k >Can_B_repeat_win500k_line.txt
cat Can_A_repeat_win500k_line.txt Can_B_repeat_win500k_line.txt > CanA-CanB-repeat_500k_line.txt
cat CanA-CanB-repeat_500k_line.txt| awk 'BEGIN{max=0}{if ($4+0>max+0) max=$4 fi} END {print "Max of repeat is",max}'
cat CanA-CanB-repeat_500k_line.txt| awk 'BEGIN{min=65536}{if($4+0 <min+0) min=$4 fi} END{print "Min of repeat is",min}'

#STEP6 link
for haplotype in A B
do
blastp -query Cangulatus_${haplotype}_longest_protein.faa \
					-db /path/Can${haplotype}_db \
					-out Can${haplotype}.blast -evalue 1e-10 -outfmt 6 -num_alignments 5

awk -F ";" '{print $1}' Can${haplotype}_chr.gff3|awk -F "\t" '{if($3=="mRNA")print $1"\t"$9"\t"$4"\t"$5}'|sed 's/ID=//g'|sort -k 1.8n -k 3n >Can${haplotype}.gff
done
DupGen_finder.pl -i ./ -t CanA -c CanB -o ./CanA_CanB_wgd_results
cat CanA_chr.gff3 CanB_chr.gff3 >CanA_CanB.gff3
python get_link_from_collinea_v2.py CanA_CanB.gff3 ./CanA_CanB_wgd_results/CanA_CanB.collinearity >CanA_CanB.links
python get_link_from_collinea_v3.py CanA_CanB.gff3 /path/Cangulatus_A.Cangulatus_B.anchors >CanA_CanB.link
sort -k 1.8n -k 2n CanA_CanB.link >CanA-CanB.link
done
python divide_by_Chr_v2.py CanA-CanB.link 
circos -conf circos.conf
