function triangles = trigen(edges, nodes)

% constructing triangles
[~, n] = size(edges);
ext_edges = zeros(2 * n, 4);
jj = 0;

for ii =1:n
    
    ext_edges([2 * ii - 1, 2 * ii], 1:2) = edges(ii).edge;
    ext_edges(2 * ii - 1, 3) = edges(ii).on;
    ext_edges(2 * ii, 3) = edges(ii).on;
    ext_edges(2 * ii - 1, 4) = edges(ii).type;
    ext_edges(2 * ii, 4) = edges(ii).type;
end

for ii =2:2:2 * n
    
    node1_of_edge = ext_edges(ii - 1, :);
    node2_of_edge = ext_edges(ii, :);
    
    if node1_of_edge(3) == 1;
        
        node1 = node1_of_edge(:, 1:2);
        node2 = node2_of_edge(:, 1:2);
            
        %f11 = find(ext_edges(:, 1) == node1(1));
        %f12 = find(ext_edges(:, 2) == node1(2));
        %f13 = find(ext_edges(:, 3) == 1);
        %f1 = intersect(f11, f12);
        %f1 = intersect(f1, f13);
        f1 = find(ismember(ext_edges(:, 1:3), [node1, 1], 'rows') == 1);
        f1s = mod(f1, 2);
        f1 = f1 + 2 * f1s - 1;
        node1p = ext_edges(f1', 1:2);
            
        %f21 = find(ext_edges(:, 1) == node2(1));
        %f22 = find(ext_edges(:, 2) == node2(2));
        %f2 = intersect(f21, f22);
        %f2 = intersect(f2, f13);
        f2 = find(ismember(ext_edges(:, 1:3), [node2, 1], 'rows') == 1);
        f2s = mod(f2, 2);
        f2 = f2 + 2 * f2s - 1;
        node2p = ext_edges(f2', 1:2);
        
        % node3 =intersect(node1p, node2p, 'rows');
        f = find(ismember(node1p, node2p, 'rows') == 1);
        node3 = node1p(f, :);
        [n3, ~] = size(node3);
        
        if n3 == 1
            jj = jj + 1;
            triangles(jj).triangle = [node1; node2; node3];
        else
            jj = jj + 1;
            triangles(jj).triangle = [node1; node2; node3(1, :)];
            jj = jj + 1;
            triangles(jj).triangle = [node1; node2; node3(2, :)];
        end
        
    else
        continue
    end
end

[~, n] = size(triangles);

%[~, ia, ~] = unique(cell2mat({triangles.incenter}'), 'rows');

%triangles = triangles(ia);

triangles = triedges(triangles, edges);
triangles = myunique(triangles);

% calculating circumcenter coordinates for triangles
[~, n] = size(triangles);

for iii = 1:n
    [triangles(iii).circumcenter, triangles(iii).radius] = circent(triangles(iii).triangle);
end

% removing extra triangles
triangles = remextr (triangles, nodes);

end