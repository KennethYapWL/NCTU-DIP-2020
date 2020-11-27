clear;
clc;
clf;
close all;

figIdx = 0;

% read the image
A = imread('img/batman_three_jokers.png');
figIdx = figIdx + 1;
figure(figIdx);
imshow(A);
title('original image');

% show the gray scale of the image
grayS = rgb_to_gray(A);


% ===================================================================
% Task 1. Gradient Filter on Edge Detections 
% ===================================================================
% 1. Prewitt Filter
edges = prewitt_filtering(grayS, 'both');
%edges = convert_to_binary_image(edges, 0.6);
figIdx = figIdx + 1;
figure(figIdx);
imshow(edges);
title('Prewitt Filtering Result');

edges = convert_to_binary_image(edges, 0.8);
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

edges = convert_to_binary_image(edges, 0.9);
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
edges = laplacian_gaussian_filter(grayS, 3);
figIdx = figIdx + 1;
figure(figIdx);
imshow(edges);
title('LoG Filtering Result');

edges = convert_to_binary_image(edges, 0.6);
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
% Task 2. Canny Edge Detection
% ===================================================================
edges = canny_edge_detection(grayS, 0.9, 40, 90);
figIdx = figIdx + 1;
figure(figIdx);
imshow(edges);
title('Canny Edge Detection');

% compare with builtin functions
edges = edge(grayS, 'canny');
figIdx = figIdx + 1;
figure(figIdx);
imshow(edges);
title('builtin Canny Edge Detection Result');