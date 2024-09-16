clc
clear all
close all

% defining right boundary (curve)

t0 = 0.5;
t = 2;
L = 40;
n = 4;
y = @(x) L - L * (2 / (t - t0) * (x - t0/2)) .^ (1 / n);

%% generating nodes

% bnodes: boundary nodes
% dnodes: domain (non-boundary) nodes

% right boundary (curve) nodes

s = NumInt(y, t0/2, t/2, 1000);

n2 = 15;

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


% from upper boundary to the bottom nodes, and domain nodes

n5 = 10;

dx = t / (2 * n5);
nx = ceil((bnode(1:n2 + 1, 1) - bnode(n2 + 2:2 * (n2 + 1), 1)) / dx);

dnode = [];

for ii = 1:n2 + 1;
    
    x1 = bnode(ii, 1);
    y1 = bnode(ii, 2);
    xin = linspace(0, x1, nx(ii) + 1);
    xd = (1 - exp(-1 ./ x1 * xin)) * x1 / (1 - exp(-1));
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
node = [bnode; dnode];

node = sortrows(node, 2);
ynode = unique(node(:, 2));
ny = numel(ynode);
node2 = [];

for ii = 1:ny
    f = find(node(:, 2) == ynode(ii));
    node2 = [node2; sortrows(node(f, :), 1)];
end
node = node2;

%% mesh generation

% generating box vertices

box = zeros(4, 3);

m = 2 * L / t;

box(1, :) = [-1, -m, 2];
box(2, :) = [t / 2 + 1, -m, 2];
box(3, :) = [-1, m + L, 2];
box(4, :) = [t / 2 + 1, m + L, 2];

node = [node; box];

% inserting box nodes in the structure

empty_node.x = [];
empty_node.y = [];
empty_node.type = []; % 1 means boundary node
empty_node.insertion = []; % 1 means inserted

[node_size1, ~] = size(node);
nodes = repmat(empty_node, node_size1, 1);

y1 = num2cell(node(:, 1));
[nodes.x] = y1{:};

y2 = num2cell(node(:, 2));
[nodes.y] = y2{:};

y3 = num2cell(node(:, 3));
[nodes.type] = y3{:};

y4 = num2cell(zeros(node_size1, 1));
[nodes.insertion] = y4{:};

edges(1).edge = [nodes(node_size1 - 3).x, nodes(node_size1 - 3).y; nodes(node_size1 - 2).x, nodes(node_size1 - 2).y];
edges(1).on = 1;
edges(1).type = 1;

edges(2).edge = [nodes(node_size1 - 2).x, nodes(node_size1 - 2).y; nodes(node_size1).x, nodes(node_size1).y];
edges(2).on = 1;
edges(2).type = 1;

edges(3).edge = [nodes(node_size1 - 1).x, nodes(node_size1 - 1).y; nodes(node_size1).x, nodes(node_size1).y];
edges(3).on = 1;
edges(3).type = 1;

edges(4).edge = [nodes(node_size1 - 3).x, nodes(node_size1 - 3).y; nodes(node_size1 - 1).x, nodes(node_size1 - 1).y];
edges(4).on = 1;
edges(4).type = 1;

edges(5).edge = [nodes(node_size1 - 3).x, nodes(node_size1 - 3).y; nodes(node_size1).x, nodes(node_size1).y];
edges(5).on = 1;
edges(5).type = 0;

y5 = num2cell(ones(4, 1));
[nodes(node_size1 - 3:node_size1).insertion] = y5{:};

triangles = trigen(edges, nodes);
%triangles = triedges(triangles, edges);

% inserting boundary nodes

fins = find([nodes.type] == 1 & [nodes.insertion] == 0, 1, 'first');

while numel(fins) ~= 0
    
    ins = nodes(fins);
    triangles = tricon(ins, triangles);
    edges = polygon(ins, edges, triangles);
    nodes(fins).insertion = 1;
    triangles = trigen(edges, nodes);
    fins = find([nodes.type] == 1 & [nodes.insertion] == 0, 1, 'first');

end

% inserting domain (non-boundary) nodes

fins = find([nodes.type] == 0 & [nodes.insertion] == 0, 1, 'first');

while numel(fins) ~= 0
    
    ins = nodes(fins);
    triangles = tricon(ins, triangles);
    edges = polygon(ins, edges, triangles);
    nodes(fins).insertion = 1;
    triangles = trigen(edges, nodes);
    fins = find([nodes.type] == 0 & [nodes.insertion] == 0, 1, 'first');

end

%% removing out of domain edges and triangles

