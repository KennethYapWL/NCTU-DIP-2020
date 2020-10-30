% ================================
% This file show the best method to enhance the image2
% ================================

clear;
close all;
clc;
clf;

figIdx = 0;
% Image 2
imgMatr = imread("p1im2.png");
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
% power law transformation
% only on I (HSI)
trans_I = power_law_transform(imgMatr_I,1.2,0.9);
transImgHSI = zeros(size(imgMatr));

transImgHSI(:,:,1) = imgMatr_H;
transImgHSI(:,:,2) = imgMatr_S;
transImgHSI(:,:,3) = trans_I;
transImg = HSI_to_RGB(transImgHSI);

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
title("Power Law Transformation only on Intensity");

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
% Convert RGB component into HSV
HSV = RGB_to_HSV(imgMatr);
changeIn_h = -30/360;
changeIn_s = 0.2;
changeIn_v = -20;

imgMatr_H = HSV(:,:,1) + changeIn_h;
imgMatr_S = HSV(:,:,2) + changeIn_s;
imgMatr_V = HSV(:,:,3) + changeIn_v;

transImgHSI = zeros(size(imgMatr));

transImgHSI(:,:,1) = imgMatr_H;
transImgHSI(:,:,2) = imgMatr_S;
transImgHSI(:,:,3) = imgMatr_V;
transImg = HSV_to_RGB(transImgHSI);

figIdx = figIdx + 1;
figure(figIdx);
imshow(transImg);
title("Color Correction on Intensity");

imgMatr = transImg;

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
% bilateral filter
% only on I (HSI)
filtSz = 3;
sigma_d = 15;
sigma_g = 15;
trans_I = bilateral_filtering(imgMatr_I,filtSz,sigma_d,sigma_g);
transImgHSI = zeros(size(imgMatr));

transImgHSI(:,:,1) = imgMatr_H;
transImgHSI(:,:,2) = imgMatr_S;
transImgHSI(:,:,3) = trans_I;
transImg = HSI_to_RGB(transImgHSI);

figIdx = figIdx + 1;
figure(figIdx);
imshow(transImg);
title("Bilateral Filtering on Intensity");

imgMatr = transImg;

imgMatr_R = imgMatr(:,:,1);
imgMatr_G = imgMatr(:,:,2);
imgMatr_B = imgMatr(:,:,3);

HSI = RGB_to_HSI(imgMatr);
imgMatr_H = HSI(:,:,1);
imgMatr_S = HSI(:,:,2);
imgMatr_I = HSI(:,:,3);

% ========================================================================
% SHARPENING
% ========================================================================
% laplacian filter
% only on I (HSI)
%Lapl_filt = [0,1,0 ; 1,-4,1 ; 0,1,0];
Lapl_filt = [1,1,1 ; 1,-8,1 ; 1,1,1];
trans_I = laplacian_filtering(imgMatr_I,Lapl_filt);
transImgHSI = zeros(size(imgMatr));

transImgHSI(:,:,1) = imgMatr_H;
transImgHSI(:,:,2) = imgMatr_S;
transImgHSI(:,:,3) = trans_I;
transImg = HSI_to_RGB(transImgHSI);

figIdx = figIdx + 1;
figure(figIdx);
imshow(transImg);
title("Result");

imgMatr = transImg;