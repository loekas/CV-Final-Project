function res = my_laplacian(img,r,c,sigma)
        L = imfilter(img, fspecial('log', ceil(sigma*6+1), sigma), 'replicate', 'same').*sigma.^2;
        B = zeros(size(L));
        B(r,c) = L(r,c);
        res = B;
end
