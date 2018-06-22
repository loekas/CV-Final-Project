function Gd = gaussianDer(G, sigma)
x = -3*sigma:0.1:3*sigma;
Gd = - x./(sigma^2).*G;
end