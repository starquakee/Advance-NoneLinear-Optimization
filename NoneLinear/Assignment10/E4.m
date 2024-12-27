close all;
clear;

main(3, false);
main(5, true);
main(7, true);
main(10, false);
main(13, true);

function f=E4_function(x)
f=2*exp(-norm(x+[1 1]')^2)+4*exp(-norm(x-[1 2]')^2)+3*exp(-norm(x+[2 -3]')^2)+x(1)^2/3-x(2)^2/4;
end

function [] = main(N, draw)
    div = 6 / (N - 1);
    N = N * N;
    [xs, ys] = meshgrid(-3:div:3, -3:div:3);
    xs = xs(:); ys = ys(:);
    fs = arrayfun(@(x, y) E4_function([x, y]), xs, ys)';
    fs = fs(:);
    d = pdist2([xs, ys], [xs, ys], 'squaredeuclidean');
    Phi = exp(-d);
    lmd = Phi \ fs;
    s = @(x, y) sum(lmd .* exp(-((x - xs) .^ 2 + (y - ys) .^ 2)));
    
    if draw
        [xs1, ys1] = meshgrid(-3:0.1:3, -3:0.1:3);
        fs1 = arrayfun(s, xs1, ys1);
        figure;
        surf(xs1, ys1, fs1);
        colormap('jet'); 
        hold on;
        scatter3(xs, ys, fs, 50, 'MarkerEdgeColor', 'r', 'MarkerFaceColor', 'y');
        view(51, 47);
        hold off;
        title(sprintf('RBF Interpolation with %d Points', N));
    end
    
    samples = lhsamp(100, 2);
    samples = 6 * samples - 3;
    diffs = arrayfun(@(x, y) s(x, y) - E4_function([x, y]), samples(:,1), samples(:,2));
    fprintf('LS error(%d points) = %f\n', N, sum(diffs .^ 2));
end
