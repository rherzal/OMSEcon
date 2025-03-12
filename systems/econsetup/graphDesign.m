function L = graphDesign()
%   Adjacency matrix
    B    = [0 1 1 1 1;
            0 0 0 0 1;
            0 1 0 0 0;
            0 0 0 0 0;
            1 0 1 0 0];

    O = zeros(5, 5);
    A = zeros(50, 50);

    A = [B O O O O O O O O O;
         O B O O O O O O O O;
         O O B O O O O O O O;
         O O O B O O O O O O;
         O O O O B O O O O O;
         O O O O O B O O O O;
         O O O O O O B O O O;
         O O O O O O O B O O;
         O O O O O O O O B O;
         O O O O O O O O O B];

    for i = 1:(50-5)
        A(i+5, i) = 1;
        A(i, i+5) = 1;
    end

%     G = digraph(B');
%     plot(G)
% 
%    
% 
%     G = digraph(A');
%     plot(G);

    

    T = 1;
    D = sum(A');
    N = length(D);
    D = diag(D);
    L = D - A;

%     histogram(ones(1, 50) * expm(-L * 100000), 10);

end