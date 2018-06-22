function Gd = gaussianDer(G,sigma)
    res = 0.01; % Filter resolution
    limit = 3; % Confidence interval limit on sigma
    x = -limit*sigma:res:limit*sigma;
%   G = ( 1/(sigma*(sqrt(2*pi) ))* exp(- (x.^2)/(2*sigma^2) ) );
    Gd = -(x./(sigma^2)).*gaussian(sigma);
%     Gd = -(x./(sigma^2)).*G; % Gaussian derivative filter
end