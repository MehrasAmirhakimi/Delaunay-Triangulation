function edges = insertion(ins, edges, triangles)

nt = sum(triangles(:, 2) ~= 0);

for ii = 1:nt
    
    tr = triangles(ii, :);
    trn = tr(2:4);
    center = tr(8:9);
    r = tr(10);
    
    if trn(1) == ins(1) | trn(2) == ins(1) | trn(3) == ins(1)
        triangles(ii, 11) = 0;
    elseif (ins(2) - center(1)) ^ 2 + (ins(3) - center(2)) ^ 2 < r ^ 2 & abs((ins(2) - center(1)) ^ 2 + (ins(3) - center(2)) ^ 2 - r ^ 2) > 10 ^ (-9)
        triangles(ii, 11) = 1;
    else
        triangles(ii, 11) = 0;
    end
             
end

e = triangles(triangles(:, 11) == 1, 5:7);
[ue, ie, ~] = unique(e);
ncon = size(e, 1);
ia = [1 : 3 * ncon]';
re = e(setdiff(ia, ie));
nre = setdiff(ue, re);

[v, ~, ~] = unique(edges(nre, 2:3));

ade = zeros(size(v, 1), 2);
ade(:, 1) = ins(1);
ade(:, 2) = v;

edges(re, 2:3) = 0;
nze = sum(edges(:, 2) ~= 0);
edges(1:nze, 2:3) = edges(edges(:, 2) ~= 0, 2:3);
edges(nze + 1  :end, 2:3) = 0;

edges(nze + 1 : nze + size(v, 1), 2:3) = ade;


end