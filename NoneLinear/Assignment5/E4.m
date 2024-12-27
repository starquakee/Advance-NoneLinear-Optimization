function run_minimax_optimization()
    dimensions = [3, 5, 10, 20];
    for n = dimensions
        fprintf('\n--- Dimension n = %d ---\n', n);
        x0 = ones(n, 1) / n; 
        Aeq = ones(1, n);
        beq = 1; 
        lb = zeros(n, 1); 
        ub = []; 
        options = optimoptions('fminimax', 'Display', 'off'); 
        [x_opt, fval, ~, output] = fminimax(@black_box, x0, [], [], Aeq, beq, lb, ub, [], options);
        plot_results(x0, x_opt, n);
    end
end

function plot_results(x0, x_opt, n)
    figure;
    subplot(1, 2, 1);
    hold on;
    plot(1:n, x0, 'ko', 'MarkerSize', 8, 'LineWidth', 1.5);
    plot(1:n, x_opt, 'ro', 'MarkerSize', 8, 'LineWidth', 1.5);
    legend('Initial', 'Optimized');
    title('Function Arguments');
    grid on;
    hold off;

    subplot(1, 2, 2);
    hold on;
    plot(1:n, black_box(x0), 'ko', 'MarkerSize', 8, 'LineWidth', 1.5);
    plot(1:n, black_box(x_opt), 'ro', 'MarkerSize', 8, 'LineWidth', 1.5);
    legend('Initial', 'Optimized');
    title('Function Values');
    grid on;
    hold off;
end

run_minimax_optimization();
