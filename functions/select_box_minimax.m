function box_i = select_box_minimax(children, leaf, upperbound, lowerbound, minimax)
    
    box_i = 1;

    while ~leaf(box_i) 
        
        if minimax(box_i) == 1
            [~, child_index] = max( upperbound(children(box_i, :)) );
        else
            [~, child_index] = min( lowerbound(children(box_i, :)) );
        end

        box_i = children(box_i, child_index);
    end
    
end

