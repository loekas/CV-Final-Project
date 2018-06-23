%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%% IN4393-16 Computer Vision %%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%% Assignment 5  %%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%% EPIPOLAR GEOMETRY %%%%%%%%%%%%%%%%%%%%
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

%% 1.2 Describing the local appearance of the regions around interest points 
% Display the features using the function provided at: http://www.robots.ox.ac.uk/~vgg/research/affine/det_eval_files/display_features.m
figure()
display_features('obj2_001.haraff', 'obj02_001.png', 0,0);
title('Object 1');

figure()
display_features('obj2_002.haraff', 'obj02_002.png', 0,0);
title('Object 2');

%% 1.3.1 Get a set of supposed matches between region descriptors in each image
% Scale and affine invariant feature detectors. Efficient implementation of
% both detectors and descriptors. Making use of sift feature extractor.

% Run the following command lines:
% ./extract_features.ln -haraff -i obj02_001.png -sift
% This return a file called obj02_001.png.haraff.sift
% ./extract_features.ln -haraff -i obj02_002.png -sift
% This return a file called obj02_002.png.haraff.sift

% The returned files have the following information:
% [x, y, a, b, c, desc] -> x, y = feature locations; a, b, c are parameters
% used in defining an affine region: u,v,a,b,c    in    a(x-u)(x-u)+2b(x-u)(y-v)+c(y-v)(y-v)=1

% Extract information from the files
data1 = importdata('obj02_001.png.haraff.sift',' ', 2); % delimiter is a space and the first two header rows are ommited. Ommited header rows in 'headerdata'
data2 = importdata('obj02_002.png.haraff.sift',' ', 2); 

headerdata1 = data1.textdata;
headerdata2 = data2.textdata;

data1 = data1.data;
data2 = data2.data;

% Organise data for image 1
x1 = data1(:,1)';
y1 = data1(:,2)';
a1 = data1(:,3)';
b1 = data1(:,4)';
c1 = data1(:,5)';
desc1 = data1(:,6:end)';

% Organise data for image 2
x2 = data2(:,1)';
y2 = data2(:,2)';
a2 = data2(:,3)';
b2 = data2(:,4)';
c2 = data2(:,5)';
desc2 = data2(:,6:end)';

% Match descriptors and return matches and scores
[matches, scores] = vl_ubcmatch(desc1,desc2);

[scores_sort, scores_sort_index] = sort(scores, 'ascend');
matches_sort = matches(:,scores_sort_index);

feat1 = [x1; y1];
feat2 = [x2; y2];

feat1_sort = feat1(:,matches_sort(1,:));
feat2_sort = feat2(:,matches_sort(2,:));

percent_keep = 0.50; % Keep this percent of top matches
num_matches = size(matches,2);
keep_till = round(num_matches*percent_keep); % Keep the first "keep_till" columns of the matrices

perm = randperm(keep_till);
seed = perm(1:20);
matches_sel = matches_sort(:,seed); % Select these matches
scores_sel = scores_sort(:,seed); % Select the corresponding scores
feat1_sel = feat1_sort(:,seed); % Select the corresponding features for image 1
feat2_sel = feat2_sort(:,seed); % Select the corresponding features for image 2



% Visualise the kept matches
img1 = imread('obj02_001.png');
img2 = imread('obj02_002.png');
figure()
imshow(cat(2,img1,img2));
Fa = feat1;
Fb = feat2;
xa = Fa(1,matches_sel(1,:)) ;
xb = Fb(1,matches_sel(2,:)) + size(img1,2)  ;
ya = Fa(2,matches_sel(1,:)) ;
yb = Fb(2,matches_sel(2,:)) ;

hold on
h = line([xa ; xb], [ya ; yb]) ;
set(h,'linewidth', 1, 'color', 'b') ;

vl_plotframe(Fa(:,matches_sel(1,:))) ;
Fb(1,:) = Fb(1,:) + size(img1,2) ;
vl_plotframe(Fb(:,matches_sel(2,:))) ;
axis image off ;
title('Visualize kept matches')
hold off


%% PART 2: EIGHT POINT ALGORITHM : FUNDAMENTAL MATRIX ESTIMATION
num_featsel = size(feat1_sel,2);
perm = randperm(num_featsel);
n = 8;
seed = perm(1:n);

feat1_8point = feat1_sel(:,seed);
feat2_8point = feat2_sel(:,seed);
matches_8point = matches_sel(:,seed);
% Visualise the points used for Fundamental matrix creation
img1 = imread('obj02_001.png');
img2 = imread('obj02_002.png');
figure()
imshow(cat(2,img1,img2));
Fa = feat1;
Fb = feat2;
xa = Fa(1,matches_8point(1,:)) ;
xb = Fb(1,matches_8point(2,:)) + size(img1,2)  ;
ya = Fa(2,matches_8point(1,:)) ;
yb = Fb(2,matches_8point(2,:)) ;

hold on
h = line([xa ; xb], [ya ; yb]) ;
set(h,'linewidth', 1, 'color', 'b') ;

vl_plotframe(Fa(:,matches_8point(1,:))) ;
Fb(1,:) = Fb(1,:) + size(img1,2) ;
vl_plotframe(Fb(:,matches_8point(2,:))) ;
axis image off ;
title('Visualize kept matches for Fundamental matrix creation')
hold off


% Estimating the fundamental matrix F
A = [];
for k = 1:n
    A = [A; [ feat1_8point(1,k)*feat2_8point(1,k) feat1_8point(1,k)*feat2_8point(2,k) feat1_8point(1,k) feat1_8point(2,k)*feat2_8point(1,k) feat1_8point(2,k)*feat2_8point(2,k) feat1_8point(2,k) feat2_8point(1,k) feat2_8point(2,k) 1]];
end

[U,D,V] = svd(A); % SVD of A such that UDV' = A

% Entries of F are the components of the column of V corresponding to the
% smallest singular value
F = reshape(V(:,9), 3,3)';

% The above estimated F is almost always non singular ( non singular =
% invertible) Singularity of the matrix is enforced by adjusting the
% entries of estimated F:

[Uf,Df,Vf] = svd(F);
% The smallest singular value in the diagonal matrix Df is set to to zero 
% in order to obtain the corrected  corrected Df. With this the new F
% becomes:
F = Uf*diag([Df(1,1), Df(2,2) 0])*Vf';  % Fundamental matrix

%% PART 3: NORMALIZED EIGHT POINT ALGORITHM
% Problem with 8 point algorithm: Orders of magnitude difference between
% column of data matrix -> least squares yields poor results. Normalised
% LSQ yields good results.
% Careful normalization of the input data leads to enourmous improvement in
% the conditioning of the problem and hence the stability of the result.
% The added complexity necessary for this transformation is insignificant.

%% 3.1 NORMALIZATION
% Approach application of similarity transformation to the set of points
% pi, so that their meain is 0 and the average distance to the mean is
% sqrt(2)

% Feature points to be used are the same as before:
% feat1_8point = feat1_sel(:,seed);
% feat2_8point = feat2_sel(:,seed);

% mean/centroid of x points 
mx1 = mean(feat1_8point(1,:)); % image 1
mx2 = mean(feat2_8point(1,:)); % image 2

% mean/centroid of y points
my1 = mean(feat1_8point(2,:)); % image 1
my2 = mean(feat2_8point(2,:)); % image 2

d1 = mean( sqrt( (feat1_8point(1,:) - mx1).^2 + (feat1_8point(2,:) - my1).^2 ) ); % mean distance from centroid image 1
d2 = mean( sqrt( (feat2_8point(1,:) - mx2).^2 + (feat2_8point(2,:) - my2).^2 ) ); % mean distance from centroid image 2

T1 = [ sqrt(2)/d1 0 -mx1*(sqrt(2))/d1 ; 0 sqrt(2)/d1 -mx1*sqrt(2)/d1; 0 0 1];
T2 = [ sqrt(2)/d2 0 -mx2*(sqrt(2))/d2 ; 0 sqrt(2)/d2 -mx2*sqrt(2)/d2; 0 0 1];

p1_hat =[];
p2_hat = [];
for k = 1:n
    p1_hat = [p1_hat, T1(1:2,:)*[feat1_8point(:,k); 1]]; % normalised feature points image 1
    p2_hat = [p2_hat, T2(1:2,:)*[feat2_8point(:,k); 1]]; % normalised feature points image 2
end

% Visual verification that the transformations are meant to reduce the
% magnitude of feature points only. No effect on the formation
figure()
subplot(1,2,1)
vl_plotframe(p1_hat,'r*');
legend('Transformed','Location','best');
subplot(1,2,2)
vl_plotframe(feat1_8point,'bo');
legend('Original', 'Location', 'best');
a = axes;
t = title('Transformation visualisation, Image 1');
a.Visible = 'off';
t.Visible = 'on';


figure()
subplot(1,2,1)
vl_plotframe(p2_hat,'r*');
legend('Transformed','Location','best');
subplot(1,2,2)
vl_plotframe(feat2_8point,'bo');
legend('Original','Location','best');
a = axes;
t = title('Transformation visualisation, Image 2');
a.Visible = 'off';
t.Visible = 'on';

%% 3.2 FINDING A FUNDAMENTAL MATRIX FOR NORMALIZED EIGHT POINT ALGORITHM
% Same approach as 8 point algorithm, but now with the normalized feature
% points
Anorm = [];

for k = 1:n
    Anorm = [Anorm; [ p2_hat(1,k)*p1_hat(1,k) p2_hat(1,k)*p1_hat(2,k) p2_hat(1,k) p2_hat(2,k)*p1_hat(1,k) p2_hat(2,k)*p1_hat(2,k) p2_hat(2,k) p1_hat(1,k) p1_hat(2,k) 1]];
end

[Un,Dn,Vn] = svd(Anorm); % SVD of A such that UDV' = A

% Entries of F are the components of the column of V corresponding to the
% smallest singular value
Fn = reshape(Vn(:,9), 3,3)';

% The above estimated F is almost always non singular ( non singular =
% invertible) Singularity of the matrix is enforced by adjusting the
% entries of estimated F:

[Unf,Dnf,Vnf] = svd(Fn);
% The smallest singular value in the diagonal matrix Df is set to to zero 
% in order to obtain the corrected  corrected Df. With this the new F
% becomes:
Fn = Unf*diag([Dnf(1,1), Dnf(2,2) 0])*Vnf'; % Normalised Fundamental Matrix

%% 3.3 Denormalization
% Let F = T'*F_hat*T
Fdn = T2'*Fn*T1; % Denormalized Fundamental matrix 

%% INTERMEZZO: VERIFICATION OF DENORMALIZATION WITH THE AID OF EPIPOLAR LINES
% Lines on Image 2, with the aid of lines from image 1
% lines = epipolarLine(F',feat2_8point');
lines = epipolarLine(Fdn',feat2_8point');
points = lineToBorderPoints(lines, size(img1));
figure()
imshow(img1)
hold on 
line(points(:,[1,3])',points(:,[2,4])');
vl_plotframe(feat1_8point,'markers',15);
hold off 
title('Epipolar lines, normalised 8 point algorithm : Image 1');
% Lines on Image 1, with the aid of lines from image 2
% lines = epipolarLine(F,feat1_8point');
lines = epipolarLine(Fdn,feat1_8point');
points = lineToBorderPoints(lines, size(img2));
figure()
imshow(img2)
hold on 
line(points(:,[1,3])',points(:,[2,4])');
vl_plotframe(feat2_8point,'markers',15);
hold off 
title('Epipolar lines, normalised 8 point algorithm : Image 2');


%% 4 NORMALIZED EIGHT POINT ALGORITHM WITH RANSAC
P = 1.0; % Percentage of matches to be used for fundamental matrix generation
no_points = 8; % number of points for the algorithm, for 8 point algorithm with RANSAC we pick 8 points
threshold = 10; % pixel radius threshold for inliers
approach = 'mypoints'; % give in the features, matches and scores
N = 5; % Number of iterations
[F_best, detections] = normalised_8point_ransac( feat1, feat2, matches, scores, img1, img2, N, P, no_points, threshold, approach); % Best fundamental matrix and corresponding inlier detections
