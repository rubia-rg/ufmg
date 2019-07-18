clear;
close all;

b = 6;
Tb = 1;
N = 189;

u = prbs(N,b,Tb);

figure(1)
subplot(2,1,1);
stairs(u)
ylim([-0.5, 1.5])
xlim([0, 190])
title('PRBS');
xlabel('Amostras')

subplot(2,1,2);
[t,ruu,l,B]=myccf2(u',N,1,1,'k');
ylim([-0.5, 1.25])
xlabel('Atraso');
title('Autocorrelação do PRBS');
