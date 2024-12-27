function f = rosenbrock(x)
    f = sum((1 - x(1:end-1)).^2 + 100 * (x(2:end) - x(1:end-1).^2).^2);
end

function [x_opt, fval, func_evals] = optimize_with_fminunc(n)
    x0 = zeros(n, 1);
    options = optimoptions('fminunc', 'Display', 'off', 'TolFun', 1e-10, 'Algorithm', 'quasi-newton');
    [x_opt, fval, ~, output] = fminunc(@rosenbrock, x0, options);
    func_evals = output.funcCount;
end

function [x_opt, fval, func_evals] = optimize_with_fminsearch(n)
    x0 = zeros(n, 1);
    options = optimset('Display', 'off', 'TolFun', 1e-10);
    [x_opt, fval, ~, output] = fminsearch(@rosenbrock, x0, options);
    func_evals = output.funcCount;
end

dimensions = [3, 5, 10];

for n = dimensions
    fprintf('\n--- Dimension n = %d ---\n', n);
    [x_opt_u, fval_u, evals_u] = optimize_with_fminunc(n);
    fprintf('fminunc: Function evaluations = %d, Final value = %.2e\n', evals_u, fval_u);
    [x_opt_s, fval_s, evals_s] = optimize_with_fminsearch(n);
    fprintf('fminsearch: Function evaluations = %d, Final value = %.2e\n', evals_s, fval_s);
end
