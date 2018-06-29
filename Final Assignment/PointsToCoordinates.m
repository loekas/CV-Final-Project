function [M,S] = PointsToCoordinates(Points)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

for i = 1:length(Points)
Points_new = Points{i};
Points_mean = mean(Points_new,2);
Points_norm = Points_new-Points_mean;

% % %singular value decomposition
[U,W,V] = svd(Points_new);

U = U(:,1:3);
W = W(1:3,1:3);
V = V(:,1:3);

M{i} = U*sqrt(W);
S{i} = sqrt(W)*V';
end

end

