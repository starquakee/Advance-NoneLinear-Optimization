function [x_opt, f_min] = pattern_search_visual(func, x0, bounds, step_size, tol)
    x = x0; 
    f_min = func(x(1), x(2));

    figure;
    hold on;
    xlabel('x'); ylabel('y'); title('Pattern Search with Contour Plot');
    grid on;

    [X, Y] = meshgrid(linspace(bounds(1,1), bounds(1,2), 100), ...
                      linspace(bounds(2,1), bounds(2,2), 100));
    Z = func(X, Y);
    contour(X, Y, Z, 30);

    plot(x(1), x(2), 'ro', 'MarkerSize', 10, 'MarkerFaceColor', 'r');
    text(x(1), x(2), 'Start', 'VerticalAlignment', 'top', 'HorizontalAlignment', 'left');
    
    path = [x];

    while step_size > tol
        next_point = x;
        f_next_min = f_min;

        directions = [1 0; -1 0; 0 1; 0 -1]; 
        
        for i = 1:size(directions, 1)
            candidate = x + step_size * directions(i, :);

            if candidate(1) >= bounds(1, 1) && candidate(1) <= bounds(1, 2) && ...
               candidate(2) >= bounds(2, 1) && candidate(2) <= bounds(2, 2)
           
                f_val = func(candidate(1), candidate(2)); 

                if f_val < f_next_min
                    next_point = candidate;
                    f_next_min = f_val;
                end
            end
        end

        if f_next_min < f_min
            x = next_point;
            f_min = f_next_min;
            path = [path; x];

            plot(x(1), x(2), 'bo', 'MarkerSize', 8, 'MarkerFaceColor', 'b');
            plot(path(:, 1), path(:, 2), 'k-', 'LineWidth', 1.5);
            pause(0.5);
        else
            step_size = step_size / 2;
        end
    end

    x_opt = x; 

    plot(x(1), x(2), 'go', 'MarkerSize', 10, 'MarkerFaceColor', 'g');
    text(x(1), x(2), 'Optimal', 'VerticalAlignment', 'top', 'HorizontalAlignment', 'left');
    hold off;

    disp(['Optimal point: (', num2str(x_opt(1)), ', ', num2str(x_opt(2)), ')']);
    disp(['Minimum function value: ', num2str(f_min)]);
end


% func1 = @(x, y) 2*x.^2 + 3*y.^2 - 3*x.*y + x;
% x0 = [5, 8];
% bounds = [-2, 8; -2, 8];
% step_size = 1;
% tol = 1e-6;
% [x_opt, f_min] = pattern_search_visual(func1, x0, bounds, step_size, tol);


% func2 = @(x, y) (1 - x).^2 + 5*(x - y.^2).^2;
% x0 = [0, 0];
% bounds = [-0.5, 1.5; -0.5, 1.5];
% step_size = 0.1;
% tol = 1e-6;
% [x_opt, f_min] = pattern_search_visual(func2, x0, bounds, step_size, tol);

% func3 = @(x, y) (x + 2*y) .* (1 - 0.9 * exp(-0.3 * (x - 2.5).^2 - 2 * (y - 3.5).^2)).* (1 - 0.9 * exp(-(x - 3).^2 - (y - 3).^2));
% x0 = [4, 2];
% bounds = [1, 5; 1, 5];
% step_size = 0.5;
% tol = 1e-6;
% [x_opt, f_min] = pattern_search_visual(func3, x0, bounds, step_size, tol);
% 
func4 = @(x, y) exp(x / 5) + exp(y / 3);
x0 = [5, 8];
bounds = [-10, 10; -10, 10];
step_size = 1;
tol = 1e-6;
[x_opt, f_min] = pattern_search_visual(func4, x0, bounds, step_size, tol);
