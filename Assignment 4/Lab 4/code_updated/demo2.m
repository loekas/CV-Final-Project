%function demo3(tracked)
%A demo of the structure from motion that shows the 3d structure of the
%points in the space. Either from the original points or the tracked points
%INPUT
%- tracked: boolean that states whether to use the tracked points
%           if set to true the tracked points will be used otherwise
%           the ground truth is used. (default = false)
%
%OUTPUT
% an image showing the points in their estimated 3-dimensional position,
% where the yellow dots are the ground truth and the pink dots the tracked
% points from the LKtracker
%- M: The transformation matrix size of 2nx3. Where n is the number of 
%     cameras i.e. images.
%- S: The estimated 3-dimensional locations of the points (3x#points)
function [M,S] = demo2
close all

% % %load points
Points = textread('model house\measurement_matrix.txt');
% % %Shift the mean of the points to zero using "repmat" command
% compute mean of points
Points_mean = mean(Points,2);
Points_norm = Points-Points_mean;
Points_x = Points(1:2:end,:);
Points_y = Points(2:2:end,:);

Points_new = [Points_x;Points_y];

% % %singular value decomposition
[U,W,V] = svd(Points_new);

U = U(:,1:3);
W = W(1:3,1:3);
V = V(:,1:3);

M = U*sqrt(W);
S = sqrt(W)*V';

save('M','M')

% % %solve for affine ambiguity
A   = M;
L0  = inv(A'*A);
L1  = eye(3);
% Solve for L
L = lsqnonlin(@myfun,L0);
L2 = lsqnonlin(@myfun,L1);
% Recover C
C = chol(L,'lower');
% Update M and S
M = M*C;


S = pinv(C)*S;

plot3(S(1,:),S(2,:),S(3,:),'.b');

%% For the tracked points with LKtracker
% % Repeat the same procedure 

Points = zeros(size(Points));

load('Xpoints')
load('Ypoints')

Points = [pointsx;pointsy];


%Shift the mean of the points to zero
Points_mean1 = mean(Points,2);
Points_norm1 = Points-Points_mean1;

 
%singular value decomposition
[U,W,V] = svd(Points_norm1);

U = U(:,1:3);
W = W(1:3,1:3);
V = V(:,1:3);

M = U*sqrtm(W);
S = sqrtm(W)*V';


%solve for affine ambiguity using non-linear least squares
A   = M;
L0  = inv(A'*A);

L = lsqnonlin(@myfun,L0);

C = chol(L,'lower');
M = M*C;
S = pinv(C)*S;

hold on
plot3(S(1,:),S(2,:),-S(3,:),'.m');

end
