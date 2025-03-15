close all; clear all; clc; tic

% Define some config for the problem
cfg = struct;
cfg.problem = 'econsetup_problem';
cfg.model_params = {};
cfg.gamma = 0.8;
cfg.planparam.n = 50;

parameters = struct;
parameters.state_size = 5;
parameters.max_tree_size = 36000;
parameters.max_horizon = 15;
parameters.M = 3;
parameters.Lv = 5;
parameters.gamma = cfg.gamma;
parameters.budget = 5000;
parameters.discounted_array = parameters.gamma .^ (0 : parameters.max_horizon - 1);

% Define the model for the maximizer marketer
model_max = struct;
model_max.id = 'max';
model_max.fun = 'maximizer_mdp';
model_max.max_budget = 1;
model_max.min_budget = 1;
model_max.lambda_1 = 0.8;
model_max.lambda_2 = 0.8;
model_max.Ts = 1;
model_max.L = graphDesign();
model_max.rho = ones(1, parameters.state_size) * expm(- model_max.L .* model_max.Ts);

% Define the model for the minimizer marketer
model_min = struct;
model_min.id = 'min';
model_min.fun = 'minimizer_mdp';
model_min.max_budget = model_max.max_budget;
model_min.min_budget = model_max.min_budget;
model_min.lambda_1 = model_max.lambda_1;
model_min.lambda_2 = model_max.lambda_2;
model_min.Ts = model_max.Ts;
model_min.L = graphDesign();
model_min.rho = model_max.rho;



% Trajectory initialization:
moves = 10;
% initial_state = 0.5 .* ones(5, 1);
% initial_state = [0.8147; 0.9058; 0.1270; 0.9134; 0.6324];
% initial_state = rand(5, 1) .* 0.3;
% initial_state = rand(5, 1) .* 0.3 + 0.7;
% initial_state = rand(5, 1);
initial_state = [0.2447; 0.0787; 0.2019; 0.0560; 0.1798];
current_state = initial_state;

t = [0:model_max.Ts/100:moves*model_max.Ts];

current_reward_max = 0;
current_reward_min = 0;

% Final trajectory and rewards:
Xstar_max = zeros(5, moves);
Rstar_max = zeros(1, moves);
Zstar_max = zeros(1, moves);

Xstar_min = zeros(5, moves);
Rstar_min = zeros(1, moves);
Zstar_min = zeros(1, moves);

%%

for move = 1:moves
    move
    Xstar_max(:, move) = current_state;
    Rstar_max(move) = current_reward_max;
    
    Xstar_min(:, move) = current_state;
    Rstar_min(move) = current_reward_min;

    % Tree initialization:
    [parent_max, children_max, leaf_max, dim_max, upperbound_max, lowerbound_max, Ki_max, depth_max, minimax_max, z_max, x_max, r_max] = initialize_tree_minimax(parameters);
    [parent_min, children_min, leaf_min, dim_min, upperbound_min, lowerbound_min, Ki_min, depth_min, minimax_min, z_min, x_min, r_min] = initialize_tree_minimax(parameters);

    % Root initialization:
    x_max(1, 1, :) = current_state;
    leaf_max(1) = true;
    depth_max(1) = 0;

    x_min(1, 1, :) = current_state;
    leaf_min(1) = true;
    depth_min(1) = 0;

    % Tree expansion:
    best_move_max = minimax_algorithm(parent_max, children_max, leaf_max, dim_max, upperbound_max, lowerbound_max, Ki_max, depth_max, minimax_max, z_max, x_max, r_max, parameters, model_max);
    best_move_min = minimax_algorithm(parent_min, children_min, leaf_min, dim_min, upperbound_min, lowerbound_min, Ki_min, depth_min, minimax_min, z_min, x_min, r_min, parameters, model_min);
    
    Zstar_max(move) = best_move_max;
    Zstar_min(move) = best_move_min;
    
    % Updating the state:
    current_action_max = inverse_norm_u(best_move_max, model_max);
    current_action_min = inverse_norm_w(best_move_min, model_min);

    % disturbance = 0;
    current_state_copy = current_state;
    [current_state, current_reward_max] = feval(model_max.fun, model_max, current_state_copy, [current_action_max; current_action_min]);
    [current_state, current_reward_min] = feval(model_min.fun, model_min, current_state_copy, [current_action_max; current_action_min]);
    
end



%% Oversampled Plot
continuous_x = initial_state;
continuous_x0 = initial_state;
budget_distribution_1 = [];
budget_distribution_2 = [];
for i = 1:moves
    [a_1, a_2, u1, u2] = findNEcont(continuous_x0, inverse_norm_u(Zstar_max(i), model_max), inverse_norm_w(Zstar_min(i), model_min), 0, 0, model_max);
    [x_plus, x_continuous] = dynamicModelWithActions(continuous_x0, a_1, a_2, model_max);
    budget_distribution_1 = [budget_distribution_1 a_1];
    budget_distribution_2 = [budget_distribution_2 a_2];
    continuous_x = [continuous_x x_continuous];
    continuous_x0 = continuous_x(:, end);
end

subplot(3, 1, 1);
title('Agents state');
hold on;
for i=1:parameters.state_size
    plot(t, continuous_x(i, :));
end
ylim([0, 1]);
xlim([0, moves .* model_max.Ts]);
xlabel('Continuous Time');
ylabel('Opinion');
legend('$x_1$', '$x_2$', '$x_3$', '$x_4$', '$x_5$', 'Interpreter', 'latex');
hold off;

subplot(3, 1, 2);
title('Total Budget Allocated')
hold on;
stairs(Zstar_max * model_max.max_budget);
stairs(Zstar_min * model_max.min_budget);
legend('marketer_{max}', 'marketer_{min}');
ylim([0, max(model_max.max_budget, model_max.min_budget)]);
xlim([1, length(Zstar_max)]);
xlabel('Campaign');
ylabel('Total Budget');
hold off;

R_sum_max = sum(Rstar_max);
R_sum_min = sum(Rstar_min);

subplot(3, 1, 3);
title('Reward')
hold on;
stairs(Rstar_max);
stairs(Rstar_min);
legend('R_{max}', 'R_{min}');
xlim([1, length(Zstar_max)]);
ylim([-4, 4]);
xlabel('Campaign');
ylabel('Reward');
title(['sum reward_{max}: ', num2str(R_sum_max), ' sum reward_{min}: ', num2str(R_sum_min)])
hold off;



figure;

hold on;
for i=1:parameters.state_size
    stairs(budget_distribution_1(i, :));
end
xlim([1, length(budget_distribution_1)]);
legend('$x_1$', '$x_2$', '$x_3$', '$x_4$', '$x_5$', 'Interpreter', 'latex');
hold off;
title('max agent budget distribution');
xlabel('Campaign');
ylabel('Budget per Agent');

figure;
hold on;
for i=1:parameters.state_size
    stairs(budget_distribution_2(i, :));
end
xlim([1, length(budget_distribution_1)]);
legend('$x_1$', '$x_2$', '$x_3$', '$x_4$', '$x_5$', 'Interpreter', 'latex');
title('min agent budget distribution');
xlabel('Campaign');
ylabel('Budget per Agent');hold off;

toc

%% testing reward functions

[~, r] = feval(model_max.fun, model_max, initial_state, [0.0; 3.0])
[~, r] = feval(model_min.fun, model_min, initial_state, [0.0; 3.0]) 
