% Gaussian function
function G = gaussian(sigma)
    res = 0.1; % Filter resolution
    limit = 3; % Confidence interval limit on sigma
    x = -limit*sigma:res:limit*sigma; % x range for Gaussian filter
    G = ( 1/(sigma*(sqrt(2*pi) ))* exp(- (x.^2)/(2*sigma^2) ) ); % Gaussian Filter
end

