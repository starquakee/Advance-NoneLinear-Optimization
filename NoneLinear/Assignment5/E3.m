t_data = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
y_data = [2.3743, 1.1497, 0.7317, 0.5556, 0.4675, 0.4157, 0.3807, 0.3546, 0.3337, 0.3164];
x0 = [1, 1, 1, 1];
lb = [0, 0, 0, 0];
ub = [10, 10, 10, 10];
options = optimoptions('lsqnonlin', 'Display', 'off');
[x_opt, ~] = lsqnonlin(@(x) model_residuals(x, t_data, y_data), x0, lb, ub, options);
y_initial = model_function(x0, t_data);
y_optimized = model_function(x_opt, t_data);
disp('Initial g(t):');
print_function_expression(x0);
disp('Optimized g(t):');
print_function_expression(x_opt);
figure;
hold on;
plot(t_data, y_data, 'kx', 'MarkerSize', 8, 'LineWidth', 1.5);
plot(t_data, y_initial, 'bo', 'MarkerSize', 8, 'LineWidth', 1.5);
plot(t_data, y_optimized, 'ro', 'MarkerSize', 8, 'LineWidth', 1.5);
legend('Data', 'Approximation function (initial)', 'Approximation function (optimized)', 'Location', 'northeast');
xlabel('t'); ylabel('y');
title('Data and Approximation Function (Initial and Optimized)');
grid on;
hold off;

function y = model_function(x, t)
    a = x(1); b = x(2); c = x(3); d = x(4);
    y = a * exp(-b * t) + c * exp(-d * t);
end

function residuals = model_residuals(x, t, y_data)
    y_model = model_function(x, t);
    residuals = y_model - y_data;
end

function print_function_expression(params)
    a = params(1); b = params(2); c = params(3); d = params(4);
    fprintf('g(t) = %.4f * exp(-%.4f * t) + %.4f * exp(-%.4f * t)\n', a, b, c, d);
end