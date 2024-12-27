function apply_newtons_method(func, deriv, start_point, tolerance, max_iterations)
    current_x = start_point;
    iteration_count = 0;
    difference = Inf;

    figure;
    hold on;
    fplot(@(x) func(x), [0, 10], 'LineWidth', 1.5); 
    xlabel('x');
    ylabel('f(x)');
    title('Newton''s Method');
    
    while difference > tolerance && iteration_count < max_iterations
        iteration_count = iteration_count + 1;
        next_x = current_x - func(current_x) / deriv(current_x);
        
        slope = deriv(current_x);
        tangent = @(x) func(current_x) + slope * (x - current_x);
        fplot(tangent, [current_x - 1, current_x + 1], 'r-');
        
        plot(current_x, func(current_x), 'ro');
        
        difference = abs(next_x - current_x);
        fprintf('Iteration %d: x = %.10f, f(x) = %.10f, diff = %.10f\n', iteration_count, current_x, func(current_x), difference);
        
        current_x = next_x; 
    end
    
    plot(current_x, func(current_x), 'go'); 
    hold off;

    fprintf('Solution: x = %.10f after %d iterations, f(x) = %.10f\n', current_x, iteration_count, func(current_x));
end

% Test Case A: f(x) = x^2, initial guess x = 5
test_func1 = @(x) x.^2; 
test_deriv1 = @(x) 2.*x; 
apply_newtons_method(test_func1, test_deriv1, 5, 1e-5, 50);

% Test Case B: f(x) = log(x), initial guess x = 0.1
test_func2 = @(x) log(x); 
test_deriv2 = @(x) 1./x;  
apply_newtons_method(test_func2, test_deriv2, 0.1, 1e-5, 50);

% Test Case C: f(x) = x^4, initial guess x = 5
test_func3 = @(x) x.^4; 
test_deriv3 = @(x) 4.*x.^3; 
apply_newtons_method(test_func3, test_deriv3, 5, 1e-5, 50);

% Test Case D: f(x) = sqrt(x) - 2, initial guess x = 10
test_func4 = @(x) sqrt(x) - 2;
test_deriv4 = @(x) 1./(2.*sqrt(x)); 
apply_newtons_method(test_func4, test_deriv4, 10, 1e-5, 50);
