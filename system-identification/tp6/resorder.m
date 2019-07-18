%% Calcula o residuo para um modelo estimado de ordem n_order
function [res, n_samples] = resorder(y, u, n_order)
    y_psi = y(n_order + 1:end);
    n_samples = length(y_psi);
    
    [y_hat, ~] = MQ(y,u,n_order);
  
    res = y_psi - y_hat;
end