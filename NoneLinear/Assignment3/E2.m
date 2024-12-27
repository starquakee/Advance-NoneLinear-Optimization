% %+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% % Course: Nonlinear Optimization. 2024. FALL
% % Lab: 3
% % Problem: 2
% % Date: 2024.10.07
% % By: 冯晨晨
% % ID NUMBER: 12432664
% % Description: Travelling Salesman Problem (TSP)
% %+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% clear;
% clc;
% close all;
% 
% load 'city_position.mat'
% city = data; 
% N = size(city, 1);
% 
% city_index = 1:N;
% route = [city(city_index, :); city(city_index(1), :)];
% rl = routelength(route);
% 
% function total_length = routelength(route)
%     diffs = diff(route);
%     distances = sqrt(sum(diffs.^2, 2));
%     total_length = sum(distances);
% end
% 
% figure;
% scatter(route(:,1), route(:,2), 18, 'black');
% hold on;
% plot(route(:,1), route(:,2), 'blue');
% ttl = "Route length = " + rl;
% title(ttl)
% hold off;
% axis([0 100 0 100]);
% pause(1e-4);
% 
% minrl = rl; 
% minroute = route; 
% min_city_index = city_index;
% 
% iter = 0;
% max_iter = 500; % Maximum number of iterations
% 
% while true
%     iter = iter + 1;
%     if iter > max_iter
%         break;
%     end
% 
%     % Randomly swap two cities in city_index
%     new_city_index = min_city_index;
%     % Select two different random indices between 1 and N
%     idx = randperm(N,2);
%     i = idx(1);
%     j = idx(2);
%     % Swap the cities
%     temp = new_city_index(i);
%     new_city_index(i) = new_city_index(j);
%     new_city_index(j) = temp;
%     % Create the new route
%     route = [city(new_city_index, :); city(new_city_index(1), :)];
%     % Compute the route length
%     rl = routelength(route);
% 
%     if rl < minrl
%         minrl = rl;
%         min_city_index = new_city_index;
%         minroute = route;
%         scatter(minroute(:,1), minroute(:,2), 18, 'black');
%         hold on;
%         plot(minroute(:,1), minroute(:,2), 'blue');
%         ttl = "Route length = " + minrl;
%         title(ttl)
%         hold off;
%         pause(1e-4);
%     end
% end
clear;
clc;
close all;

% Load city positions from 'city_position.mat'
load('city_position.mat')
city = data;

% Parameters
population_size = 100;
num_generations = 500;
mutation_rate = 0.1;
elite_size = 5; % Number of top routes to keep each generation

% Initialize population
population = initialize_population(population_size, city);

% Main evolutionary loop
for generation = 1:num_generations
    % Calculate fitness (route lengths)
    fitness = calculate_fitness(population);

    % Sort population by fitness (shortest route first)
    [fitness, sorted_idx] = sort(fitness);
    population = population(sorted_idx);
    
    % Elitism: Keep the best routes
    new_population = population(1:elite_size);

    % Crossover and mutation to create the rest of the population
    while length(new_population) < population_size
        % Select two parents using tournament selection
        parent1 = tournament_selection(population, fitness);
        parent2 = tournament_selection(population, fitness);

        % Crossover
        child = crossover(parent1, parent2);

        % Mutation
        if rand < mutation_rate
            child = mutate(child);
        end
        
        % Add the child to the new population
        new_population{end+1} = child;
    end

    % Update population
    population = new_population;

    % Display the best route of this generation
    best_route = population{1};
    best_length = fitness(1);
    plot_route(best_route, best_length);
    pause(1e-4);

    % Adaptive mutation rate adjustment
    if mod(generation, 50) == 0
        mutation_rate = adjust_mutation_rate(mutation_rate, fitness);
    end
end

% Function to initialize population
function population = initialize_population(pop_size, city)
    population = cell(1, pop_size);
    for i = 1:pop_size
        route = city(randperm(size(city, 1)), :);
        population{i} = [route; route(1,:)]; % closed route
    end
end

% Function to calculate fitness (route length for each individual)
function fitness = calculate_fitness(population)
    fitness = zeros(1, length(population));
    for i = 1:length(population)
        fitness(i) = routelength(population{i});
    end
end

% Tournament selection function
function parent = tournament_selection(population, fitness)
    tournament_size = 5;
    selected = randperm(length(population), tournament_size);
    [~, best_idx] = min(fitness(selected));
    parent = population{selected(best_idx)};
end

% Crossover function
function child = crossover(parent1, parent2)
    % Implement order crossover (OX) or another suitable method
    N = size(parent1, 1) - 1;
    idx = sort(randperm(N, 2));
    child = parent1;
    child(idx(1):idx(2), :) = parent2(idx(1):idx(2), :);
    
    % Fix any duplicate cities by filling with missing cities from parent1
    for i = 1:N
        if sum(ismember(child(1:N, :), child(i, :), 'rows')) > 1
            missing = setdiff(parent1(1:N, :), child(1:N, :), 'rows');
            child(i, :) = missing(1, :);
        end
    end
    child(end, :) = child(1, :); % Close the route
end

% Mutation function (swaps two cities)
function route = mutate(route)
    N = size(route, 1) - 1;
    idx = randperm(N, 2);
    temp = route(idx(1), :);
    route(idx(1), :) = route(idx(2), :);
    route(idx(2), :) = temp;
    route(end, :) = route(1, :); % Close the route
end

% Adjust mutation rate based on population diversity
function mutation_rate = adjust_mutation_rate(mutation_rate, fitness)
    diversity = std(fitness);
    if diversity < 10
        mutation_rate = min(mutation_rate + 0.01, 0.3);
    else
        mutation_rate = max(mutation_rate - 0.01, 0.05);
    end
end

% Plot the route
function plot_route(route, route_length)
    scatter(route(:,1), route(:,2), 18, 'black');
    hold on;
    plot(route(:,1), route(:,2), 'blue');
    ttl = "Route length = " + route_length;
    title(ttl)
    hold off;
    axis([0 100 0 100]);
end

% Define the routelength function (updated to include return distance)
function length = routelength(route)
    length = 0;
    for i = 1:(size(route, 1) - 1)
        length = length + norm(route(i+1, :) - route(i, :));
    end
    % Add distance from last city back to the first
    length = length + norm(route(end, :) - route(1, :));
end
