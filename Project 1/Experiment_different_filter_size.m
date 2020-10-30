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

filtWd = [3,5,7,9];
Type = "median"; % also, "max","min","mean" are allowed
% 1. order statistics filtering
% only on I (HSI)
for x = 1 : size(filtWd,2)
    wd = filtWd(1,x);
    hg = filtWd(1,x);
    trans_I = statistic_filtering(imgMatr_I,hg,wd,Type);
    transImgHSI = zeros(size(imgMatr));

    transImgHSI(:,:,1) = imgMatr_H;
    transImgHSI(:,:,2) = imgMatr_S;
    transImgHSI(:,:,3) = trans_I;
    transImg = HSI_to_RGB(transImgHSI);

    figIdx = figIdx + 1;
    figure(figIdx);
    imshow(transImg);
    title("Order Statistics Filtering on Intensity, filter size = " + hg + "," + wd);
end

filtWd = [3];
filtHg = [2,3,4,5,7,9];
Type = "median"; % also, "max","min","mean" are allowed
% 1. order statistics filtering
% only on I (HSI)
for x = 1 : size(filtHg,2)
    for y = 1 : size(filtWd,2)
        wd = filtWd(1,y);
        hg = filtHg(1,x);
        trans_I = statistic_filtering(imgMatr_I,hg,wd,Type);
        transImgHSI = zeros(size(imgMatr));

        transImgHSI(:,:,1) = imgMatr_H;
        transImgHSI(:,:,2) = imgMatr_S;
        transImgHSI(:,:,3) = trans_I;
        transImg = HSI_to_RGB(transImgHSI);

        figIdx = figIdx + 1;
        figure(figIdx);
        imshow(transImg);
        title("Order Statistics Filtering on Intensity, filter size = " + hg + "," + wd);

    end
end

