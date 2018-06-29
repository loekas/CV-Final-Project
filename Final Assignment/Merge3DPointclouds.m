function S = Merge3DPointclouds(S3,S4)
%UNTITLED4 Summary of this function goes here

% Match points in 4 point to 3 point views, to find corresponding points
for i = 1:length(S3)
    [~,~,I_3] = intersect(S3{i}',S4{i}(1:3,:)','rows','stable');
    procrustes(S3{i+1},S4{i}(:,I_3));
end

