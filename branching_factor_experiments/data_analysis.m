N = length(algorithm_states_max);

bf = zeros(N, 30);

for i = 1:N
    max_depth = max(algorithm_states_max{i}.depth);
    for j = 2:max_depth
        idx1 = find(algorithm_states_max{i}.depth == j);
        idx2 = find(algorithm_states_max{i}.depth == (j-1));
        length(idx1)
        length(idx2)
        bf(i, j) = length(idx1) / length(idx2);
    end
end


hold on
plot(bf(1, 2:end));
plot(bf(8, 2:end));
hold off;