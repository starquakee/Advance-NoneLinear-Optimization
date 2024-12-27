load('Problem_3_data.mat');

whos;

x_data = x;
y_data = y;

figure;
plot(x_data, y_data, 'bo', 'MarkerFaceColor', 'b');
title('Data Plot');
xlabel('x');
ylabel('y');
grid on;

model = @(params, x) params(1) * exp(-params(2) * x) + params(3);

initial_guess = [1, 0.1, 1];

options = optimset('Display', 'off');
params_estimated = lsqnonlin(@(params) model(params, x_data) - y_data, initial_guess, [], [], options);

hold on;
x_fit = linspace(min(x_data), max(x_data), 100);
y_fit = model(params_estimated, x_fit);

plot(x_fit, y_fit, 'r-', 'LineWidth', 2);
legend('Data', 'Fitted Curve');
title('Data and Fitted Nonlinear Regression Model');
grid on;
hold off;

disp('Estimated Parameters:');
disp(params_estimated);
