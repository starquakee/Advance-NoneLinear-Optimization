function main()
    lb = [0, 0]; % Lower bounds for 2D case
    ub = [1, 1]; % Upper bounds for 2D case
    N_values = [50, 100, 200]; % Number of points
    dims_list = [2, 3]; % Dimensions to test

    for n = dims_list
        lb = zeros(1, n);
        ub = ones(1, n);
        for i = 1:length(N_values)
            N = N_values(i);
            points = latin_hypercube_sampling(lb, ub, N);
            visualize_sampling(points, lb, ub, ['Latin Hypercube Sampling: N = ', num2str(N), ', n = ', num2str(n)]);
        end
    end
end

function points = latin_hypercube_sampling(lb, ub, N)
    dims = length(lb);
    points = zeros(N, dims);
    for d = 1:dims
        intervals = linspace(lb(d), ub(d), N+1);
        for i = 1:N
            points(i, d) = intervals(i) + rand * (intervals(i+1) - intervals(i));
        end
        points(:, d) = points(randperm(N), d);
    end
end

function visualize_sampling(points, lb, ub, title_text)
    figure;
    scatter(points(:, 1), points(:, 2), 'filled');
    xlim([lb(1), ub(1)]);
    ylim([lb(2), ub(2)]);
    title(title_text);
end



main();
