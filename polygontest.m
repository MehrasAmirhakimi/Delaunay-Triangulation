clc

err = 0;
cont = find([triangles.containing] == 1);
ncon = numel(cont);
e = zeros(ncon, 3);

for ii = 1:ncon
    
    e(ii, :) = triangles(cont(ii)).edges;
    
end

ia = [1:ncon * 3]';
[C, ie, ~] = unique(e);
repedge = e(setdiff(ia, ie));

nonrepedge = setdiff(C, repedge);
nonrep = numel(nonrepedge);

nonrepnode = zeros(2 * nonrep, 2);

for ii = 1:nonrep
    
    nonrepnode(2 * ii - 1 : 2 * ii, 1:2) = edges(nonrepedge(ii)).edge;

end

polyvert = unique(nonrepnode, 'rows');

[npoly, ~] = size(polyvert);
[~, ne] = size(edges);

if npoly ~= nonrep
    err = 1;
    return
end

edges(repedge).on = 0;

for ii = 1:npoly
    
    edges(ne + ii).edge = [ins.x, ins.y; polyvert(ii, :)];
    edges(ne + ii).on = 1;
    edges(ne + ii).type = 0;
    
end