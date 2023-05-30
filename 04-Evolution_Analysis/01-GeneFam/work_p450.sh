#!/usr/bin/env bash

#==============================P450 Pipeline======================================================================================================================================
#Andy_Zhu
#August 5th 2022
#=================================================================================================================================================================================

R=/path/01-Cangulatus_A
R2=/path/01-basic_genome_analysis
R3=/path/01-P450

#STEP 1: Genomic mining for CYP450
hmmbuild PF00067_seed.hmm PF00067_seed.txt

hmmsearch -E 1e-5 --domE 0.00001 --cpu 3 --noali --domtblout CanA_CYP.tbout --tblout CanA_CYP.txt PF00067_seed.hmm $R/Cangulatus_A_longest_protein.faa

grep -v "#" CanA_CYP.tbout|cut -f1 -d " "|sort -u > CanA_CYP.list
perl $R2/filter_fasta_by_ids.pl -l CanA_CYP.list -f $R/Cangulatus_A_longest_protein.faa -o CanA_CYP.fa

#STEP 2: CanA CYP450 Classification
blastp -query CanA_CYP.fa  -db /vol3/agis/yanjianbin_group/zhuandong/Database/P450-database/all_p450_db \
					-outfmt 7 -max_target_seqs 1 -num_threads 10 -out CanA_P450.blast
python $R3/get_p450_family.py CanA_P450.blast > CanA_p450.class

#STEP 3: Phylogenetic tree of CYP450

#STEP 3.1:
cat /path/Arabidopsis.P450.fas CanA_CYP.fa >Ath_CanA_CYP.fa

mafft --maxiterate 1000 --localpair --anysymbol --thread 5 Ath_CanA_CYP.fa > Ath_CanA_CYP.MSA.fa

python /path/fa2phy.py -i Ath_CanA_CYP.MSA.fa -o Ath_CanA_CYP.MSA.phy

raxmlHPC-PTHREADS-SSE3 -f a -x 12345 -p 12345 -# 1000 -m PROTGAMMAJTTX -s Ath_CanA_CYP.MSA.phy -n Ath_CanA_CYP.raxml-tree -T 30 

#STEP 3.2: Phylogeny of CYP71 clan 
perl $R2/filter_fasta_by_ids.pl -l Can_CYP_71_Clan.lst -f $R/Cangulatus_A_longest_protein.faa -o CanA_71_Clan.fa
cat CanA_71_Clan.fa Function_71_Clan.fa > 71_clan.fa
mafft --maxiterate 1000 --localpair --anysymbol --thread 5 71_clan.fa > 71_clan.MSA.fa
python /path/fa2phy.py -i 71_clan.MSA.fa -o 71_clan.MSA.phy
raxmlHPC-PTHREADS-SSE3 -f a -x 12345 -p 12345 -# 1000 -m PROTGAMMAJTTX -s 71_clan.MSA.phy -n 71_Clan.raxml-tree -T 15 

#STEP 3.3: Phylogeny of CYP71 clan/CYP71 subfamily
perl $R2/filter_fasta_by_ids.pl -l Can_CYP_71_subfam.lst -f $R/Cangulatus_A_longest_protein.faa -o CanA_71_Subfam.fa
perl $R2/filter_fasta_by_ids.pl -l Can_CYP_76_subfam.lst -f $R/Cangulatus_A_longest_protein.faa -o CanA_76_Subfam.fa
perl $R2/filter_fasta_by_ids.pl -l Can_CYP_82_subfam.lst -f $R/Cangulatus_A_longest_protein.faa -o CanA_82_Subfam.fa
perl $R2/filter_fasta_by_ids.pl -l Can_CYP_706_subfam.lst -f $R/Cangulatus_A_longest_protein.faa -o CanA_706_Subfam.fa

cat CanA_71_Subfam.fa CanA_76_Subfam.fa CanA_82_Subfam.fa CanA_706_Subfam.fa Functional_Sesquiterpenoid_CYP_Subfam.fa > Sesquiterpenoid_CYP_subfam.fa
mafft --maxiterate 1000 --localpair --anysymbol --thread 5 Sesquiterpenoid_CYP_subfam.fa > Sesquiterpenoid_CYP_subfam.MSA.fa
python /path/fa2phy.py -i Sesquiterpenoid_CYP_subfam.MSA.fa -o Sesquiterpenoid_CYP_subfam.MSA.phy
raxmlHPC-PTHREADS-SSE3 -f a -x 12345 -p 12345 -# 1000 -m PROTGAMMAJTTX -s Sesquiterpenoid_CYP_subfam.MSA.phy -n Sesquiterpenoid_CYP.raxml-tree -T 15 
cat Can_CYP_71_subfam.lst|awk '{print$0 "\t" "#D3D3D3"}' > Can_CYP_71_subfam_Color.lst 
cat Can_CYP_76_subfam.lst|awk '{print$0 "\t" "#COCOCO"}' > Can_CYP_76_subfam_Color.lst
cat Can_CYP_706_subfam.lst|awk '{print$0 "\t" "#A9A9A9"}' > Can_CYP_706_subfam_Color.lst
cat Can_CYP_82_subfam.lst|awk '{print$0 "\t" "#808080"}' > Can_CYP_82_subfam_Color.lst
#STEP 4: Plot 

#python /path/get_position_v4.py /path/CanA_chr.gff3 CanA_CYP.list > CanA_CYP_anchor.txt

#cat CanA_CYP_anchor.txt|awk '{print$0 "\t" "104,203,203"}' >CanA_CYP_color.txt


perl /path/cds_to_pep.pl CaCYP28_cds.fa CaCYP28_pep.fa 
for id in CaCYP21 CaCYP22 CaCYP23 CaCYP28 
do
blastp -query ${id}_pep.fa -db /path/CanA_db -outfmt 6 -evalue 1e-5 -num_threads 5 -out ${id}.blast
done
#ssh smp10
makeblastdb -in Cangulatus_A_longest_cds.faa -dbtype nucl -parse_seqids -out CaA_db
makeblastdb -in Cangulatus_B_longest_cds.faa -dbtype nucl -parse_seqids -out CaB_db
for species in CaA CaB
do
blastn -query sequence.fas -num_threads 5 -db ${species}_db -outfmt 7 -max_target_seqs 1 -out ${species}.blastn
done
