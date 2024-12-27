% de_algorithm(); 
randde_algorithm(); 
function randde_algorithm()
    F_range = [0.5, 0.9];  % 变异因子的范围
    CR_range = [0.1, 0.9]; % 交叉概率的范围
    N = 100;                % 种群规模
    max_iter = 100;        % 最大迭代次数

    func_choice = 1;       % 选择目标函数
    [objective_func, lb, ub, n] = select_function(func_choice);

    % 初始化种群
    population = lb + (ub - lb) .* rand(N, n);
    fitness = evaluate_population(population, objective_func);

    % 为每个个体分配随机策略
    F = F_range(1) + (F_range(2) - F_range(1)) * rand(N, 1); % 每个个体的变异因子
    CR = CR_range(1) + (CR_range(2) - CR_range(1)) * rand(N, 1); % 每个个体的交叉概率

    for iter = 1:max_iter
        for i = 1:N
            % 随机选择其他三个个体
            indices = randperm(N, 3);
            while any(indices == i)
                indices = randperm(N, 3);
            end
            x1 = population(indices(1), :);
            x2 = population(indices(2), :);
            x3 = population(indices(3), :);

            % 当前个体的策略
            F_i = F(i);
            CR_i = CR(i);

            % 变异和交叉
            p = randi(n); % 随机选择一个维度
            y = population(i, :); % 初始化子代为当前个体

            for j = 1:n
                if j == p || rand() < CR_i
                    y(j) = x1(j) + F_i * (x2(j) - x3(j));
                end
            end

            % 修正超出边界的解
            y = max(min(y, ub), lb);

            % 适应值评估
            f_y = objective_func(y);
            if f_y < fitness(i)
                population(i, :) = y;
                fitness(i) = f_y;
            end
        end

        % 打印当前最优适应值
        [best_fitness, best_index] = min(fitness);
        fprintf('Iteration %d: Best Fitness = %.5f\n', iter, best_fitness);
    end
end



function de_algorithm()
    F = 0.9;     
    CR = 0.5;  
    N = 20;     
    max_iter = 100; 

    func_choice = 1;
    [objective_func, lb, ub, n] = select_function(func_choice);

    population = lb + (ub - lb) .* rand(N, n);
    fitness = evaluate_population(population, objective_func);

    for iter = 1:max_iter
        for i = 1:N
            indices = randperm(N, 3);
            while any(indices == i)
                indices = randperm(N, 3);
            end
            x1 = population(indices(1), :);
            x2 = population(indices(2), :);
            x3 = population(indices(3), :);

            p = randi(n);  
            y = population(i, :);  

            for j = 1:n
                if j == p || rand() < CR
                    y(j) = x1(j) + F * (x2(j) - x3(j));
                end
            end

            y = max(min(y, ub), lb);

            f_y = objective_func(y);
            if f_y < fitness(i)
                population(i, :) = y;
                fitness(i) = f_y;
            end
        end

        [best_fitness, best_index] = min(fitness);
        fprintf('Iteration %d: Best Fitness = %.5f\n', iter, best_fitness);
    end
end

function [f, lb, ub, n] = select_function(choice)
    switch choice
        case 1  
            % Rosenbrock Function, 放大100倍
            f = @(x) 100 * sum(100 * (x(2:end) - x(1:end-1).^2).^2 + (1 - x(1:end-1)).^2);
            lb = -2; ub = 2; n = 2;
        case 2  
            % Sphere Function, 放大100倍
            f = @(x) 100 * sum(x.^2);
            lb = -2; ub = 2; n = 2;
        case 3  
            % Ackley Function, 放大100倍
            f = @(x) 100 * (-20*exp(-0.2*sqrt(mean(x.^2))) - exp(mean(cos(2*pi*x))) + 20 + exp(1));
            lb = -10; ub = 10; n = 3;
    end
end


function fitness = evaluate_population(population, objective_func)
    N = size(population, 1);
    fitness = zeros(N, 1);
    for i = 1:N
        fitness(i) = objective_func(population(i, :));
    end
end
