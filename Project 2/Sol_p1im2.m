clear;
clc;
clf;
close all;

figIdx = 0;

% read the image
A = imread('img/p1im2.png');
figIdx = figIdx + 1;
figure(figIdx);
imshow(A);
title('original image');

% show the gray scale of the image
grayS = rgb_to_gray(A);


% ===================================================================
% Task 1a. Gradient Filter on Edge Detections (without preprocessing)
% ===================================================================
% 1. Prewitt Filter
edges = prewitt_filtering(grayS, 'both');
%edges = convert_to_binary_image(edges, 0.6);
figIdx = figIdx + 1;
figure(figIdx);
imshow(edges);
title('Prewitt Filtering Result');

edges = convert_to_binary_image(edges, 0.2);
figIdx = figIdx + 1;
figure(figIdx);
imshow(edges);
title('Prewitt Filtering Result with thresholding');

% compare with builtin functions
edges = edge(grayS, 'Prewitt');
figIdx = figIdx + 1;
figure(figIdx);
imshow(edges);
title('builtin Prewitt Filtering Result');

% 2. Sobel Filter
edges = sobel_filtering(grayS, 'both');
figIdx = figIdx + 1;
figure(figIdx);
imshow(edges);
title('Sobel Filtering Result');

edges = convert_to_binary_image(edges, 0.3);
figIdx = figIdx + 1;
figure(figIdx);
imshow(edges);
title('Sobel Filtering Result with thresholding');

% compare with builtin functions
edges = edge(grayS, 'Sobel');
figIdx = figIdx + 1;
figure(figIdx);
imshow(edges);
title('builtin Sobel Filtering Result');

% 3. LoG Filter
edges = laplacian_gaussian_filter(grayS, 2.3);
figIdx = figIdx + 1;
figure(figIdx);
imshow(edges);
title('LoG Filtering Result');

tmp = edges;
edges = convert_to_binary_image(edges, 0.4);
figIdx = figIdx + 1;
figure(figIdx);
imshow(edges);
title('LoG Filtering Result with thresholding');

% compare with builtin functions
edges = edge(grayS, 'log');
figIdx = figIdx + 1;
figure(figIdx);
imshow(edges);
title('builtin LoG Filtering Result');


% ===================================================================
% Task 1b. Gradient Filter on Edge Detections (after preprocessing)
% ===================================================================
% 0. Enhancement
imgMatr = A;
HSI = RGB_to_HSI(imgMatr);
imgMatr_H = HSI(:,:,1);
imgMatr_S = HSI(:,:,2);
imgMatr_I = HSI(:,:,3);

%-- contrast adjusment
trans_I = power_law_transform(imgMatr_I,1.2,0.9);
transImgHSI = zeros(size(imgMatr));

transImgHSI(:,:,1) = imgMatr_H;
transImgHSI(:,:,2) = imgMatr_S;
transImgHSI(:,:,3) = trans_I;
transImg = HSI_to_RGB(transImgHSI);

%-- color correction
imgMatr = transImg;
HSI = RGB_to_HSI(imgMatr);
imgMatr_H = HSI(:,:,1);
imgMatr_S = HSI(:,:,2);
imgMatr_I = HSI(:,:,3);

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


%-- smoothing
imgMatr = transImg;
HSI = RGB_to_HSI(imgMatr);
imgMatr_H = HSI(:,:,1);
imgMatr_S = HSI(:,:,2);
imgMatr_I = HSI(:,:,3);

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
title("After Preprocessing");

% show the gray scale of the image
imgMatr = transImg;
grayS_pre = rgb_to_gray(imgMatr);

% 1. Prewitt Filter
edges = prewitt_filtering(grayS_pre, 'both');
figIdx = figIdx + 1;
figure(figIdx);
imshow(edges);
title('Prewitt Filtering Result');

edges = convert_to_binary_image(edges, 0.17);
figIdx = figIdx + 1;
figure(figIdx);
imshow(edges);
title('Prewitt Filtering Result with thresholding');

% compare with builtin functions
edges = edge(grayS_pre, 'Prewitt');
figIdx = figIdx + 1;
figure(figIdx);
imshow(edges);
title('builtin Prewitt Filtering Result');

% 2. Sobel Filter
edges = sobel_filtering(grayS_pre, 'both');
figIdx = figIdx + 1;
figure(figIdx);
imshow(edges);
title('Sobel Filtering Result');

edges = convert_to_binary_image(edges, 0.2);
figIdx = figIdx + 1;
figure(figIdx);
imshow(edges);
title('Sobel Filtering Result with thresholding');

% compare with builtin functions
edges = edge(grayS_pre, 'Sobel');
figIdx = figIdx + 1;
figure(figIdx);
imshow(edges);
title('builtin Sobel Filtering Result');

% 3. LoG Filter
edges = laplacian_gaussian_filter(grayS_pre, 2.1);
figIdx = figIdx + 1;
figure(figIdx);
imshow(edges);
title('LoG Filtering Result');

edges = convert_to_binary_image(edges, 0.45);
figIdx = figIdx + 1;
figure(figIdx);
imshow(edges);
title('LoG Filtering Result with thresholding');

% compare with builtin functions
edges = edge(grayS_pre, 'log');
figIdx = figIdx + 1;
figure(figIdx);
imshow(edges);
title('builtin LoG Filtering Result');


% ===================================================================
% Task 2. Canny Edge Detection
% ===================================================================
edges = canny_edge_detection(grayS, 0.08, 30, 45);
figIdx = figIdx + 1;
figure(figIdx);
imshow(edges);
title('Canny Edge Detection (without preprocessing)');

% compare with builtin functions
edges = edge(grayS, 'canny');
figIdx = figIdx + 1;
figure(figIdx);
imshow(edges);
title('builtin Canny Edge Detection Result');

edges = canny_edge_detection(grayS_pre, 0.08, 19, 31);
figIdx = figIdx + 1;
figure(figIdx);
imshow(edges);
title('Canny Edge Detection (with preprocessing)');

% compare with builtin functions
edges = edge(grayS_pre, 'canny');
figIdx = figIdx + 1;
figure(figIdx);
imshow(edges);
title('builtin Canny Edge Detection Result');