f = @(x1, x2) exp(-x1/2 - x2/3);
points = [0 0; 0 2; 0 4; 2 0; 2 2; 2 4; 4 0; 4 2; 4 4];
f_values = arrayfun(@(i) f(points(i,1), points(i,2)), 1:size(points,1))';

X1 = [ones(size(points,1),1), points];
lambda_s1 = (X1' * X1) \ (X1' * f_values);

X2 = [ones(size(points,1),1), points, points(:,1).*points(:,2), points(:,1).^2, points(:,2).^2];
lambda_s2 = (X2' * X2) \ (X2' * f_values);

[X, Y] = meshgrid(0:0.1:4, 0:0.1:4);
f_grid = exp(-X/2 - Y/3);
s1_grid = lambda_s1(1) + lambda_s1(2)*X + lambda_s1(3)*Y;
s2_grid = lambda_s2(1) + lambda_s2(2)*X + lambda_s2(3)*Y + lambda_s2(4)*X.*Y + lambda_s2(5)*X.^2 + lambda_s2(6)*Y.^2;

figure;
surf(X, Y, f_grid);
title('f(x) = exp(-x1/2 - x2/3)');
xlabel('x1');
ylabel('x2');
zlabel('f(x)');
hold on;
scatter3(points(:,1), points(:,2), f_values, 'r', 'filled');

figure;
surf(X, Y, s1_grid);
title('Linear Regression Model s1(x)');
xlabel('x1');
ylabel('x2');
zlabel('s1(x)');
hold on;
scatter3(points(:,1), points(:,2), f_values, 'r', 'filled');

figure;
surf(X, Y, s2_grid);
title('Quadratic Regression Model s2(x)');
xlabel('x1');
ylabel('x2');
zlabel('s2(x)');
hold on;
scatter3(points(:,1), points(:,2), f_values, 'r', 'filled');

error_s1 = norm(f_values - X1*lambda_s1)^2;
error_s2 = norm(f_values - X2*lambda_s2)^2;

disp(['Least squares error for s1: ', num2str(error_s1)]);
disp(['Least squares error for s2: ', num2str(error_s2)]);
