clear;
clc;
close all;

load('city_position.mat');
city = data;

pop_size = 20;
mutation_rate = 0.1;
max_generations = 500;
elite_size = 5;
N = size(city, 1);

population = initialize_population(pop_size, city);

for gen = 1:max_generations
    fitness = calculate_fitness(population);
    [fitness, sorted_idx] = sort(fitness);
    population = population(sorted_idx);
    new_population = population(1:elite_size);

    while length(new_population) < pop_size
        parent1 = tournament_selection(population, fitness);
        parent2 = tournament_selection(population, fitness);
        child = crossover(parent1, parent2, N);

        if rand < mutation_rate
            child = mutate(child);
        end

        new_population{end + 1} = child;
    end

    population = new_population;

    if mod(gen, 50) == 0
        mutation_rate = adjust_mutation_rate(mutation_rate, fitness);
    end

    best_route = population{1};
    best_length = fitness(1);
    plot_route(best_route, best_length, gen);
    pause(1e-4);
end

function population = initialize_population(pop_size, city)
    population = cell(1, pop_size);
    for i = 1:pop_size
        route = city(randperm(size(city, 1)), :);
        population{i} = [route; route(1,:)];
    end
end

function fitness = calculate_fitness(population)
    fitness = zeros(1, length(population));
    for i = 1:length(population)
        fitness(i) = routelength(population{i});
    end
end

function parent = tournament_selection(population, fitness)
    tournament_size = 5;
    selected = randperm(length(population), tournament_size);
    [~, best_idx] = min(fitness(selected));
    parent = population{selected(best_idx)};
end

function child = crossover(parent1, parent2, N)
    idx = sort(randperm(N, 2));
    child = parent1;
    child(idx(1):idx(2), :) = parent2(idx(1):idx(2), :);

    for i = 1:N
        if sum(ismember(child(1:N, :), child(i, :), 'rows')) > 1
            missing = setdiff(parent1(1:N, :), child(1:N, :), 'rows');
            child(i, :) = missing(1, :);
        end
    end
    child(end, :) = child(1, :);
end

function route = mutate(route)
    N = size(route, 1) - 1;
    idx = randperm(N, 2);
    temp = route(idx(1), :);
    route(idx(1), :) = route(idx(2), :);
    route(idx(2), :) = temp;
    route(end, :) = route(1, :);
end

function mutation_rate = adjust_mutation_rate(mutation_rate, fitness)
    diversity = std(fitness);
    if diversity < 10
        mutation_rate = min(mutation_rate + 0.01, 0.3);
    else
        mutation_rate = max(mutation_rate - 0.01, 0.05);
    end
end

function plot_route(route, route_length, generation)
    scatter(route(:,1), route(:,2), 18, 'black');
    hold on;
    plot(route(:,1), route(:,2), 'blue');
    ttl = sprintf("Generation: %d, Route length = %.2f", generation, route_length);
    title(ttl);
    hold off;
    axis([0 100 0 100]);
end

function length = routelength(route)
    length = 0;
    for i = 1:(size(route, 1) - 1)
        length = length + norm(route(i+1, :) - route(i, :));
    end
    length = length + norm(route(end, :) - route(1, :));
end
