function F = ImageDerivatives(img, sigma, type)
    res = 0.1; % Filter resolution
    limit = 3; % Confidence interval limit on sigma
    x = -limit*sigma:res:limit*sigma;
%       x = sigma.^[0:12];
%       sigma = 1.2;
    if strcmp(type,'x')== 1
        gx = -(x./(sigma^2)).*gaussian(sigma); % derivative wrt x
        F = conv2(img,gx,'same');
%         F = conv2(img,gx);
    elseif strcmp(type,'y') == 1
        gy = -(x./(sigma^2)).*gaussian(sigma); % derivative wrt y
%         F = conv2(gy,img);
%         F = [conv2(gy,img')]';
        F = conv2(img,gy','same');
    elseif strcmp(type,'xx') == 1
        gxx =  ((-sigma^2 + (x.*x) )./(sigma^4) ).*gaussian(sigma); % double derivative wrt x
%         F = conv2(gxx,img);
        F = conv2(img,gxx);
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
    % Apply cropping on picture
    oldsize = size(img);
    newsize = size(F);
    cropout1 = floor( ( newsize(1) - oldsize(1) )/2 );
    cropout2 = floor( ( newsize(2) - oldsize(2) )/2);
    F = F(cropout1 + 1:end - cropout1, cropout2 + 1:end - cropout2);
end
