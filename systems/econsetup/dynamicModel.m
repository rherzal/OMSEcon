function [x_plus, x_continuous] = dynamicModel(x_0, model)
    L = model.L;
    rho = model.rho;

    Ts = model.Ts / 100;
    Tf = model.Ts;
    t = [Ts:Ts:Tf];
    N = length(t);
    x_continuous = zeros(length(x_0), N);
    x_continuous(:, 1) = x_0;
    
    for i = 2:N
        x_continuous(:, i) = x_continuous(:, i-1) - Ts * L * x_continuous(:, i-1);
    end

    x_plus = x_continuous(:, end);
    
end