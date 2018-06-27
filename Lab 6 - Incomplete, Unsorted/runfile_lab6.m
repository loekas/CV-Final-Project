%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%% IN4393-16 Computer Vision %%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%% Assignment 6  %%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%% CHAINING %%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%% RUN VERSION 1 %%%%%%%%%%%%%%%%%%%%%%
%%% Author Info: Ali Nawaz, TU Delft, The Netherlands %%%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

close all; clear all; clc; % Clear memory, close previous windows and clear command window

%% PART 1. FUNDAMENTAL MATRIX ESTIMATION

%% 1.1 Detecting interest points in each image 
% Conduct the following prompts in linux terminal to detect the interest
% points in each image
% Binaries accessible at: http://www.robots.ox.ac.uk/~vgg/research/affine/detectors.html#binaries
%  ./h_affine.ln -haraff -i obj02_001.png -o obj2_001.haraff -thres 1000 
%  ./h_affine.ln -haraff -i obj02_002.png -o obj2_002.haraff -thres 1000 

%% Describing a sample local appearance of the regions around interest points 
% Display the features using the function provided at: http://www.robots.ox.ac.uk/~vgg/research/affine/det_eval_files/display_features.m

addpath('TeddyBear/Extraction SIFT descriptors/')
addpath('TeddyBear/Features point detection/')

figure()
display_features('obj02_001.haraff','obj02_001.png',0, 0);
title('Object 1 - Harris Affine')


figure()
display_features('obj02_001.hesaff','obj02_001.png',0, 0);
title('Object 1 - Hessian Affine')

%% 
