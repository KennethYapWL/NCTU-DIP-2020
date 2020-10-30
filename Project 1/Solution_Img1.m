% ================================
% This file show the best method to enhance the image1
% ================================

clear all;
close all;
clc;
clf;

figIdx = 0;
% Image 1
imgMatr = imread("p1im1.png");
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

% check each distribution of channel (RGB)
histR = compute_histogram(imgMatr_R);
histG = compute_histogram(imgMatr_G);
histB = compute_histogram(imgMatr_B);


figIdx = figIdx + 1;
figure(figIdx);
subplot(3,1,1),bar(0:255,histR);
title("Distribution of RGB");
subplot(3,1,2),bar(0:255,histG);
subplot(3,1,3),bar(0:255,histB);


% check distribution of Intensity
histI = compute_histogram(imgMatr_I);

figIdx = figIdx + 1;
figure(figIdx);
bar(0:255,histI);
title("Distribution of Intensity");

% ========================================================================
% CONTRAST ADJUSTMENT
% ========================================================================
% use Piecewise Linear Stretching
[trans_I, transFunc] = piecewise_linear_streching(imgMatr_I,120,70,250,190);
transImgHSI = zeros(size(imgMatr));

transImgHSI(:,:,1) = imgMatr_H;
transImgHSI(:,:,2) = imgMatr_S;
transImgHSI(:,:,3) = trans_I;
transImg = HSI_to_RGB(transImgHSI);

% Transform function
figIdx = figIdx + 1;
figure(figIdx);
plot(transFunc(1,:),transFunc(2,:));
title("Transform Function");

% check adjusted distribution of Intensity
histI = compute_histogram(trans_I);

figIdx = figIdx + 1;
figure(figIdx);
bar(0:255,histI);
title("Distribution of Intensity");

% Check the adjusted distribution of RGB
trans_R = transImg(:,:,1);
trans_G = transImg(:,:,2);
trans_B = transImg(:,:,3);

histR = compute_histogram(trans_R);
histG = compute_histogram(trans_G);
histB = compute_histogram(trans_B);

figIdx = figIdx + 1;
figure(figIdx);
subplot(3,1,1),bar(0:255,histR);
title("Distribution of RGB");
subplot(3,1,2),bar(0:255,histG);
subplot(3,1,3),bar(0:255,histB);

figIdx = figIdx + 1;
figure(figIdx);
imshow(transImg);
title("Piecewise Streching only on Intensity");


imgMatr = transImg;

imgMatr_R = imgMatr(:,:,1);
imgMatr_G = imgMatr(:,:,2);
imgMatr_B = imgMatr(:,:,3);

HSI = RGB_to_HSI(imgMatr);
imgMatr_H = HSI(:,:,1);
imgMatr_S = HSI(:,:,2);
imgMatr_I = HSI(:,:,3);

% ========================================================================
% SMOOTHING DENOISING
% ========================================================================
% Adaptive local noise reduction filter
filtSz = 3;
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

imgMatr_R = imgMatr(:,:,1);
imgMatr_G = imgMatr(:,:,2);
imgMatr_B = imgMatr(:,:,3);

HSI = RGB_to_HSI(imgMatr);
imgMatr_H = HSI(:,:,1);
imgMatr_S = HSI(:,:,2);
imgMatr_I = HSI(:,:,3);

% ========================================================================
% COLOR CORRECTION
% ========================================================================
% Get the RGB and HSI components of the best result in last section
imgMatr_R = imgMatr(:,:,1);
imgMatr_G = imgMatr(:,:,2);
imgMatr_B = imgMatr(:,:,3);

% Convert RGB component into HSV
HSV = RGB_to_HSV(imgMatr);
changeIn_h = 0;
changeIn_s = 0;
changeIn_v = -40;

imgMatr_H = HSV(:,:,1) + changeIn_h;
imgMatr_S = HSV(:,:,2) + changeIn_s;
imgMatr_V = HSV(:,:,3) + changeIn_v;

transImgHSV = zeros(size(imgMatr));

transImgHSV(:,:,1) = imgMatr_H;
transImgHSV(:,:,2) = imgMatr_S;
transImgHSV(:,:,3) = imgMatr_V;
transImg = HSV_to_RGB(transImgHSV);

figIdx = figIdx + 1;
figure(figIdx);
imshow(transImg);
title("Result");
