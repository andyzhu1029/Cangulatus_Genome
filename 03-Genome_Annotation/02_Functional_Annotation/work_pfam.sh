#!/usr/bin/env bash


#/vol3/agis/yanjianbin_group/zhuandong/software/hmmer-3.3.2/src/hmmscan -o CanA_gene_annotation.txt --tblout CanA_gene_annotation.tbl --noali -E 1e-5 /vol3/agis/yanjianbin_group/zhuandong/Database/04_Pfam/Pfam-A.hmm ../../Cangulatus_A_longest_protein.faa
grep -v "#" CanA_gene_annotation.tbl| awk '{print$3}'| sort -u > CaA_pfam_annote.list
