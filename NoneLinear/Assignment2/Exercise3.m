x = [0, 2, 2.8, 4, 5, 6, 7];
y = [0, -1, 5, 2, -1, 5, 8];
plot_polynomial(x, y);

function plot_polynomial(x, y)
    if length(x) ~= length(y)
        error('输入的 x 和 y 长度必须一致');
    end

    p = polyfit(x, y, 5);
    disp(p);
    
    dp = polyder(p);
    
    x_fit = linspace(min(x), max(x), 1000);
    y_fit = polyval(p, x_fit);
    y_deriv = polyval(dp, x_fit);
    critical_points = roots(dp);
    critical_points = critical_points(imag(critical_points) == 0);
    critical_values = polyval(p, critical_points);
    for i = 1:length(critical_points)
        d2p = polyder(dp); 
        second_derivative_at_cp = polyval(d2p, critical_points(i));
        
        if second_derivative_at_cp > 0
            fprintf('极小值: x = %.4f, y = %.4f\n', critical_points(i), critical_values(i));
        elseif second_derivative_at_cp < 0
            fprintf('极大值: x = %.4f, y = %.4f\n', critical_points(i), critical_values(i));
        end
    end
    figure;
    hold on;

    plot(x, y, 'bo', 'MarkerFaceColor', 'b', 'DisplayName', 'Data Points');
    plot(x_fit, y_fit, 'r-', 'LineWidth', 2, 'DisplayName', '5th Order Polynomial');
    plot(x_fit, y_deriv, 'g--', 'LineWidth', 2, 'DisplayName', '1st Derivative');
    plot(critical_points, critical_values, 'ko', 'MarkerFaceColor', 'y', 'DisplayName', 'Minima/Maxima');
    
    xlabel('x');
    ylabel('y');
    title('5th Order Polynomial and its Derivative');
    legend('show', 'Location', 'southeast');
    grid on;
    hold off;
end
