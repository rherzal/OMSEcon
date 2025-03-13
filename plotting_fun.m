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
ylim([0, model_max.max_budget]);
xlim([1, moves]);
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
xlim([1, moves]);
% ylim([-4, 4]);
xlabel('Campaign');
ylabel('Reward');
title(['sum reward_{max}: ', num2str(R_sum_max), ' sum reward_{min}: ', num2str(R_sum_min)])
hold off;



figure;

hold on;
for i=1:parameters.state_size
    stairs(budget_distribution_1(i, :));
end
xlim([1, moves]);
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
xlim([1, moves]);
legend('$x_1$', '$x_2$', '$x_3$', '$x_4$', '$x_5$', 'Interpreter', 'latex');
title('min agent budget distribution');
xlabel('Campaign');
ylabel('Budget per Agent');hold off;
