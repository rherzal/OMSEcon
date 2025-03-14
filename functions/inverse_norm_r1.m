function [reward] = inverse_norm_r1(normalized_reward, m)
    N = length(m.rho);
    rho = m.rho;
    max = rho * ones(N, 1) + m.lambda_2 * m.min_budget;
    min = - m.lambda_1 * m.max_budget;
    reward = normalized_reward * (max - min) + min;
end

