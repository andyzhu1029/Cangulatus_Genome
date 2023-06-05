#!/usr/bin/env bash
echo =========start at : `date` ===========================================================
cat ../Gamma_family_results.txt |grep "y"|cut -f1 > p0.05.significant

for id in 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34
do
cat ../Gamma_change.tab |cut -f1,${id}|grep "+[1-9]" > ${id}.expanded_OG.txt
cat ../Gamma_change.tab |cut -f1,${id}|grep "-" > ${id}.contracted_OG.txt
grep -f p0.05.significant ${id}.expanded_OG.txt |cut -f1 > ${id}.expanded.significant_OG.txt
grep -f p0.05.significant ${id}.contracted_OG.txt |cut -f1 > ${id}.contracted.significant_OG.txt
echo '+' >> ${id}.txt
wc -l ${id}.expanded.significant_OG.txt | awk '{print $1}' >> ${id}.txt
echo '-' >> ${id}.txt
wc -l ${id}.contracted.significant_OG.txt | awk '{print $1}' >> ${id}.txt
done

mkdir node-value
cp 2.txt ./node-value/"Cpa<0>".txt
cp 3.txt ./node-value/"Ath<1>".txt
cp 4.txt ./node-value/"<2>".txt
cp 5.txt ./node-value/"Tca<3>".txt
cp 6.txt ./node-value/"Twi<4>".txt
cp 7.txt ./node-value/"CaA<5>".txt
cp 8.txt ./node-value/"Pti<6>".txt
cp 9.txt ./node-value/"Rco<7>".txt
cp 10.txt ./node-value/"Ptr<8>".txt
cp 11.txt ./node-value/"<9>".txt
cp 12.txt ./node-value/"<10>".txt
cp 13.txt ./node-value/"<11>".txt
cp 14.txt ./node-value/"Fve<12>".txt
cp 15.txt ./node-value/"Ppe<13>".txt
cp 16.txt ./node-value/"<14>".txt
cp 17.txt ./node-value/"<15>".txt
cp 18.txt ./node-value/"<16>".txt
cp 19.txt ./node-value/"Csa<17>".txt
cp 20.txt ./node-value/"<18>".txt
cp 21.txt ./node-value/"<19>".txt
cp 22.txt ./node-value/"Sme<20>".txt
cp 23.txt ./node-value/"Stu<21>".txt
cp 24.txt ./node-value/"Han<22>".txt
cp 25.txt ./node-value/"Lsa<23>".txt
cp 26.txt ./node-value/"<24>".txt
cp 27.txt ./node-value/"Vvi<25>".txt
cp 28.txt ./node-value/"<26>".txt
cp 29.txt ./node-value/"<27>".txt
cp 30.txt ./node-value/"<28>".txt
cp 31.txt ./node-value/"<29>".txt
cp 32.txt ./node-value/"Osa<30>".txt
cp 33.txt ./node-value/"<31>".txt
cp 34.txt ./node-value/"<32>".txt

grep -f 7.expanded.significant_OG.txt ../../../../Orthogroups.txt | sed "s/ /\n/g"|grep "CaA|CaA" |sort -k 1.8n |uniq > CaA.expanded.significant.genes.txt
grep -f 7.contracted.significant_OG.txt ../../../../Orthogroups.txt | sed "s/ /\n/g"|grep "CaA|CaA" |sort -k 1.8n |uniq > CaA.contracted.significant.genes.txt
echo =========end at : `date` ============================================================











