function triangles = trigen2(edges, nodes)

n = sum(edges(:, 2) ~= 0);
edgesp = edges(1:n, :);
nt = 200;
triangles = zeros(nt, 10);
trnum = [1:size(triangles, 1)]';
triangles = [trnum, triangles];
jt = 0;

for i = 1:n
    
    edgesp2 = edgesp(:, 2:3);
    edgesp2(i, :) = 0;
    edge = edgesp(i, :);
    nd1 = edge(2);
    nd2 = edge(3);
    e1 = edgesp2 - nd1;
    e2 = edgesp2 - nd2;
    f11 = e1 == 0;
    f21 = e2 == 0;
    f1 = f11(:, 1) + f11(:, 2);
    f1 = [f1, f1];
    f1 = f1 - f11;
    f2 = f21(:, 1) + f21(:, 2);
    f2 = [f2, f2];
    f2 = f2 - f21;
    ednod1 = edgesp2 .* f1;
    ednod2 = edgesp2 .* f2;
    [a, b, c] = intersect(ednod1, ednod2);
    b = b(a ~= 0);
    c = c(a ~= 0);
    a = a(a ~= 0);
    be = b - n * (b > n);
    ce = c - n * (c > n);
    trn = [a, repmat([nd1, nd2], numel(a), 1)];
    tre = sort([ones(numel(a), 1) * i, be, ce], 2);
    triangles(jt + 1 : jt + numel(a), 2:7) = [trn, tre];
    jt = jt + numel(a);
    
end

aa = triangles(1:jt, 5:7);
[~, a2, ~] = unique(aa, 'rows');
na2 = numel(a2);
triangles(1:na2, 2:11) = triangles(a2, 2:11);
triangles(na2 + 1:jt, :) = 0;

triangles = circent2(nodes, triangles);
triangles = remextr2 (triangles, nodes);

end