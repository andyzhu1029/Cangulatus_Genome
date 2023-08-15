#/usr/bin/env bash
#export PATH=/vol3/agis/yanjianbin_group/zhuandong/Database/eggnog-mapper/bin:$PATH
#/vol3/agis/yanjianbin_group/zhuandong/Database/eggnog-mapper/emapper.py -i ../../Cangulatus_A_longest_protein.faa --output Cangulatus_A_maNOG -m diamond --cpu 10 -d euk --data_dir /vol3/agis/yanjianbin_group/zhuandong/Database/eggnog-mapper/data/
grep -v "#" Cangulatus_A_maNOG.emapper.annotations |cut -f 1 | sort| uniq -c > Cangulatus_A_gene.annotations
