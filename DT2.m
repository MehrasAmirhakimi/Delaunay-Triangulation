clc
clear all
close all

%% node generation

% defining right boundary (curve)

t0 = 0.5;
t = 2;
L = 20;
n = 5;
y = @(x) L - L * (2 / (t - t0) * (x - t0/2)) .^ (1 / n);



% bnodes: boundary nodes
% dnodes: domain (non-boundary) nodes

% right boundary (curve) nodes

s = NumInt(y, t0/2, t/2, 1000);

n2 = 5;

ds = s/n2;

bnode(1, 1) = t0/2;
bnode(1, 2) = L;

syms x

for ii =2:n2
   xp = bnode(ii-1, 1);
   yp = bnode(ii-1, 2);
   xn = real(vpasolve( yp - (ds ^ 2 - (x - xp) ^ 2) ^ 0.5 == L - L * (2 / (t - t0) * (x - t0/2)) ^ (1 / n)));
   yn = y(xn);
   bnode(ii, 1) = xn;
   bnode(ii, 2) = yn;
end

clear x

bnode(n2 + 1, 1) = t / 2;
bnode(n2 + 1, 2) = 0;

% left boundary nodes

bnode(n2 + 2:2 * (n2 + 1), 1) = 0;
bnode(n2 + 2:2 * (n2 + 1), 2) = bnode(1:n2 + 1, 2);


% domain nodes, from upper boundary to the bottom nodes

n5 = 5;

dx = t / (2 * n5);
nx = ceil((bnode(1:n2 + 1, 1) - bnode(n2 + 2:2 * (n2 + 1), 1)) / dx);

dnode = [];

for ii = 1:n2 + 1;
    
    x1 = bnode(ii, 1);
    y1 = bnode(ii, 2);
    xin = linspace(0, x1, nx(ii) + 1);
    xd = (1 - exp(-0.5 ./ x1 * xin)) * x1 / (1 - exp(-0.5));
    xd = xd(2:numel(xd) - 1)';
    nxd = numel(xd);
    yd = y1 * ones(nxd, 1);
    %yd = y1 * (1 + 0.01 * randn(nxd, 1));
    
    if ii == 1 || ii == n2 + 1
        bnode = [bnode; [xd yd]];
    else
        dnode = [dnode; [xd yd]];
    end
    
end


bnode = unique(bnode, 'rows');

bnode(:, 3) = 1;
dnode(:, 3) = 0;
nodes = [bnode; dnode];

nodes = sortrows(nodes, 2);
[~, ~, c] = unique(nodes(:, 2));
for i = 1:c(end)
    nodes(c == i, :) = sortrows(nodes(c == i, :), 1);
end

%% mesh generation

% generating box vertices

box = zeros(4, 3);

m = 2 * L / t;

box(1, :) = [-1, -m, 2];
box(2, :) = [t / 2 + 1, -m, 2];
box(3, :) = [-1, m + L, 2];
box(4, :) = [t / 2 + 1, m + L, 2];

nodes = [nodes; box];
nodes(:, 4) = 0;
node_size = size(nodes, 1);

nodnum = [1:node_size]';
nodes = [nodnum, nodes];

% inserting box nodes in the structure

edges = zeros(100, 2);
edgnum = [1:size(edges, 1)]';
edges = [edgnum, edges];


edges(1, 2:3) = [node_size - 3, node_size - 2];
edges(2, 2:3) = [node_size - 2, node_size - 0];
edges(3, 2:3) = [node_size - 1, node_size - 0];
edges(4, 2:3) = [node_size - 3, node_size - 1];
edges(5, 2:3) = [node_size - 3, node_size - 0];

nodes(node_size - 3:node_size, 5) = 1;

triangles = trigen2(edges, nodes);
fins = find(nodes(:, 4) == 1 & nodes(:, 5) == 0);

for i = 1:numel(fins)
    
    ins = nodes(fins(i), :);
    edges = insertion(ins, edges, triangles);
    nodes(ins(1), 5) = 1;
    triangles = trigen2(edges, nodes);
    % gridplot(nodes, edges);

end

fins = find(nodes(:, 4) == 0 & nodes(:, 5) == 0);

for i = 1:numel(fins)
    
    ins = nodes(fins(i), :);
    edges = insertion(ins, edges, triangles);
    nodes(ins(1), 5) = 1;
    triangles = trigen2(edges, nodes);
    % gridplot(nodes, edges);

end

gridplot(nodes, edges);