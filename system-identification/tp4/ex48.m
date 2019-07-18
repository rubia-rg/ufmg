clc;
clear;
close all;

sigma = 1;
mu = 0;
N = 10000;

s = rng;
e = normrnd(mu, sigma, [1, N+3]);
u = zeros(1, N-3);

for k=4:N+3
    u(k-3)= 0.9*e(k-1) + 0.8*e(k-2) + 0.7*e(k-3) + e(k);
end

k = 5;
[t,ruu,l,B]=myccf2([u' u'],k,0,1,'k');
plot([0 5],[l l],'k--',[0 5],[-l -l],'k--');
axis([-0.5 5.5 -1.25 1.25]);
hold on
stem(t,ruu,'k');
hold off
xlabel('Atraso');
ylabel('Ru(k)');
title('Autocorrelação de u(k)');

txt = 'Ru(k) x fator de escala B: ';
disp(txt)
disp(ruu*B)