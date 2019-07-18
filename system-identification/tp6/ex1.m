%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Rubia Reis Guerra - 2013031143
% ELT016
% Trabalho Pratico 6
% 30/06/2019
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear;
clc;
close all;

%% Parametros
VAL_SPLIT = 0.7;
TAU_LIM = 15;
MAX_ORDER = 10;
TOL = 0.1;
DEL = true; 

%% Leitura dos dados
dados = load('dados_tmsd1.txt');

t = dados(:,1);
u = dados(:,2);
y = dados(:,3);

Ts = mean(diff(t));

sample_size = length(t);

% Dados originais
fig_dados = figure;
plot(t, [u y]);
hold on;

%% Separação dos dados para validacao

val_idx = round(VAL_SPLIT * sample_size);

t_id = 1:val_idx;
t_val = 1:(sample_size - val_idx);

u_id = u(1:val_idx);
u_val = u(val_idx:end);

y_id = y(1:val_idx);
y_val = y(val_idx:end);

% Dados para identificacao
plot(t(1:val_idx), [u_id y_id]);
legend('u', 'y','u_{id}', 'y_{id}');
title('Dados de Identificação do Modelo');
saveas(fig_dados, 'fig_dados.eps', 'epsc');
hold off;

%% Decimacao

ystar = y_id - mean(y_id);
fig_facy = figure;
[tstar, ryy, ~, ~] = myccf2(ystar, length(ystar), 0, 1, 'k');
title('FAC: y^*(k)');
saveas(fig_facy, 'fig_facy.eps', 'epsc');

ystar2 = y_id .^2;
ystar2 = ystar2 - mean(ystar2);

fig_facy2 = figure;
[tstar2, ryy2, ~, ~] = myccf2(ystar2, length(ystar2), 0, 1, 'k');
title('FAC: y^{*2}(k)');
saveas(fig_facy2, 'fig_facy2.eps', 'epsc');

taustar = tstar(ryy == min(ryy));
taustar2 = tstar2(ryy2 == min(ryy2));

tm = min(taustar, taustar2);

% Fator de decimacao
delta = round(tm / TAU_LIM);

if delta > 0
    disp('Fator de decimacao:')
    disp(delta)
    t_id = 1:round(val_idx / delta);
    u_id = u_id(1:delta:end);
    y_id = y_id(1:delta:end);
    Ts_id = Ts * delta;
    
    t_val = 1:round((sample_size - val_idx)/delta + 1);
    u_val = u_val(1:delta:end);
    y_val = y_val(1:delta:end);
    Ts_val = Ts * delta;
    
    % FAC do sinal decimado
    fig_facdec = figure;
    myccf2(y_id, length(y_id), 0, 1, 'k');
    title('FAC: sinal decimado');
    saveas(fig_facdec, 'fig_facdec.eps', 'epsc');
    
    % Dados decimados
    fig_dadosdec = figure;
    plot(t_id, [u_id y_id]);
    legend('u', 'y');
    title('Resultado da decimação');
    saveas(fig_dadosdec, 'fig_dadosdec.eps', 'epsc');
end

%% Determinacao da ordem do modelo
n_samples = length(y_id);
AIC = zeros(MAX_ORDER, 1);
res = [];

for i = 1:MAX_ORDER
    [res, n_samples] = resorder(y_id, u_id, i);
    AIC(i) = akaike(i, n_samples, res);
end

norm_AIC = normalize(AIC, 'range');
diff_AIC = -diff(norm_AIC);
n_order = find(diff_AIC < TOL, 1);
[y_hat, theta] = MQ(y_id, u_id, n_order);

fig_aic = figure;
plot(AIC)
title('AIC x Ordem do Modelo')
saveas(fig_aic, 'fig_aic.eps', 'epsc');

%% Validação do modelo
% Simulaçao 1 passo a frente
PSI_ahead = regmat(y_val, u_val, n_order);
y_ahead = PSI_ahead*theta;

fig_sim1pf = figure;
plot(t_val(n_order + 1:end),[y_val(n_order + 1:end) y_ahead])
legend;
title('Simulacao 1 passo a frente');
legend('y_{val}', 'y_{1pf}')
saveas(fig_sim1pf, 'fig_sim1pf.eps', 'epsc');

% RMSE
err_ahead = y_val(n_order + 1:end) - y_ahead;
rmse_ahead = sqrt(sum(err_ahead.^2)) / sqrt(sum((y_val-mean(y_val)).^2));
disp('RMSE simulacao 1 passo a frente');
disp(rmse_ahead);

% Analise de Residuos
fig_fac1pf = figure;
myccf2(err_ahead, length(err_ahead), 0, 1, 'k');
title('FAC: Residuo da simulacao 1 passo a frente')
saveas(fig_fac1pf, 'fig_fac1pf.eps', 'epsc');

fig_fcc1pf = figure;
myccf2([u_val(n_order + 1:end) err_ahead], length(err_ahead), 1, 1, 'k');
title('FCC: Resíduos e entrada 1 passo a frente')
saveas(fig_fcc1pf, 'fig_fcc1pf.eps', 'epsc');

% Simulacao livre
y_livre = zeros(length(y_val),1);
y_livre(1:n_order) = y_val(1:n_order);
PSI_livre = [y_livre(1:n_order)' u_val(1:n_order)'];
y_livre(n_order+1) = PSI_livre * theta;

for i = n_order+1:length(u_val)
    PSI_livre = [y_livre(i-n_order+1:i)' u_val(i-n_order+1:i)'];
    if i < length(t_val)
        y_livre(i+1) = PSI_livre * theta;
    end
end

fig_simlivre = figure;
plot(t_val, [y_val y_livre])
title('Simulacao Livre');
legend('y_{val}', 'y_{livre}')
saveas(fig_simlivre, 'fig_simlivre.eps', 'epsc');

% RMSE
err_livre = y_val - y_livre;
rmse_livre = sqrt(sum(err_livre.^2)) / sqrt(sum((y_val - mean(y_val)).^2));
disp('RMSE simulacao livre:');
disp(rmse_ahead);

% Analise de Residuos
fig_faclivre = figure;
myccf2(err_livre, length(err_livre), 0, 1, 'k');
title('FAC: Residuo da simulacao livre')
saveas(fig_faclivre, 'fig_faclivre.eps', 'epsc');

fig_fcclivre = figure;
myccf2([u_val err_livre], length(err_livre), 1, 1,'k');
title('FCC: Resíduos e entrada livre')
saveas(fig_fcclivre, 'fig_fcclivre.eps', 'epsc');

%% Removendo valores inutilizados
if DEL
    clear ystar;
    clear ystar2;
    clear tstar;
    clear tstar2;
    clear taustar;
    clear taustar2;
    clear i;
end
