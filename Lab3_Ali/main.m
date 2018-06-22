%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%% IN4393-16 Computer Vision %%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%% Assignment 2  %%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%% RANSAC IMAGE ALIGNMENT AND STITCHING %%%%%%%%%%
%%%%%%%%%%%%%%%%% RUN VERSION FINAL %%%%%%%%%%%%%%%%%%%%%%
%%% Author Info: Ali Nawaz, TU Delft, The Netherlands %%%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
close all; clear all; clc; % Clear memory, close previous windows and clear command window

%% ////////////// PART 1: IMAGE ALIGNMENT ////////////// 

img1 = im2single(imread('img1.pgm')); % load first boat image
img2 = im2single(imread('img2.pgm')); % load first boat image

P = 0.8; % percentage of matches to be used random columns
no_points = 6; % minimum three, 
threshold = 10; % pixel radius for inlier detection.

[T, inliers] = ransac(img1, img2, P, no_points,threshold); % T is the transformation matrix, inliers = the corresponding inliers

% Plot original images
figure();
imshow(img1);
title('Original Image 1');

figure();
imshow(img2);
title('Original Image 2');

% Plot the transformed images
figure()
tform1 = maketform('affine',T');
[image1_transformed] = imtransform(img1,tform1,'bicubic');
imshow(image1_transformed);
title('Image 1 transformed to Image 2');

figure()
tform2 = maketform('affine',inv(T)');
[image2_transformed] = imtransform(img2, tform2, 'bicubic');
figure()
imshow(image2_transformed);
title('Image 2 transformed to Image 1');

%% ////////////// PART 2. STITCHING TWO IMAGES //////////////
clear all;
img1 = im2single(rgb2gray(imread('left.jpg'))); % load first boat image
img2 = im2single(rgb2gray(imread('right.jpg'))); % load first boat image


P = 0.8; % percentage of matches to be used random columns
no_points = 6; % minimum three, 
threshold = 10; % pixel radius for inlier detection.

[T, inliers] = ransac(img1, img2, P, no_points,threshold); % T is the transformation matrix, inliers = the corresponding inliers

% Stitch images and return the transformed and stitched images. 
image_stitch(img1, img2, T)