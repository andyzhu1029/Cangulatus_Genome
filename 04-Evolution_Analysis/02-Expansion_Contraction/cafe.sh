#!/usr/bin/env bash
#Andy
#20th,Oct, 2022
#ssh smp10
#conda activate /path/envs/cafe5

echo ==========Start at `date` ====================================================================

#STEP1 Get tree.file
R=/path/Mcmctree/dict2

#grep -E -v "NEXUS|BEGIN|END" $R/FigTree.tre|sed -E -e "s/\[[^]]*\]//g" -e "s/[ \t]//g" -e "/^$/d" -e "s/UTREE/tree tree/" >tree.txt

#STEP 2 Get CAFE.data
#cut -f 1-18 ../../Orthogroups.GeneCount.csv >cafe.data.1
#echo ID Ath CaA Cpa Csa Fve Han Lsa Osa Ppe Pti Ptr Rco Sme Stu Tca Twi Vvi > title.txt
#sed -i 's/ /\t/g' title.txt
#删除cafe.data.1表头
#vim cafe.data.1
#添加新表头
#cat title.txt cafe.data.1 >cafe.data.2
#增加首列
#cat cafe.data.2|awk '{print "(null)""\t"$0}'|less >cafe.data
#or
#sed 's/^/(null)\t&/g' cafe.data.1 > cafe.data

#STEP 3 
for num in {2..10} 
do
cafe5 -i cafe.data -t tree.txt -p -k $num -o k${num}p
done
echo ==========End at `date` ==================================================================================
