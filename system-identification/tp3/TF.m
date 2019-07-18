%Tarefa 3
% Simulacao por Funcao de Transferencia
%% based on material from System and Control Theory, by Prof. Roberto Zanasi: 
%% http://www.dii.unimo.it/~zanasi/didattica/Teoria_dei_Sistemi/System_and_Control_Theory_2017.htm
clc
clear
close all

% parametros
m = 0.8; %R
k = 3; %C
c = 4; %L

H = tf([0 0 1], [m c k]); 

poles = pole(H);
% dividindo a funcao de transferencia por 's', 
% a funcao "step" fornece a resposta à rampa
s = tf('s'); 

figure(2)
opt = stepDataOptions('StepAmplitude', 1, 'InputOffset', 1);
step(H, opt);
title('Sistema Original')

%% Testes com resposta ao degrau de subida
% Sistema discretizado
Ts = 0.01;

Hz = c2d(H, Ts, 'zoh');

[numHz, denHz] = tfdata(Hz,'v');

% Comparando as respostas ao degrau:

figure; step(H); hold on; step(Hz);
title('Sistema discretizado')
legend;

[yz, tz] = step(Hz);

% Simulando com ruído adicionado:

N = length(tz);
SNR_dB = 20;
yzr = add_awgn_noise(yz', SNR_dB);
yzr = yzr';

figure;
plot(tz, yzr)
title('Sistema com ruído')

% salvando .dat
outvar = [tz, yzr];
save test_subida.dat outvar -ascii

%% Transicao

disp('Clique na ultima figura para continuar...')
w = waitforbuttonpress;
close all

%% Testes com resposta ao degrau de descida
% Comparando as respostas ao degrau:
u = ones(1, N);
u(100:end) = 0;

figure; lsim(H, u, tz); hold on; lsim(Hz, u, tz);
title('Sistema discretizado')
legend;

yz = lsim(Hz, u, tz);

% Simulando com ruído adicionado:

N = length(tz);
SNR_dB = 20;
yzr = add_awgn_noise(yz', SNR_dB);
yzr = yzr';

figure;
plot(tz(1:end-98), yzr(99:end))
title('Sistema com ruído')

% salvando .dat
outvar = [tz(1:end-98), yzr(99:end)];
save test_descida.dat outvar -ascii

figs =  findobj('type','figure');
fig_num = length(figs);
%% Transicao

disp('Clique na ultima figura para finalizar...')
w = waitforbuttonpress;
close all
