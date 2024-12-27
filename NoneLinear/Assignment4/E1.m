function golden_ratio_search_with_visual(func, left_bound, right_bound, tolerance)
    phi = (1 + sqrt(5)) / 2;
    figure;
    hold on;
    fplot(func, [left_bound, right_bound]);
    xlabel('x');
    ylabel('f(x)');
    title('Golden Ratio Search Process');
    
    left = left_bound;
    right = right_bound;
    mid1 = right - (right - left) / phi;
    mid2 = left + (right - left) / phi;
    val1 = func(mid1);
    val2 = func(mid2);

    iteration = 0;

    while (right - left) > tolerance
        iteration = iteration + 1;
        fprintf('Iteration %d: left = %.4f, mid1 = %.4f, mid2 = %.4f, right = %.4f, val1 = %.4f, val2 = %.4f\n', ...
            iteration, left, mid1, mid2, right, val1, val2);
        
        plot([left, left], [func(left), func(left)], 'rx');
        plot([mid1, mid1], [func(mid1), func(mid1)], 'bo');
        plot([mid2, mid2], [func(mid2), func(mid2)], 'bo');
        plot([right, right], [func(right), func(right)], 'rx');
        drawnow;
        
        if val1 > val2
            left = mid1;
            mid1 = mid2;
            val1 = val2;
            mid2 = left + (right - left) / phi;
            val2 = func(mid2);
        else
            right = mid2;
            mid2 = mid1;
            val2 = val1;
            mid1 = right - (right - left) / phi;
            val1 = func(mid1);
        end
    end
    
    plot([left, right], [func(left), func(right)], 'g', 'LineWidth', 2);
    hold off;
    x_min = (left + right) / 2;
    f_min = func(x_min);
    fprintf('Minimum found at x = %.5f with f(x) = %.5f after %d iterations.\n', x_min, f_min, iteration);
end

func1 = @(x) (x - 2).^2;
golden_ratio_search_with_visual(func1, 0, 10, 1e-3);

func2 = @(x) x.^2 + 3*exp(-2*x);
golden_ratio_search_with_visual(func2, 0, 10, 1e-3);
