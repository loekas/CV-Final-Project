%%% Final Assignment
clear all;close all;clc;

%% add all paths & folders
addpath('Part 1')
run('../../vl_feat Toolbox/toolbox/vl_setup.m');


%% Part 1: Extracting Harris and Hessian interest points and corresponding SIFT descriptors 
        %% FIRST TIME ONLY
        % Descriptor
% Run the following via linux terminal. More info: http://www.robots.ox.ac.uk/~vgg/research/affine/detectors.html
% Harris affine interest/feature point detection:
% prompt>./h_affine.ln -haraff -i img1.ppm -o img1.haraff -thres 1000
% Hessian affine interest/feature point detection:
% prompt>./h_affine.ln -hesaff -i img1.ppm -o img1.hesaff -thres 500

        % SIFT features
% Run the following via linux terminal. More info: http://www.robots.ox.ac.uk/~vgg/research/affine/detectors.html
% Harris affine SIFT interest/feature point detectors/descriptors
% prompt>./extract_features -haraff -i img.png -thres 1000 -sift
% Hessian affine SIFT interest/feature point detectors/descriptors
% prompt>./extract_features -hesaff -i img.png -thres 500 -sift

% The returned files have the following information:
% [x, y, a, b, c, desc] -> x, y = feature locations; a, b, c are parameters
% used in defining an affine region: u,v,a,b,c    in    a(x-u)(x-u)+2b(x-u)(y-v)+c(y-v)(y-v)=1

%% AFTER FIRST INITIATION
        % load the SIFT Features from the previously constructed files
[feat_haraff_sift, descr_haraff_sift] = features_descriptors('Part 1/Files with new threshold/', '*.haraff.sift');
[feat_hesaff_sift, descr_hesaff_sift] = features_descriptors('Part 1/Files with new threshold/', '*.hesaff.sift');
        
        % %% Generate matches and corresponding featurepoints between consecutive frames, i.e.  Frames 1-2, 2-3 ... 18-19, 19-1
[matched_feature_points_combined, matches, scores] = combine_feature_return_matches(feat_haraff_sift, feat_hesaff_sift, descr_haraff_sift, descr_hesaff_sift);        


%% Part 2: Apply normalized 8-point RANDAC to find best matches
% Set parameters for Normalized 8-point RANSAC
N = 10; % Number of iterations
P = 0.5; % Percentage of matches for Normalised 8 point RANSAC algorithm
no_points = 8;
threshold = 10;
% Ignore points outside these bounds. To avoid missed detections at the box
% corners 
lbx = 800;
ubx = 3200; 

% Do RANSAC
[fundamental_matrices, inliers_matched_features_combined,inliers_matches] = normalised_8point_ransac_multiframes(matched_feature_points_combined, matches, N, P, no_points, threshold, lbx, ubx);

%% Part 3: Apply the chaining method
% find match indices corresponding to the newly found matched features.

point_view_matrix = chain(inliers_matches);



%%
% Visual verfication of the results with the aid of epipolar lines
% Pick two consecutive frames
frame1 = 19;
frame2 = 1;

frame1_string = num2str(frame1+585);
frame2_string = num2str(frame2+585);

% load two selected images
imgc1 = imread(strcat('8ADT8',frame1_string,'.png'));
imgc2 = imread(strcat('8ADT8',frame2_string,'.png'));
% load the corresponding best Fundamental matrix and the inliers selected 
F_best_global = fundamental_matrices{1,frame1};
feat1_bestglobal = inliers_matched_features_combined{1,frame1}{1,1};
feat2_bestglobal = inliers_matched_features_combined{2,frame2}{1,1};

plotmatches(imgc1,imgc2,feat1_bestglobal,feat2_bestglobal,inliers_matches_cells);

lines = epipolarLine(F_best_global',feat2_bestglobal(1:2,:)');
points = lineToBorderPoints(lines, size(imgc1));
figure()
imshow(imgc1)
hold on 
line(points(:,[1,3])',points(:,[2,4])');
vl_plotframe(feat1_bestglobal(1:2,:),'markers',15);
hold off 
title(strcat('Epipolar Lines, normalised 8 point RANSAC: Image ',frame1_string) );

lines = epipolarLine(F_best_global,feat1_bestglobal(1:2,:)');
points = lineToBorderPoints(lines, size(imgc2));
figure()
imshow(imgc2)
hold on 
line(points(:,[1,3])',points(:,[2,4])');
vl_plotframe(feat2_bestglobal(1:2,:),'markers',15);
hold off 
title(strcat('Epipolar Lines, normalised 8 point RANSAC: Image ',frame2_string) );
  