function [center, r] = circent(tr)

%circumcenter

e = tr(1, 1);
f = tr(1, 2);
c = tr(2, 1);
d = tr(2, 2);
a = tr(3, 1);
b = tr(3, 2);

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

end