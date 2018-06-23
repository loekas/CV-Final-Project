%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%% IN4393-16 Computer Vision %%%%%%%%%%%%%%%%
%%%%%%%%%%%%%% Assignment 2 - Week 4.6 %%%%%%%%%%%%%%%%%%%
%%%%%%% Haris Corner Detector and SIFT Descriptor %%%%%%%%
%%%%%%%%%%%%%%%%%%%%% RUN VERSION 1 %%%%%%%%%%%%%%%%%%%%%%
%%% Author Info: Ali Nawaz, TU Delft, The Netherlands %%%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
close all; clear all; clc; % Clear memory, close previous windows and clear command window
% Haris corner detector
sigma = 1.2.^[0:12]; % Sigma range for scale invariant Haris Corner Detector
% Compute the entries of the structure tensor matrix
% ^ Used to form the 'cornerness' (R)

%% Image 1
% im1 = im2double(rgb2gray(imread('landscape-a.jpg')));
% imrgb1 = im2double(imread('landscape-a.jpg'));
im1 = im2double(rgb2gray(imread('im1.jpg')));

laplace_list = [];  % Store Laplacian values for the detected Harris feature keypoints
keypoint_rows = []; % Find feature keypoint rows
keypoint_cols = []; % Find feature keypoint columns
for sc = 1:length(sigma)
    [r,c] = harris(im1,sigma(sc)); % Generate rows and columns of harris feature points
    keypoint_rows = [keypoint_rows r']; % Feature keypoint rows
    keypoint_cols = [ keypoint_cols c']; % Feature keypoint columns
% % Show figure for the detected features on the picture
%     figure() 
%     imshow(imrgb1);
%     hold on
%     plot(c,r,'r*');
%     hold off
    laplace_list(:,:,sc) = my_laplacian(im1,r,c,sigma(sc)); % Laplacian of the detected harris points
end

sigma_max = []; % Sigma value for maximum Laplacian of a given pixel
sigma_min = []; % Sigma value for minimum Lapalcian of a given pixel

for rc = 1:length(laplace_list(:,1,1))
    for colc = 1:length(laplace_list(1,:,1))
        max_laplace = max(laplace_list(rc,colc,:)); % Pick the maximum value of Laplacian
        min_laplace = min( laplace_list(rc,colc,:)); % Pick the minimum value of Lapalcian     
        sigma_max(rc,colc) = sigma(find(laplace_list(rc,colc,:)== max_laplace,1)); % Store the value of sigma for max Laplacian value
        sigma_min(rc,colc) = sigma(find(laplace_list(rc,colc,:)== min_laplace,1)); % Store the value of sigma for min Laplacian value
    end
end

keypoint_sigmas = []; % For all the keypoints, generate the corresponding sigma value with max Laplacian
for k = 1:length(keypoint_rows)
    keypoint_sigmas = [keypoint_sigmas sigma_max(keypoint_rows(k),keypoint_cols(k))]; 
end
% Remove repititions
% unorganised_data = [keypoint_rows; keypoint_cols; keypoint_sigmas]';
% organised_data = unique(unorganised_data,'rows')';
[F1, D1] = vl_sift(single(im1),'frames',[ keypoint_cols;keypoint_rows; 2*keypoint_sigmas+1;zeros(size(keypoint_cols))],'orientations');

%% IMAGE 2
% im2 = im2double(rgb2gray(imread('landscape-b.jpg')));
% imrgb2 = im2double(imread('landscape-b.jpg'));
im2 = im2double(rgb2gray(imread('im2.jpg')));

laplace_list = []; % Store Laplacian values for the detected Harris feature keypoints
keypoint_rows = [];% Find feature keypoint rows
keypoint_cols = [];% Find feature keypoint columns
for sc = 1:length(sigma)
    [r,c] = harris(im2,sigma(sc)); % Generate rows and columns of harris feature points
    keypoint_rows = [keypoint_rows r']; % Feature keypoint rows
    keypoint_cols = [ keypoint_cols c']; % Feature keypoint columns
%     figure()
%     subplot(3,2,sc)
%     imshow(imrgb2);
%     hold on
%     plot(c,r,'r*');
%     hold off
    laplace_list(:,:,sc) = my_laplacian(im2,r,c,sigma(sc)); % Laplacian of the detected harris points
end

sigma_max = []; % Sigma value for maximum Laplacian of a given pixel
sigma_min = []; % Sigma value for minimum Lapalcian of a given pixel

for rc = 1:length(laplace_list(:,1,1))
    for colc = 1:length(laplace_list(1,:,1))
        max_laplace = max(laplace_list(rc,colc,:)); % Pick the maximum value of Laplacian
        min_laplace = min( laplace_list(rc,colc,:)); % Pick the minimum value of Lapalcian     
        sigma_max(rc,colc) = sigma(find(laplace_list(rc,colc,:)== max_laplace,1)); % Store the value of sigma for max Laplacian value
        sigma_min(rc,colc) = sigma(find(laplace_list(rc,colc,:)== min_laplace,1)); % Store the value of sigma for min Laplacian value
    end
end

keypoint_sigmas = []; % For all the keypoints, generate the corresponding sigma value with max Laplacian
for k = 1:length(keypoint_rows)
    keypoint_sigmas = [keypoint_sigmas sigma_max(keypoint_rows(k),keypoint_cols(k))]; 
end
% Remove repititions
% unorganised_data = [keypoint_rows; keypoint_cols; keypoint_sigmas]';
% organised_data = unique(unorganised_data,'rows')';
[F2, D2] = vl_sift(single(im2),'frames',[keypoint_cols;keypoint_rows; 2*keypoint_sigmas+1;zeros(size(keypoint_cols))],'orientations');

%% MATCHES
[matches,scores]= vl_ubcmatch(D1,D2); % find matches and scores for the obtained descriptors
%% PLOT IMAGE WITH COMMON FIGURE

ima = im1; % Image 1
imb = im2; % Image 2

figure()
imshow(cat(2,ima,imb));
Fa = F1;
Fb = F2;
xa = Fa(1,matches(1,:)) ;
xb = Fb(1,matches(2,:)) + size(ima,2)  ;
ya = Fa(2,matches(1,:)) ;
yb = Fb(2,matches(2,:)) ;

hold on
h = line([xa ; xb], [ya ; yb]) ;
set(h,'linewidth', 1, 'color', 'b') ;

vl_plotframe(Fa(:,matches(1,:))) ;
Fb(1,:) = Fb(1,:) + size(ima,2) ;
vl_plotframe(Fb(:,matches(2,:))) ;
axis image off ;
title('Estimated results')
hold off

%% Alternative plotting option
figure()
plotmatches(im1,im2,F1,F2,matches)
title('Estimated results - plot style similar to verification plot')

%% Matlab Auto implementation

[fa, da] = vl_sift(single(im1));
[fb, db] = vl_sift(single(im2));
[mat, sco] = vl_ubcmatch(da, db);

figure()
plotmatches(im1,im2,fa,fb,mat)
title('Verification plot');


