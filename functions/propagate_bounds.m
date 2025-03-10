function [lowerbound, upperbound] = propagate_bounds(node, parent, children, minimax, lowerbound, upperbound)

    while node ~= 0 
        
        if minimax(node) == true
            lowerbound(node) = max( lowerbound(children(node, :)) );
            upperbound(node) = max( upperbound(children(node, :)) );
        else
            lowerbound(node) = min( lowerbound(children(node, :)) );
            upperbound(node) = min( upperbound(children(node, :)) );
        end
        
        node = parent(node);
    end

end

