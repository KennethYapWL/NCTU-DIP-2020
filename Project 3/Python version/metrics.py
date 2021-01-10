# -*- coding: utf-8 -*-
"""
Created on Sun Jan 10 18:38:22 2021

@author: ywleo
"""

import numpy as np
import math
from skimage.metrics import structural_similarity as ssim
import scipy


#ref: 
#1. https://github.com/tarikd/python-compare-two-images/blob/master/compare.py
#2. https://stackoverflow.com/questions/60057795/attributeerror-module-scipy-stats-has-no-attribute-signaltonoise

def MSE(oriImage, recImage):
    err = np.sum((oriImage.astype("float") - recImage.astype("float")) ** 2)
    err /= float(oriImage.shape[0] * oriImage.shape[1])
    
    return err


def SSIM(oriImage, recImage):
    return ssim(np.moveaxis(oriImage, 1, -3), np.moveaxis(recImage, 1, -3), multichannel=True)


def RMSE(oriImage, recImage):
    return math.sqrt(MSE(oriImage, recImage))


def SNR(image, axis=0, ddof=0):
    image = np.asanyarray(image)
    mean = image.mean(axis)
    std = image.std(axis=axis, ddof=ddof)
    return np.where(std == 0, 0, mean/std)
    