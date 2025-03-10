function [reward] = rewardFunctionMinimizer(x, a_1, a_2, Ts, m)

    N = length(x);
    rho = ones(1, N) * expm(-m.L .* m.Ts);
    reward = rho * (1 - x) + m.lambda_1 * sum(a_1) - m.lambda_2 * sum(a_2);
end