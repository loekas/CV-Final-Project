function image_stitch(img1, img2, T)
    % Plot actual images
    figure()
    imshow(img1)
    title('Left image');

    figure()
    imshow(img2)
    title('Right image');
    
    % Generate and plot transformed images
    tform1 = maketform('affine',T');
    [image1_transformed, xdata1, ydata1] = imtransform(img1,tform1,'bicubic');
    figure()
    imshow(image1_transformed);
    title('Image 1 transformed to Image 2');


    tform2 = maketform('affine',inv(T)');
    [image2_transformed, xdata2, ydata2] = imtransform(img2, tform2, 'bicubic');
    figure()
    imshow(image2_transformed);
    title('Image 2 transformed to Image 1');

    % Assuming first image has correct orientation
    minRow = round( floor( min(               0 , ydata2(1)  ))); % find total needed dimensions
    minCol = round( floor( min(               0 , xdata2(1)  )));
    maxRow = round( ceil(  max( size(img1,1) , ydata2(2)  )));
    maxCol = round( ceil(  max( size(img1,2) , xdata2(2)  ))); 

    offset1_row = -minRow;
    offset1_col = -minCol;
    offset2_row = round(ydata2(1) - minRow);
    offset2_col = round(xdata2(1) - minCol);

    
    
    if ((maxRow - minRow > 3000) || (maxCol - minCol > 3000))
        fprintf("INFO : image too big, something is wrong with the transformation. terminating.\n");
        return;
    end

    if size(img1,3) ~= 1
        imFinal = zeros( maxRow - minRow , maxCol - minCol, 3); % RGB 
        imFinal(offset2_row+1:offset2_row+size(image2_transformed,1),offset2_col+1:offset2_col+size(image2_transformed,2),:) = image2_transformed(:,:,:); % all three RGB
        imFinal(offset1_row+1:offset1_row+size(img1,1),offset1_col+1:offset1_col+size(img1,2),:) = img1(:,:,:); % all three RGB
    else
        imFinal = zeros( maxRow - minRow , maxCol - minCol, 1); % 1-channel
        imFinal(offset2_row+1:offset2_row+size(image2_transformed,1),offset2_col+1:offset2_col+size(image2_transformed,2),:) = image2_transformed(:,:,:); % 1-channel
        imFinal(offset1_row+1:offset1_row+size(img1,1),offset1_col+1:offset1_col+size(img1,2),:) = img1(:,:,:); % 1-channel
    end
    
    % Plot stitched images
    
    figure();
    imshow(imFinal);
    title('Stitched images')
end
