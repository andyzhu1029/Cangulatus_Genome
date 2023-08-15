#!/usr/bin/env bash
#blastp -query ../../Cangulatus_B_longest_protein.faa -db /vol3/agis/yanjianbin_group/zhuandong/Database/05-TAIR/Araport11_db -outfmt 6 -evalue 1e-5 -num_threads 10 -out CanB_Ath.blast
cat CanB_Ath.blast|cut -f 1|sort -u >CanB_tair_annotate.list
