%% Initialize program
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
% clc;
% x_0 = rand(5, 1);
a_1 = rand(5, 1);
a_2 = rand(5, 1);

x_0 = 0.5 .* ones(5, 1);

N = length(x_0);
K = 10;

x = x_0;

%   Adjacency matrix
    A = [0 1 0 0 1;
         0 0 1 0 0;
         1 1 0 0 1;
         1 1 1 0 0;
         1 0 1 1 0];
    G = digraph(A);

%% Do NE actions
lambda_1 = 1;
lambda_2 = 1;

B1_max = 10;
B2_max = 0;

x_discrete = x_0;


for i = 1:K
    a_1 = rand(5, 1);
    a_2 = rand(5, 1);
    [a_1, a_2, u1, u2] = findNEcont(x_0, B1_max, B2_max, lambda_1, lambda_2, model_max);
    [x_plus, x_continuous] = dynamicModelWithActions(x_0, a_1, a_2, model_max);
    x_discrete = [x_discrete x_plus];
    x = [x x_continuous];
    x_0 = x(:, end);

end
subplot(1, 2, 1);
hold on;
for i=1:N
    plot(x_discrete(i, :));
end
ylim([0, 1]);
legend('$x_1$', '$x_2$', '$x_3$', '$x_4$', '$x_5$', 'Interpreter', 'latex');
hold off;
subplot(1, 2, 2);
G.plot;