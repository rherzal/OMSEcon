function [lowerbound_node, upperbound_node] = compute_bounds_minimax(node, Ki, r, dim, parameters)
    
    n = Ki(node);
    
    discounted_array = parameters.discounted_array(1:n);
    discount = parameters.gamma;
    Lv = parameters.Lv;
    
    r_node = r(node, 1:n);
    dim_node = dim(node, 1:n);
   
    lowerbound_node = discounted_array * (r_node - Lv .* dim_node)';
    upperbound_node = discounted_array * (r_node + Lv .* dim_node)' + Lv * discount ^ n / ( 1 - discount );

end

