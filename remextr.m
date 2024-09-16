function triangles = remextr (triangles, nodes)

[~, nt] = size(triangles);
innodes = find([nodes.insertion] == 1);
extra = zeros(nt, 1);

for ii = 1:nt
    tr = triangles(ii);
    tri = tr.triangle;
    center = tr.circumcenter;
    r = tr.radius;
    
    for jj = 1:numel(innodes)
        node = nodes(innodes(jj));
        if all(tri(1, :) == [node.x, node.y]) | all(tri(2, :) == [node.x, node.y]) | all(tri(3, :) == [node.x, node.y])
            extra(ii) = extra(ii) + 0;
        elseif (node.x - center(1)) ^ 2 + (node.y - center(2)) ^ 2 < r ^ 2 & abs((node.x - center(1)) ^ 2 + (node.y - center(2)) ^ 2 - r ^ 2) > 10 ^ (-9)
            extra(ii) = extra(ii) + 1;
        else
            extra(ii) = extra(ii) + 0;
        end
    
    end
end

triangles = triangles(find(extra == 0));

end