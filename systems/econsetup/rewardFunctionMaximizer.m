function [reward] = rewardFunctionMaximizer(x, a_1, a_2, Ts, m)
    N = length(x);
    rho = m.rho;
    reward = rho * x - m.lambda_1 * sum(a_1) + m.lambda_2 * sum(a_2);
end