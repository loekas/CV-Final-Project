%% Final Assignment TU Delft Course IN4393-16 Computer Vision 
% Lucas Pijnacker Hordijk 4243307
% Ali Nawaz

clear all; close all; clc;

addpath('model_castle');
run('../vl_feat Toolbox/toolbox/vl_setup.m');

%% load files
im1 = im2single(rgb2gray(imread('8ADT8604.jpg')));
im2 = im2single(rgb2gray(imread('8ADT8603.jpg')));
[f1,d1] = vl_sift(im1);
[f2,d2] = vl_sift(im2);

figure(1)
subplot(1,2,1)
imagesc(im1); colormap gray; hold on ;
vl_plotframe(f1);
vl_plotsiftdescriptor(d1, f1) ;
title('Left image with keypoints and discriptors','FontSize',16)

% Show a discriptor in image 1
subplot(1,2,2)
title('Left image with keypoints and a discriptor','FontSize',16)
imagesc(im2); colormap gray; hold on ;
vl_plotframe(f2);
vl_plotsiftdescriptor(d2, f2) ;

[matches, scores] = vl_ubcmatch(d1,d2);

indexes = sort(scores,'ascend');

matches_sort = matches(:, indexes);
feat1_sort = f1(:,matches_sort(1,:));
feat2_sort = f2(:,matches_sort(2,:));

figure;
plotmatches(im1,im2,feat1_sort,feat2_sort,matches_sort);