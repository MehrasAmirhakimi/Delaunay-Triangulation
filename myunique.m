function triangles = myunique (triangles)

[~, nt] = size(triangles);
kk = 0;
for ii = 1:nt - 1
    
    edge = triangles(ii).edges;
    
    for jj = ii + 1:nt
        
        if triangles(jj).edges == edge
            kk = kk + 1;
            rep(kk) = jj;
        else
            continue
        end
        
    end
    
end

nonrep = setdiff(1:nt, rep);
triangles = triangles(nonrep);


end