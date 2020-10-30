% ================================
% This file is used to run multiple experiments on
% 1. Different methods
% 2. Different parameter choices
% The best result will be demostrated on solution_img4.m
% ================================

clear;
close all;
clc;
clf;

figIdx = 0;

% Image 4
imgMatr = imread("p1im4.png");
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
% contrast adjustment
% ========================================================================
% 1. piecewise linear streching
% only on I (HSI)
[trans_I, transFunc] = piecewise_linear_streching(imgMatr_I,170,150,180,250);
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

% 2. power law transformation
% only on I (HSI)
trans_I = power_law_transform(imgMatr_I,1,0.95);
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

%imgMatr = transImg;

% ========================================================================
% Sharpening
% ========================================================================
% Get the RGB and HSI components of the best result in last section
imgMatr_R = imgMatr(:,:,1);
imgMatr_G = imgMatr(:,:,2);
imgMatr_B = imgMatr(:,:,3);

HSI = RGB_to_HSI(imgMatr);
imgMatr_H = HSI(:,:,1);
imgMatr_S = HSI(:,:,2);
imgMatr_I = HSI(:,:,3);

% 1. laplacian filter
% b. only on I (HSI)
Lapl_filt = [0,1,0 ; 1,-4,1 ; 0,1,0];
trans_I = laplacian_filtering(imgMatr_I,Lapl_filt);
transImgHSI = zeros(size(imgMatr));

transImgHSI(:,:,1) = imgMatr_H;
transImgHSI(:,:,2) = imgMatr_S;
transImgHSI(:,:,3) = trans_I;
transImg = HSI_to_RGB(transImgHSI);

figIdx = figIdx + 1;
figure(figIdx);
imshow(transImg);
title("Laplacian Filtering on Intensity");

imgMatr = transImg;

% ========================================================================
% Color Correction
% ========================================================================
% Get the RGB and HSI components of the best result in last section
imgMatr_R = imgMatr(:,:,1);
imgMatr_G = imgMatr(:,:,2);
imgMatr_B = imgMatr(:,:,3);

% Convert RGB component into HSV
HSV = RGB_to_HSV(imgMatr);
changeIn_h = -5/360;
changeIn_s = 0.1;
changeIn_v = 10;

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



close all;
clc;
clf;

figIdx = 0;
figIdx = figIdx + 1;
figure(figIdx);
imshow(imgMatr);
title("Best Contrast Adjustment Image");

% ========================================================================
% Smoothing and Noise Reduction
% ========================================================================
% Get the RGB and HSI components of the best result in last section
imgMatr_R = imgMatr(:,:,1);
imgMatr_G = imgMatr(:,:,2);
imgMatr_B = imgMatr(:,:,3);

HSI = RGB_to_HSI(imgMatr);
imgMatr_H = HSI(:,:,1);
imgMatr_S = HSI(:,:,2);
imgMatr_I = HSI(:,:,3);

filtSz = 3;

% 1. order statistics filtering
% only on I (HSI)
Type = "median";
trans_I = statistic_filtering(imgMatr_I,filtSz,filtSz,Type);
transImgHSI = zeros(size(imgMatr));

transImgHSI(:,:,1) = imgMatr_H;
transImgHSI(:,:,2) = imgMatr_S;
transImgHSI(:,:,3) = trans_I;
transImg = HSI_to_RGB(transImgHSI);

figIdx = figIdx + 1;
figure(figIdx);
imshow(transImg);
title("Order Statistics Filtering on Intensity");

% 2. gaussian smoothing filter
% only on I (HSI)
sigma = 1;
trans_I = gaussian_filtering(imgMatr_I,sigma,filtSz);
transImgHSI = zeros(size(imgMatr));

transImgHSI(:,:,1) = imgMatr_H;
transImgHSI(:,:,2) = imgMatr_S;
transImgHSI(:,:,3) = trans_I;
transImg = HSI_to_RGB(transImgHSI);

figIdx = figIdx + 1;
figure(figIdx);
imshow(transImg);
title("Gaussian Filtering on Intensity");

% 3. midpoint filter
% only on I (HSI)
trans_I = midpoint_filtering(imgMatr_I,filtSz,filtSz);
transImgHSI = zeros(size(imgMatr));

transImgHSI(:,:,1) = imgMatr_H;
transImgHSI(:,:,2) = imgMatr_S;
transImgHSI(:,:,3) = trans_I;
transImg = HSI_to_RGB(transImgHSI);

figIdx = figIdx + 1;
figure(figIdx);
imshow(transImg);
title("Midpoint Filtering on Intensity");

% 4. alpha-trimmed filter
% only on I (HSI)
alpha = 0.25;
trans_I = alpha_trimmed_filtering(imgMatr_I,filtSz,filtSz,alpha);
transImgHSI = zeros(size(imgMatr));

transImgHSI(:,:,1) = imgMatr_H;
transImgHSI(:,:,2) = imgMatr_S;
transImgHSI(:,:,3) = trans_I;
transImg = HSI_to_RGB(transImgHSI);

figIdx = figIdx + 1;
figure(figIdx);
imshow(transImg);
title("Alpha Trimmed Filtering on Intensity");

% 5. adaptive local noise reduction filter
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

% 6. adaptive median filter
% only on I (HSI)
trans_I = adaptive_median_filtering(imgMatr_I,filtSz);
transImgHSI = zeros(size(imgMatr));

transImgHSI(:,:,1) = imgMatr_H;
transImgHSI(:,:,2) = imgMatr_S;
transImgHSI(:,:,3) = trans_I;
transImg = HSI_to_RGB(transImgHSI);

figIdx = figIdx + 1;
figure(figIdx);
imshow(transImg);
title("Adaptive Median Filtering on Intensity");

% 7. bilateral filter
% only on I (HSI)
sigma_d = 10;
sigma_g = 10;
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



figIdx = figIdx + 1;
figure(figIdx);
imshow(imgMatr);
title("Best Contrast Adjustment Image");