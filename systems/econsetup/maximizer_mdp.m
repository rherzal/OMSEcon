function [xplus, rplus] = maximizer_mdp(m, x, u)
    [a_1, a_2, u1, u2] = findNEcont(x, u(1), u(2), 0.000000000001, 0.000000000001, m);
    [x_plus, x_continuous] = dynamicModelWithActions(x, a_1, a_2, m);
    xplus = x_plus;
%     rplus = rewardFunctionMaximizer(x_continuous(:, 1), a_1, a_2, 1, m);
    rplus = rewardFunctionMaximizer(x_plus, a_1, a_2, 1, m);
end