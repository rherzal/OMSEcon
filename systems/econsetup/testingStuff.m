%% Initialize program
clear all;
clc;
x_0 = rand(5, 1);
a_1 = rand(5, 1);
a_2 = rand(5, 1);

N = length(x_0);
K = 10;

x = x_0;

%% plot random actions

for i = 1:K
    a_1 = rand(5, 1);
    a_2 = rand(5, 1);
    [x_plus, x_continuous] = dynamicModelWithActions(x_0, a_1, a_2);
    x = [x x_continuous];
    x_0 = x(:, end);

end

hold on;
for i=1:N
    plot(x(i, :));
end
legend('$x_1$', '$x_2$', '$x_3$', '$x_4$', '$x_5$', 'Interpreter', 'latex');
hold off;
% set(gca, 'XColor', 'None', 'YColor', 'None');
% set(gcf, 'Color', 'white');

%% Testing NE action
lambda_1 = 0;
lambda_2 = 0;

B1_max = 1;
B2_max = 1;
[a_1, a_2, u1, u2] = findNEcont(x_0, B1_max, B2_max, lambda_1, lambda_2);
[x_plus, x_continuous] = dynamicModelWithActions(x_0, a_1, a_2);
x = [x_0 x_continuous];

hold on;
for i=1:N
    plot(x(i, :));
end
legend('$x_1$', '$x_2$', '$x_3$', '$x_4$', '$x_5$', 'Interpreter', 'latex');
ylim([0 1]);
hold off;