function main()
    % files = {'Problem1_n=2.mat', 'Problem1_n=3.mat', 'Problem1_n=4.mat', 'Problem1_n=5.mat'};
    files = {'Problem1_n=5.mat'};

    for i = 1:length(files)
        dataStruct = load(files{i});
        sample_points = dataStruct.data;
        lb = dataStruct.lb;
        ub = dataStruct.ub;
        
        uniformity_measure(sample_points, lb, ub);

        dims = size(sample_points, 2);
        for j = 1:dims-1
            for k = j+1:dims
                visualize_2D(sample_points(:, [j, k]), [lb(j), lb(k)], [ub(j), ub(k)], j, k);
            end
        end
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

function visualize_2D(points, lb, ub, dim1, dim2)
    figure; % Create a new figure window
    scatter(points(:, 1), points(:, 2), 'filled');
    xlim([lb(1), ub(1)]);
    ylim([lb(2), ub(2)]);
    title(['2D Projection: Dim ' num2str(dim1) ' vs Dim ' num2str(dim2)]);
end

main();
