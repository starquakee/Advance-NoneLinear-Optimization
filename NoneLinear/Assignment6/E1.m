rosenbrock = @(x) sum(100 * (x(2:end) - x(1:end-1).^2).^2 + (1 - x(1:end-1)).^2);
ackley = @(x) -20 * exp(-0.2 * sqrt(mean(x.^2))) - exp(mean(cos(2 * pi * x))) + 20 + exp(1);
fp = @(x) sum(x.^4 - 16 * x.^2 + 5 * x);

grad = @(f, x) (f(x + 1e-5) - f(x)) / 1e-5;

runs = 5;
tol = 1e-6;
max_iters = 100;

ranges = {
    [-2, 2],
    [-2, 2],
    [-10, 10]
};
dimensions = [2, 2, 2];

for func_idx = 1:3
    if func_idx == 1
        func = rosenbrock;
        name = 'Rosenbrock';
    elseif func_idx == 2
        func = fp;
        name = 'f_p';
    else
        func = ackley;
        name = 'Ackley';
    end
    
    fprintf('\nTesting %s Function\n', name);
    range = ranges{func_idx};
    dim = dimensions(func_idx);
    
    for run = 1:runs
        x = range(1) + (range(2) - range(1)) * rand(1, dim);
        best_val = func(x);
        evals = 0;
        
        for iter = 1:max_iters
            g = grad(func, x);
            x = x - 0.01 * g;
            
            val = func(x);
            evals = evals + 1;
            if val < best_val
                best_val = val;
            end
            
            if norm(g) < tol
                break;
            end
        end
        
        fprintf('Run %d: Best Value = %.6f, Function Evaluations = %d\n', run, best_val, evals);
    end
end
