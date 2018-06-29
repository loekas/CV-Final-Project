function [fundamental_matrices, inliers_matched_features_combined,inliers_matches] = normalised_8point_ransac_multiframes(matched_features_combined, matches_cells, N, P, no_points, threshold,lbx, ubx)
    % # INPUT PARAMETERS
    % * matched_features_combined = cell containined the matched features.
    % The cells should be of dimensions 2xframes. 2 rows of cells for each
    % frame. 
    % * matches_cells = matches between consecutive frames
    % * N = no of iterations
    % * P =  percentage of matches to pick for seeding
    % * no_points = number of matches to solve and affine transformation.
    % * threshold = pixel threshold for inliers selectionNumber of 
    %   transformed pairs that lie within 10 pixels of their actual 
    %   detected pairs.
    % # OUTPUT PARAMETERS
    % * fundamental_matrices = fundamental matrices in cells, in terms of
    %   highest number of inliers detected.
    % * inliers_matched_features_combined = Selected feature matches with
    %   inliers. 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Script Author: Ali Nawaz & Lucas Pijnacker Hordijk, Delft University of Technology.
    % Aerospace Engineering Faculty [LR]
    % Mechanical, Maritime and Materials Engineering Faculty [3ME]
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    inliers_matched_features_combined = {};
    fundamental_matrices = {};
    for kk = 1:length(matches_cells)
        feat1 = matched_features_combined{1,kk};
        feat2 = matched_features_combined{2,kk};
        matches = matches_cells{1,kk};
        inliers_global = 0;
        % Throw away points in the background. Keep all the matches in the
        % x range [lbx, ubx]
        I = find( feat1(1,:) > lbx & feat1(1,:)< ubx & feat2(1,:) > lbx & feat2(1,:)< ubx );
        feat1 = feat1( 1:2, I );
        feat2 = feat2( 1:2, I );

        iter = 0; 
        detections_global = 0;
        while iter < N

            %% Now seeding is done to randomly pick P percentage of matched feature points. Note no sorting is applied here.
            num_matches = size(feat1,2); % number of matches
            perm = randperm(num_matches); % generates randomly sorted numbers between 1 and num_matches


            seed = perm(1:round(P*num_matches)); % pick only P percentage of the matches for generating fundamental matrix.
            num_seed = size(seed,2); % number of seeded matches

%             matches_seed = matches(:,seed); % select the seeded matches
% 
%             % Select the seeded features
%             feat1_seed = feat1(1:2,matches(1,seed));
%             feat2_seed = feat2(1:2,matches(2,seed));

            % Select the seeded features
            feat1_seed = feat1(1:2,seed);
            feat2_seed = feat2(1:2,seed);

            % no_point < 8, singularities in matrix. More unknowns than equations.
            if no_points < 8
               fprintf("ERROR: Please include at least eight number of points (no_points)");
               return;
            end

            %% Scan through the collection of points to generate a collection of fundamental matrices
            % Initialising number of inliers 
            number_inliers = 0;
            detections = 0;
            count = 0;

            % Scanning through segments of no_points to generate Fundamental matrix
            % with RANSAC
            for j = 1:no_points:num_seed

                if (j+ no_points -1) > num_seed
                    break;
                end

                % Generate feature points
                feat1_8point = feat1_seed(:,j:(j+ no_points -1));
                feat2_8point = feat2_seed(:,j:(j+ no_points -1));

                %% Normalization
                % Approach application of similarity transformation to the set of points
                % pi, so that their meain is 0 and the average distance to the mean is
                % sqrt(2)

                % mean/centroid of x points 
                mx1 = mean(feat1_8point(1,:)); % image 1
                mx2 = mean(feat2_8point(1,:)); % image 2

                % mean/centroid of y points
                my1 = mean(feat1_8point(2,:)); % image 1
                my2 = mean(feat2_8point(2,:)); % image 2

                d1 = mean( sqrt( (feat1_8point(1,:) - mx1).^2 + (feat1_8point(2,:) - my1).^2 ) ); % mean distance from centroid image 1
                d2 = mean( sqrt( (feat2_8point(1,:) - mx2).^2 + (feat2_8point(2,:) - my2).^2 ) ); % mean distance from centroid image 2

                T1 = [ sqrt(2)/d1 0 -mx1*(sqrt(2))/d1 ; 0 sqrt(2)/d1 -mx1*sqrt(2)/d1; 0 0 1]; % Transformation matrix 1
                T2 = [ sqrt(2)/d2 0 -mx2*(sqrt(2))/d2 ; 0 sqrt(2)/d2 -mx2*sqrt(2)/d2; 0 0 1]; % Transformation matrix 2

                % normalising the feature points
                p1_hat =[];
                p2_hat = [];    
                for k = 1:no_points
                    p1_hat = [p1_hat, T1(1:2,:)*[feat1_8point(:,k); 1]]; % normalised feature points image 1
                    p2_hat = [p2_hat, T2(1:2,:)*[feat2_8point(:,k); 1]]; % normalised feature points image 2
                end


                %% FINDING A FUNDAMENTAL MATRIX FOR NORMALIZED EIGHT POINT ALGORITHM
                % Same approach as 8 point algorithm, but now with the normalized feature points

                Anorm = [];

                for k = 1:no_points
                    Anorm = [Anorm; [ p2_hat(1,k)*p1_hat(1,k) p2_hat(1,k)*p1_hat(2,k) p2_hat(1,k) p2_hat(2,k)*p1_hat(1,k) p2_hat(2,k)*p1_hat(2,k) p2_hat(2,k) p1_hat(1,k) p1_hat(2,k) 1]];
                end

                [Un,Dn,Vn] = svd(Anorm); % SVD of A such that UDV' = A

                % Entries of F are the components of the column of V corresponding to the
                % smallest singular value
                Fn = reshape(Vn(:,9), 3,3)';

                % The above estimated F is almost always non singular ( non singular =
                % invertible) Singularity of the matrix is enforced by adjusting the
                % entries of estimated F:

                [Unf,Dnf,Vnf] = svd(Fn);
                % The smallest singular value in the diagonal matrix Df is set to to zero 
                % in order to obtain the corrected  corrected Df. With this the new F
                % becomes:
                Fn = Unf*diag([Dnf(1,1), Dnf(2,2) 0])*Vnf'; % Normalized Fundamental Matrix

                %% DENORMALIZATION
                % Let F = T'*F_hat*T
                Fdn = T2'*Fn*T1;

                % Finding the p1_hat and p2_hat equivalent for other
                % correspondences to check for the inliers
                feat1_hat = [];
                feat2_hat = [];
                for k = 1:num_seed
                    feat1_hat = [feat1_hat, T1*[feat1_seed(:,k); 1]]; % normalised feature points image 1
                    feat2_hat = [feat2_hat, T2*[feat2_seed(:,k); 1]]; % normalised feature points image 2
                end

                % SAMPSON DISTANCE ESTIMATION FOR INLIER DETECTION
                dnumerator = diag( [feat2_hat]'*Fdn*[feat1_hat])'.^2;
                Fx1 = Fdn*[feat1_hat];
                Fx2 = Fdn'*[feat2_hat];
                d = dnumerator ./ ( Fx1(1,:).^2 + Fx1(2,:).^2 + Fx2(1,:).^2 + Fx2(2,:).^2);

                inliers = find(abs(d)<threshold);
                number_inliers = size(inliers,2);

                % PICK THE BEST FUNDAMENAL MATRIX
                if number_inliers > detections
                    F_best = Fdn;
                    detections = number_inliers;
                    feat1_best = feat1_seed(:,inliers);
                    inliers_best = inliers;
                    feat2_best = feat2_seed(:,inliers);
                end

            end
            if detections > detections_global
                F_best_global = F_best;
                detections_global = detections;
                feat1_bestglobal = feat1_best;
                feat2_bestglobal = feat2_best;
                inliers_global = inliers_best;
            end
            iter = iter + 1;
            if detections_global == 0 && iter == N
                iter = 1;  
                disp('first set of iterations not sufficient, trying another set')
            end
        end
        inliers_matched_features_combined(1:2,kk) = {feat1_bestglobal;feat2_bestglobal};
        fundamental_matrices(1,kk) = {[F_best_global]};        
        
        %find the indices of the matched features
        inliers_matches{kk} = matches(:,sort(seed(inliers_global))); 
    end
        
end
