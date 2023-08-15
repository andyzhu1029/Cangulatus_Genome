#!/usr/bin/env bash
##2021/18/02#########
export PATH=~/mysoftware/anaconda2/envs/blast/bin:$PATH
R=/vol3/agis/yanjianbin_group/zhuandong/Database/SWISSPORT
~/mysoftware/anaconda2/envs/blast/bin/blastp -query ../../Cangulatus_A_longest_protein.faa -db $R/uniprot_sprot_db -outfmt 5 -evalue 1e-5 -num_threads 5 -out Cangulatus_A_swissprot.xml
perl /public/agis/yanjianbin_group/zhuandong/private/01-scripts/01-basic_genome_analysis/parsing_blast_result.pl Cangulatus_A_swissprot.xml 20 1e-5 0.2  >Cangulatus_A.swissprot.xls
perl /public/agis/yanjianbin_group/zhuandong/private/01-scripts/01-basic_genome_analysis/sort_blastResult_by_name_and_e_value.pl Cangulatus_A.swissprot.xls >Cangulatus_A.swissprot.sort.xls
cut -f 1 Cangulatus_A.swissprot.sort.xls|sort | uniq > Cangulatus_A.swissprot_uniq_id.text

