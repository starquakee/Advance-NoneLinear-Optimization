gram_schmidt_demo([[1 2 3 4]',[2,3,4,1]',[1,1,1,1]'])
function orthonormal_basis = gram_schmidt_demo(vectors)
    [n, k] = size(vectors);
    orthonormal_basis = zeros(n, k);
    for i = 1:k
        t = vectors(:, i);
        for j = 1:i-1
            t = t - (dot(vectors(:, i), orthonormal_basis(:, j)) * orthonormal_basis(:, j));
        end
        orthonormal_basis(:, i) = t / norm(t);
    end
    if n == 2 && k >= 2
        figure;
        hold on;
        grid on;
        quiver(0, 0, vectors(1, 1), vectors(2, 1), 'b', 'LineWidth', 2, 'DisplayName', 'v1');
        quiver(0, 0, vectors(1, 2), vectors(2, 2), 'b', 'LineWidth', 2, 'DisplayName', 'v2');
        quiver(0, 0, orthonormal_basis(1, 1), orthonormal_basis(2, 1), 'r', 'LineWidth', 2, 'DisplayName', 'e1');
        quiver(0, 0, orthonormal_basis(1, 2), orthonormal_basis(2, 2), 'r', 'LineWidth', 2, 'DisplayName', 'e2');
        xlim([-2.5, 2.5]);
        ylim([-2.5, 2.5]);
        xlabel('X-axis');
        ylabel('Y-axis');
        title('Gram-Schmidt Orthonormalization');
        legend show;
        axis equal;
        hold off;
    end
end
