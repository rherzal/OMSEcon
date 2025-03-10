function [a1, a2, u1s, u2s] = findNEcont(x, Amax1, Amax2, lambda_1, lambda_2, model)
    Tk = model.Ts; % sampling time for campaigns
    rhos = (model.rho)';
    N = length(rhos);
    a1 = rand(N,1);
    a2 = rand(N,1);
    a1 = a1 ./ sum(a1) * Amax1;
    a2 = a2 ./ sum(a2) * Amax2;
    dt = 0.1;
    a1s = []; a2s = []; u1s = []; u2s = [];
    for iter=1:500
        a1s = [a1s, a1];
        a2s = [a2s, a2];
        a1 = a1 + dt * (doBRD(rhos, x, a2, Amax1, lambda_1) - a1);
        a2 = a2 + dt * (doBRD(rhos, 1 - x , a1, Amax2, lambda_2) - a2);
        xp = (x + a1) ./ (1 + a1 + a2);
        u1s = [u1s, sum(rhos .* xp) - lambda_1 * sum(a1)];
        u2s = [u2s, sum(rhos .* (1 - xp)) - lambda_2 * sum(a2)];  
    end
end