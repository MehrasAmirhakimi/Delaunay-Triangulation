clc
[~, nt] = size(triangles);
onedge = find([edges.on] == 1);
ne = numel(onedge);

for ii = 1:nt
    
    triedge = [];
    
    triangle1 = triangles(ii).triangle;
    tr1 = triangle1(1, :);
    tr2 = triangle1(2, :);
    tr3 = triangle1(3, :);
    e1 = [tr1; tr2];
    e2 = [tr2; tr1];
    e3 = [tr1; tr3];
    e4 = [tr3; tr1];
    e5 = [tr2; tr3];
    e6 = [tr3; tr2];
    
    for jj = 1:ne
        
        noe = onedge(jj);
        edge1 = edges(noe).edge;
        
        if all(edge1 == e1) | all(edge1 == e2) | all(edge1 == e3) | all(edge1 == e4) | all(edge1 == e5) | all(edge1 == e6)
            triedge = [triedge, noe];
        else
            continue
        end
        
    end
    
    triangles(ii).edges = triedge;
    
end
