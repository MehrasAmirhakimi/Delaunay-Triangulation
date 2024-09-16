function plotgrid(nodes, edges)

onedges1 = find([edges.on] == 1);
num1 = numel(onedges1);
plot([nodes.x], [nodes.y], 'ro');
hold on
for ii = 1:num1
    edge1 = edges(onedges1(ii)).edge;
    plot(edge1(:, 1)', edge1(:, 2)');
end

end