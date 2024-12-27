function main()
    files = [20, 50, 100];
    stratified_files = [25, 49, 100];
    lb = zeros(1, 2);
    ub = ones(1, 2);

    for i = 1:length(files)
        N = files(i);
        points = random_sampling(lb, ub, N);
        visualize_2D(points, lb, ub, ['Random Sampling, N = ', num2str(N)]);
        uniformity_measure(points, lb, ub);
    end

    for i = 1:length(stratified_files)
        N = stratified_files(i);
        points = stratified_random_sampling(lb, ub, N);
        visualize_2D(points, lb, ub, ['Stratified Sampling, N = ', num2str(N)]);
        uniformity_measure(points, lb, ub);
    end
end

function points = random_sampling(lb, ub, N)
    dims = length(lb);
    points = rand(N, dims) .* (ub - lb) + lb;
end

function points = stratified_random_sampling(lb, ub, N)
    dims = length(lb);
    grid_size = round(N^(1/dims));
    linspace_cell = cell(1, dims);

    for i = 1:dims
        linspace_cell{i} = linspace(lb(i), ub(i), grid_size + 1);
    end

    points = zeros(grid_size^dims, dims);
    idx = 1;
    for i = 1:grid_size
        for j = 1:grid_size
            x = linspace_cell{1}(i) + rand * (linspace_cell{1}(i+1) - linspace_cell{1}(i));
            y = linspace_cell{2}(j) + rand * (linspace_cell{2}(j+1) - linspace_cell{2}(j));
            points(idx, :) = [x, y];
            idx = idx + 1;
        end
    end

    if size(points, 1) > N
        points = points(randperm(size(points, 1), N), :);
    end
end

function uniformity_measure(points, lb, ub)
    ranges = ub - lb;
    normalized_points = (points - lb) ./ ranges;
    num_points = size(normalized_points, 1);
    distances = zeros(num_points * (num_points - 1) / 2, 1);
    idx = 1;
    for i = 1:num_points-1
        for j = i+1:num_points
            distances(idx) = norm(normalized_points(i, :) - normalized_points(j, :));
            idx = idx + 1;
        end
    end
    uniformity = sum(distances) / numel(distances);
    disp(['Uniformity measure: ', num2str(uniformity)]);
end

function visualize_2D(points, lb, ub, title_text)
    figure;
    scatter(points(:, 1), points(:, 2), 'filled');
    xlim([lb(1), ub(1)]);
    ylim([lb(2), ub(2)]);
    title(title_text);
end

main();
