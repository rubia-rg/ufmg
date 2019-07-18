clear;
clc;
close all;

%% Definicao de G(s)

K = 5;
tau = 20;
delay = 30;

num = K;
den = [tau 1];

G = tf(num, den, 'IODelay', delay);
G0 = tf(num, den);

figure(1)
subplot(2,1,1);
step(G0, 'r', G, 'b')

%% Defincao do PRBS

N = 500;
Tb = 1;
b = 9;

u = prbs(N, b, Tb);

subplot(2,1,2);
stairs(u)
ylim([-0.5 1.5])
title('PRBS');
xlabel('Amostras');

%% Resposta de G(s) ao PRBS e adicao de ruido baixo
Ts = 0.1*tau;
s = rng;
nu = randn(N, 1) * 3;

t = (0:499) * Ts;

[y, t] = lsim(G, u, t);
[y0, t0] = lsim(G0, u, t);
y = y + nu;
y0 = y0 + nu;

figure(2)
subplot(2,1,1);
plot(t,y);
title('Resposta ao PRBS');
xlabel('Time (seconds)');
ylabel('Amplitude');

%% Funcao de Correlacao Cruzada (FCC)

subplot(2,1,2);
myccf2([y u'], N, 1, 1,'k');
xlabel('Atraso');
title('Função de Correlação Cruzada');

%% Metodo dos Minimos Quadrados
Psi = [y0(1:100), u(1:100)'];
theta = (Psi' * Psi) \ Psi' * y0(2:101);

tau_hat = - Ts / (theta(1) - 1);
K_hat = (tau_hat * theta(2)) / Ts;

txt = 'Constante de tempo estimada: ';
disp(txt);
disp(tau_hat);
txt = 'Ganho estimado: ';
disp(txt);
disp(K_hat);
