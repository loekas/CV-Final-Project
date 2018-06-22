function [magnitude, orientation] = gradmag(img,sigma)
    gx = gaussian(sigma); % Gaussian filter on x
    gy = gaussian(sigma); % Gaussian fitler on y
    
    dgx = gaussianDer(gx,sigma); % Derivative Gaussian filter on x
    dgy = gaussianDer(gy,sigma); % Derivative Gaussian filter on y
    
    imOut = conv2(dgx,dgy,img);
    % Apply cropping on picture
    oldsize = size(img);
    newsize = size(imOut);
    cropout1 = ( newsize(1) - oldsize(1) )/2;
    cropout2 = ( newsize(2) - oldsize(2) )/2;
    imOut = imOut(cropout1:end-(cropout1+1),cropout2:end-(cropout2+1));

    magnitude = abs(imOut);
    orientation = atan(imOut);
%     orientation = pi*sign(imOut);
end

    
    