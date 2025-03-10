function model = setup_model(cfg)
    model = feval(cfg.problem, 'model', cfg.model_params{:});
end