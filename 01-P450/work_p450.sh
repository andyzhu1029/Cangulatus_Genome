#!/usr/bin/env bash

#==============================P450 Pipeline======================================================================================================================================
#Andy_Zhu
#August 5th 2022
#=================================================================================================================================================================================

R=/vol3/agis/yanjianbin_group/zhuandong/02-Cangulatus/01-Cangulatus_A
R2=/public/agis/yanjianbin_group/zhuandong/private/01-scripts/01-basic_genome_analysis
R3=/public/agis/yanjianbin_group/zhuandong/private/01-scripts/02-Evolution_analysis/01-P450

#STEP 1: Genomic mining for CYP450
#hmmbuild PF00067_seed.hmm PF00067_seed.txt

#quick_qsub =CYP= {-q queue3 -l nodes=1:ppn=3} hmmsearch -E 1e-5 --domE 0.00001 --cpu 3 --noali --domtblout CanA_CYP.tbout --tblout CanA_CYP.txt PF00067_seed.hmm $R/Cangulatus_A_longest_protein.faa

#grep -v "#" CanA_CYP.tbout|cut -f1 -d " "|sort -u > CanA_CYP.list
#perl $R2/filter_fasta_by_ids.pl -l CanA_CYP.list -f $R/Cangulatus_A_longest_protein.faa -o CanA_CYP.fa

#STEP 2: CanA CYP450 Classification
#quick_qsub {-q queue5 -l nodes=1:ppn=10} ~/mysoftware/anaconda2/envs/blast/bin/blastp -query CanA_CYP.fa  -db /vol3/agis/yanjianbin_group/zhuandong/Database/P450-database/all_p450_db \
#					-outfmt 7 -max_target_seqs 1 -num_threads 10 -out CanA_P450.blast
#python $R3/get_p450_family.py CanA_P450.blast > CanA_p450.class

#STEP 3: Phylogenetic tree of CYP450

#STEP 3.1:
#cat /vol3/agis/yanjianbin_group/zhuandong/Database/P450-database/Arabidopsis.P450.fas CanA_CYP.fa >Ath_CanA_CYP.fa

#~/mysoftware/anaconda2/envs/py2/bin/mafft --maxiterate 1000 --localpair --anysymbol --thread 5 Ath_CanA_CYP.fa > Ath_CanA_CYP.MSA.fa

#python /public/agis/yanjianbin_group/zhuandong/private/my_scripts/fa2phy.py -i Ath_CanA_CYP.MSA.fa -o Ath_CanA_CYP.MSA.phy

#quick_qsub =CanA_raxml= {-q queue1 -l nodes=1:ppn=30} ~/mysoftware/anaconda2/envs/py2/bin/raxmlHPC-PTHREADS-SSE3 -f a -x 12345 -p 12345 -# 1000 -m PROTGAMMAJTTX \
#							-s Ath_CanA_CYP.MSA.phy -n Ath_CanA_CYP.raxml-tree -T 30 

#STEP 3.2: Phylogeny of CYP71 clan 
#perl $R2/filter_fasta_by_ids.pl -l Can_CYP_71_Clan.lst -f $R/Cangulatus_A_longest_protein.faa -o CanA_71_Clan.fa
#cat CanA_71_Clan.fa Function_71_Clan.fa > 71_clan.fa
#~/mysoftware/anaconda2/envs/py2/bin/mafft --maxiterate 1000 --localpair --anysymbol --thread 5 71_clan.fa > 71_clan.MSA.fa
#python /public/agis/yanjianbin_group/zhuandong/private/my_scripts/fa2phy.py -i 71_clan.MSA.fa -o 71_clan.MSA.phy
#quick_qsub =71_clan= {-q queue2 -l nodes=1:ppn=15} ~/mysoftware/anaconda2/envs/py2/bin/raxmlHPC-PTHREADS-SSE3 -f a -x 12345 -p 12345 -# 1000 -m PROTGAMMAJTTX \
#							-s 71_clan.MSA.phy -n 71_Clan.raxml-tree -T 15 

#STEP 3.3: Phylogeny of CYP71 clan/CYP71 subfamily
#perl $R2/filter_fasta_by_ids.pl -l Can_CYP_71_subfam.lst -f $R/Cangulatus_A_longest_protein.faa -o CanA_71_Subfam.fa
#perl $R2/filter_fasta_by_ids.pl -l Can_CYP_76_subfam.lst -f $R/Cangulatus_A_longest_protein.faa -o CanA_76_Subfam.fa
#perl $R2/filter_fasta_by_ids.pl -l Can_CYP_82_subfam.lst -f $R/Cangulatus_A_longest_protein.faa -o CanA_82_Subfam.fa
#perl $R2/filter_fasta_by_ids.pl -l Can_CYP_706_subfam.lst -f $R/Cangulatus_A_longest_protein.faa -o CanA_706_Subfam.fa

#cat CanA_71_Subfam.fa CanA_76_Subfam.fa CanA_82_Subfam.fa CanA_706_Subfam.fa Functional_Sesquiterpenoid_CYP_Subfam.fa > Sesquiterpenoid_CYP_subfam.fa
#~/mysoftware/anaconda2/envs/py2/bin/mafft --maxiterate 1000 --localpair --anysymbol --thread 5 Sesquiterpenoid_CYP_subfam.fa > Sesquiterpenoid_CYP_subfam.MSA.fa
#python /public/agis/yanjianbin_group/zhuandong/private/my_scripts/fa2phy.py -i Sesquiterpenoid_CYP_subfam.MSA.fa -o Sesquiterpenoid_CYP_subfam.MSA.phy
#quick_qsub =sesquiter_subfam= {-q queue2 -l nodes=1:ppn=15} ~/mysoftware/anaconda2/envs/py2/bin/raxmlHPC-PTHREADS-SSE3 -f a -x 12345 -p 12345 -# 1000 \
#						-m PROTGAMMAJTTX -s Sesquiterpenoid_CYP_subfam.MSA.phy -n Sesquiterpenoid_CYP.raxml-tree -T 15 
cat Can_CYP_71_subfam.lst|awk '{print$0 "\t" "#D3D3D3"}' > Can_CYP_71_subfam_Color.lst 
cat Can_CYP_76_subfam.lst|awk '{print$0 "\t" "#COCOCO"}' > Can_CYP_76_subfam_Color.lst
cat Can_CYP_706_subfam.lst|awk '{print$0 "\t" "#A9A9A9"}' > Can_CYP_706_subfam_Color.lst
cat Can_CYP_82_subfam.lst|awk '{print$0 "\t" "#808080"}' > Can_CYP_82_subfam_Color.lst
#STEP 4: Plot 

#python /public/agis/yanjianbin_group/zhuandong/private/my_worklog/01_basic_genome_analysis/01_circos/get_position_v4.py /vol3/agis/yanjianbin_group/zhuandong/02-Cangulatus/04-basic_genome_analysis/01-circos/CanA_chr.gff3 CanA_CYP.list > CanA_CYP_anchor.txt

#cat CanA_CYP_anchor.txt|awk '{print$0 "\t" "104,203,203"}' >CanA_CYP_color.txt


#perl /public/agis/yanjianbin_group/zhuandong/private/01-scripts/01-basic_genome_analysis/cds_to_pep.pl CaCYP28_cds.fa CaCYP28_pep.fa 
#for id in CaCYP21 CaCYP22 CaCYP23 CaCYP28 
#do
#~/mysoftware/anaconda2/envs/blast/bin/blastp -query ${id}_pep.fa -db /vol3/agis/yanjianbin_group/zhuandong/02-Cangulatus/03-Evolution_analysis/03-Genome_Synteny_Analysis/Blast_db/CanA_db \
#					-outfmt 6 -evalue 1e-5 -num_threads 5 -out ${id}.blast
#done
#ssh smp10
#$makeblastdb -in Cangulatus_A_longest_cds.faa -dbtype nucl -parse_seqids -out CaA_db
#$makeblastdb -in Cangulatus_B_longest_cds.faa -dbtype nucl -parse_seqids -out CaB_db
#for species in CaA CaB
#do
#blastn -query sequence.fas -num_threads 5 -db ${species}_db -outfmt 7 -max_target_seqs 1 -out ${species}.blastn
#done
