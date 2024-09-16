function triangles = triedges(triangles, edges)

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
        
        cm1 = edge1 == e1;
        sum1 = cm1(1) + cm1(2) + cm1(3) + cm1(4);
        c1 = sum1 == 4;
        
        cm2 = edge1 == e2;
        sum2 = cm2(1) + cm2(2) + cm2(3) + cm2(4);
        c2 = sum2 == 4;
        
        cm3 = edge1 == e3;
        sum3 = cm3(1) + cm3(2) + cm3(3) + cm3(4);
        c3 = sum3 == 4;
        
        cm4 = edge1 == e4;
        sum4 = cm4(1) + cm4(2) + cm4(3) + cm4(4);
        c4 = sum4 == 4;
        
        cm5 = edge1 == e5;
        sum5 = cm5(1) + cm5(2) + cm5(3) + cm5(4);
        c5 = sum5 == 4;
        
        cm6 = edge1 == e6;
        sum6 = cm6(1) + cm6(2) + cm6(3) + cm6(4);
        c6 = sum6 == 4;
        
        c = c1 + c2 + c3 + c4 + c5 + c6;
        if c >=1
            triedge = [triedge, noe];
        else
            continue
        end
        
    end
    
    triangles(ii).edges = triedge;
    
end

end