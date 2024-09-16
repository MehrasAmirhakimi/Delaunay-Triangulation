clc
clear all
close all

L = 10;
n = 3;
t =  3;
t0 = 0.5;

empty_node.x = [];
empty_node.y = [];
empty_node.i = [];
empty_node.j = [];
empty_node.type = [];
empty_node.R = [];

empty_tile.ti = [];
empty_tile.tj = [];
empty_tile.nodes = [];
empty_tile.center = [];

m = 25;
dx = L/(m-1);

% constructing nodes

nn = 0;
for j = floor((m - 1) * t0 / (2 * L)) + 1 : floor((m - 1) * t / (2 * L))
    nn = nn + 1;
    node_mat(nn, 1) = dx * j;
    node_mat(nn, 2) = L - L * (2 / (t - t0) * (dx*j - t0/2)) ^ (1/n);
    node_mat(nn, 3) = NaN;
    node_mat(nn, 4) = NaN;
    node_mat(nn, 5) = 2;
end

for i = 0 : m - 1
    nn = nn + 1;
    node_mat(nn, 1) = t0/2 + (t - t0) / 2 * (i / (m - 1)) ^ n;
    node_mat(nn, 2) = L * (1 - i/(m - 1));
    node_mat(nn, 3) = NaN;
    node_mat(nn, 4) = NaN;
    node_mat(nn, 5) = 2;
end

for i = 0 : m-1
    for j = 0 : floor( (m - 1)/L * (t0/2 + (t - t0) / 2 * (i / (m - 1)) ^ n));
        nn = nn + 1;
        node_mat(nn, 1) = dx * j;
        node_mat(nn, 2) = L * (1 - i/(m - 1));
        node_mat(nn, 3) = i;
        node_mat(nn, 4) = j;
    end
end

node_mat2 = node_mat(:, [1 2]);
[~, ia] = unique(node_mat2, 'rows');
node_mat = node_mat(ia, :);

[node_size1, ~] = size(node_mat);
node = repmat(empty_node, node_size1, 1);

y1 = num2cell(node_mat(:, 1));
[node.x] = y1{:};

y2 = num2cell(node_mat(:, 2));
[node.y] = y2{:};

y3 = num2cell(node_mat(:, 3));
[node.i] = y3{:};

y4 = num2cell(node_mat(:, 4));
[node.j] = y4{:};

y5 = num2cell(node_mat(:, 5));
[node.type] = y5{:};

type1l = find([node.y]' == L);
type1 = num2cell(1 * ones(length(type1l), 1));
[node(type1l).type] = type1{:};

type3l = find([node.y]' == 0);
type3 = num2cell(3 * ones(length(type3l), 1));
[node(type3l).type] = type3{:};

type4l = find([node.x]' == 0);
type4 = num2cell(4 * ones(length(type4l), 1));
[node(type4l).type] = type4{:};

type2l = find([node.x]' == t0/2 | [node.x]' == t/2);
type2 = num2cell(2 * ones(length(type2l), 1));
[node(type2l).type] = type2{:};

type5l = find([node.type]' == 0);
type5 = num2cell(5 * ones(length(type5l), 1));
[node(type5l).type] = type5{:};

% constructing tiles
tile_size = sum(floor( (m - 1)/L * (t0/2 + (t - t0) / 2 * ((1:m - 1) ./ (m - 1)) .^ n)) + 1);
tile = repmat(empty_tile, tile_size, 1);

tn = 0;
for i = 0:m - 2
   yup = L * (1 - i / (m - 1));
   ydown = L * (1 - (i + 1) / (m - 1));
   fy = find([node.y] <= yup & [node.y] >= ydown);
   for j = 0:floor( (m - 1)/L * (t0/2 + (t - t0) / 2 * ((i + 1) / (m - 1)) ^ n));
       tn = tn + 1;
       xleft = dx * j;
       xright = dx * (j + 1);
       fx = find ([node.x] <= xright & [node.x] >= xleft);
       f = intersect(fx, fy);
       tile(tn).ti = i;
       tile(tn).tj = j;
       noft = [node(f).x; node(f).y]';
       [size_noft, ~] = size(noft);
       tile(tn).nodes = noft;
       tile(tn).center = [sum(noft(:, 1)), sum(noft(:, 2))] / size_noft;
   end
end

n2 = find([node.type] == 2);
for ii = 1:length(n2)
    node1 = node(n2(ii));
    if mod(node1.x, dx) == 0 && mod(node1.y, dx) == 0
        if node1.x == 0
            n_node2 = find([node.x] == 0 && [node.y] == node1.y - dx);
            n_node3 = n2(2);
            node2 = node(n_node2);
            node3 = node(n_node3);
            deltax2 = dx;
            deltax3 = ((node1.x - node3.x)^2 + (node1.y - node3.y)^2)^0.5;
            
        end
    end
end