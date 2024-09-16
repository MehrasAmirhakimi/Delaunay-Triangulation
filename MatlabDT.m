clc
clear all
close all

% defining right boundary (curve)

t0 = 0.5;
t = 2;
L = 20;
n = 3;
y = @(x) L - L * (2 / (t - t0) * (x - t0/2)) .^ (1 / n);

%% generating nodes

% bnodes: boundary nodes
% dnodes: domain (non-boundary) nodes

% right boundary (curve) nodes

s = NumInt(y, t0/2, t/2, 1000);

n2 = 8;

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
    %yd = y1 * ones(nxd, 1);
    yd = y1 * (1 + 0.01 * randn(nxd, 1));
    
    if ii == 1 || ii == n2 + 1
        bnode = [bnode; [xd yd]];
    else
        dnode = [dnode; [xd yd]];
    end
    
end


bnode = unique(bnode, 'rows');

nodes = [bnode; dnode];
DT = delaunayTriangulation(nodes);
triplot(DT);