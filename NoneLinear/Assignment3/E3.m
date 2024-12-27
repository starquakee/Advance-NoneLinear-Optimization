%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% Course: Nonlinear Optimization. 2024. FALL
% Lab: 3
% Problem: 3
% Date: 2024.10.07
% By: 冯晨晨
% ID NUMBER: 12432664
% Description: BinPackingProblem
%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
clear; clc; close all;

W = 12;
N = 40;

% Generate random rectangle sizes (integers between 1 and 5)
w = randi([1, 5], N, 1); % widths
h = randi([1, 5], N, 1); % heights

rect_order = 1:N;
orientation = zeros(N,1); 

[packed_height, positions] = pack_rectangles(W, w, h, rect_order, orientation);

figure;
subplot(1,2,1);
plot_packing(W, positions, w, h, rect_order, orientation);
title(['Initial Packing (Height = ' num2str(packed_height) ')']);
ylim([0, packed_height]); % Set Y-axis to match the packed height

% Optimization parameters
max_iter = 1000;
best_height = packed_height;
best_order = rect_order;
best_orientation = orientation;

for iter = 1:max_iter
    % Randomly swap two rectangles
    new_order = best_order;
    swap_idx = randperm(N, 2);
    new_order(swap_idx) = new_order(fliplr(swap_idx));
    
    % Randomly change orientation of one rectangle
    new_orientation = best_orientation;
    rotate_idx = randi(N);
    new_orientation(rotate_idx) = ~new_orientation(rotate_idx);
    
    % Try packing with new order and orientation
    [new_height, new_positions] = pack_rectangles(W, w, h, new_order, new_orientation);
    
    % Accept new arrangement if height is reduced
    if new_height < best_height
        best_height = new_height;
        best_order = new_order;
        best_orientation = new_orientation;
        
        % Visualize the improved packing
        clf;
        subplot(1,2,1);
        plot_packing(W, positions, w, h, rect_order, orientation);
        title(['Initial Packing (Height = ' num2str(packed_height) ')']);
        ylim([0, packed_height]);
        
        subplot(1,2,2);
        plot_packing(W, new_positions, w, h, new_order, new_orientation);
        title(['Optimized Packing (Height = ' num2str(best_height) ')']);
        ylim([0, best_height]); 
        axis equal; 
        drawnow;
    end
end

% Final optimized packing
subplot(1,2,2);
plot_packing(W, new_positions, w, h, best_order, best_orientation);
title(['Optimized Packing (Height = ' num2str(best_height) ')']);
ylim([0, best_height]);
axis equal; 

%% Function to pack rectangles with gravity (no floating)
function [total_height, positions] = pack_rectangles(W, w, h, rect_order, orientation)
    N = length(w);
    positions = zeros(N, 2);
    heights_at_x = zeros(1, W); 
    
    for i = 1:N
        idx = rect_order(i);

        if orientation(idx) == 1
            rect_w = h(idx);
            rect_h = w(idx);
        else
            rect_w = w(idx);
            rect_h = h(idx);
        end

        lowest_y = Inf;
        best_x = 0;
        
        for x = 1:(W - rect_w + 1)
            max_height_in_range = max(heights_at_x(x:x+rect_w-1));
            if max_height_in_range < lowest_y
                lowest_y = max_height_in_range;
                best_x = x;
            end
        end
        
        positions(idx, :) = [best_x, lowest_y];
        
        heights_at_x(best_x:best_x+rect_w-1) = lowest_y + rect_h;
    end
    
    total_height = max(heights_at_x);
end

%% Function to plot packing
function plot_packing(W, positions, w, h, rect_order, orientation)
    N = length(w);
    hold on;
    for i = 1:N
        idx = rect_order(i);
        if orientation(idx) == 1
            rect_w = h(idx);
            rect_h = w(idx);
        else
            rect_w = w(idx);
            rect_h = h(idx);
        end
        rectangle('Position',[positions(idx,1), positions(idx,2), rect_w, rect_h],...
            'FaceColor', rand(1,3), 'EdgeColor', 'k');
    end
    xlim([0, W]);
    ylim([0, max(positions(:,2) + max(h,w))]);
    xlabel('Width');
    ylabel('Height');
    grid on;
    hold off;
end
