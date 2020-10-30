% ================================
% This file is used to run multiple experiments on
% 1. Different methods
% 2. Different parameter choices
% The best result will be demostrated on solution_img1.m
% ================================

clear;
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
% contrast adjustment
% ========================================================================
% 1. piecewise linear streching
% a. on R,G,B separately
[trans_R, transFunc] = piecewise_linear_streching(imgMatr_R,125,0,250,255);
[trans_G, transFunc] = piecewise_linear_streching(imgMatr_G,125,0,250,255);
[trans_B, transFunc] = piecewise_linear_streching(imgMatr_B,125,0,250,255);

% Transform function
figIdx = figIdx + 1;
figure(figIdx);
plot(transFunc(1,:),transFunc(2,:));
title("Transform Function");

% Check the adjusted distribution of RGB
histR = compute_histogram(trans_R);
histG = compute_histogram(trans_G);
histB = compute_histogram(trans_B);

figIdx = figIdx + 1;
figure(figIdx);
subplot(3,1,1),bar(0:255,histR);
title("Distribution of RGB");
subplot(3,1,2),bar(0:255,histG);
subplot(3,1,3),bar(0:255,histB);


transImg = cat(3,trans_R,trans_G,trans_B);
figIdx = figIdx + 1;
figure(figIdx);
imshow(transImg);
title("Piecewise Streching on RGB separately");

% b. only on I (HSI)
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

% 2. power law transformation
% a. on R,G,B separately
trans_R = power_law_transform(imgMatr_R,1,2.5);
trans_G = power_law_transform(imgMatr_G,1,2.5);
trans_B = power_law_transform(imgMatr_B,1,2.5);

% Check the adjusted distribution of RGB
histR = compute_histogram(trans_R);
histG = compute_histogram(trans_G);
histB = compute_histogram(trans_B);

figIdx = figIdx + 1;
figure(figIdx);
subplot(3,1,1),bar(0:255,histR);
title("Distribution of RGB");
subplot(3,1,2),bar(0:255,histG);
subplot(3,1,3),bar(0:255,histB);


transImg = cat(3,trans_R,trans_G,trans_B);
figIdx = figIdx + 1;
figure(figIdx);
imshow(transImg);
title("Power Law Transformation on RGB separately");

% b. only on I (HSI)
trans_I = power_law_transform(imgMatr_I,0.90,0.95);
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


% 1. order statistics filtering
% a. on R,G,B separately
Type = "mean"; % also, "max","min","mean" are allowed
filtSz = 3;
trans_R = statistic_filtering(imgMatr_R,filtSz,filtSz,Type);
trans_G = statistic_filtering(imgMatr_G,filtSz,filtSz,Type);
trans_B = statistic_filtering(imgMatr_B,filtSz,filtSz,Type);

transImg = cat(3,trans_R,trans_G,trans_B);
figIdx = figIdx + 1;
figure(figIdx);
imshow(transImg);
title("Order Statistics Filtering on RGB separately");

% b. only on I (HSI)
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
% a. on R,G,B separately
sigma = 0.5;
filtSz = 3;
trans_R = gaussian_filtering(imgMatr_R,sigma,filtSz);
trans_G = gaussian_filtering(imgMatr_G,sigma,filtSz);
trans_B = gaussian_filtering(imgMatr_B,sigma,filtSz);

transImg = cat(3,trans_R,trans_G,trans_B);
figIdx = figIdx + 1;
figure(figIdx);
imshow(transImg);
title("Gaussian Filtering on RGB separately");

% b. only on I (HSI)
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
% a. on R,G,B separately
filtSz = 3;
trans_R = midpoint_filtering(imgMatr_R,filtSz,filtSz);
trans_G = midpoint_filtering(imgMatr_G,filtSz,filtSz);
trans_B = midpoint_filtering(imgMatr_B,filtSz,filtSz);

transImg = cat(3,trans_R,trans_G,trans_B);
figIdx = figIdx + 1;
figure(figIdx);
imshow(transImg);
title("Midpoint Filtering on RGB separately");

% b. only on I (HSI)
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
% a. on R,G,B separately
alpha = 0.5;
filtSz = 3;
trans_R = alpha_trimmed_filtering(imgMatr_R,filtSz,filtSz,alpha);
trans_G = alpha_trimmed_filtering(imgMatr_G,filtSz,filtSz,alpha);
trans_B = alpha_trimmed_filtering(imgMatr_B,filtSz,filtSz,alpha);

transImg = cat(3,trans_R,trans_G,trans_B);
figIdx = figIdx + 1;
figure(figIdx);
imshow(transImg);
title("Alpha Trimmed Filtering on RGB separately");

% b. only on I (HSI)
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
% a. on R,G,B separately
filtSz = 3;
trans_R = adaptive_filtering(imgMatr_R,filtSz,filtSz);
trans_G = adaptive_filtering(imgMatr_G,filtSz,filtSz);
trans_B = adaptive_filtering(imgMatr_B,filtSz,filtSz);

transImg = cat(3,trans_R,trans_G,trans_B);
figIdx = figIdx + 1;
figure(figIdx);
imshow(transImg);
title("Adaptive Filtering on RGB separately");

% b. only on I (HSI)
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
% a. on R,G,B separately
filtSz = 9;
trans_R = adaptive_median_filtering(imgMatr_R,filtSz);
trans_G = adaptive_median_filtering(imgMatr_G,filtSz);
trans_B = adaptive_median_filtering(imgMatr_B,filtSz);

transImg = cat(3,trans_R,trans_G,trans_B);
figIdx = figIdx + 1;
figure(figIdx);
imshow(transImg);
title("Adaptive Median Filtering on RGB separately");

% b. only on I (HSI)
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
% a. on R,G,B separately
sigma_d = 10;
sigma_g = 10;
filtSz = 3;
trans_R = bilateral_filtering(imgMatr_R,filtSz,sigma_d,sigma_g);
trans_G = bilateral_filtering(imgMatr_G,filtSz,sigma_d,sigma_g);
trans_B = bilateral_filtering(imgMatr_B,filtSz,sigma_d,sigma_g);

transImg = cat(3,trans_R,trans_G,trans_B);
figIdx = figIdx + 1;
figure(figIdx);
imshow(transImg);
title("Bilateral Filtering on RGB separately");

% b. only on I (HSI)
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


figIdx = figIdx + 1;
figure(figIdx);
imshow(imgMatr);
title("Best Contrast Adjustment & denoising Image");

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
% a. on R,G,B separately
Lapl_filt = [0,1,0;1,-4,1;0,1,0];
trans_R = laplacian_filtering(imgMatr_R,Lapl_filt);
trans_G = laplacian_filtering(imgMatr_G,Lapl_filt);
trans_B = laplacian_filtering(imgMatr_B,Lapl_filt);

transImg = cat(3,trans_R,trans_G,trans_B);
figIdx = figIdx + 1;
figure(figIdx);
imshow(transImg);
title("Laplacian Filtering on RGB separately");

% b. only on I (HSI)
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


figIdx = figIdx + 1;
figure(figIdx);
imshow(imgMatr);
title("Best Image so far");


% ========================================================================
% Color Correction
% ========================================================================
% Get the RGB and HSI components of the best result in last section
imgMatr_R = imgMatr(:,:,1);
imgMatr_G = imgMatr(:,:,2);
imgMatr_B = imgMatr(:,:,3);

% Convert RGB component into HSV
HSV = RGB_to_HSV(imgMatr);
changeIn_h = 5;
changeIn_s = 0;
changeIn_v = 0;

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
