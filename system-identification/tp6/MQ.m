%% Metodo dos Minimos Quadrados
function [y_hat, theta] = MQ(y, u, n_order)
    y_psi = y(n_order + 1:end);
    
    PSI = regmat(y, u, n_order);

    theta = (PSI' * PSI) \ PSI' * y_psi;
    y_hat = PSI*theta;
end