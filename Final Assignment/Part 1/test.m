%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%% IN4393-16 Computer Vision %%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%% Assignment 6  %%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%% CHAINING %%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%% RUN VERSION 1 %%%%%%%%%%%%%%%%%%%%%%
%%% Author Info: Ali Nawaz, TU Delft, The Netherlands %%%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
close all; clear all; clc; % Clear memory, close previous windows and clear command window


% addpath('Extraction SIFT descriptors/')
% addpath('Feature point detection/')
% addpath('PNG image files/')
addpath('Files with new threshold/')

%% PART 1: MATCHING

%% 1.1 Detecting Harris and Hessian interest points in each image

% Run the following via linux terminal. More info: http://www.robots.ox.ac.uk/~vgg/research/affine/detectors.html
% Harris affine interest/feature point detection:
% prompt>./h_affine.ln -haraff -i img1.ppm -o img1.haraff -thres 1000
% Hessian affine interest/feature point detection:
% prompt>./h_affine.ln -hesaff -i img1.ppm -o img1.hesaff -thres 500

% Visualising one of the detected Harris and Hessian Affine feature point
% sets
figure()
display_features('8ADT8586.haraff','8ADT8586.png',0, 0);
title('Harris affine features')

figure()
display_features('8ADT8587.hesaff','8ADT8587.png',0, 0);
title('Hessian affine features')

%% 1.2 Extracting SIFT descriptors around these interest points

% Run the following via linux terminal. More info: http://www.robots.ox.ac.uk/~vgg/research/affine/detectors.html
% Harris affine SIFT interest/feature point detectors/descriptors
% prompt>./extract_features -haraff -i img.png -thres 1000 -sift
% Hessian affine SIFT interest/feature point detectors/descriptors
% prompt>./extract_features -hesaff -i img.png -thres 500 -sift

% The returned files have the following information:
% [x, y, a, b, c, desc] -> x, y = feature locations; a, b, c are parameters
% used in defining an affine region: u,v,a,b,c    in    a(x-u)(x-u)+2b(x-u)(y-v)+c(y-v)(y-v)=1


% files_hes_aff_sift = dir('TeddyBear/Features point detection/*.hesaff.sift');
% files_har_aff_sift = dir('TeddyBear/Features point detection/*.haraff.sift');

%% Scan through all the haraff and hessian affine sift files in the folder and generate features and descriptors
[feat_haraff_sift, descr_haraff_sift] = features_descriptors('Files with new threshold/', '*.haraff.sift');
[feat_hesaff_sift, descr_hesaff_sift] = features_descriptors('Files with new threshold/', '*.hesaff.sift');
%% Generate matches between consecutive frames, i.e.  Frames 1-2, 2-3, 3-4, 5-6 ... 15-16, 16-1
[matched_features_combined, matches_cells] = combine_feature_return_matches(feat_haraff_sift, feat_hesaff_sift, descr_haraff_sift, descr_hesaff_sift);

%% Run Normalized 8 point RANSAC algorithm to generate the best fundamental matrices and for all the matched frames and corresponding updated matched features with the best inlier matches selected and the rest of the matches thrown away.
N = 10; % Number of iterations
P = 0.5; % Percentage of matches for Normalised 8 point RANSAC algorithm
no_points = 8;
threshold = 10;
% Ignore points outside these bounds. To avoid missed detections at the box
% corners 
lbx = 800;
ubx = 3200; 
[fundamental_matrices, inliers_matched_features_combined] = normalised_8point_ransac_multiframes(matched_features_combined, matches_cells, N, P, no_points, threshold, lbx, ubx);
%
%%
% Visual verfication of the results with the aid of epipolar lines
% Pick two consecutive frames
frame1_string = '590';
frame2_string = '591';

% load two selected images
imgc1 = imread(strcat('8ADT8',frame1_string,'.png'));
imgc2 = imread(strcat('8ADT8',frame2_string,'.png'));
% load the corresponding best Fundamental matrix and the inliers selected 
F_best_global = fundamental_matrices{1,str2num(frame1_string)-585};
feat1_bestglobal = inliers_matched_features_combined{1,str2num(frame1_string)-585}{1,1};
feat2_bestglobal = inliers_matched_features_combined{2,str2num(frame1_string)-585}{1,1};

figure(111)
lines = epipolarLine(F_best_global',feat2_bestglobal(1:2,:)');
points = lineToBorderPoints(lines, size(imgc1));
imshow(imgc1)
hold on 
line(points(:,[1,3])',points(:,[2,4])');
vl_plotframe(feat1_bestglobal(1:2,:),'markers',15); 
title(strcat('Epipolar Lines, normalised 8 point RANSAC: Image ',frame1_string) );
hold off
%%
figure(222)
lines = epipolarLine(F_best_global,feat1_bestglobal(1:2,:)');
points = lineToBorderPoints(lines, size(imgc2));
imshow(imgc2)
hold on 
line(points(:,[1,3])',points(:,[2,4])');
vl_plotframe(feat2_bestglobal(1:2,:),'markers',15);
title(strcat('Epipolar Lines, normalised 8 point RANSAC: Image ',frame2_string) );
hold off 
%% PART 2: Chaining

    
    
    