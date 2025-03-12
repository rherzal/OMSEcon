function [xplus, rplus] = minimizer_mdp(m, x, u)
    [a_1, a_2, u1, u2] = findNEcont(x, u(1), u(2), 0, 0, m);
    [x_plus, x_continuous] = dynamicModelWithActions(x, a_1, a_2, m);
    xplus = x_plus;
    rplus = rewardFunctionMinimizer(x_continuous(:, 1), a_1, a_2, m.Ts, m);
end