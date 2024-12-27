close all
rng default
OBS(50, 2);
OBS(100, 2);
OBS(200, 2);

OBS(50, 3);
OBS(100, 3);
OBS(200, 3);
function [] = OBS(N, D)
    lb = zeros(1, D);
    ub = ones(1, D);
    samples = LatinHypercubeSample(N, lb, ub);
    opts = optimset('MaxFunEvals', 1e5, 'MaxIter', 1e6, 'Display', 'none');
    [samples, um] = fmincon(@UniformMeasure, samples, [], [], [], [], ...
                            repmat(lb, [N, 1]), repmat(ub, [N, 1]), [], opts);
    fprintf('%d samples in %d dimensions optimized. Final uniformity: %f.\n', N, D, um);
    ProjectionPlot(samples, lb, ub, N, D, um);
end

function [samples] = LatinHypercubeSample(N, lb, ub)
    D = length(lb);
    samples = zeros(N, D);
    for i = 1 : D
        samples(:, i) = rand(N, 1) ./ N + (randperm(N) - 1)' ./ N;
    end
    fprintf('%d Latin Hypercube samples generated in %d dimensions. Initial uniformity: %f.\n', N, D, UniformMeasure(samples));
    ProjectionPlot(samples, lb, ub, N, D, UniformMeasure(samples));
end

function [um] = UniformMeasure(samples)
    N = size(samples, 1);
    D = size(samples, 2);
    d = (samples(:, 1) - samples(:, 1)') .^ 2;
    for i = 2 : D
        d = d + (samples(:, i) - samples(:, i)') .^ 2;
    end
    d = diag(Inf(N, 1)) + d;
    um = sum(1 ./ d, 'all') / N / N;
end

function [] = ProjectionPlot(samples, lb, ub, N, D, um)
    D = length(lb);
    if D ~= 2
        bestUM = Inf;
        bestPro = []; 
        bestLB = []; 
        bestUB = [];
        for i = 1 : D - 1
            for j = i + 1 : D
                proNow = [samples(:, i), samples(:, j)];
                lbNow = [lb(i), lb(j)]; 
                ubNow = [ub(i), ub(j)];
                UMnow = UniformMeasure(proNow);
                if UMnow < bestUM
                    bestUM = UMnow;
                    bestPro = proNow; 
                    bestLB = lbNow; 
                    bestUB = ubNow;
                end
            end
        end
        samples = bestPro;
        lb = bestLB; 
        ub = bestUB;
    end
    figure;
    scatter(samples(:, 1), samples(:, 2));
    xlim([lb(1), ub(1)]);
    ylim([lb(2), ub(2)]);
    title(sprintf('Sample Distribution\nN = %d, D = %d, Uniformity = %.6f', N, D, um));
    drawnow;
end