function Points = ExtractPixel42(Blocks, inliers_matches, inliers_matched_features_combined)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
no_cons_img = size(Blocks{1},1);

for i = 1:(length(Blocks)-2)
    [~, I_match] = ismember(Blocks{i},inliers_matches{1,i}(1,:));
    I_match(I_match==0) = 1;
    points_x(1,:) = inliers_matched_features_combined{1,i}(1,I_match(1,:));
    points_y(1,:) = inliers_matched_features_combined{1,i}(2,I_match(1,:));
    for j = 1:no_cons_img-1
        [~, I_match] = ismember(Blocks{i},inliers_matches{1,i+j-1}(2,:));
        I_match(I_match==0) = 1;
        points_x(j+1,:) = inliers_matched_features_combined{2,i+j-1}(1,I_match(j+1,:));
        points_y(j+1,:) = inliers_matched_features_combined{2,i+j-1}(2,I_match(j+1,:));
    end
    Points{i} = round([points_x;points_y]);
    clear points_x;clear points_y;
end
% for the 18th index
[~, I_match] = ismember(Blocks{18},inliers_matches{1,18}(1,:));
I_match(I_match==0) = 1;
points_x(1,:) = inliers_matched_features_combined{1,18}(1,I_match(1,:));
points_y(1,:) = inliers_matched_features_combined{1,18}(2,I_match(1,:));

[~, I_match] = ismember(Blocks{18},inliers_matches{1,18}(2,:));
I_match(I_match==0) = 1;
points_x(2,:) = inliers_matched_features_combined{1,18}(1,I_match(2,:));
points_y(2,:) = inliers_matched_features_combined{1,18}(2,I_match(2,:));

[~, I_match] = ismember(Blocks{18},inliers_matches{1,19}(2,:));
I_match(I_match==0) = 1;
points_x(3,:) = inliers_matched_features_combined{1,19}(1,I_match(3,:));
points_y(3,:) = inliers_matched_features_combined{1,19}(2,I_match(3,:));

[~, I_match] = ismember(Blocks{18},inliers_matches{1,1}(2,:));
I_match(I_match==0) = 1;
points_x(4,:) = inliers_matched_features_combined{1,1}(1,I_match(4,:));
points_y(4,:) = inliers_matched_features_combined{1,1}(2,I_match(4,:));

Points{18} = round([points_x;points_y]);
clear points_x;clear points_y;

% for the 19th index
[~, I_match] = ismember(Blocks{19},inliers_matches{1,19}(1,:));
I_match(I_match==0) = 1;
points_x(1,:) = inliers_matched_features_combined{1,19}(1,I_match(1,:));
points_y(1,:) = inliers_matched_features_combined{1,19}(2,I_match(1,:));

[~, I_match] = ismember(Blocks{19},inliers_matches{1,19}(2,:));
I_match(I_match==0) = 1;
points_x(2,:) = inliers_matched_features_combined{1,19}(1,I_match(2,:));
points_y(2,:) = inliers_matched_features_combined{1,19}(2,I_match(2,:));

[~, I_match] = ismember(Blocks{19},inliers_matches{1,1}(2,:));
I_match(I_match==0) = 1;
points_x(3,:) = inliers_matched_features_combined{1,1}(1,I_match(3,:));
points_y(3,:) = inliers_matched_features_combined{1,1}(2,I_match(3,:));

[~, I_match] = ismember(Blocks{19},inliers_matches{1,2}(2,:));
I_match(I_match==0) = 1;
points_x(4,:) = inliers_matched_features_combined{1,2}(1,I_match(4,:));
points_y(4,:) = inliers_matched_features_combined{1,2}(2,I_match(4,:));

Points{19} = ([points_x;points_y]);

end

