function [best_move, algorithm_state] = minimax_algorithm(parent, children, leaf, dim, upperbound, lowerbound, Ki, depth, minimax, z, x, r, parameters, model)

    budget = parameters.budget;
    discount_array = parameters.discounted_array;
    number_of_children = parameters.M;
    
    node = 1;
    best_box = 1;
    while budget > 0
    
        % Box selection:
        box_i = select_box_minimax(children, leaf, upperbound, lowerbound, minimax);

        % Selecting split dimension k:
        [~, k] = max( discount_array .* dim(box_i, :) );
        
        % Deciding if the box is min or max box:
        if mod(k,2) == 1 
            minimax(box_i) = 1;
        else
            minimax(box_i) = 0;
        end

        % Expanding box_i along dimension k into M parts:
        leaf(box_i) = false;
        for i = 1:number_of_children
            
            node = node + 1;

            if k > Ki(box_i)
                Ki(node) = Ki(box_i) + 1;
            else
                Ki(node) = Ki(box_i);
            end

            parent(node) = box_i;
            children(box_i, i) = node;
            depth(node) = depth(box_i) + 1;

            z(node, :) = z(box_i, :);
            z(node, k) = compute_center_action(z, dim, box_i, k, i, number_of_children);
            
            dim(node, :) = dim(box_i, :);
            dim(node, k) = dim(box_i, k) / number_of_children;

            leaf(node) = true;

            x(node, :, :) = x(box_i, :, :);
            r(node, :) = r(box_i, :);
            
            for j = k : Ki(node)
                
                if mod(j,2) == 0
                    % Minimax problem?
                    state = squeeze( x(node, j-1, :) );

                    if model.id == 'max'
                        action_max = inverse_norm_u(z(node, j - 1), model); % the action is at odd steps
                        action_min = inverse_norm_w(z(node, j), model); % the disturbance is at even steps
                        [x(node, j + 1, :), r(node, j)] = feval(model.fun, model, state, [action_max; action_min]);
                    else 
                        action_max = inverse_norm_w(z(node, j - 1), model);
                        action_min = inverse_norm_u(z(node, j), model);
                        [x(node, j + 1, :), r(node, j)] = feval(model.fun, model, state, [action_min; action_max]);
                    end
                    budget = budget - 1;
                end 
            end

            [lowerbound(node), upperbound(node)]  = compute_bounds_minimax(node, Ki, r, dim, parameters);
            
        end
        
        if depth(box_i) > depth(best_box)
            best_box = box_i;
        end
        
        [lowerbound, upperbound] = propagate_bounds(box_i, parent, children, minimax, lowerbound, upperbound);
        
        % plot_tree(children, leaf, lowerbound, upperbound, depth, minimax);
    end

    % Finding best trajectory:
    best_move = z(best_box, 1);
    
    % plot_tree(children, leaf, lowerbound, upperbound, depth, minimax);

    algorithm_state = struct;
    algorithm_state.parent = parent;
    algorithm_state.children = children;
    algorithm_state.leaf = leaf;
    algorithm_state.dim = dim;
    algorithm_state.upperbound = upperbound;
    algorithm_state.lowerbourd = lowerbound;
    algorithm_state.Ki = Ki;
    algorithm_state.depth = depth;
    algorithm_state.minimax = minimax;
    algorithm_state.z = z;
    algorithm_state.x = x;
    algorithm_state.parameters = r;
    algorithm_state.model = model;



end

