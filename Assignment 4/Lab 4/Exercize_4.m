%% Lab exercize 4

%% setup
addpath('model house');
addpath('code_updated');
run('../../vl_feat Toolbox/toolbox/vl_setup.m');

%% 1.2 Lucas-Kanade Algorithm

im1 = im2double(rgb2gray(imread('sphere1.ppm')));
im2 = im2double(rgb2gray(imread('sphere2.ppm')));
%im1 = im2double(imread('synth1.pgm'));
%im2 = im2double(imread('synth2.pgm'));
sigma   = 25;
demo12();





%% old code
% [F, ind] = opticalflow(im1,im2,sigma);
% 
% % divide image in 15x15 image pathes
% for i = 0:floor(length(im1)/15)-1
%     for j = 0:floor(length(im1)/15)-1
%         % for each region
%         % save the samples in a page
%         index = (i)*13+j+1;
%         v(2,index) = 1+15*i + 7;
%         v(1,index) = 1+15*j + 7;
%         im1_patches(:,:,index) = im1(1+15*i:15*i+15,1+15*j:15*j+15);
%         im2_patches(:,:,index) = im2(1+15*i:15*i+15,1+15*j:15*j+15);
%         
%         %
%         Ix1     = ImageDerivatives(im1_patches(:,:,index), sigma, 'x');        
%         Iy1     = ImageDerivatives(im1_patches(:,:,index), sigma, 'y');
%         It1     = (im1_patches(:,:,index) - im2_patches(:,:,index));
%         A1      = [Ix1(:), Iy1(:)];
%         A2      = A1';
%         b       = -It1(:);
%         
%         v(3:4,index)       = inv(A2*A1)*A2*b;
%     end
% end
% 
% imshow(im2)
% hold on 
% quiver(v(1,:),v(2,:),v(3,:),v(4,:),'filled');
% 


    