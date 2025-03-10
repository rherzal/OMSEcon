function plot_tree(childrenArray, leafArray, lowerBound, upperBound, depthArray, minimaxArray)
    % Validate input
    numParents = length(leafArray);

    if length(depthArray) ~= numParents
        error('The length of depthArray must match the length of leafArray.');
    end

    % Create a graph object
    treeGraph = digraph();

    % Initialize node labels
    nodeLabels = strings(numParents, 1);

    % Add edges between parent and children
    for i = 1:numParents
        isLeaf = leafArray(i);

        % Create label for the parent node
        nodeLabels(i) = sprintf('%d: [%.2f %.2f]', i, lowerBound(i), upperBound(i));

        if isLeaf
            continue; % Skip adding children if the node is a leaf
        end

        children = childrenArray(i, :);
        for j = 1:length(children)
            child = children(j);

            % Validate child ID
            if isnan(child) || child <= 0 || mod(child, 1) ~= 0
                continue; % Skip invalid children
            end

            % Add edge
            treeGraph = addedge(treeGraph, i, child);
        end
    end

    % Plot the tree
    h = plot(treeGraph, 'Layout', 'layered', 'Direction', 'down');
    title('Tree Structure');
    xlabel('Nodes');
    ylabel('Hierarchy');

    % Add node labels
    numNodes = numnodes(treeGraph);
    h.NodeLabel = nodeLabels(1:numNodes);

    % Customize node shapes based on depth
    hold on;
    for k = 1:numNodes
        % Get node coordinates
        x = h.XData(k);
        y = h.YData(k);

        % Determine shape based on depth
        if minimaxArray(k) == true
            scatter(x, y, 75, 's', 'filled',  'k');
        else
            scatter(x, y, 50, 'o', 'filled',  'k');
        end
    end
    hold off;
end
