%% Monta a matriz de regressores
function PSI = regmat(y, u, n_order)
    PSI = [];
    
    for i = 0:n_order-1
        PSI = [PSI, y(n_order-i:end-i-1) u(n_order-i:end-i-1)];
    end
    
end