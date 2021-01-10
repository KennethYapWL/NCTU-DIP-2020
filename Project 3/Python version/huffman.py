# -*- coding: utf-8 -*-
"""
Created on Fri Jan  8 00:54:05 2021

@author: ywleo
"""

import numpy as np
import pandas as pd
import utils
from queue import PriorityQueue

#refs:
#1. https://github.com/ghallak/jpeg-python/blob/2fe1bd2244c3090543695b106866dfa0a3b48f6c/utils.py

#ref: ITU-T.81, Annex-K, Table-K.3, Page-149
HUFF_DICT_LUM_DC = dict()
path = 'table refs/Table_DC_lum.xlsx'
catecol, codecol = 'Category', 'Code Word'
df = pd.read_excel(path, dtype=str)
categ, code = df[catecol].values, df[codecol].values
for cat, cw in zip(categ, code):
    HUFF_DICT_LUM_DC[int(cat)] = cw
    
    
#ref: ITU-T.81, Annex-K, Table-K.5, Page-150
HUFF_DICT_LUM_AC = dict()
path = 'table refs/Table_AC_lum.xlsx'
catecol, codecol = 'Run/Size', 'Code Word'
df = pd.read_excel(path, dtype=str)
categ, code = df[catecol].values, df[codecol].values
        
for cat, cw in zip(categ, code):
    rs = cat.split('/')
    HUFF_DICT_LUM_AC[(int('0x'+rs[0],16), int('0x'+rs[1],16))] = cw
    
     
#ref: ITU-T.81, Annex-K, Table-K.4, Page-149
HUFF_DICT_CHROM_DC = dict()
path = 'table refs/Table_DC_chrom.xlsx'
catecol, codecol = 'Category', 'Code Word'
df = pd.read_excel(path, dtype=str)
categ, code = df[catecol].values, df[codecol].values
        
for cat, cw in zip(categ, code):
    HUFF_DICT_CHROM_DC[int(cat)] = cw
    
    
#ref: ITU-T.81, Annex-K, Table-K.6, Page-154
HUFF_DICT_CHROM_AC = dict()
path = 'table refs/Table_AC_chrom.xlsx'
catecol, codecol = 'Run/Size', 'Code Word'
df = pd.read_excel(path, dtype=str)
categ, code = df[catecol].values, df[codecol].values

for cat, cw in zip(categ, code):
    rs = cat.split('/')
    HUFF_DICT_CHROM_AC[(int('0x'+rs[0],16), int('0x'+rs[1],16))] = cw


def huffman_coding_standard_ac(ac_arr, BStream, component):
    if not component in ['lum', 'chrom']:
        raise ValueError((
            "component should be either 'lum' or 'chrom',"
            "but '{comp}' was found").format(comp=component))
        
    # Run Length Coding
    rlc_arr = utils.run_length_coding(ac_arr);
    if component == 'lum':
        huff_table = HUFF_DICT_LUM_AC
    else:
        huff_table = HUFF_DICT_CHROM_AC
    
    for rlc in rlc_arr:
        run, size = int(rlc[0]), utils.bits_length(int(rlc[1]))
        _bin = utils.int_to_binstr(int(rlc[1]))
        
        BStream.write([int(b) for b in (huff_table[(run, size)] + _bin)], bool)

def huffman_coding_standard_dc(dc, BStream, component):
    if not component in ['lum', 'chrom']:
        raise ValueError((
            "component should be either 'lum' or 'chrom',"
            "but '{comp}' was found").format(comp=component))
    
    if component == 'lum':
        huff_table = HUFF_DICT_LUM_DC
    else:
        huff_table = HUFF_DICT_CHROM_DC
        
    categ = utils.bits_length(int(dc))
    BStream.write([int(b) for b in (huff_table[categ] + utils.int_to_binstr(int(dc)))], bool)


class HuffmanTree:

    class __Node:
        def __init__(self, value, freq, left_child, right_child):
            self.value = value
            self.freq = freq
            self.left_child = left_child
            self.right_child = right_child

        @classmethod
        def init_leaf(self, value, freq):
            return self(value, freq, None, None)

        @classmethod
        def init_node(self, left_child, right_child):
            freq = left_child.freq + right_child.freq
            return self(None, freq, left_child, right_child)

        def is_leaf(self):
            return self.value is not None

        def __eq__(self, other):
            stup = self.value, self.freq, self.left_child, self.right_child
            otup = other.value, other.freq, other.left_child, other.right_child
            return stup == otup

        def __nq__(self, other):
            return not (self == other)

        def __lt__(self, other):
            return self.freq < other.freq

        def __le__(self, other):
            return self.freq < other.freq or self.freq == other.freq

        def __gt__(self, other):
            return not (self <= other)

        def __ge__(self, other):
            return not (self < other)

    def __init__(self, arr):
        q = PriorityQueue()

        # calculate frequencies and insert them into a priority queue
        for val, freq in self.__calc_freq(arr).items():
            q.put(self.__Node.init_leaf(val, freq))

        while q.qsize() >= 2:
            u = q.get()
            v = q.get()

            q.put(self.__Node.init_node(u, v))

        self.__root = q.get()

        # dictionaries to store huffman table
        self.__value_to_bitstring = dict()

    def value_to_bitstring_table(self):
        if len(self.__value_to_bitstring.keys()) == 0:
            self.__create_huffman_table()
        return self.__value_to_bitstring

    def __create_huffman_table(self):
        def tree_traverse(current_node, bitstring=''):
            if current_node is None:
                return
            if current_node.is_leaf():
                self.__value_to_bitstring[current_node.value] = bitstring
                return
            tree_traverse(current_node.left_child, bitstring + '0')
            tree_traverse(current_node.right_child, bitstring + '1')

        tree_traverse(self.__root)

    def __calc_freq(self, arr):
        freq_dict = dict()
        for elem in arr:
            if elem in freq_dict:
                freq_dict[elem] += 1
            else:
                freq_dict[elem] = 1
        return freq_dict
        
    