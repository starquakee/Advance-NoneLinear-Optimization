plot_3d_with_image('logo.png')

function plot_3d_with_image(name)
    img = imread(name);
    [X, Y] = meshgrid(1:size(img, 2), 1:size(img, 1));
    Z = 10 * sin(X/10) .* cos(Y/10); 
    surf(X, Y, Z, 'FaceColor', 'texturemap', 'CData', img, 'EdgeColor', 'none');
    view(3);
    xlabel('X-axis');
    ylabel('Y-axis');
    zlabel('Z-axis');
    title('3D Surface with Image as Texture');
   
    axis equal;
    rotate3d on;
end


