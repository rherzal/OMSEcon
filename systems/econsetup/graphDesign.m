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

% N = 15; 
% A = zeros(N, N);
% links = [5 6; 6 5; 6 11; 7 5; 7 10; 8 6; 8 9; 9 6; 9 2; 10 7; 10 13; 1 6; 1 7; 1 3; 11 6; 11 8; 11 14;
%     12 6; 12 8; 12 15; 2 9; 2 4; 13 9; 3 1; 3 2; 4 1; 14 6; 14 12; 15 6; 15 12; 7 12; 12 7; 5 1; 1 5];
% 
% for i = 1:size(links, 1)
%     A(links(i, 2), links(i, 1)) = 1;
% end

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