close all
clear
%% Testes com resposta ao degrau de subida

disp('Testes com degrau de subida');
figs =  findobj('type','figure');
fig_num = length(figs);

data = load('test_subida.dat');
tz = data(:, 1);
yzr = data(:, 2);

% Aproximação de 1a ordem: Método de Sundaresan
[tau1, K1, theta, fig_num] = sundaresan('test_subida.dat', fig_num);
Hhat1 = tf(K1, [tau1 1], 'ioDelay', theta);
y1 = step(Hhat1, tz);
figure; plot(tz, yzr); hold on; plot(tz, y1, 'm-.', 'LineWidth', 2);
legend;
title('Sundaresan')
legend('H(s)', 'H_{est}(s)');
hold off;
fig_num = fig_num + 1;

% Aproximação de 2a ordem: Método da Resposta Complementar
[K2, tau2a, tau2b, fig_num] = respostacomplementar('test_subida.dat', fig_num);
Hhat2 = tf(K2, [tau2a*tau2b  tau2a+tau2b  1]);
y2 = step(Hhat2, tz);
figure; plot(tz, yzr); hold on; plot(tz, y2, 'm-.', 'LineWidth', 2);
legend('H(s)', 'H_{est}(s)');
title('Resposta Complementar')
hold off;
fig_num = fig_num + 1;

%% Transicao

disp('Clique na ultima figura para continuar...')
waitforbuttonpress;
close all

%% Testes com resposta ao degrau de descida
disp('Testes com degrau de descida');

% Aproximação pelo Método de Sundaresan
sundaresan('test_descida.dat', fig_num);
%% Transicao

disp('Clique na ultima figura para finalizar...')
waitforbuttonpress;
close all