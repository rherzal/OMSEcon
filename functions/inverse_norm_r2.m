function [reward] = inverse_norm_r2(normalized_reward, m)
    N = length(m.rho);
    rho = m.rho;
    max = m.lambda_1 * m.max_budget;
    min = - rho * ones(N, 1) - m.lambda_2 * m.min_budget;
    reward = normalized_reward * (max - min) + min;
end
