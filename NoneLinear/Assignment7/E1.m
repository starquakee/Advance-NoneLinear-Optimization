N = 100;
generations = 200;
mutation_rate = 0.1;
crossover_rate = 0.7;

disp('Rosenbrock Function:');
dimension = 2;
lb = -2; ub = 2;
rosenbrock_func = @(x) sum(100 * (x(2:end) - x(1:end-1).^2).^2 + (1 - x(1:end-1)).^2);
[best_solution_rosen, best_fitness_rosen] = genetic_algorithm(rosenbrock_func, dimension, lb, ub, N, generations, mutation_rate, crossover_rate);
disp('Best Solution for Rosenbrock:');
disp(best_solution_rosen);
disp('Best Fitness for Rosenbrock:');
disp(best_fitness_rosen);

disp('Custom Function f_p:');
dimension = 2;
lb = -2; ub = 2;
custom_func = @(x) sum(x.^2);
[best_solution_fp, best_fitness_fp] = genetic_algorithm(custom_func, dimension, lb, ub, N, generations, mutation_rate, crossover_rate);
disp('Best Solution for f_p:');
disp(best_solution_fp);
disp('Best Fitness for f_p:');
disp(best_fitness_fp);

disp('Ackley Function:');
dimension = 3;
lb = -10; ub = 10;
ackley_func = @(x) -20 * exp(-0.2 * sqrt(mean(x.^2))) - exp(mean(cos(2 * pi * x))) + 20 + exp(1);
[best_solution_ackley, best_fitness_ackley] = genetic_algorithm(ackley_func, dimension, lb, ub, N, generations, mutation_rate, crossover_rate);
disp('Best Solution for Ackley:');
disp(best_solution_ackley);
disp('Best Fitness for Ackley:');
disp(best_fitness_ackley);

function [best_solution, best_fitness] = genetic_algorithm(func, dimension, lb, ub, N, generations, mutation_rate, crossover_rate)
    population = lb + (ub - lb) * rand(N, dimension);
    fitness = arrayfun(@(i) func(population(i, :)), 1:N)';

    for gen = 1:generations
        [~, indices] = sort(fitness);
        population = population(indices, :);
        
        new_population = population;
        for i = 1:2:N-1
            if rand < crossover_rate
                alpha = rand;
                new_population(i, :) = alpha * population(i, :) + (1 - alpha) * population(i + 1, :);
                new_population(i + 1, :) = alpha * population(i + 1, :) + (1 - alpha) * population(i, :);
            end
        end
        
        for i = 1:N
            if rand < mutation_rate
                new_population(i, :) = new_population(i, :) + mutation_rate * randn(1, dimension);
                new_population(i, :) = max(lb, min(ub, new_population(i, :)));
            end
        end
        
        new_fitness = arrayfun(@(i) func(new_population(i, :)), 1:N)';
        
        [population, fitness] = elitism(population, fitness, new_population, new_fitness);
        
        mutation_rate = mutation_rate * exp(randn * 0.05);
    end

    best_solution = population(1, :);
    best_fitness = fitness(1);
end

function [population, fitness] = elitism(pop_old, fit_old, pop_new, fit_new)
    combined_pop = [pop_old; pop_new];
    combined_fit = [fit_old; fit_new];
    [sorted_fit, indices] = sort(combined_fit);
    population = combined_pop(indices(1:size(pop_old, 1)), :);
    fitness = sorted_fit(1:size(pop_old, 1));
end
