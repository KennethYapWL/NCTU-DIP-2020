# -*- coding: utf-8 -*-
"""
Created on Fri Jan  8 04:46:00 2021

@author: ywleo
"""

import numpy as np
from bitstream import BitStream
from PIL import Image
from scipy import fftpack
import sys
from datetime import datetime

import utils
import huffman
import huffman2
import write_file
import metrics


#ref:
#1. https://koushtav.me//jpeg/tutorial/2017/11/25/lets-write-a-simple-jpeg-library-part-1
#2. https://yasoob.me/posts/understanding-and-writing-jpeg-decoder-in-python/
#3. https://boisgera.github.io/bitstream/
#4. https://github.com/fangwei123456/python-jpeg-encoder
#5. https://koushtav.me/jpeg/tutorial/c++/decoder/2019/03/02/lets-write-a-simple-jpeg-library-part-2/#the-jfif-file-format
#6. https://ithelp.ithome.com.tw/articles/10230274


def main():
#    if(len(sys.argv)!=3):
#        print('inputBMPFileName outputJPEGFilename')
#        print('example:')
#        print('./lena.bmp ./output.jpg')
#        return
    
    is_include_JFIF_format = False
    srcFileDir = 'img/img1.bmp'#sys.argv[1]
    output_Dir = 'compressed/JFIF_out.jpg'#sys.argv[2]
    if is_include_JFIF_format == False:
        output_Dir = 'compressed/noJFIF_out.jpg'
    
    
    print("{}, start compressing.".format(datetime.now()))
    srcImage = Image.open(srcFileDir)
    imgHg, imgWd = srcImage.size
    
    padd_y, padd_x = 0, 0
    # make sure the width and height of the image are the multiple of 8
    if imgHg % 8 != 0:
        padd_y = 8 - (imgHg % 8)
    if imgWd % 8 != 0:
        padd_x = 8 - (imgWd % 8)
        
    imgMatr = np.asarray(srcImage)
    imgHg, imgWd, imgCh = imgMatr.shape
    imgMatr = np.asarray([np.pad(chl, pad_width=((0,padd_y),(0,padd_x)), mode='symmetric') for chl in imgMatr])
    imgHg, imgWd, imgCh = imgMatr.shape
    
    # Step 1: Colour space transformation from RGB to Y-Cb-Cr
    #YCbCr = color_space.RGB_2_YCbCr(imgMatr)
    yImage,uImage,vImage = Image.fromarray(imgMatr).convert('YCbCr').split()

    yImageMatrix = np.asarray(yImage).astype(int)
    uImageMatrix = np.asarray(uImage).astype(int)
    vImageMatrix = np.asarray(vImage).astype(int)
    
    YCbCr = np.array([yImageMatrix, uImageMatrix, vImageMatrix])
    
    # Step 2: Chroma Subsampling
    #TODO
    
    # Step 3: Level Shifting
    YCbCr = YCbCr - 128
    
    # Step 4: Discrete Cosine Transform (DCT) of Minimum Coded Units (MCU)
    blockTotal = imgHg // 8 * imgWd // 8 # How many blocks needed to split the image
    print('block Total:' + str(blockTotal))
    components = ['lum', 'chrom', 'chrom']
    block_idx = 0
    DCs, deltaDCs = np.zeros([blockTotal, imgCh]), np.zeros([blockTotal, imgCh])
    ACs = np.empty((blockTotal, 63, imgCh), dtype=np.int32)
    BStream = BitStream() # see details on ref[3]
    for y in range(0, imgHg, 8):
        for x in range(0, imgWd, 8):
            for ch in range(imgCh): 
                block = YCbCr[ch][y:y+8, x:x+8] # 8x8 Block Splitting
                
                #block = utils.dct_2D(block) # DCT  ==> this is so slow, use fftpack better
                block = utils.fftpack_dct_2d(block) # DCT
                
                # Quantization
                block = utils.quantization(block, component=components[ch])
                # Zigzag Traversal
                zz = utils.zigzag_traversal(block)
                
                # Step 5: Delta Coding (Predictive Coding)
                DCs[block_idx, ch] = zz[0]
                if block_idx == 0:
                    deltaDCs[block_idx, ch] = DCs[block_idx, ch]
                else:
                    deltaDCs[block_idx, ch] = DCs[block_idx, ch] - DCs[block_idx - 1, ch]
                    
                # Except for the first element of zz, the remains are AC coefficients
                ACs[block_idx, :, ch] = zz[1:]
                if is_include_JFIF_format == True:
                    # Step 6: Huffman Coding for DC
                    huffman2.huffman_coding_standard_dc(deltaDCs[block_idx, ch],
                                                       BStream,
                                                       component=components[ch])
    
                    # Step 7: Run Length Coding and Huffman Coding for AC
                    huffman2.huffman_coding_standard_ac(ACs[block_idx, :, ch],
                                                       BStream,
                                                       component=components[ch])
                    

                
                
            block_idx += 1
            if block_idx % 100000 == 0:
                print(str(block_idx) + ' blocks are done encoding! {}'.format(datetime.now()))

            
    print("{}, writing file...".format(datetime.now()))
    if is_include_JFIF_format == True: 
        write_file.write_jpgfile_JFIF(output_Dir, BStream, imgHg, imgWd)
        
    else:
        H_DC_Y = huffman.HuffmanTree(np.vectorize(utils.bits_length)(deltaDCs[:, 0]))
        H_DC_C = huffman.HuffmanTree(np.vectorize(utils.bits_length)(deltaDCs[:, 1:].flat))
        H_AC_Y = huffman.HuffmanTree(
                utils.flatten(utils.run_length_encode_binstr(ACs[i, :, 0])[0] for i in range(blockTotal)))
        H_AC_C = huffman.HuffmanTree(
                utils.flatten(utils.run_length_encode_binstr(ACs[i, :, j])[0] for i in range(blockTotal) for j in [1, 2]))
    
        tables = {'dc_y': H_DC_Y.value_to_bitstring_table(),
                  'ac_y': H_AC_Y.value_to_bitstring_table(),
                  'dc_c': H_DC_C.value_to_bitstring_table(),
                  'ac_c': H_AC_C.value_to_bitstring_table()}
        
        write_file.write_jpgfile_without_JFIF(output_Dir, imgHg, imgWd, DCs, ACs, blockTotal, tables)
        
    print("{}, finish.".format(datetime.now()))
    
    if is_include_JFIF_format == True:
        # Performance
        compressedImage = Image.open(output_Dir)
        compressedImage = np.array(compressedImage) 
        srcImage = np.array(srcImage)
        
        print('SNR of image: ', end='')
        print(metrics.SNR(compressedImage).mean())
        
        print('RMSE of original image and the reconstruted image: ', end='')
        print(metrics.RMSE(srcImage, compressedImage))
        
        print('SSIM of original image and the reconstruted image: ', end='')
        print(metrics.SSIM(srcImage, compressedImage))



if __name__ == '__main__':
    main()