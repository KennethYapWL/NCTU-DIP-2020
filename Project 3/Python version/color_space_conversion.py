# -*- coding: utf-8 -*-
"""
Created on Thu Jan  7 06:07:07 2021

@author: ywleo
"""

import numpy as np

def RGB_2_YCbCr(img):
    #ref https://zhuanlan.zhihu.com/p/88933905
    if len(img.shape) != 3 or img.shape[2] != 3:
        raise ValueError('the input image is not a rgb image')
    
    hg, wd, ch = img.shape
    img = img.astype(np.float32)
    coeffs = np.array([[ 0.257,  0.504,  0.098],
                       [-0.148, -0.291,  0.439],
                       [ 0.439, -0.368, -0.071]]) 
    
    offset = np.array([16, 128, 128])
    ycbcr = np.zeros(shape=[hg, wd, ch])
    
    for row in range(hg):
        for col in range(wd):
            ycbcr[row,col,:] = np.dot(coeffs, img[row,col,:]) + offset
            
    return ycbcr


def YCbCr_2_RGB(img):
    #ref https://zhuanlan.zhihu.com/p/88933905
    if len(img.shape) != 3 or img.shape[2] != 3:
        raise ValueError('the input image is not a ycbcr image')
        
    hg, wd, ch = img.shape
    img = img.astype(np.float32)
    coeffs = np.array([[ 0.257,  0.504,  0.098],
                       [-0.148, -0.291,  0.439],
                       [ 0.439, -0.368, -0.071]]) 
    
    offset = np.array([16, 128, 128])
    coeffs_inv = np.linalg.inv(coeffs)
    rgb = np.zeros(shape=[hg, wd, ch])
    
    for row in range(hg):
        for col in range(wd):
            rgb[row,col,:] = np.dot(coeffs_inv, img[row,col,:]) \
                           - np.dot(coeffs_inv, offset)
    

    