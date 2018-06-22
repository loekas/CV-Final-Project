function F = ImageDerivatives(img, sigma, type)
    res = 0.01; % Filter resolution
    limit = 3; % Confidence interval limit on sigma
    x = -limit*sigma:res:limit*sigma;
    if strcmp(type,'x')== 1
        gx = -(x./(sigma^2)).*gaussian(sigma); % derivative wrt x
        F = conv2(gx,img);
    elseif strcmp(type,'y') == 1
        gy = -(x./(sigma^2)).*gaussian(sigma); % derivative wrt y
        F = conv2(gx,img);
    elseif strcmp(type,'xx') == 1
        gxx =  ((-sigma^2 + (x.*x) )./(sigma^4) ).*gaussian(sigma); % double derivative wrt x
        F = conv2(gxx,img);
    elseif strcmp(type,'yy') == 1
        gyy =  ((-sigma^2 + (x.*x) )./(sigma^4)).*gaussian(sigma); % double derivative wrt y
        F = conv2(gyy,img);
    elseif strcmp(type,'xy') == 1
        gx = -(x./(sigma^2)).*gaussian(sigma); % derivative wrt x
        gy = -(x./(sigma^2)).*gaussian(sigma); % derivative wrt y
        F = conv2(gx,gy,img);
    else 
        gx = -(x./(sigma^2)).*gaussian(sigma); % derivative wrt x
        gy = -(x./(sigma^2)).*gaussian(sigma); % derivative wrt y
        F= conv2(gy,gx,img);
    end
end
