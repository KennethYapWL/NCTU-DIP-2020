% ================================
% This file is used to run multiple experiments on
% 1. Different methods
% 2. Different parameter choices
% The best result will be demostrated on solution_img3.m
% ================================

clear;
close all;
clc;
clf;

figIdx = 0;

% Image 3
imgMatr = imread("p1im3.png");
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
[trans_R, transFunc] = piecewise_linear_streching(imgMatr_R,120,0,155,250);
[trans_G, transFunc] = piecewise_linear_streching(imgMatr_G,120,0,170,250);
[trans_B, transFunc] = piecewise_linear_streching(imgMatr_B,130,0,160,250);

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
[trans_I, transFunc] = piecewise_linear_streching(imgMatr_I,120,0,170,250);
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
% a. on R,G,B separately
trans_R = power_law_transform(imgMatr_R,1.7,3.2);
trans_G = power_law_transform(imgMatr_G,1.7,2.8);
trans_B = power_law_transform(imgMatr_B,1.7,2.8);

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

imgMatr = transImg;

% b. only on I (HSI)
trans_I = power_law_transform(imgMatr_I,0.89,2.3);
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






