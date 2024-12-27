%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% Course: Nonlinear Optimization. 2024. FALL
% Lab: 3
% Problem: 1
% Date: 2024.10.07
% By: 冯晨晨
% ID NUMBER: 12432664
% Description: Draw vehicle moving video
%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
figure;
axis([0 10 0 5]);
hold on;

% Vehicle parameters
vehicleLength = 2;
vehicleHeight = 1;
wheelRadius = 0.2;
xPosStart = 1; 
xPosEnd = 8;   
yPos = 1;    

v = VideoWriter('Exercise1', 'MPEG-4');
open(v);

plot([0 10], [0.5 0.5], 'k', 'LineWidth', 3);
for xPos = linspace(xPosStart, xPosEnd, 100)
    % Draw vehicle body
    body = rectangle('Position', [xPos, yPos, vehicleLength, vehicleHeight], ...
                     'FaceColor', [0.7 0 0], 'EdgeColor', 'k');
    
    % Draw wheels
    wheel1 = rectangle('Position', [xPos+0.2, yPos-0.2, wheelRadius, wheelRadius], ...
                       'Curvature', [1 1], 'FaceColor', [0.7 0 0], 'EdgeColor', 'k');
    wheel2 = rectangle('Position', [xPos+vehicleLength-0.4, yPos-0.2, wheelRadius, wheelRadius], ...
                       'Curvature', [1 1], 'FaceColor', [0.7 0 0], 'EdgeColor', 'k');

    frame = getframe(gcf);
    writeVideo(v, frame);
    
    % Pause and delete previous vehicle for the next frame
    pause(0.05);
    delete(body);
    delete(wheel1);
    delete(wheel2);
end

close(v);

disp('Animation saved as Exercise1.mp4');
