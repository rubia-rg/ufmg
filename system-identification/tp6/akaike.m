%% Calcula o Criterio de Informacao de Akaike
function AIC = akaike(p, N, res)
    SSE = sum(res.^2);
    AIC = N * log(SSE/N) + 2*p;
end