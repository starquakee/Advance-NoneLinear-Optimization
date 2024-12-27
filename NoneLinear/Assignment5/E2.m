function f = objective_function(x)
    n = length(x); 
    f = exp(sum(x ./ (1:n)')); 
end

function run_fmincon_optimization()
    dimensions = [2, 3, 4, 20]; 
    options = optimoptions('fmincon', 'Display', 'off', 'Algorithm', 'interior-point', 'TolFun', 1e-10);

    for n = dimensions
        fprintf('\n--- Dimension n = %d ---\n', n);
        x0 = zeros(n, 1);
        A = [];
        b = [];
        Aeq = [];
        beq = [];
        lb = [];
        ub = [];
        nonlcon = @(x) norm_constraint(x);

        [x_opt, fval, exitflag, output] = fmincon(@objective_function, x0, A, b, Aeq, beq, lb, ub, nonlcon, options);
        
        fprintf('Optimal value: %.6e, Function evaluations: %d\n', fval, output.funcCount);
    end
end

function [c, ceq] = norm_constraint(x)
    c = norm(x) - 1;
    ceq = []; 
end
run_fmincon_optimization();
