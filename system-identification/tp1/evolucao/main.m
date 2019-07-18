clear all; close all; clc;

tspan = [0 500];
step = 0.1;

% Modelo de (Upadhyay; Jyengar, 1998)
y0_cont = [0.7 0.15 0.15];
[t, y] = ode23(@(t,y) upadhyay(t, y), [tspan(1):step:tspan(2)], y0_cont);

uj = figure;
plot(t,y)
title('Modelo de (Upadhyay; Jyengar, 1998)')
ylabel('Densidade Normalizada')
xlabel('Tempo')
legend('Presa', 'Pred. Esp.', 'Pred. Gen.')
saveas(uj, 'upadhyay.eps', 'epsc')

% Modelo de (Letellier et al., 2002)
y0_disc = [0.500 0.7591 0.8151 0.8621 0.8962 0.9203 0.9353 0.9432];
y = y0_disc;
for t = tspan(1):tspan(2)
    x = letellier(y(end - 7:end));
    y = [y x];
end

t = tspan(1):tspan(2);
t = [-8:-1, t];

lt = figure;
title('Modelo de (Letellier et al., 2002)')
plot(t, y, '-o')
xlim([-8 500])
ylabel('Densidade Normalizada')
xlabel('Tempo')
saveas(lt, 'letellier.eps','epsc')
