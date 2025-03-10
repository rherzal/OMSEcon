function [parent, children, leaf, dim, upperbound, lowerbound, Ki, depth, minimax, z, x, r] = initialize_tree_minimax(parameters)

    tree_size = parameters.max_tree_size;
    horizon_size = parameters.max_horizon;
    number_of_children = parameters.M;

    parent = zeros(tree_size, 1);
    children = zeros(tree_size, number_of_children);
    leaf = false(tree_size, 1);
    dim = ones(tree_size, horizon_size);
    upperbound = zeros(tree_size, 1);
    lowerbound = zeros(tree_size, 1);
    Ki = zeros(tree_size, 1);
    depth = zeros(tree_size, 1);
    minimax = false(tree_size, 1);

    z = ones(tree_size, horizon_size) ./ 2;
    x = zeros(tree_size, horizon_size, parameters.state_size);
    r = zeros(tree_size, horizon_size);
end

