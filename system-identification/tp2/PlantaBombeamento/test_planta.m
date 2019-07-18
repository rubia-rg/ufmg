tau = 4;
theta = 3;
K = 0.75;
G1 = tf(K, [tau 1], 'ioDelay', theta);

Ts = 0.01;
u0 = 0; y0 = 0;
t = [0:Ts:30-Ts]';
u = [0; ones(length(t)-1,1)] + u0;
y = lsim(G1, u, t) + y0;
y = y + 0.02*randn(length(y),1);

u = [0; ones(length(t)-1,1)] + u0;

plot(t,y)
hold on
plot(t,medfilt1(y,3))
legend('original','filtrado')

y = medfilt1(y,3);

% Metodo das areas:
K1 = (mean(y(end-20:end)) - mean(y(1:20)))/(u(end)-u(1));
yn = y - y0;
yn = yn./K1;

[~, t35] = min(abs(yn-yn(end)*0.35));
[~, t85] = min(abs(yn-yn(end)*0.85));
tau1 = 0.682*(t(t85)-t(t35));
theta1 = t(t35)-0.431*tau1;

G1a = tf(K1, [tau1 1], 'ioDelay', theta1+0.3);
y1 = lsim(G1a, u, t) + y0;
plot(t,y1)
legend('original','filtrado','estimado')
