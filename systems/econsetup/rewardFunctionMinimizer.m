function [reward_normalized] = rewardFunctionMinimizer(x, a_1, a_2, Ts, m)
    N = length(x);
    rho = m.rho;
    reward = rho * (-x) + m.lambda_1 * sum(a_1) - m.lambda_2 * sum(a_2);

    max = rho * ones(N, 1) + m.lambda_1 * m.max_budget;
    min = - m.lambda_2 * m.min_budget;
    reward_normalized = (reward - min) / (max - min);

end