clear;
clc;
clf;
close all;

figIdx = 0;

% read the image
A = imread('img/batman_god_of_knowledge.jpg');
figIdx = figIdx + 1;
figure(figIdx);
imshow(A);
title('original image');


img_R = A(:,:,1);
img_G = A(:,:,2);
img_B = A(:,:,3);

grayS = rgb_to_gray(A);

% ===================================================================
% Gradient Filtering (Sobel)
% ===================================================================
% 1. GrayScale
RES = sobel_filtering(grayS, 'both');
figIdx = figIdx + 1;
figure(figIdx);
imshow(RES);
title('Sobel Filtering Gray Scale Result');

% 2. RGB components
trans_R = sobel_filtering(img_R, 'both');
trans_G = sobel_filtering(img_G, 'both');
trans_B = sobel_filtering(img_B, 'both');

RES = cat(3, trans_R, trans_G, trans_B);
figIdx = figIdx + 1;
figure(figIdx);
imshow(RES);
title('Sobel Filtering RGB Result');

% 3. HSI components
HSI = RGB_to_HSI(A);
H = HSI(:,:,1);
S = HSI(:,:,2);
I = HSI(:,:,3);
trans_I = sobel_filtering(I, 'both');
HSI(:,:,3) = trans_I;
RES = HSI_to_RGB(HSI);

figIdx = figIdx + 1;
figure(figIdx);
imshow(RES);
title('Sobel Filtering HSI Result');

% 4. YCbCr components
YCbCr = RGB_to_YCbCr(A);
Y = YCbCr(:,:,1);
Cb = YCbCr(:,:,2);
Cr = YCbCr(:,:,3);

trans_Y = sobel_filtering(Y, 'both');
YCbCr(:,:,1) = trans_Y;
RES = YCbCr_to_RGB(YCbCr);

figIdx = figIdx + 1;
figure(figIdx);
imshow(RES);
title('Sobel Filtering YCbCr Result');



