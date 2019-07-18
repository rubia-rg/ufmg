function torneira(filename)
filename = 'torneira3.txt'    
data = load(filename);
    u = data(:,2);
    y = data(:,1);
    y0 = y(1);
    Au = abs(u(end)-u(1));
    Ay = abs(y(end)-y(1));
    K = Ay/Au;
    Ts = 1;
    t = [0:Ts:(length(y)-1)]';
    
    figure(1); 
    subplot(211); stairs(t, u,'LineWidth',2); xlabel('t (s)'); ylabel('u(t)');
    subplot(212); plot(t, y); xlabel('t (s)'); ylabel('y(t)');
    
    y = y - y0;
    yn = (y - min(y))./(max(y)-min(y));
    
    u = flip(u);
    u = u - u(1);
    
    idx = find(yn>=0.05, 1, 'first');
    idxend = find(u>=2000, 1, 'first');
    
    u(idx:idxend-1) = u(idx:idxend-1)+u(end);
    
    Ayn = mean(yn(1:5))-mean(yn(end-5:end));
    K1 = abs(Ayn/Au);
    
    %% Resposta complementar:
    %Torneira 3, modificar parâmetros para torneira 4 e torneira 5
    yy = log(abs(1 - yn./(K1*u)));
    figure(2); subplot(211); plot(t, yy); xlabel('t (s)'); ylabel('ln(1 - y(t)/(K*u(t)))');
    figure(2); plot(t, yy); xlabel('t (s)'); ylabel('w(t)');
    coef = polyfit(t(20:40), yy(20:40), 1);
    hold on; plot(t, coef(1)*t + coef(2), 'm-.', 'LineWidth', 2); axis([0 18 -8 2]);
    tau2a = -1/coef(1);
    theta = idx;

    yy2 = log(abs(exp(coef(2))*exp(-(t)./tau2a) - (1 - yn./(K1*u))));
    coef2 = polyfit(t(11:34),yy2(11:34),1);
    figure(2); subplot(212); plot(t, yy2); xlabel('t (s)'); ylabel('v(t)');
    hold on; plot(t, coef2(1)*t + coef2(2), 'm-.', 'LineWidth', 2); axis([0 18 -8 2]);
    tau2b = -1/coef2(1);

    G2a = tf(K, [tau2a*tau2b  tau2a+tau2b  1], 'ioDelay', theta);
    y2 = lsim(G2a, u, t) + y0;

    figure(1); subplot(212); hold on; plot(t, y2, 'm--','LineWidth',2); xlabel('t (s)'); ylabel('y(t)');
    figure(1); hold on; plot(t, y2, 'm--','LineWidth',2); xlabel('t (s)'); ylabel('y(t)');
end