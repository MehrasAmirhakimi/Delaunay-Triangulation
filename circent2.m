function triangles = circent2(nodes, triangles)

n = sum(triangles(:, 2) ~= 0);

for i = 1:n
    
    tn1 = triangles(i, 2);
    tn2 = triangles(i, 3);
    tn3 = triangles(i, 4);
    
    e = nodes(tn1, 2);
    f = nodes(tn1, 3);
    c = nodes(tn2, 2);
    d = nodes(tn2, 3);
    a = nodes(tn3, 2);
    b = nodes(tn3, 3);

    m1 = (a - c) / (d - b);
    m2 = (a - e) / (f - b);
    x1 = (a + c) / 2;
    y1 = (b + d) / 2;
    x2 = (a + e) / 2;
    y2 = (b + f) / 2;

    if abs(m1) == inf;
        center = [x1; m2 * (x1 - x2) + y2];
    elseif abs(m2) == inf;
        center = [x2; m1 * (x2 - x1) + y1];
    else
        A1 = [m1, -1; m2, -1];
        A2 = [m1 * x1 - y1; m2 * x2 - y2];
        center = inv(A1) * A2;
    end
    
    center = center';

    r = norm([a - center(1), b - center(2)], 2);
    
    triangles(i, 8:10) = [center, r];
    
end

end