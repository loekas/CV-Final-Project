function Points = ExtractPixel(Blocks, inliers_matches, inliers_matched_features)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
no_cons_img = size(Blocks{1},1);

% for each block, compute the measurement matrix
for i = 1:length(Blocks)-no_cons_img+1
    % for each measurement, find the x- and y-coordinates
    for j = 1:no_cons_img
        % find the index of the match in the inliers_matches
        [~,idx_block, idx_match]   = intersect(Blocks{i}(j,:),inliers_matches{i}(j,:));
        points_x(j,:) = inliers_matched_features_combined{1,i}(1,idx_match);
        points_y(j,:) = inliers_matched_features_combined{1,i}(2,idx_match);
    end
end
end

end

