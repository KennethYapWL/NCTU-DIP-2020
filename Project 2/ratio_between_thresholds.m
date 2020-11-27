clear;
clc;
clf;
close all;

figIdx = 0;

% read the image
A = imread('img/p1im5.png');
figIdx = figIdx + 1;
figure(figIdx);
imshow(A);
title('original image');

% show the gray scale of the image
grayS = rgb_to_gray(A);

% ===================================================================
% Task 2. Canny Edge Detection
% ===================================================================
edges = canny_edge_detection(grayS, 0.0005, 20, 50);
figIdx = figIdx + 1;
figure(figIdx);
imshow(edges);
title('Canny Edge Detection (between 1/2 to 1/3)');

edges = canny_edge_detection(grayS, 0.0005, 20, 70);
figIdx = figIdx + 1;
figure(figIdx);
imshow(edges);
title('Canny Edge Detection (smaller than 1/3)');

edges = canny_edge_detection(grayS, 0.0005, 20, 30);
figIdx = figIdx + 1;
figure(figIdx);
imshow(edges);
title('Canny Edge Detection (bigger than 1/2)');