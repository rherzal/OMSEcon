function L = graphDesign()
%   Adjacency matrix
    A = [0 1 0 0 1;
         0 0 1 0 0;
         1 1 0 0 1;
         1 1 1 0 0;
         1 0 1 1 0];
%     A = [0 1 0 0 0;
%          1 0 0 0 0;
%          1 1 0 0 0;
%          1 1 0 0 0;
%          1 1 0 0 0];

    T = 1;
    D = sum(A');
    N = length(D);
    D = diag(D);
    L = D - A;
end