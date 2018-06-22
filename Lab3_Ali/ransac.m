function [T_best, detections] = ransac(img1, img2, P, no_points,threshold) 
    %# INPUT PARAMETERS:
    % * P =  percentage of matches to pick for seeding
    % * no_points = number of matches to solve and affine transformation.
    % Each match = 2 equations, 6 unknowns. Minimum of 3 matches =
    % no_points.
    % * threshold =  in pixels; Number of transformed pairs that lie
    % within 10 pixels of their actual detected pairs.
    %# OUTPUT PARAMETERS:
    % * T_best = Best transformation matrix in terms of highest number of
    %   inliers detected
    % * detections = number of inliers
    
    [feat1, desc1] = vl_sift(img1); % generate features and descriptors from the first image
    [feat2, desc2] = vl_sift(img2); % generate features and descriptors from the second image

    % Each column of the feature frame in the above has the format [X;Y;S;TH], where X,Y is the (fractional) center of the frame, S is the scale and TH is the orientation (in radians).
    [matches, scores] = vl_ubcmatch(desc1, desc2); % find matches and scores for the obtained descriptors
    
    num_matches = size(matches,2);
    perm = randperm(num_matches); % generates randomly sorted numbers between 1 and num_matches
    
    
    seed = perm(1:round(P*num_matches)); % pick only P percentage of the matches for generating transformation matrix.
    num_seed = size(seed,2);
    % no_point < 3, singularities in matrix. More unknowns than equations.
    if no_points<3
       fprintf("ERROR: Please include at least three number of points (no_points)");
       return;
    end
    
    % Select the seeded features and descriptors
    feat1_seed = feat1(:,matches(1,seed));
    feat2_seed = feat2(:,matches(2,seed));
    
    %% Scan through the collection of points for to generate a collection of
    % transformation matrices
    % Initialising number of inliers 
    number_inliers = 0;
    detections =0;
    count = 0;
    for j = 1:no_points:num_seed
        
        % For each of the sampled collection of points generate model
        % parameters using samples.
        A = []; % constructed with x and y from feat 1
        b = []; % constructed with x' and y' from feat 2
        if (j+ no_points -1) > num_seed
            break;
        end
        
        for k = j: (j+ no_points -1)
            A = [A ; [feat1_seed(1,k) feat1_seed(2,k) 0 0 1 0; 0 0  feat1_seed(1,k) feat1_seed(2,k) 0 1 ]];
            b = [b; [ feat2_seed(1,k) ; feat2_seed(2,k)]];
        end
            
                
        % Tranformation matrix parameters x = [m1 m2 m3 m4 t1 t2]'
        x = pinv(A)*b;
        T = [x(1) x(2) x(5); x(3) x(4) x(6); 0 0 1];
        
        % Transformation matrix in 2x2 matrix representation.  [x',; y'] =
        % T2dA*[x; y] + T2db
        T2dA = [ x(1) x(2); x(3) x(4)];
        T2db = [ x(5); x(6) ];
        
        % Transform all match points T ( Stands for Total, != transformation matrix) in image 1
        
        feat1_before = feat1(1:2, matches(1,:)); % Feat1 before transformation
        feat2_target = feat2(1:2, matches(2,:)); % Feat2 actual detected points
        feat2_trans = []; % Feat2 obtained by transforming Feat 1
        
        for k = 1:num_matches
            feat2_trans = [feat2_trans , T2dA*[feat1_before(1,k) ; feat1_before(2,k)] + T2db ];
        end
        
        inliers = find( sqrt( sum( (feat2_trans - feat2_target).^2)) );
        number_inliers = size(inliers,2);
        
        if number_inliers> detections
            T_best = T;
            inliers_best = inliers;
            number_inliers_best = number_inliers;
            detections = number_inliers_best;
            count = count + 1
        end
            
        end
        
    end
    
        