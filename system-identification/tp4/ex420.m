
close all;
clear;
clc;

num = 1;
den = [1000 1];
H = tf(num,den);
Ts = 1;

Tb = [1 100 1000 10000];
b = 12;
N = 10000;

for i=1:length(Tb)
    u = prbs(N, b, Tb(i));
    figure(i)
    lsim(H, u, 0:Ts:N-1);
    xlim([0 N])
    title(['Resposta do sistema, Tb = ' num2str(Tb(i))]);
end