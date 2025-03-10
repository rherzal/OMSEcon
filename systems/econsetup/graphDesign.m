function [L, q, rho] = graphDesign()
%   Adjacency matrix
%     A = [0 1 0 0 1;
%          0 0 1 0 0;
%          1 1 0 0 1;
%          1 1 1 0 0;
%          1 0 1 1 0];
    A = [0 1 0 0 0;
         1 0 0 0 0;
         1 1 0 0 0;
         1 1 0 0 0;
         1 1 0 0 0];
%   Discrete Time Interval
    T = 1;
%   
    D = sum(A');
    N = length(D);
    D = diag(D);
%   Laplacian Matrix
    L = D - A;
    
    [qs, es] = eigs(L');
    q = (qs(:, 1))/ sum(qs(:, 1));
    J = ones(N, 1) * q';

    G = -(L+J)^(-1) * (expm(-T*(L+J)) - diag(ones(N,1))) - J * (exp(-T) - T - 1);
    rho = ones(1,N) * G;
end