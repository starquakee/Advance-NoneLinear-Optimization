close all
clear all

main(20);
main(50);
main(100);
main(200);
main(500);

function [] = main(N)
    lb = [0.5, 0.5, 0.5];
    xs = lhsamp(N, 3);
    xs = xs + lb;
    testX = rand(10, 3) + lb;
    
    testY = [];  
    realY = [];
    
    for t = 0 : 0.1 : 2
        ft = @(x) exercise_5_function(x, t);
        fs = splitapply(ft, xs', 1:N);
        model = dacefit(xs, fs, @regpoly0, @corrgauss, 0.5);
        testY = [testY, predictor(testX, model)];
        realY = [realY, splitapply(ft, testX', 1:10)'];
    end
    
    figure;
    hold on;
    plot(0:0.1:2, testY, 'b-', 'LineWidth', 2);
    scatter(0:0.1:2, realY, 50, 'k', 'filled');
    
    xlabel('Time (t)', 'FontSize', 12);
    ylabel('Y', 'FontSize', 12);
    title(['Kriging Model Predictions vs Real Values (N = ' num2str(N) ')'], 'FontSize', 14);
    
    ls_error = sum((realY - testY) .^ 2, 'all');
    fprintf('LS error(%d points)=%f\n', N, ls_error);
    
    hold off;
end

function R = exercise_5_function(x, omega)
    for j = 1:length(omega)
        R(j) = x(3)^2 / sqrt((x(3)^2 - omega(j)^2 * x(1) * x(2))^2 + (omega(j) * x(1) * x(3))^2);
    end
    R = R';
end
