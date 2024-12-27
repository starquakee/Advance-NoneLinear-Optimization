function f = objfun_f(x)
    sum1 = sum((x - 1/sqrt(8)).^2);
    sum2 = sum((x + 1/sqrt(8)).^2);
    f(1) = 1 - exp(-sum1);
    f(2) = 1 - exp(-sum2);
end

function f = objfun_t(x)
    f(1) = 1 / x(1) * (1 + (x(2)^2 + x(3)^2)^0.25 * (sin(50 * (x(2)^2 + x(3)^2)^0.1)^2 + 1));
    f(2) = x(1);
end

lb_f = -2 * ones(1, 8);
ub_f = 2 * ones(1, 8);
lb_t = [0.5, -2, -2];
ub_t = [1.0, 2, 2];

video_f = VideoWriter('convergence_ff.mp4', 'MPEG-4');
video_t = VideoWriter('convergence_ft.mp4', 'MPEG-4');
open(video_f);
open(video_t);

options_f = optimoptions('gamultiobj', 'Display', 'iter', ...
    'PlotFcn', @(options, state, flag) saveParetoFrame(options, state, flag, video_f));
options_t = optimoptions('gamultiobj', 'Display', 'iter', ...
    'PlotFcn', @(options, state, flag) saveParetoFrame(options, state, flag, video_t));

[x_f, fval_f] = gamultiobj(@objfun_f, 8, [], [], [], [], lb_f, ub_f, options_f);
[x_t, fval_t] = gamultiobj(@objfun_t, 3, [], [], [], [], lb_t, ub_t, options_t);

close(video_f);
close(video_t);

disp('f_f(x) Pareto front:');
disp(fval_f);
disp('f_t(x) Pareto front:');
disp(fval_t);

function state = saveParetoFrame(~, state, flag, video)
    if strcmp(flag, 'iter')
        fig = figure('Visible', 'off');
        plot(state.Score(:, 1), state.Score(:, 2), 'bo');
        xlabel('f1');
        ylabel('f2');
        title('Pareto Front');
        frame = getframe(fig);
        writeVideo(video, frame);
        close(fig);
    end
end
