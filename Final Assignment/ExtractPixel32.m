function Points = ExtractPixel32(Blocks,  matches,  matched_features_combined)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
no_cons_img = size(Blocks{1},1);

for i = 1:(length(Blocks)-1)
    [~, I_match] = ismember(Blocks{i}, matches{1,i}(1,:));
    I_match(I_match==0) = 1;
    points_x(1,:) =  matched_features_combined{1,i}(1,I_match(1,:));
    points_y(1,:) =  matched_features_combined{1,i}(2,I_match(1,:));
    for j = 1:no_cons_img-1
        [~, I_match] = ismember(Blocks{i}, matches{1,i+j-1}(2,:));
        I_match(I_match==0) = 1;
        points_x(j+1,:) =  matched_features_combined{2,i+j-1}(1,I_match(j+1,:));
        points_y(j+1,:) =  matched_features_combined{2,i+j-1}(2,I_match(j+1,:));
    end
    Points{i} = round([points_x;points_y]);
    clear points_x;clear points_y;
end

[~, I_match] = ismember(Blocks{19}, matches{1,19}(1,:));
I_match(I_match==0) = 1;
points_x(1,:) =  matched_features_combined{2,19}(1,I_match(1,:));
points_y(1,:) =  matched_features_combined{2,19}(2,I_match(1,:));

[~, I_match] = ismember(Blocks{19}, matches{1,19}(2,:));
I_match(I_match==0) = 1;
points_x(2,:) =  matched_features_combined{2,19}(1,I_match(2,:));
points_y(2,:) =  matched_features_combined{2,19}(2,I_match(2,:));

[~, I_match] = ismember(Blocks{19}, matches{1,1}(2,:));
I_match(I_match==0) = 1;
points_x(3,:) =  matched_features_combined{2,1}(1,I_match(3,:));
points_y(3,:) =  matched_features_combined{2,1}(2,I_match(3,:));


Points{19} = round([points_x;points_y]);

end

