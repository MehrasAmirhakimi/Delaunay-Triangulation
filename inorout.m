function edges = inorout(nodes, edges)

bnode = find(nodes.type == 1);
nb = numel(bnodes);

ne = size(edges, 2);
edge = zeros(2 * ne, 2);

for i = 1:ne
    
    edge(2 * i - 1:2 * i, :) = edges(i).edge;
    
end

for i = 1:nb
    
    node = [nodes(bnode(i)).x, nodes(bnode(i)).y];
    f1 = find(ismember(edge, node, 'rows') == 1);
    
    
    
end


end