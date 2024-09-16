offedges1 = find([edges.on] == 0);
num2 = numel(offedges1);
plot(node(:, 1)', node(:, 2)', 'ro');
hold on
for ii = 1:num2
    edge2 = edges(offedges1(ii)).edge;
    plot(edge2(:, 1)', edge2(:, 2)', 'm');
end