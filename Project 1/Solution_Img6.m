% ================================
% This file show the best method to enhance the image6
% ================================

clear;
close all;
clc;
clf;

figIdx = 0;
% Image 6
imgMatr = imread("p1im6.png");
figIdx = figIdx + 1;
figure(figIdx);
imshow(imgMatr);
title("Original Image");


imgMatr_R = imgMatr(:,:,1);
imgMatr_G = imgMatr(:,:,2);
imgMatr_B = imgMatr(:,:,3);

HSI = RGB_to_HSI(imgMatr);
imgMatr_H = HSI(:,:,1);
imgMatr_S = HSI(:,:,2);
imgMatr_I = HSI(:,:,3);


% ========================================================================
% SMOOTHING AND NOISE REDUCTION
% ========================================================================
filtSz = 5;
% Adaptive local noise reduction filter
% only on I (HSI)
trans_I = adaptive_filtering(imgMatr_I,filtSz,filtSz);
transImgHSI = zeros(size(imgMatr));

transImgHSI(:,:,1) = imgMatr_H;
transImgHSI(:,:,2) = imgMatr_S;
transImgHSI(:,:,3) = trans_I;
transImg = HSI_to_RGB(transImgHSI);

figIdx = figIdx + 1;
figure(figIdx);
imshow(transImg);
title("Adaptive Filtering on Intensity");

imgMatr = transImg;



