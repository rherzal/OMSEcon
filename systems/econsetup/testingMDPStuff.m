clear all;
model_max = struct;
model_max.id = 'max';
model_max.fun = 'maximizer_mdp';
model_max.max_budget = 10;
model_max.min_budget = 10;
model_max.lambda_1 = 1;
model_max.lambda_2 = 1;
[model_max.L, model_max.q, model_max.rho] = graphDesign();

% Define the model for the minimizer marketer
model_min = struct;
model_min.id = 'min';
model_min.fun = 'minimizer_mdp';
model_min.max_budget = model_max.max_budget;
model_min.min_budget = model_max.min_budget;
model_min.lambda_1 = model_max.lambda_1;
model_min.lambda_2 = model_max.lambda_2;
[model_min.L, model_min.q, model_min.rho] = graphDesign();

current_action_max = 10;
current_action_min = 0;

X(:, 1) = 0.5 .* ones(5, 1); 
% X(:, 1) = [0.2450; 0.8071; 0.1174; 0.8679; 0.5829];

for i = 1:12
%     [X(:, i+1), current_reward_max] = feval(model_max.fun, model_max, X(:, i), [current_action_max; current_action_min]);
    [X(:, i+1), current_reward_max] = feval(model_min.fun, model_min, X(:, i), [current_action_max; current_action_min]);
end


hold on;
for i=1:5
    plot(X(i, :));
end
ylim([0, 1]);
legend('$x_1$', '$x_2$', '$x_3$', '$x_4$', '$x_5$', 'Interpreter', 'latex');
hold off;