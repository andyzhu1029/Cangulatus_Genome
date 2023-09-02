#!/usr/bin/env python
# -*- encoding: utf-8 -*-
'''
@File		: 	count.py
@Time		:	2023/08/20 11:09:50
Author		:	Andy_Zhu 
Version	:	1.0
Contact	: 	Andy_Zhu1029@163.com
Desc		:	Process bed file
Usage		:	None
'''
import sys
import re
import numpy as np

class bed:
    def __init__(self,path:str):        
        with open(path,'r')as gfffile:
            self.out_str = gfffile.read() #string
        self.data = []
        out_list = self.out_str.strip().split('\n')   
        # col_name_lst = [n.strip("\t") for n in out_list[1].strip('\t').split('\t')] 
        # for name in self.out_str:
        #     self.data[name]=[]
        for i in range(len(out_list[1].split('\t'))):
           # out_list.append([])
            self.data.append([])
        for row in range(len(out_list)):
            for column, content in enumerate(out_list[row].split('\t')):
                #self.data[col_name_lst[column]].append(content)
                self.data[column].append(content)

    def data_analysis(self):
        begin_data = np.array(self.data[1])
        end_data = np.array(self.data[2])
        deta_data = np.absolute(begin_data.astype(np.int) - end_data.astype(np.int))
        total_data = np.sum(deta_data)
        average_data = total_data/begin_data.shape[0]
        return begin_data.shape[0], average_data,total_data

if __name__=="__main__":
    out = bed('./CanB_repeat.bed')
    print(out.data_analysis())
    

    



        
