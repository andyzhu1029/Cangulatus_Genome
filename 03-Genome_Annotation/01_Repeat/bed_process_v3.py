#!/usr/bin/env python
# -*- encoding: utf-8 -*-

import numpy as np

def data_analysis(element_list,keywords):
    indes_lst = []
    for i, type in enumerate(element_list[3]):
        if keywords in type:
            indes_lst.append(i)
    begin_data = np.array(element_list[1])[indes_lst]
    end_data = np.array(element_list[2])[indes_lst]
    deta_data = np.absolute(begin_data.astype(np.int) - end_data.astype(np.int))
    total_data = np.sum(deta_data)
    average_data = total_data/begin_data.shape[0]
    return begin_data.shape[0], average_data,total_data
if __name__=="__main__":
    with open('./CanB_repeat.bed','r')as bedfile:
        bed_str = bedfile.read()
        element_lst = []
        bed_lst = bed_str.strip().split("\n")        
        for i in range(len(bed_lst[0].split("\t"))):
            element_lst.append([])
        for row in range(len(bed_lst)):
            for column, content in enumerate(bed_lst[row].split('\t')):
                element_lst[column].append(content)
        print("DNA: ", data_analysis(element_lst,"DNA"))
        print("LINE: ", data_analysis(element_lst,"LINE"))
        print("SINE: ", data_analysis(element_lst,"SINE"))
        print("LTR: ", data_analysis(element_lst,"LTR"))
        print("Unknown: ", data_analysis(element_lst,"Unknown"))
        print("Satellite: ", data_analysis(element_lst,"Satellite"))
        print("Simple_repeat: ", data_analysis(element_lst,"Simple_repeat"))
        print("Low_complexity: ", data_analysis(element_lst,"Low_complexity"))
