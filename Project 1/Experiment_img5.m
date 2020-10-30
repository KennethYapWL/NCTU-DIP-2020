% ================================
% This file is used to run multiple experiments on
% 1. Different methods
% 2. Different parameter choices
% The best result will be demostrated on solution_img5.m
% ================================

clear;
close all;
clc;
clf;

figIdx = 0;

% Image 5
imgMatr = imread("p1im5.png");
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
[trans_R, transFunc] = piecewise_linear_streching(imgMatr_R,40,0,180,255);
[trans_G, transFunc] = piecewise_linear_streching(imgMatr_G,55,0,180,255);
[trans_B, transFunc] = piecewise_linear_streching(imgMatr_B,50,0,180,255);

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
[trans_I, transFunc] = piecewise_linear_streching(imgMatr_I,50,0,180,255);
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
trans_R = power_law_transform(imgMatr_R,1,1.5);
trans_G = power_law_transform(imgMatr_G,1,1.5);
trans_B = power_law_transform(imgMatr_B,1,1.5);

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
trans_I = power_law_transform(imgMatr_I,0.9,0.8);
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

close all;
clc;
clf;

figIdx = 0;
figIdx = figIdx + 1;
figure(figIdx);
imshow(imgMatr);
title("Best Contrast Adjustment Image");

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
changeIn_s = 0.09;
changeIn_v = -25;

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

