function S = Merge3DPointclouds(S3,S4)
%UNTITLED4 Summary of this function goes here

% Match points in 4 point to 3 point views, to find corresponding points
for i = length(S3):-1:2
    % find points in 3-view in next image to correspond with the current
    % 4-view
    points_new = S3{i}(:,1:length(S4{i}));
    [~,C,T] = procrustes(S4{i}',points_new');
    S3{i-1}  =  [S3{i-1}, (T.b*S3{i}'*T.T+T.c(1,:))'];  
end

S = S3{1};
end

