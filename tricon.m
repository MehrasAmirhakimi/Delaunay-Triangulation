function triangles = tricon(ins, triangles)


[~, nt] = size(triangles);


for ii = 1:nt
    tr = triangles(ii);
    tri = tr.triangle;
    center = tr.circumcenter;
    r = tr.radius;
    
    if all(tri(1, :) == [ins.x, ins.y]) | all(tri(2, :) == [ins.x, ins.y]) | all(tri(3, :) == [ins.x, ins.y])
        triangles(ii).containing = 0;
    elseif (ins.x - center(1)) ^ 2 + (ins.y - center(2)) ^ 2 < r ^ 2 & abs((ins.x - center(1)) ^ 2 + (ins.y - center(2)) ^ 2 - r ^ 2) > 10 ^ (-9)
        triangles(ii).containing = 1;
    else
        triangles(ii).containing = 0;
    end
    
end


end