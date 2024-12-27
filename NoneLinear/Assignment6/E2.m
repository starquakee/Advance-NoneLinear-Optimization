rosenbrock = @(x) sum(100 * (x(2:end) - x(1:end-1).^2).^2 + (1 - x(1:end-1)).^2);
ackley = @(x) -20 * exp(-0.2 * sqrt(mean(x.^2))) - exp(mean(cos(2 * pi * x))) + 20 + exp(1);
fp = @(x) sum(x.^4 - 16 * x.^2 + 5 * x);

runs = 1;
iterations = 30;
ranges = {
    [-2, 2],
    [-2, 2],
    [-10, 10]
};
dimensions = [2, 2, 2];

for func_idx = 1:3
    if func_idx == 1
        func = rosenbrock;
        func_name = 'Rosenbrock';
    elseif func_idx == 2
        func = fp;
        func_name = 'f_p';
    else
        func = ackley;
        func_name = 'Ackley';
    end

    fprintf('\nTesting %s Function\n', func_name);
    range = ranges{func_idx};
    dim = dimensions(func_idx);

    for run = 1:runs
        basic_best_val = inf;
        evals_basic = 0;

        for iter = 1:iterations
            x_basic = range(1) + (range(2) - range(1)) * rand(1, dim);
            val_basic = func(x_basic);
            evals_basic = evals_basic + 1;

            if val_basic < basic_best_val
                basic_best_val = val_basic;
            end

            fprintf('%s - Basic Search, Iter %d: Best Value = %.5f, Evaluations = %d\n', func_name, iter, basic_best_val, evals_basic);
        end

        smart_best_val = inf;
        evals_smart = 0;
        center = range(1) + (range(2) - range(1)) * rand(1, dim);

        for iter = 1:iterations
            radius = 0.5 * (range(2) - range(1)) * (1 - iter / iterations);
            x_smart = center + radius * (2 * rand(1, dim) - 1);
            val_smart = func(x_smart);
            evals_smart = evals_smart + 1;

            if val_smart < smart_best_val
                smart_best_val = val_smart;
                center = x_smart;
            end

            fprintf('%s - Smart Search, Iter %d: Best Value = %.5f, Evaluations = %d\n', func_name, iter, smart_best_val, evals_smart);
        end
    end
end
