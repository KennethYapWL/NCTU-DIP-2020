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