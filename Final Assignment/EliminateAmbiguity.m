function [M, S] = EliminateAmbiguity(M,S)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
A   = M;
save('M','M')
L0  = inv(A'*A);

% Solve for L
L = lsqnonlin(@myfun,L0);

% Recover C    
    C = chol(L,'lower');
    % Update M and S
    M = M*C;
    S = pinv(C)*S;
end

