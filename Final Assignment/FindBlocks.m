function Blocks = FindBlocks(point_view_matrix,no_cons_img)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here


%for each image (row), find points. For each point, find number of matches 
for i = 1:size(point_view_matrix,1)-no_cons_img+1
    idx = find(point_view_matrix(i,:) ~= 0 & point_view_matrix(i+no_cons_img-1,:) ~= 0);
    Blocks{i} = point_view_matrix(i:i+no_cons_img-1,idx);
end

% special case for the 
for j = size(point_view_matrix,1)-no_cons_img+2:size(point_view_matrix,1)
    idx = find(point_view_matrix(j,:) ~= 0 & point_view_matrix(j+no_cons_img-1-size(point_view_matrix,1),:) ~= 0);
    Blocks{j} = [point_view_matrix(j:end,idx); point_view_matrix(1:j+no_cons_img-1-size(point_view_matrix,1),idx)];
end
end
