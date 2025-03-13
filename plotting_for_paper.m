
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

subplot(2, 1, 1);
hold on;
for i=1:parameters.state_size
    plot(t, continuous_x(i, :));
end
ylim([0, 1]);
xlim([0, moves .* model_max.Ts]);
xlabel('$t$', 'Interpreter','latex');
ylabel('$x_o(t)$', 'Interpreter','latex');
% legend('$x_1$', '$x_2$', '$x_3$', '$x_4$', '$x_5$', 'Interpreter', 'latex');
fontsize(gca, 13, "points");
hold off;

subplot(2, 1, 2);
hold on;
stairs([0:moves], [Zstar_max * model_max.max_budget Zstar_max(end) * model_max.max_budget]);
stairs([0:moves], [Zstar_min * model_max.min_budget Zstar_min(end) * model_min.min_budget]);
legend('$u_k$', '$w_k$', 'Interpreter', 'latex');
ylim([0, model_max.max_budget]);
xlim([0, moves]);
xlabel('$t$', 'Interpreter', 'latex');
ylabel('$z_k$', 'Interpreter', 'latex');
fontsize(gca, 13, "points");
hold off;

fig = gcf;
fig.Position(3:4) = fig.Position(3:4) .* 0.85;


%%
figure;
A = [0 1 0 0 1;
         0 0 1 0 0;
         1 1 0 0 1;
         1 1 1 0 0;
         1 0 1 1 0];

G = digraph(A');
h = plot(G);
h.MarkerSize = 7;
h.LineWidth = 0.7;
h.ArrowSize = 10;
h.NodeColor = 'r';
h.NodeFontSize = 13;
fontsize(gca, 13, "points");
set(gca, 'XTick', [], 'XTickLabel', []);
set(gca, 'YTick', [], 'YTickLabel', []);

%% 

figure;
hold on;
for i=1:parameters.state_size
    stairs([0:moves], [budget_distribution_1(i, :) budget_distribution_1(i, end)] );
end
xlim([0, moves]);
% legend('$x_1$', '$x_2$', '$x_3$', '$x_4$', '$x_5$', 'Interpreter', 'latex');
fontsize(gca, 13, "points");
hold off;
ylabel('$a_{1, o}(t)$', 'Interpreter','latex');
xlabel('$t$', 'Interpreter','latex');

fig = gcf;
fig.Position(3:4) = fig.Position(3:4) .* 0.85;




