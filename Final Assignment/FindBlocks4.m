function Blocks = FindBlocks4(point_view_matrix,no_cons_img)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here


%for each image (row), find points. For each point, find number of matches
for i = 1:16
    idx         = find(point_view_matrix(i,:) ~= 0 & point_view_matrix(i+1,:) ~= 0 & point_view_matrix(i+2,:) ~= 0 & point_view_matrix(i+3,:) ~= 0);
    Blocks{i}   = point_view_matrix(i:i+no_cons_img-1,idx);
end

% special case for the third, second to last and last image
    idx         = find(point_view_matrix(1,:) ~= 0 & point_view_matrix(17,:) ~= 0 & point_view_matrix(18,:) ~= 0 & point_view_matrix(19,:) ~= 0);
    Blocks{17}  = [point_view_matrix(17:19,idx);point_view_matrix(1,idx)];

    idx         = find(point_view_matrix(1,:) ~= 0 & point_view_matrix(2,:) ~= 0 & point_view_matrix(18,:) ~= 0 & point_view_matrix(19,:) ~= 0);
    Blocks{18}  = [point_view_matrix(18:19,idx);point_view_matrix(1:2,idx)];
        
    idx         = find(point_view_matrix(1,:) ~= 0 & point_view_matrix(2,:) ~= 0 & point_view_matrix(3,:) ~= 0 & point_view_matrix(19,:) ~= 0);
    Blocks{19}  = [point_view_matrix(19,idx);point_view_matrix(1:3,idx)];

end