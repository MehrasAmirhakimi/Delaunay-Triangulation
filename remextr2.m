function triangles = remextr2 (triangles, nodes)

nt = sum(triangles(:, 2) ~= 0);
innodes = find(nodes(:, 5) == 1);
extra = zeros(nt, 1);
sztr = size(triangles, 1);

for ii = 1:nt
    
    tr = triangles(ii, :);
    trn = tr(2:4);
    center = tr(8:9);
    r = tr(10);
    
    for jj = 1:numel(innodes)
        node = nodes(innodes(jj), :);
        if trn(1) == node(1) | trn(2) == node(1) | trn(3) == node(1)
            extra(ii) = extra(ii) + 0;
        elseif (node(2) - center(1)) ^ 2 + (node(3) - center(2)) ^ 2 < r ^ 2 & abs((node(2) - center(1)) ^ 2 + (node(3) - center(2)) ^ 2 - r ^ 2) > 10 ^ (-9)
            extra(ii) = extra(ii) + 1;
        else
            extra(ii) = extra(ii) + 0;
        end
    
    end
end

s = sum(extra == 0);

triangles(1:s, 2:11) = triangles(extra == 0, 2:11);
triangles(s+1:sztr, 1:11) = 0;

end