%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%% IN4393-16 Computer Vision %%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%% FINAL ASSIGNMENT  %%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%% CHAINING %%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%% RUN VERSION 1 %%%%%%%%%%%%%%%%%%%%%%
%%% Author Info: Ali Nawaz, TU Delft, The Netherlands %%%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

close all; clear all; clc; % Clear memory, close previous windows and clear command window
addpath('Extraction SIFT descriptors/')
addpath('Feature point detection/')
addpath('PNG image files/')
figure()
display_features('8ADT8604.haraff','8ADT8604.png',0, 0);

figure()
display_features('8ADT8604.hesaff','8ADT8604.png',0, 0);