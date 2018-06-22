function [r, c] = harris(im, sigma)
% inputs: 
% im: double grayscale image
% sigma: integration-scale
% outputs:  The row and column of each point is returned in r and c
% This function finds Harris corners at integration-scale sigma.
% The derivative-scale is chosen automatically as gamma*sigma

gamma = 0.7; % The derivative-scale is gamma times the integration scale

% Calculate Gaussian Derivatives at derivative-scale
% Hint: use your previously implemented function in assignment 1 
Ix =  ImageDerivatives(im, gamma*sigma, 'x');
Iy =  ImageDerivatives(im, gamma*sigma, 'y');
Ixy = ImageDerivatives(im, gamma*sigma, 'xy');
% Allocate an 3-channel image to hold the 3 parameters for each pixel
M = zeros(size(Ix,1), size(Ix,2), 3);   

% Calculate M for each pixel
M(:,:,1) = Ix.*Ix;
M(:,:,2) = Iy.*Iy;
M(:,:,3) = Ix.*Iy;



% Smooth M with a gaussian at the integration scale sigma.
M = imfilter(M, fspecial('gaussian', ceil(sigma*6+1), sigma), 'replicate', 'same');

% Compute the cornerness R
k = 0.05; % Empirical constant between 0.04 and 0.06

Mc = {};
traceM = [];
detM = [];
R = [];
% scan through all rows
for r = 1:length(M(:,1,1))
    %scan through all columns
    for c = 1:length(M(r,:,1))
        Mc(r,c) = {[M(r,c,1) M(r,c,3); M(r,c,3) M(r,c,2)]};
        traceM(r,c) = trace([M(r,c,1) M(r,c,3); M(r,c,3) M(r,c,2)]);
        detM(r,c) = det([M(r,c,1) M(r,c,3); M(r,c,3) M(r,c,2)]);
        R(r,c) = abs(detM(r,c) - k.*traceM(r,c).^2);
    end
end

% Set the threshold 
threshold = 0.05;

% Find local maxima
% Dilation will alter every pixel except local maxima in a 3x3 square area.
% Also checks if R is above threshold
R = ((R>threshold) & ((imdilate(R, strel('square', 3))==R))) ; %.* sigma;

% Display corners
% figure
% imshow(R,[]);

% Return the coordinates
[r,c] = find(R ==1);

end

