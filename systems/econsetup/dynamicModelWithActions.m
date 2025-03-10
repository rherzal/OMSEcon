function [x_plus, x_continuous] = dynamicModelWithActions(x_0, a_1, a_2, model)
    N = length(x_0);

    x_0 = (x_0 + a_1) ./ (1 + a_1 + a_2);

    [x_plus, x_continuous] = dynamicModel(x_0, model);


end