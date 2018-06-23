function imOut = gaussianConv(image_path,sigma_x, sigma_y)
    gx = gaussian(sigma_x); % Generate Gaussian filter for x
    gy = gaussian(sigma_y); % Generate Gaussian filter for y
    % two dimensional convolution 
    imOut = conv2(gy,gx,image_path); % 1: convolve with y, 2: convolve with x 
    % Apply cropping on picture
    oldsize = size(image_path);
    newsize = size(imOut);
    cropout1 = ( newsize(1) - oldsize(1) )/2;
    cropout2 = ( newsize(2) - oldsize(2) )/2;
    imOut = imOut(cropout1:end-(cropout1+1),cropout2:end-(cropout2+1));
end
