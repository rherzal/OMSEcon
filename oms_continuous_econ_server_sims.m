5%% Init Optimal-Optimalsend
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
parameters.budget = 1000;
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

%% Simulating Optimal-Optimal Response

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



%% Simulating Dynamics Optimal-Optimal
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

total_min_budget = sum(model_max.min_budget .* Zstar_min);
total_max_budget = sum(model_max.max_budget .* Zstar_max);
save('experiments_workspace_paper_5agents\optimal-optimal.mat');

%% Init Optimal-Dumb
close all; clc; tic

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
parameters.budget = 1000;
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

%% Simulating Optimal-Dumb Response

for move = 1:moves
    move
    Xstar_max(:, move) = current_state;
    Rstar_max(move) = current_reward_max;
    
    Xstar_min(:, move) = current_state;
    Rstar_min(move) = current_reward_min;

    % Tree initialization:
    [parent_max, children_max, leaf_max, dim_max, upperbound_max, lowerbound_max, Ki_max, depth_max, minimax_max, z_max, x_max, r_max] = initialize_tree_minimax(parameters);
    
    % Root initialization:
    x_max(1, 1, :) = current_state;
    leaf_max(1) = true;
    depth_max(1) = 0;

    x_min(1, 1, :) = current_state;
    leaf_min(1) = true;
    depth_min(1) = 0;

    % Tree expansion:
    best_move_max = minimax_algorithm(parent_max, children_max, leaf_max, dim_max, upperbound_max, lowerbound_max, Ki_max, depth_max, minimax_max, z_max, x_max, r_max, parameters, model_max);
    
    Zstar_max(move) = best_move_max;
    Zstar_min(move) = total_min_budget / moves;
    
    % Updating the state:
    current_action_max = inverse_norm_u(best_move_max, model_max);
    current_action_min = inverse_norm_w(best_move_min, model_min);

    % disturbance = 0;
    current_state_copy = current_state;
    [current_state, current_reward_max] = feval(model_max.fun, model_max, current_state_copy, [current_action_max; current_action_min]);
    [current_state, current_reward_min] = feval(model_min.fun, model_min, current_state_copy, [current_action_max; current_action_min]);
    
end

%% Simulating Dynamics Optimal-Dumb
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


save('experiments_workspace_paper_5agents\optimal-dumb.mat');

%% Init Dumb-Dumb

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
parameters.budget = 1000;
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

%% Simulating Dumb-Dumb Response

for move = 1:moves
    move
    Xstar_max(:, move) = current_state;
    Rstar_max(move) = current_reward_max;
    
    Xstar_min(:, move) = current_state;
    Rstar_min(move) = current_reward_min;

    
    % Root initialization:
    x_max(1, 1, :) = current_state;
    leaf_max(1) = true;
    depth_max(1) = 0;

    x_min(1, 1, :) = current_state;
    leaf_min(1) = true;
    depth_min(1) = 0;

    % Tree expansion:
     
    Zstar_max(move) = total_max_budget / moves;
    Zstar_min(move) = total_min_budget / moves;
    
    % Updating the state:
    current_action_max = inverse_norm_u(best_move_max, model_max);
    current_action_min = inverse_norm_w(best_move_min, model_min);

    % disturbance = 0;
    current_state_copy = current_state;
    [current_state, current_reward_max] = feval(model_max.fun, model_max, current_state_copy, [current_action_max; current_action_min]);
    [current_state, current_reward_min] = feval(model_min.fun, model_min, current_state_copy, [current_action_max; current_action_min]);
    
end

%% Simulating Dynamics Dumb-Dumb
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


save('experiments_workspace_paper_5agents\dumb-dumb.mat');

%% Init Dumb-Optimal
close all; clc; tic

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
parameters.budget = 1000;
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

%% Simulating Dumb-Optimal Response

for move = 1:moves
    move
    Xstar_max(:, move) = current_state;
    Rstar_max(move) = current_reward_max;
    
    Xstar_min(:, move) = current_state;
    Rstar_min(move) = current_reward_min;

    % Tree initialization:
%     [parent_max, children_max, leaf_max, dim_max, upperbound_max, lowerbound_max, Ki_max, depth_max, minimax_max, z_max, x_max, r_max] = initialize_tree_minimax(parameters);
    [parent_min, children_min, leaf_min, dim_min, upperbound_min, lowerbound_min, Ki_min, depth_min, minimax_min, z_min, x_min, r_min] = initialize_tree_minimax(parameters);
    % Root initialization:
    x_max(1, 1, :) = current_state;
    leaf_max(1) = true;
    depth_max(1) = 0;

    x_min(1, 1, :) = current_state;
    leaf_min(1) = true;
    depth_min(1) = 0;

    % Tree expansion:
%     best_move_max = minimax_algorithm(parent_max, children_max, leaf_max, dim_max, upperbound_max, lowerbound_max, Ki_max, depth_max, minimax_max, z_max, x_max, r_max, parameters, model_max);
    best_move_min = minimax_algorithm(parent_min, children_min, leaf_min, dim_min, upperbound_min, lowerbound_min, Ki_min, depth_min, minimax_min, z_min, x_min, r_min, parameters, model_min);
    
    Zstar_max(move) = total_max_budget / moves;
    Zstar_min(move) = best_move_min;
    
    % Updating the state:
    current_action_max = inverse_norm_u(best_move_max, model_max);
    current_action_min = inverse_norm_w(best_move_min, model_min);

    % disturbance = 0;
    current_state_copy = current_state;
    [current_state, current_reward_max] = feval(model_max.fun, model_max, current_state_copy, [current_action_max; current_action_min]);
    [current_state, current_reward_min] = feval(model_min.fun, model_min, current_state_copy, [current_action_max; current_action_min]);
    
end

%% Simulating Dynamics Dumb-Optimal
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


save('experiments_workspace_paper_5agents\dumb-optimal.mat');