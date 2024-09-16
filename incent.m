function center = incent (tr)

%incenter

a = tr(1, 1);
b = tr(1, 2);
c = tr(2, 1);
d = tr(2, 2);
e = tr(3, 1);
f = tr(3, 2);

x1 = norm([c - e, d - f], 2);
x2 = norm([a - e, b - f], 2);
x3 = norm([a - c, b - d], 2);

center = [(a * x1 + c * x2 + e * x3) / (x1 + x2 + x3), (b * x1 + d * x2 + f * x3) / (x1 + x2 + x3)];

end