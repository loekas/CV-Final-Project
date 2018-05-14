%% Final Assignment TU Delft Course IN4393-16 Computer Vision 
% Lucas Pijnacker Hordijk 4243307
% Ali Nawaz

clear all; close all; clc;

addpath('model_castle');
run('vl_feat Toolbox/toolbox/vl_setup.m');


%% load files
im1 = im2single(rgb2gray(imread('8ADT8604.jpg')));
[f1, d1] = vl_sift(im1);

figure(1)
subplot(1,2,1)
imagesc(im1); colormap gray; hold on ;
vl_plotframe(f1);


% Show a discriptor in image 1
title('Left image with keypoints and a discriptor','FontSize',16)