function point_view_matrix = chain(inlier_matches)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
no_img = length(inlier_matches);

% Create the Point view matrix using the first two images
point_view_matrix = inlier_matches{1};

% Loop over the different views and add new matches for all images
for k = 2:no_img
    % load new matches
    new_layer   = inlier_matches{k};
    
    % find correspondences and differences
    [~,IA, IB]   = intersect(new_layer(1,:),point_view_matrix(k,:));
    [~,Diff]     = setdiff(new_layer(1,:),point_view_matrix(k,:));
    
    % add matches to Point View Matrix
    point_view_matrix(k+1,IB) = new_layer(2,IA);
    
    % for new matches, add a new column and fill it with the values
    point_view_matrix = [point_view_matrix, zeros(k+1,length(Diff))];
    point_view_matrix(k:k+1,length(point_view_matrix)-length(Diff)+1:length(point_view_matrix)) = new_layer(:,Diff);    
end

% For the last image, check whether it has matches with the first image and
% move the columns correspoding to that to the row of the first image
[~,I_last, I_first]   = intersect(point_view_matrix(no_img+1,:),point_view_matrix(1,:));
point_view_matrix(:,I_first(2:end)) = max(point_view_matrix(:,I_first(2:end)),point_view_matrix(:,I_last(2:end)));
% 
point_view_matrix(:,I_last(2:end)) = [];
point_view_matrix(no_img+1,:) = [];

end

