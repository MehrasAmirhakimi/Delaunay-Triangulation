function yint = NumInt(f, a, b, n)

x = linspace(a, b, n + 1);
y = f(x);
d = zeros(1, n);

for i = 1:n
   d(i) = ((x(i + 1) - x(i)) ^ 2 + (y(i + 1) - y(i)) ^ 2) ^ 0.5;
end

yint = sum(d);

end