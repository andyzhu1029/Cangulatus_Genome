#!/usr/bin/env bash
#Andy
#9th August 2023

#R=/vol3/agis/yanjianbin_group/zhuandong/Database/07_NR/nr_plant
#blastp -query ../../Cangulatus_A_longest_protein.faa -out Can_A_nr.blast -db $R/nr_plant.fa -evalue 1e-5 -outfmt 6 -num_threads 30
cut -f 1 Can_A_nr.blast|sort -u > Can_A_gene.ann.list
