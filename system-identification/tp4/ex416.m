clear;
close all;
clc;

b = 6;
Tb = [2 3 5 10];
N = 189;
T = 2^b - 1;

for i=1:length(Tb)
    u = prbs(N*Tb(i),b,Tb(i));
    
    figure(i)
    subplot(2,1,1);
    stairs(u);
    ylim([-0.5, 1.5])
    xlim([0, 200])
    title(['PRBS, Tb = ' num2str(Tb(i))]); 
    
    subplot(2,1,2);
    [t,ruu,l,B] = myccf2(u', N*2, 1, 1, 'k');
    ylim([-0.5, 1.25])
    xlim([-200, 200])
    title(['Autocorrleação do sinal PRBS, Tb = ' num2str(Tb(i))]);
end