function gridplot(nodes, edges)

figure

ne = sum(edges(:, 2) ~= 0);
plot(nodes(:, 2), nodes(:, 3), 'ro');
hold on
for ii = 1:ne
    edge1 = edges(ii, :);
    x = nodes(edge1(2:3), 2);
    y = nodes(edge1(2:3), 3);
    p = plot(x, y);
end

hold off

end