% ================================
% This file is used to run multiple experiments on
% 1. Different methods
% 2. Different parameter choices
% The best result will be demostrated on solution_img6.m
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

filtSz = 5;
% 1. order statistics filtering
% a. on R,G,B separately
Type = "median"; % also, "max","min","mean" are allowed
trans_R = statistic_filtering(imgMatr_R,filtSz,filtSz,Type);
trans_G = statistic_filtering(imgMatr_G,filtSz,filtSz,Type);
trans_B = statistic_filtering(imgMatr_B,filtSz,filtSz,Type);

transImg = cat(3,trans_R,trans_G,trans_B);
%figIdx = figIdx + 1;
%figure(figIdx);
%imshow(transImg);
%title("Order Statistics Filtering on RGB separately");

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
trans_R = gaussian_filtering(imgMatr_R,sigma,filtSz);
trans_G = gaussian_filtering(imgMatr_G,sigma,filtSz);
trans_B = gaussian_filtering(imgMatr_B,sigma,filtSz);

transImg = cat(3,trans_R,trans_G,trans_B);
%figIdx = figIdx + 1;
%figure(figIdx);
%imshow(transImg);
%title("Gaussian Filtering on RGB separately");

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
trans_R = midpoint_filtering(imgMatr_R,filtSz,filtSz);
trans_G = midpoint_filtering(imgMatr_G,filtSz,filtSz);
trans_B = midpoint_filtering(imgMatr_B,filtSz,filtSz);

transImg = cat(3,trans_R,trans_G,trans_B);
%figIdx = figIdx + 1;
%figure(figIdx);
%imshow(transImg);
%title("Midpoint Filtering on RGB separately");

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
trans_R = alpha_trimmed_filtering(imgMatr_R,filtSz,filtSz,alpha);
trans_G = alpha_trimmed_filtering(imgMatr_G,filtSz,filtSz,alpha);
trans_B = alpha_trimmed_filtering(imgMatr_B,filtSz,filtSz,alpha);

transImg = cat(3,trans_R,trans_G,trans_B);
%figIdx = figIdx + 1;
%figure(figIdx);
%imshow(transImg);
%title("Alpha Trimmed Filtering on RGB separately");

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
trans_R = adaptive_filtering(imgMatr_R,filtSz,filtSz);
trans_G = adaptive_filtering(imgMatr_G,filtSz,filtSz);
trans_B = adaptive_filtering(imgMatr_B,filtSz,filtSz);

transImg = cat(3,trans_R,trans_G,trans_B);
%figIdx = figIdx + 1;
%figure(figIdx);
%imshow(transImg);
%title("Adaptive Filtering on RGB separately");

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
trans_R = adaptive_median_filtering(imgMatr_R,filtSz);
trans_G = adaptive_median_filtering(imgMatr_G,filtSz);
trans_B = adaptive_median_filtering(imgMatr_B,filtSz);

transImg = cat(3,trans_R,trans_G,trans_B);
%figIdx = figIdx + 1;
%figure(figIdx);
%imshow(transImg);
%title("Adaptive Median Filtering on RGB separately");

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
sigma_d = 50;
sigma_g = 50;
trans_R = bilateral_filtering(imgMatr_R,filtSz,sigma_d,sigma_g);
trans_G = bilateral_filtering(imgMatr_G,filtSz,sigma_d,sigma_g);
trans_B = bilateral_filtering(imgMatr_B,filtSz,sigma_d,sigma_g);

transImg = cat(3,trans_R,trans_G,trans_B);
%figIdx = figIdx + 1;
%figure(figIdx);
%imshow(transImg);
%title("Bilateral Filtering on RGB separately");

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

