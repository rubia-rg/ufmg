%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Rubia Reis Guerra - 2013031143
% ELT016
% Prova Computacional
% 25/06/2019
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Parametros estimados
% tau_estimado = 2.3170
% K_estimado = 5.2500
% Fator de decimacao = 1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Obs: as partes que dependem do
% arquivo myccf2.m foram comenta-
% das. As analises feitas com o 
% metodo foram descritas nas res-
% pectivas secoes que utizaram o 
% metodo.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Preparacao do ambiente
clear;
close all;
clc;

%% Constantes do algortimo
FILENAME = 'data_prova_ceai_21.dat';

% 80% das amostras serao utilizadas para identificacao do modelo
% 20% das amostras serao utilizadas para validacao do modelo estimado
SPLIT = 0.8;

% Para decimacao, deseja-se tau_min = 15
TAU_LIM = 15;

%% Dados originais
data = load(FILENAME);

t = data(:, 1);
u = data(:, 2);
y = data(:, 3);

Ts = mean(diff(t));
N = length(t);

figure;
plot(t, [u y])
legend('u', 'y');
title('Dados originais do problema');

%% Separacao de dados de validacao
val_idx = round(SPLIT * N);

% Dados de identificacao
t_id = 0:val_idx - 1;
u_id = u(1:val_idx);
y_id = y(1:val_idx);

N_id = length(y_id);

figure;
plot(t(1:val_idx), [u_id y_id])
hold on;

% Dados de validacao
t_val = 0:(N - val_idx - 1);
u_val = u(val_idx + 1:end);
y_val = y(val_idx + 1:end);

N_val = length(y_val);

plot(t(val_idx+1:end), [u_val y_val])
legend('u_{id}', 'y_{id}', 'u_{val}', 'y_{val}');
title('Dados de validacao do modelo');
hold off;

%% Funcao de Correlacao Cruzada (FCC) para identificacao de atraso puro

% figure;
% [atr, ruy, ~, ~] = myccf2([y_id u_id], N_id, 1, 1,'k');
% xlabel('Atraso');
% title('Função de Correlação Cruzada: Ruy');
% 
% if atr(ruy==max(ruy)) == 1
%     disp('O sistema nao apresenta atraso puro de tempo');
%     disp(' ');
% end

% Como esperado, o sistema nao apresenta atraso puro de tempo

%% Decimacao

% ystar = y_id - mean(y_id);
% [tstar, ryy, ~, ~] = myccf2(ystar, length(ystar), 0, 0, 'k');
% 
% ystar2 = y_id .^2;
% ystar2 = ystar2 - mean(ystar2);
% 
% [tstar2, ryy2, ~, ~] = myccf2(ystar2, length(ystar2), 0, 0, 'k');
% 
% taustar = tstar(ryy == min(ryy));
% taustar2 = tstar2(ryy2 == min(ryy2));
% 
% tm = min(taustar, taustar2);
% 
% % Fator de decimacao
% delta = round(tm / TAU_LIM);
% 
% if delta > 1
%     t_id = 1:round(val_idx / delta);
%     u_id = u_id(1:delta:end);
%     y_id = y_id(1:delta:end);
%     Ts_id = Ts * delta;
% 
% txt = 'Fator de decimacao: ';
% disp(txt);
% disp(delta);
% 
% % Dados decimados
% figure;
% plot(t_id, [u_id y_id]);
% title('Dados decimados');
% 
% else
%     disp('Nao foi necessario decimar os dados.');
%     disp(' ');
% end

%% Metodo dos Minimos Quadrados
% Utilizando o metodo dos Minimos Quadrados para estimar a FT
% G(s) = K/(tau s + 1),
% a partir da aproximacao y(k) = ay(k-1) + bu(k-1)
% sendo a = 1 - Ts/tau; b = TsK/tau.

% Equacao de regressores
Psi = [y_id(1:N_id - 1), u_id(1:N_id - 1)];

% Theta
theta = (Psi' * Psi) \ Psi' * y_id(2:N_id);

% Parametros estimados
tau_hat = - Ts / (theta(1) - 1);
K_hat = (tau_hat * theta(2)) / Ts;

txt = 'Constante de tempo estimada: ';
disp(txt);
disp(tau_hat);
txt = 'Ganho estimado: ';
disp(txt);
disp(K_hat);

%% Validacao

num = K_hat;
den = [tau_hat 1];
G = tf(num, den);
[y_hat, t_val] = lsim(G, u_val, t_val);

figure;
plot(t_val, [y_val y_hat])
legend('y_{val}', 'y_{hat}');
title('Comparacao: modelo estimado x dados de validacao');
%% Comparando com os dados completos

num = K_hat;
den = [tau_hat 1];
G_all = tf(num, den);
[y_hat_all, t_all] = lsim(G_all, u, t);

figure;
plot(t_all, [y y_hat_all])
legend('y', 'y_{hat}');
title('Comparacao: modelo estimado x dados originais');