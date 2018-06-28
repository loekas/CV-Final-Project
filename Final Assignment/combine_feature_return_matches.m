function [matched_features_combined, matches, scores] = combine_feature_return_matches(feat_haraff_sift, feat_hesaff_sift, descr_haraff_sift, descr_hesaff_sift)
% # INPUT PARAMETERS:
% * feat_haraff_sift = feature obtainined with strategy one: in this case
% Harris affine SIFT features. Could be other feature as well. Format is 
% cells, with each cell containing features for each image. 
% * feat_hesaff_sift = feature obtained with strategy two: in this case
% Hessain affine SIFT features. Could be other features as well. Format is
% cells, with each cell containing features for each image.
% * descr_haraff_sift = descriptors for Hariss affine SIFT features. Format 
% is cell, with each cell containing descriptors of an image.
% * descr_hesaff_sift = descriptors for Hessian affine SIFT features.
% Format is cell, with each cell containing descriptors of an image.
% # OUTPUT PARAMETERS:
% * matched_features_combined = matched feature, combining both the feature
% types.
% * matches = indices of the matches for consecutive frames e.g. for 16
% images: Frames 1-2, 2-3, 3-4 ... 15-16, 16-1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Script Author: Ali Nawaz & Lucas Pijnacker Hordijk, Delft University of Technology.
% Aerospace Engineering Faculty [LR]
% Mechanical, Maritime and Materials Engineering Faculty [3ME]
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % Combining different features and descriptors
    feat_comb = {}; % initialize combined features for each image
    desc_comb = {}; % initialize combined descriptors for each image
    
    for k = 1:length(feat_haraff_sift)
        feat_comb(1,k) = {[ cell2mat(feat_haraff_sift(1,k)), cell2mat(feat_hesaff_sift(1,k)) ]}; % combined feature types for all images
        descr_comb(1,k) = {[cell2mat(descr_haraff_sift(1,k)), cell2mat(descr_hesaff_sift(1,k)) ]}; % combined descriptor types for all images
    end
    
    matches = {}; % intialise the matches between consecutive keyframes. 
    scores = {};
    
    for k = 1:length(feat_comb)
        if k == length(feat_comb)
            [matches_buf, scores_buf] = vl_ubcmatch(cell2mat(descr_comb(1,k)), cell2mat(descr_comb(1,1)) ); % For the last frame compare the matches with the first frame
        else 
            [matches_buf, scores_buf] = vl_ubcmatch(cell2mat(descr_comb(1,k)), cell2mat(descr_comb(1,k +1)) ); % For the rest frames compare the current frame with the next frame
        end
        matches(1,k) = {matches_buf};
        score(1,k) = {scores_buf};
    end
    %%
    matched_features_combined = {}; % initialise matched features between keyframes
    
    for k = 1:length(matches)
        % For the last keyframe extract matches features between image 16
        % and image 1, otherwise extract matches features between
        % consecutive images.
        if k == length(matches)
            feat1 = cell2mat(feat_comb(1,k));
            feat2 = cell2mat(feat_comb(1,1));
            matches_buf = cell2mat(matches(1,k));
            feat1 = feat1(:,matches_buf(1,:));
            feat2 = feat2(:,matches_buf(2,:));
            matched_features_combined(1:2,k) = {feat1;feat2};
        else
            feat1 = cell2mat(feat_comb(1,k));
            feat2 = cell2mat(feat_comb(1,k+1));
            matches_buf = cell2mat(matches(1,k));
            feat1 = feat1(:,matches_buf(1,:));
            feat2 = feat2(:,matches_buf(2,:));
            matched_features_combined(1:2,k) = {feat1;feat2};
        end
    end
end