# -*- coding: utf-8 -*-
"""
Created on Sat Jan  9 03:58:50 2021

@author: ywleo
"""

import numpy as np
import tables
import utils
from queue import PriorityQueue

#refs:
#1. https://github.com/ghallak/jpeg-python/blob/2fe1bd2244c3090543695b106866dfa0a3b48f6c/utils.py

#The DC Hoffman coding table for luminance recommended by JPEG
DCLuminanceSizeToCode = [
    [1,1,0],              #0 EOB
    [1,0,1],            #1
    [0,1,1],            #2
    [0,1,0],            #3
    [0,0,0],            #4
    [0,0,1],            #5
    [1,0,0],            #6
    [1,1,1,0],        #7
    [1,1,1,1,0],      #8
    [1,1,1,1,1,0],    #9
    [1,1,1,1,1,1,0],  #10 0A
    [1,1,1,1,1,1,1,0] #11 0B
]



#The DC Hoffman coding table for chrominance recommended by JPEG
DCChrominanceSizeToCode = [
    [0,1],                 #0 EOB
    [0,0],                 #1
    [1,0,0],               #2
    [1,0,1],               #3
    [1,1,0,0],             #4
    [1,1,0,1],             #5
    [1,1,1,0],             #6
    [1,1,1,1,0],           #7
    [1,1,1,1,1,0],     #8
    [1,1,1,1,1,1,0],   #9
    [1,1,1,1,1,1,1,0], #10 0A
    [1,1,1,1,1,1,1,1,0]#11 0B
]


ACLuminanceSizeToCode = {
'01':[0,0],
'02':[0,1],
'03':[1,0,0],
'11':[1,0,1,0],
'04':[1,0,1,1],
'00':[1,1,0,0],
'05':[1,1,0,1,0],
'21':[1,1,0,1,1],
'12':[1,1,1,0,0],
'31':[1,1,1,0,1,0],
'41':[1,1,1,0,1,1],
'51':[1,1,1,1,0,0,0],
'06':[1,1,1,1,0,0,1],
'13':[1,1,1,1,0,1,0],
'61':[1,1,1,1,0,1,1],
'22':[1,1,1,1,1,0,0,0],
'71':[1,1,1,1,1,0,0,1],
'81':[1,1,1,1,1,0,1,0,0],
'14':[1,1,1,1,1,0,1,0,1],
'32':[1,1,1,1,1,0,1,1,0],
'91':[1,1,1,1,1,0,1,1,1],
'A1':[1,1,1,1,1,1,0,0,0],
'07':[1,1,1,1,1,1,0,0,1],
'15':[1,1,1,1,1,1,0,1,0,0],
'B1':[1,1,1,1,1,1,0,1,0,1],
'42':[1,1,1,1,1,1,0,1,1,0],
'23':[1,1,1,1,1,1,0,1,1,1],
'C1':[1,1,1,1,1,1,1,0,0,0],
'52':[1,1,1,1,1,1,1,0,0,1],
'D1':[1,1,1,1,1,1,1,0,1,0],
'E1':[1,1,1,1,1,1,1,0,1,1,0],
'33':[1,1,1,1,1,1,1,0,1,1,1],
'16':[1,1,1,1,1,1,1,1,0,0,0],
'62':[1,1,1,1,1,1,1,1,0,0,1,0],
'F0':[1,1,1,1,1,1,1,1,0,0,1,1],
'24':[1,1,1,1,1,1,1,1,0,1,0,0],
'72':[1,1,1,1,1,1,1,1,0,1,0,1],
'82':[1,1,1,1,1,1,1,1,0,1,1,0,0],
'F1':[1,1,1,1,1,1,1,1,0,1,1,0,1],
'25':[1,1,1,1,1,1,1,1,0,1,1,1,0,0],
'43':[1,1,1,1,1,1,1,1,0,1,1,1,0,1],
'34':[1,1,1,1,1,1,1,1,0,1,1,1,1,0],
'53':[1,1,1,1,1,1,1,1,0,1,1,1,1,1],
'92':[1,1,1,1,1,1,1,1,1,0,0,0,0,0],
'A2':[1,1,1,1,1,1,1,1,1,0,0,0,0,1],
'B2':[1,1,1,1,1,1,1,1,1,0,0,0,1,0,0],
'63':[1,1,1,1,1,1,1,1,1,0,0,0,1,0,1],
'73':[1,1,1,1,1,1,1,1,1,0,0,0,1,1,0,0],
'C2':[1,1,1,1,1,1,1,1,1,0,0,0,1,1,0,1],
'35':[1,1,1,1,1,1,1,1,1,0,0,0,1,1,1,0],
'44':[1,1,1,1,1,1,1,1,1,0,0,0,1,1,1,1],
'27':[1,1,1,1,1,1,1,1,1,0,0,1,0,0,0,0],
'93':[1,1,1,1,1,1,1,1,1,0,0,1,0,0,0,1],
'A3':[1,1,1,1,1,1,1,1,1,0,0,1,0,0,1,0],
'B3':[1,1,1,1,1,1,1,1,1,0,0,1,0,0,1,1],
'36':[1,1,1,1,1,1,1,1,1,0,0,1,0,1,0,0],
'17':[1,1,1,1,1,1,1,1,1,0,0,1,0,1,0,1],
'54':[1,1,1,1,1,1,1,1,1,0,0,1,0,1,1,0],
'64':[1,1,1,1,1,1,1,1,1,0,0,1,0,1,1,1],
'74':[1,1,1,1,1,1,1,1,1,0,0,1,1,0,0,0],
'C3':[1,1,1,1,1,1,1,1,1,0,0,1,1,0,0,1],
'D2':[1,1,1,1,1,1,1,1,1,0,0,1,1,0,1,0],
'E2':[1,1,1,1,1,1,1,1,1,0,0,1,1,0,1,1],
'08':[1,1,1,1,1,1,1,1,1,0,0,1,1,1,0,0],
'26':[1,1,1,1,1,1,1,1,1,0,0,1,1,1,0,1],
'83':[1,1,1,1,1,1,1,1,1,0,0,1,1,1,1,0],
'09':[1,1,1,1,1,1,1,1,1,0,0,1,1,1,1,1],
'0A':[1,1,1,1,1,1,1,1,1,0,1,0,0,0,0,0],
'18':[1,1,1,1,1,1,1,1,1,0,1,0,0,0,0,1],
'19':[1,1,1,1,1,1,1,1,1,0,1,0,0,0,1,0],
'84':[1,1,1,1,1,1,1,1,1,0,1,0,0,0,1,1],
'94':[1,1,1,1,1,1,1,1,1,0,1,0,0,1,0,0],
'45':[1,1,1,1,1,1,1,1,1,0,1,0,0,1,0,1],
'46':[1,1,1,1,1,1,1,1,1,0,1,0,0,1,1,0],
'A4':[1,1,1,1,1,1,1,1,1,0,1,0,0,1,1,1],
'B4':[1,1,1,1,1,1,1,1,1,0,1,0,1,0,0,0],
'56':[1,1,1,1,1,1,1,1,1,0,1,0,1,0,0,1],
'D3':[1,1,1,1,1,1,1,1,1,0,1,0,1,0,1,0],
'55':[1,1,1,1,1,1,1,1,1,0,1,0,1,0,1,1],
'28':[1,1,1,1,1,1,1,1,1,0,1,0,1,1,0,0],
'1A':[1,1,1,1,1,1,1,1,1,0,1,0,1,1,0,1],
'F2':[1,1,1,1,1,1,1,1,1,0,1,0,1,1,1,0],
'E3':[1,1,1,1,1,1,1,1,1,0,1,0,1,1,1,1],
'F3':[1,1,1,1,1,1,1,1,1,0,1,1,0,0,0,0],
'C4':[1,1,1,1,1,1,1,1,1,0,1,1,0,0,0,1],
'D4':[1,1,1,1,1,1,1,1,1,0,1,1,0,0,1,0],
'E4':[1,1,1,1,1,1,1,1,1,0,1,1,0,0,1,1],
'F4':[1,1,1,1,1,1,1,1,1,0,1,1,0,1,0,0],
'65':[1,1,1,1,1,1,1,1,1,0,1,1,0,1,0,1],
'75':[1,1,1,1,1,1,1,1,1,0,1,1,0,1,1,0],
'85':[1,1,1,1,1,1,1,1,1,0,1,1,0,1,1,1],
'95':[1,1,1,1,1,1,1,1,1,0,1,1,1,0,0,0],
'A5':[1,1,1,1,1,1,1,1,1,0,1,1,1,0,0,1],
'B5':[1,1,1,1,1,1,1,1,1,0,1,1,1,0,1,0],
'C5':[1,1,1,1,1,1,1,1,1,0,1,1,1,0,1,1],
'D5':[1,1,1,1,1,1,1,1,1,0,1,1,1,1,0,0],
'E5':[1,1,1,1,1,1,1,1,1,0,1,1,1,1,0,1],
'F5':[1,1,1,1,1,1,1,1,1,0,1,1,1,1,1,0],
'66':[1,1,1,1,1,1,1,1,1,0,1,1,1,1,1,1],
'76':[1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0],
'86':[1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,1],
'96':[1,1,1,1,1,1,1,1,1,1,0,0,0,0,1,0],
'A6':[1,1,1,1,1,1,1,1,1,1,0,0,0,0,1,1],
'B6':[1,1,1,1,1,1,1,1,1,1,0,0,0,1,0,0],
'C6':[1,1,1,1,1,1,1,1,1,1,0,0,0,1,0,1],
'D6':[1,1,1,1,1,1,1,1,1,1,0,0,0,1,1,0],
'E6':[1,1,1,1,1,1,1,1,1,1,0,0,0,1,1,1],
'F6':[1,1,1,1,1,1,1,1,1,1,0,0,1,0,0,0],
'37':[1,1,1,1,1,1,1,1,1,1,0,0,1,0,0,1],
'47':[1,1,1,1,1,1,1,1,1,1,0,0,1,0,1,0],
'57':[1,1,1,1,1,1,1,1,1,1,0,0,1,0,1,1],
'67':[1,1,1,1,1,1,1,1,1,1,0,0,1,1,0,0],
'77':[1,1,1,1,1,1,1,1,1,1,0,0,1,1,0,1],
'87':[1,1,1,1,1,1,1,1,1,1,0,0,1,1,1,0],
'97':[1,1,1,1,1,1,1,1,1,1,0,0,1,1,1,1],
'A7':[1,1,1,1,1,1,1,1,1,1,0,1,0,0,0,0],
'B7':[1,1,1,1,1,1,1,1,1,1,0,1,0,0,0,1],
'C7':[1,1,1,1,1,1,1,1,1,1,0,1,0,0,1,0],
'D7':[1,1,1,1,1,1,1,1,1,1,0,1,0,0,1,1],
'E7':[1,1,1,1,1,1,1,1,1,1,0,1,0,1,0,0],
'F7':[1,1,1,1,1,1,1,1,1,1,0,1,0,1,0,1],
'38':[1,1,1,1,1,1,1,1,1,1,0,1,0,1,1,0],
'48':[1,1,1,1,1,1,1,1,1,1,0,1,0,1,1,1],
'58':[1,1,1,1,1,1,1,1,1,1,0,1,1,0,0,0],
'68':[1,1,1,1,1,1,1,1,1,1,0,1,1,0,0,1],
'78':[1,1,1,1,1,1,1,1,1,1,0,1,1,0,1,0],
'88':[1,1,1,1,1,1,1,1,1,1,0,1,1,0,1,1],
'98':[1,1,1,1,1,1,1,1,1,1,0,1,1,1,0,0],
'A8':[1,1,1,1,1,1,1,1,1,1,0,1,1,1,0,1],
'B8':[1,1,1,1,1,1,1,1,1,1,0,1,1,1,1,0],
'C8':[1,1,1,1,1,1,1,1,1,1,0,1,1,1,1,1],
'D8':[1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0],
'E8':[1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,1],
'F8':[1,1,1,1,1,1,1,1,1,1,1,0,0,0,1,0],
'29':[1,1,1,1,1,1,1,1,1,1,1,0,0,0,1,1],
'39':[1,1,1,1,1,1,1,1,1,1,1,0,0,1,0,0],
'49':[1,1,1,1,1,1,1,1,1,1,1,0,0,1,0,1],
'59':[1,1,1,1,1,1,1,1,1,1,1,0,0,1,1,0],
'69':[1,1,1,1,1,1,1,1,1,1,1,0,0,1,1,1],
'79':[1,1,1,1,1,1,1,1,1,1,1,0,1,0,0,0],
'89':[1,1,1,1,1,1,1,1,1,1,1,0,1,0,0,1],
'99':[1,1,1,1,1,1,1,1,1,1,1,0,1,0,1,0],
'A9':[1,1,1,1,1,1,1,1,1,1,1,0,1,0,1,1],
'B9':[1,1,1,1,1,1,1,1,1,1,1,0,1,1,0,0],
'C9':[1,1,1,1,1,1,1,1,1,1,1,0,1,1,0,1],
'D9':[1,1,1,1,1,1,1,1,1,1,1,0,1,1,1,0],
'E9':[1,1,1,1,1,1,1,1,1,1,1,0,1,1,1,1],
'F9':[1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0],
'2A':[1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,1],
'3A':[1,1,1,1,1,1,1,1,1,1,1,1,0,0,1,0],
'4A':[1,1,1,1,1,1,1,1,1,1,1,1,0,0,1,1],
'5A':[1,1,1,1,1,1,1,1,1,1,1,1,0,1,0,0],
'6A':[1,1,1,1,1,1,1,1,1,1,1,1,0,1,0,1],
'7A':[1,1,1,1,1,1,1,1,1,1,1,1,0,1,1,0],
'8A':[1,1,1,1,1,1,1,1,1,1,1,1,0,1,1,1],
'9A':[1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0],
'AA':[1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,1],
'BA':[1,1,1,1,1,1,1,1,1,1,1,1,1,0,1,0],
'CA':[1,1,1,1,1,1,1,1,1,1,1,1,1,0,1,1],
'DA':[1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0],
'EA':[1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,1],
'FA':[1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0]
}


ACChrominanceToCode = {
'01':[0,0],
'00':[0,1],
'02':[1,0,0],
'11':[1,0,1],
'03':[1,1,0,0],
'04':[1,1,0,1,0],
'21':[1,1,0,1,1],
'12':[1,1,1,0,0,0],
'31':[1,1,1,0,0,1],
'41':[1,1,1,0,1,0],
'05':[1,1,1,0,1,1,0],
'51':[1,1,1,0,1,1,1],
'13':[1,1,1,1,0,0,0],
'61':[1,1,1,1,0,0,1],
'22':[1,1,1,1,0,1,0],
'06':[1,1,1,1,0,1,1,0],
'71':[1,1,1,1,0,1,1,1],
'81':[1,1,1,1,1,0,0,0],
'91':[1,1,1,1,1,0,0,1],
'32':[1,1,1,1,1,0,1,0],
'A1':[1,1,1,1,1,0,1,1,0],
'B1':[1,1,1,1,1,0,1,1,1],
'F0':[1,1,1,1,1,1,0,0,0],
'14':[1,1,1,1,1,1,0,0,1],
'C1':[1,1,1,1,1,1,0,1,0,0],
'D1':[1,1,1,1,1,1,0,1,0,1],
'E1':[1,1,1,1,1,1,0,1,1,0],
'23':[1,1,1,1,1,1,0,1,1,1],
'42':[1,1,1,1,1,1,1,0,0,0],
'15':[1,1,1,1,1,1,1,0,0,1,0],
'52':[1,1,1,1,1,1,1,0,0,1,1],
'62':[1,1,1,1,1,1,1,0,1,0,0],
'72':[1,1,1,1,1,1,1,0,1,0,1],
'F1':[1,1,1,1,1,1,1,0,1,1,0],
'33':[1,1,1,1,1,1,1,0,1,1,1],
'24':[1,1,1,1,1,1,1,1,0,0,0,0],
'34':[1,1,1,1,1,1,1,1,0,0,0,1],
'43':[1,1,1,1,1,1,1,1,0,0,1,0],
'82':[1,1,1,1,1,1,1,1,0,0,1,1],
'16':[1,1,1,1,1,1,1,1,0,1,0,0,0],
'92':[1,1,1,1,1,1,1,1,0,1,0,0,1],
'53':[1,1,1,1,1,1,1,1,0,1,0,1,0],
'25':[1,1,1,1,1,1,1,1,0,1,0,1,1],
'A2':[1,1,1,1,1,1,1,1,0,1,1,0,0],
'63':[1,1,1,1,1,1,1,1,0,1,1,0,1],
'B2':[1,1,1,1,1,1,1,1,0,1,1,1,0],
'C2':[1,1,1,1,1,1,1,1,0,1,1,1,1],
'07':[1,1,1,1,1,1,1,1,1,0,0,0,0,0],
'73':[1,1,1,1,1,1,1,1,1,0,0,0,0,1],
'D2':[1,1,1,1,1,1,1,1,1,0,0,0,1,0],
'35':[1,1,1,1,1,1,1,1,1,0,0,0,1,1,0],
'E2':[1,1,1,1,1,1,1,1,1,0,0,0,1,1,1],
'44':[1,1,1,1,1,1,1,1,1,0,0,1,0,0,0],
'83':[1,1,1,1,1,1,1,1,1,0,0,1,0,0,1,0],
'17':[1,1,1,1,1,1,1,1,1,0,0,1,0,0,1,1],
'54':[1,1,1,1,1,1,1,1,1,0,0,1,0,1,0,0],
'93':[1,1,1,1,1,1,1,1,1,0,0,1,0,1,0,1],
'08':[1,1,1,1,1,1,1,1,1,0,0,1,0,1,1,0],
'09':[1,1,1,1,1,1,1,1,1,0,0,1,0,1,1,1],
'0A':[1,1,1,1,1,1,1,1,1,0,0,1,1,0,0,0],
'18':[1,1,1,1,1,1,1,1,1,0,0,1,1,0,0,1],
'19':[1,1,1,1,1,1,1,1,1,0,0,1,1,0,1,0],
'26':[1,1,1,1,1,1,1,1,1,0,0,1,1,0,1,1],
'36':[1,1,1,1,1,1,1,1,1,0,0,1,1,1,0,0],
'45':[1,1,1,1,1,1,1,1,1,0,0,1,1,1,0,1],
'1A':[1,1,1,1,1,1,1,1,1,0,0,1,1,1,1,0],
'27':[1,1,1,1,1,1,1,1,1,0,0,1,1,1,1,1],
'64':[1,1,1,1,1,1,1,1,1,0,1,0,0,0,0,0],
'74':[1,1,1,1,1,1,1,1,1,0,1,0,0,0,0,1],
'55':[1,1,1,1,1,1,1,1,1,0,1,0,0,0,1,0],
'37':[1,1,1,1,1,1,1,1,1,0,1,0,0,0,1,1],
'F2':[1,1,1,1,1,1,1,1,1,0,1,0,0,1,0,0],
'A3':[1,1,1,1,1,1,1,1,1,0,1,0,0,1,0,1],
'B3':[1,1,1,1,1,1,1,1,1,0,1,0,0,1,1,0],
'C3':[1,1,1,1,1,1,1,1,1,0,1,0,0,1,1,1],
'28':[1,1,1,1,1,1,1,1,1,0,1,0,1,0,0,0],
'29':[1,1,1,1,1,1,1,1,1,0,1,0,1,0,0,1],
'D3':[1,1,1,1,1,1,1,1,1,0,1,0,1,0,1,0],
'E3':[1,1,1,1,1,1,1,1,1,0,1,0,1,0,1,1],
'F3':[1,1,1,1,1,1,1,1,1,0,1,0,1,1,0,0],
'84':[1,1,1,1,1,1,1,1,1,0,1,0,1,1,0,1],
'94':[1,1,1,1,1,1,1,1,1,0,1,0,1,1,1,0],
'A4':[1,1,1,1,1,1,1,1,1,0,1,0,1,1,1,1],
'B4':[1,1,1,1,1,1,1,1,1,0,1,1,0,0,0,0],
'C4':[1,1,1,1,1,1,1,1,1,0,1,1,0,0,0,1],
'D4':[1,1,1,1,1,1,1,1,1,0,1,1,0,0,1,0],
'E4':[1,1,1,1,1,1,1,1,1,0,1,1,0,0,1,1],
'F4':[1,1,1,1,1,1,1,1,1,0,1,1,0,1,0,0],
'65':[1,1,1,1,1,1,1,1,1,0,1,1,0,1,0,1],
'75':[1,1,1,1,1,1,1,1,1,0,1,1,0,1,1,0],
'85':[1,1,1,1,1,1,1,1,1,0,1,1,0,1,1,1],
'95':[1,1,1,1,1,1,1,1,1,0,1,1,1,0,0,0],
'A5':[1,1,1,1,1,1,1,1,1,0,1,1,1,0,0,1],
'B5':[1,1,1,1,1,1,1,1,1,0,1,1,1,0,1,0],
'C5':[1,1,1,1,1,1,1,1,1,0,1,1,1,0,1,1],
'D5':[1,1,1,1,1,1,1,1,1,0,1,1,1,1,0,0],
'E5':[1,1,1,1,1,1,1,1,1,0,1,1,1,1,0,1],
'F5':[1,1,1,1,1,1,1,1,1,0,1,1,1,1,1,0],
'46':[1,1,1,1,1,1,1,1,1,0,1,1,1,1,1,1],
'56':[1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0],
'66':[1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,1],
'76':[1,1,1,1,1,1,1,1,1,1,0,0,0,0,1,0],
'86':[1,1,1,1,1,1,1,1,1,1,0,0,0,0,1,1],
'96':[1,1,1,1,1,1,1,1,1,1,0,0,0,1,0,0],
'A6':[1,1,1,1,1,1,1,1,1,1,0,0,0,1,0,1],
'B6':[1,1,1,1,1,1,1,1,1,1,0,0,0,1,1,0],
'C6':[1,1,1,1,1,1,1,1,1,1,0,0,0,1,1,1],
'D6':[1,1,1,1,1,1,1,1,1,1,0,0,1,0,0,0],
'E6':[1,1,1,1,1,1,1,1,1,1,0,0,1,0,0,1],
'F6':[1,1,1,1,1,1,1,1,1,1,0,0,1,0,1,0],
'47':[1,1,1,1,1,1,1,1,1,1,0,0,1,0,1,1],
'57':[1,1,1,1,1,1,1,1,1,1,0,0,1,1,0,0],
'67':[1,1,1,1,1,1,1,1,1,1,0,0,1,1,0,1],
'77':[1,1,1,1,1,1,1,1,1,1,0,0,1,1,1,0],
'87':[1,1,1,1,1,1,1,1,1,1,0,0,1,1,1,1],
'97':[1,1,1,1,1,1,1,1,1,1,0,1,0,0,0,0],
'A7':[1,1,1,1,1,1,1,1,1,1,0,1,0,0,0,1],
'B7':[1,1,1,1,1,1,1,1,1,1,0,1,0,0,1,0],
'C7':[1,1,1,1,1,1,1,1,1,1,0,1,0,0,1,1],
'D7':[1,1,1,1,1,1,1,1,1,1,0,1,0,1,0,0],
'E7':[1,1,1,1,1,1,1,1,1,1,0,1,0,1,0,1],
'F7':[1,1,1,1,1,1,1,1,1,1,0,1,0,1,1,0],
'38':[1,1,1,1,1,1,1,1,1,1,0,1,0,1,1,1],
'48':[1,1,1,1,1,1,1,1,1,1,0,1,1,0,0,0],
'58':[1,1,1,1,1,1,1,1,1,1,0,1,1,0,0,1],
'68':[1,1,1,1,1,1,1,1,1,1,0,1,1,0,1,0],
'78':[1,1,1,1,1,1,1,1,1,1,0,1,1,0,1,1],
'88':[1,1,1,1,1,1,1,1,1,1,0,1,1,1,0,0],
'98':[1,1,1,1,1,1,1,1,1,1,0,1,1,1,0,1],
'A8':[1,1,1,1,1,1,1,1,1,1,0,1,1,1,1,0],
'B8':[1,1,1,1,1,1,1,1,1,1,0,1,1,1,1,1],
'C8':[1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0],
'D8':[1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,1],
'E8':[1,1,1,1,1,1,1,1,1,1,1,0,0,0,1,0],
'F8':[1,1,1,1,1,1,1,1,1,1,1,0,0,0,1,1],
'39':[1,1,1,1,1,1,1,1,1,1,1,0,0,1,0,0],
'49':[1,1,1,1,1,1,1,1,1,1,1,0,0,1,0,1],
'59':[1,1,1,1,1,1,1,1,1,1,1,0,0,1,1,0],
'69':[1,1,1,1,1,1,1,1,1,1,1,0,0,1,1,1],
'79':[1,1,1,1,1,1,1,1,1,1,1,0,1,0,0,0],
'89':[1,1,1,1,1,1,1,1,1,1,1,0,1,0,0,1],
'99':[1,1,1,1,1,1,1,1,1,1,1,0,1,0,1,0],
'A9':[1,1,1,1,1,1,1,1,1,1,1,0,1,0,1,1],
'B9':[1,1,1,1,1,1,1,1,1,1,1,0,1,1,0,0],
'C9':[1,1,1,1,1,1,1,1,1,1,1,0,1,1,0,1],
'D9':[1,1,1,1,1,1,1,1,1,1,1,0,1,1,1,0],
'E9':[1,1,1,1,1,1,1,1,1,1,1,0,1,1,1,1],
'F9':[1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0],
'2A':[1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,1],
'3A':[1,1,1,1,1,1,1,1,1,1,1,1,0,0,1,0],
'4A':[1,1,1,1,1,1,1,1,1,1,1,1,0,0,1,1],
'5A':[1,1,1,1,1,1,1,1,1,1,1,1,0,1,0,0],
'6A':[1,1,1,1,1,1,1,1,1,1,1,1,0,1,0,1],
'7A':[1,1,1,1,1,1,1,1,1,1,1,1,0,1,1,0],
'8A':[1,1,1,1,1,1,1,1,1,1,1,1,0,1,1,1],
'9A':[1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0],
'AA':[1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,1],
'BA':[1,1,1,1,1,1,1,1,1,1,1,1,1,0,1,0],
'CA':[1,1,1,1,1,1,1,1,1,1,1,1,1,0,1,1],
'DA':[1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0],
'EA':[1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,1],
'FA':[1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0],
}


def huffman_coding_standard_ac(ac_arr, BStream, component):
    if not component in ['lum', 'chrom']:
        raise ValueError((
            "component should be either 'lum' or 'chrom',"
            "but '{comp}' was found").format(comp=component))

    i = 0
    maxI = np.size(ac_arr)
    while 1:
        if(i==maxI):
            break
        run = 0

        # check if rest of ACArray are all zero. If so, just write EOB and return
        j = i
        while 1:
            if(ac_arr[j]!=0):
                break
            if(j==maxI - 1):
                if (component == 'lum'):
                    BStream.write(ACLuminanceSizeToCode['00'], bool)  # EO
                else:
                    BStream.write(ACChrominanceToCode['00'], bool)
                return
            j = j + 1



        while 1:
            if(ac_arr[i]!=0 or i==maxI - 1 or run==15):
                break
            else:
                run = run + 1
                i = i + 1

        value = int(ac_arr[i])

        if(value==0 and run!=15):
            break # Rest of the components are zeros therefore we simply put the EOB to signify this fact

        size = int(value).bit_length()

        runSizeStr = str.upper(str(hex(run))[2:]) + str.upper(str(hex(size))[2:])

        if (component == 'lum'):
            BStream.write(ACLuminanceSizeToCode[runSizeStr], bool)
        else:
            BStream.write(ACChrominanceToCode[runSizeStr], bool)


        if(value<=0):# if value==0, codeList = [], (SIZE,VALUE)=(SIZE,[])=EOB
            codeList = list(bin(value)[3:])
            for k in range(len(codeList)):
                if (codeList[k] == '0'):
                    codeList[k] = 1
                else:
                    codeList[k] = 0
        else:
            codeList = list(bin(value)[2:])
            for k in range(len(codeList)):
                if (codeList[k] == '0'):
                    codeList[k] = 0
                else:
                    codeList[k] = 1
        BStream.write(codeList, bool)
        i = i + 1

def huffman_coding_standard_dc(dc, BStream, component):
    dc = int(dc)
    if not component in ['lum', 'chrom']:
        raise ValueError((
            "component should be either 'lum' or 'chrom',"
            "but '{comp}' was found").format(comp=component))
        
    boolList = []
    size = int(dc).bit_length() 
    if(component == 'lum'):
        boolList = boolList + DCLuminanceSizeToCode[size]
    else:
        boolList = boolList + DCChrominanceSizeToCode[size]
    if(dc <= 0): 
        codeList = list(bin(dc)[3:])
        for i in range(len(codeList)):
            if (codeList[i] == '0'):
                codeList[i] = 1
            else:
                codeList[i] = 0
    else:
        codeList = list(bin(dc)[2:])
        for i in range(len(codeList)):
            if (codeList[i] == '0'):
                codeList[i] = 0
            else:
                codeList[i] = 1
    boolList = boolList + codeList
    BStream.write(boolList, bool)
