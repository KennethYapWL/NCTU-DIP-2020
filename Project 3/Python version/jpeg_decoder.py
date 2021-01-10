# -*- coding: utf-8 -*-
"""
Created on Sun Jan 10 14:48:16 2021

@author: ywleo
"""

import numpy as np
import utils
from PIL import Image
from datetime import datetime
import metrics

IMG_SIZE_BITS = 16
TABLE_SIZE_BITS = 16
BLOCKS_COUNT_BITS = 32

DC_CODE_LENGTH_BITS = 4
CATEGORY_BITS = 4

AC_CODE_LENGTH_BITS = 8
RUN_LENGTH_BITS = 4
SIZE_BITS = 4


def read_dc_table(jpgFile):
    table = dict()

    table_size = int(jpgFile.read(TABLE_SIZE_BITS), 2)
    for _ in range(table_size):
        category = int(jpgFile.read(CATEGORY_BITS), 2)
        code_length = int(jpgFile.read(DC_CODE_LENGTH_BITS), 2)
        code = jpgFile.read(code_length)
        table[code] = category
    return table

def read_ac_table(jpgFile):
    table = dict()

    table_size = int(jpgFile.read(TABLE_SIZE_BITS), 2)
    for _ in range(table_size):
        run_length = int(jpgFile.read(RUN_LENGTH_BITS), 2)
        size = int(jpgFile.read(SIZE_BITS), 2)
        code_length = int(jpgFile.read(AC_CODE_LENGTH_BITS), 2)
        code = jpgFile.read(code_length)
        table[code] = (run_length, size)
    return table

def read_huffman_code(jpgFile, table):
    prefix = ''
    # TODO: break the loop if __read_char is not returing new char
    while prefix not in table:
        prefix += jpgFile.read(1)
    return table[prefix]

def read_int(jpgFile, size):
    if size == 0:
        return 0

    # the most significant bit indicates the sign of the number
    bin_num = jpgFile.read(size)
    if bin_num[0] == '1':
        return int(bin_num, 2)
    else:
        return int(utils.binstr_flip(bin_num), 2) * -1


def decode_data(jpgDir):
    imgHg, imgWd, blockTotal = 0, 0, 0
    jpgFile = open(jpgDir, "r")
    
    imgHg = int(jpgFile.read(IMG_SIZE_BITS), 2)
    imgWd = int(jpgFile.read(IMG_SIZE_BITS), 2)
    print("size %ix%i" % (imgHg,  imgWd))
    
    tables = dict()
    for table_name in ['dc_y', 'ac_y', 'dc_c', 'ac_c']:
        if 'dc' in table_name:
            tables[table_name] = read_dc_table(jpgFile)
        else:
            tables[table_name] = read_ac_table(jpgFile)
            
    blockTotal = imgHg // 8 * imgWd // 8 # How many blocks needed to split the image
    dc = np.empty((blockTotal, 3), dtype=np.int32)
    ac = np.empty((blockTotal, 63, 3), dtype=np.int32)
    
    for block_index in range(blockTotal):
        for component in range(3):
            dc_table = tables['dc_y'] if component == 0 else tables['dc_c']
            ac_table = tables['ac_y'] if component == 0 else tables['ac_c']

            category = read_huffman_code(jpgFile, dc_table)
            dc[block_index, component] = read_int(jpgFile, category)

            cells_count = 0

            # TODO: try to make reading AC coefficients better
            while cells_count < 63:
                run_length, size = read_huffman_code(jpgFile, ac_table)

                if (run_length, size) == (0, 0):
                    while cells_count < 63:
                        ac[block_index, cells_count, component] = 0
                        cells_count += 1
                else:
                    for i in range(run_length):
                        ac[block_index, cells_count, component] = 0
                        cells_count += 1
                    if size == 0:
                        ac[block_index, cells_count, component] = 0
                    else:
                        value = read_int(jpgFile,  size)
                        ac[block_index, cells_count, component] = value
                    cells_count += 1
                
        
    jpgFile.close()
    return dc, ac, imgHg,  imgWd, blockTotal


def main():
    jpgDir = 'compressed/noJFIF_out.jpg'
    dc, ac, imgHg,  imgWd, blockTotal = decode_data(jpgDir)
    
    image = np.empty((imgHg, imgWd, 3), dtype=np.uint8)
    blockTotal = imgHg // 8 * imgWd // 8 # How many blocks needed to split the image
    print('block total: ' + str(blockTotal))
    print("{}, start decompressing.".format(datetime.now()))
    
    block_index = 0
    for y in range(0, imgHg, 8):
        for x in range(0, imgWd, 8):
            for ch in range(3):
                zigzag = [dc[block_index, ch]] + list(ac[block_index, :, ch])
                quant_matrix = utils.zigzag_to_block(zigzag)
                dct_matrix = utils.de_quantization(quant_matrix, 'lum' if ch == 0 else 'chrom')
                block = utils.fftpack_idct_2d(dct_matrix)
                image[y:y+8, x:x+8, ch] = block + 128
                
            block_index += 1
            if block_index % 100000 == 0:
                print(str(block_index) + ' blocks are done decoding! {}'.format(datetime.now()))

    print("{}, finish decompressing.".format(datetime.now()))
    image = Image.fromarray(image, 'YCbCr')
    image = image.convert('RGB')
    image.show()
    image.save('recontructedImage2.bmp')
    
    
    # Performance
    srcFileDir = 'img/img1.bmp'
    oriImage = Image.open(srcFileDir)
    image = np.array(image) 
    oriImage = np.array(oriImage)
    
    print('SNR of image: ', end='')
    print(metrics.SNR(image).mean())
    
    print('RMSE of original image and the reconstruted image: ', end='')
    print(metrics.RMSE(oriImage, image))
    
    print('SSIM of original image and the reconstruted image: ', end='')
    print(metrics.SSIM(oriImage, image))
    
    
            
    
if __name__ == "__main__":
    main()
