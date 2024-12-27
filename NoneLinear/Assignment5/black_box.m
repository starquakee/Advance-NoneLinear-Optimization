function R = black_box(x)
c = 1;
R = zeros(size(x));
for j = 1:length(x)
    R(j) = x(j)/j+c*x(j)^2/sqrt(j);
end
