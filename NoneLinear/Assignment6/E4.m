function pso_algorithm()
    N = 30; 
    max_iter = 100; 
    c1 = 1.5; 
    c2 = 1.5; 
    w = 0.7;

    func_choice = 1;  
    [objective_func, lb, ub, n] = select_function(func_choice);

    particles = lb + (ub - lb) * rand(N, n);
    velocities = zeros(N, n);

    personal_best = particles;
    personal_best_scores = evaluate_population(particles, objective_func);
    [global_best_score, idx] = min(personal_best_scores);
    global_best = particles(idx, :);

    for iter = 1:max_iter
        for i = 1:N
            r1 = rand(1, n);
            r2 = rand(1, n);
            velocities(i, :) = w * velocities(i, :) + ...
                c1 * r1 .* (personal_best(i, :) - particles(i, :)) + ...
                c2 * r2 .* (global_best - particles(i, :));

            particles(i, :) = particles(i, :) + velocities(i, :);
            particles(i, :) = max(min(particles(i, :), ub), lb);

            score = objective_func(particles(i, :));
            if score < personal_best_scores(i)
                personal_best(i, :) = particles(i, :);
                personal_best_scores(i) = score;
            end

            if score < global_best_score
                global_best = particles(i, :);
                global_best_score = score;
            end
        end
        fprintf('Iteration %d: Best Score = %.6f\n', iter, global_best_score);
    end
end

function [f, lb, ub, n] = select_function(choice)
    if choice == 1
        f = @(x) sum(100 * (x(2:end) - x(1:end-1).^2).^2 + (1 - x(1:end-1)).^2);
        lb = -2; ub = 2; n = 2;
    elseif choice == 2
        f = @(x) sum(x.^2);
        lb = -2; ub = 2; n = 2;
    elseif choice == 3
        f = @(x) -20 * exp(-0.2 * sqrt(mean(x.^2))) - exp(mean(cos(2 * pi * x))) + 20 + exp(1);
        lb = -10; ub = 10; n = 3;
    end
end

function fitness = evaluate_population(particles, objective_func)
    N = size(particles, 1);
    fitness = zeros(N, 1);
    for i = 1:N
        fitness(i) = objective_func(particles(i, :));
    end
end
