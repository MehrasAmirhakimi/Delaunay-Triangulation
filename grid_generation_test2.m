ins = nodes(fins);
triangles = tricon(ins, triangles);
edges = polygon(ins, edges, triangles);
nodes(fins).insertion = 1;
triangles = trigen(edges, nodes);
%triangles = triedges(triangles, edges);
fins = find([nodes.type] == 1 & [nodes.insertion] == 0, 1, 'first');