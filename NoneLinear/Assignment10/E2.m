load('Problem_2_data.mat');

function Phi = constructBasisFunctions(x, n)
    Phi = ones(length(x), 1);
    for i = 1:n
        Phi = [Phi, sin(i*x), cos(i*x)];
    end
end

function beta = fitLinearModel(x, y, n)
    Phi = constructBasisFunctions(x, n);
    beta = (Phi' * Phi) \ (Phi' * y);
end

function y_pred = regressionModel(x, beta, n)
    Phi = constructBasisFunctions(x, n);
    y_pred = Phi * beta;
end

n_values = [1, 3, 5, 10];

figure;
hold on;
plot(x, y, 'ko', 'MarkerFaceColor', 'k');
for i = 1:length(n_values)
    n = n_values(i);
    beta = fitLinearModel(x, y, n);
    y_pred = regressionModel(x, beta, n);
    plot(x, y_pred, 'LineWidth', 2, 'DisplayName', sprintf('n = %d', n));
end
hold off;
xlabel('x');
ylabel('y');
title('Linear Regression with Different Basis Functions');
grid on;
legend('show', 'Location', 'best');

errors = zeros(length(n_values), 1);
for i = 1:length(n_values)
    n = n_values(i);
    beta = fitLinearModel(x, y, n);
    y_pred = regressionModel(x, beta, n);
    errors(i) = norm(y - y_pred);
end

figure;
plot(n_values, errors, 'r-s', 'MarkerFaceColor', 'r', 'LineWidth', 2);
xlabel('n');
ylabel('Approximation Error');
title('Approximation Error vs. n');
grid on;
