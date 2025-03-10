function [cfg, parameters] = define_model()
    % Configuration settings
    cfg = struct;
    cfg.problem = 'ipsetup_problem';

    cfg.model_params = {'rewtype=nlqr Qrew=[1,0] Rrew=0.0', [], 'Ts=.05'};
    % cfg.model_params = {'nlqr Rrew', 'type=ip maxx=[pi;15*pi] maxu=3', 'Ts=0.05'};

    cfg.gamma = 0.85; % original = 0.85
    cfg.planparams.n = 50;

    % Problem-specific parameters
    parameters = struct;
    parameters.max_tree_size = 36000;
    parameters.max_horizon = 15;
    parameters.M = 3;
    parameters.Lf = 0.8;
    parameters.Lrho = 0.8;
    parameters.Lv = 1.1; % original is 1.2, this worked for OPC
    % Works with Lv = 2.1, gamma = 0.99
    
    parameters.gamma = cfg.gamma; % Use gamma from cfg
    parameters.budget = 15000;

    % Precompute the discounted array
    parameters.discounted_array = parameters.gamma .^ (0 : parameters.max_horizon - 1);
end