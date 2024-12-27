plotXYFromMATAndRotate("Exercise2_Rotate.mat",12432664)
function plotXYFromMATAndRotate(filename, SID)
    data = load(filename);
    if isfield(data, 'x') && isfield(data, 'y')
        x = data.x;
        y = data.y;
    else
        error('MAT文件中未找到 x 或 y 字段');
    end
    angle = mod(SID, 360);
    theta = -angle * pi / 180;  

    R = [cos(theta), -sin(theta); sin(theta), cos(theta)];
    rotated_coords = R * [x(:)'; y(:)'];
    x_rotated = rotated_coords(1, :);
    y_rotated = rotated_coords(2, :);
    % 绘制旋转前的图
    figure;
    subplot(1, 2, 1); 
    plot(x, y, 'LineWidth', 2);
    title('Original X-Y Plot');
    xlabel('X-axis');
    ylabel('Y-axis');
    xlim([-2, 2]);
    ylim([-1, 2]); 
    grid on;

    % 绘制旋转后的图
    subplot(1, 2, 2);
    plot(x_rotated, y_rotated, 'LineWidth', 2, 'Color', 'r');
    title(['Rotated X-Y Plot by ', num2str(angle), '° Clockwise']);
    xlabel('X-axis');
    ylabel('Y-axis');
    xlim([-2, 2]);
    ylim([-1, 2]);
    grid on;
end



