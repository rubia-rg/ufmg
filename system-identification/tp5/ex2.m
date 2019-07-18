clear;
clc;
close all;

data = load('PRBSA02.DAT');

%% Analise Exploratoria
% Funcao de Autocorelacao (FAC)
t = data(:, 1);
u = data(:, 2);
y = data(:, 3);

fig_orig = figure(1);
subplot(2,1,1);
plot(t,u);
title('u(k)');
subplot(2,1,2);
plot(t,y);
title('y(k)');
saveas(fig_orig, 'fig_orig.eps', 'epsc');

y = medfilt1(y, 3);
y_0 = mean(y(1:100));

Nu = length(u); 
figure(2);
subplot(2,1,1);
myccf2(u, Nu, 0, 1,'k');
xlabel('Atraso');
title('Função de Autocorelação de u(k)');

%% Dados para Metodo dos Minimos Quadrados
t = data(50:2500, 1);
u = data(50:2500, 2);
y = data(50:2500, 3);

N = length(t);

y = medfilt1(y, 3);

K_0 = (max(y) - min(y))/(max(u) - min(u));
y = (y - min(y))/(max(y) - min(y)); 
u = (u - min(u))/(max(u) - min(u)); 

Ts = mean(diff(t));

fig_norm = figure(3);
subplot(2,1,1);
plot(t, u)
title('u(k) normalizado')
subplot(2,1,2);
plot(t, y)
title('y(k) filtrado e normalizado')
saveas(fig_norm, 'fig_norm.eps', 'epsc');

%% Funcao de Correlacao Cruzada (FCC)
fig_fcc_fca = figure(2);
subplot(2,1,2);
myccf2([y u], N, 1, 1,'k');
xlabel('Atraso');
title('Função de Correlação Cruzada entre y(k) e u(k)');
saveas(fig_fcc_fca, 'fig_fcc_fca.eps', 'epsc');
%% Metodo dos Minimos Quadrados
Psi = [y(1:N-1), u(1:N-1)];
theta = (Psi' * Psi) \ Psi' * y(2:N);

tau_hat = - Ts / (theta(1) - 1);
K_hat = (tau_hat * theta(2)) / Ts;

txt = 'Constante de tempo estimada: ';
disp(txt);
disp(tau_hat);
txt = 'Ganho estimado: ';
disp(txt);
disp(K_hat);

num = K_0*K_hat;
den = [tau_hat 1];

G = tf(num, den);
[y_hat, t_hat] = lsim(G, u, t);
[y_step, ~] = step(G, t_hat);

y_step = y_step - y_step(1); % Garantir que o sistema começa em 0

fig_y = figure(4);
plot(t, y, 'r')
hold on;
plot(t_hat, y_hat)
hold on;
plot(t_hat, y_step);
leg = legend({'y(k)';'$\hat{y}(k)$';'$\hat{y}_{step}(k)$'});
set(leg,'Interpreter','latex');
saveas(fig_y, 'y-est.eps', 'epsc');