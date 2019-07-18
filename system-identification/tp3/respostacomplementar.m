%% Authors: Rubia Guerra and Joao Pedro Araujo
%% Adapted from System Identification Class Notes, by 
%% Prof. Bruno Teixeira, UFMG
function [K, tau2a, tau2b, fig_num] = respostacomplementar(filename, fig_num)
    data = load(filename);
    t = data(:,1);
    y = data(:,2);
    y0 = y(1);
    Ay = abs(y(end)-y(1));
    
    u0 = 0;
    u = [0; ones(length(t)-1, 1)] + u0;
    Au = abs(u(end)-u(1));
    
    K = Ay/Au;
    
    figure(fig_num+1); 
    subplot(211); stairs(t, u,'LineWidth',2); xlabel('t (s)'); ylabel('u(t)');
    subplot(212); plot(t, y); xlabel('t (s)'); ylabel('y(t)');
    
    y = y - y0;
    yn = (y - min(y))./(max(y)-min(y));
    
    u = flip(u);
    u = u - u0;
    
    idx = find(yn>=0.05, 1, 'first');
    idxend = find(u>=1, 1, 'first');
    
    u(idx:idxend-1) = u(idx:idxend-1)+u(end);
    
    Ayn = mean(yn(1:5))-mean(yn(end-5:end));
    K1 = abs(Ayn/Au);
    
    %% Resposta complementar:
    yy = log(abs(1 - yn./(K1*u)));
    figure(fig_num+2); subplot(211); plot(t, yy); xlabel('t (s)'); ylabel('ln(1 - y(t)/(K*u(t)))');
    figure(fig_num+2); plot(t, yy); xlabel('t (s)'); ylabel('w(t)');
    coef = polyfit(t(10:100), yy(10:100), 1);
    hold on; plot(t, coef(1)*t + coef(2), 'm-.', 'LineWidth', 2); axis([-1 10 -8 6]);
    tau2a = -1/coef(1);

    yy2 = log(abs(exp(coef(2))*exp(-(t)./tau2a) - (1 - yn./(K1*u))));
    coef2 = polyfit(t(1:45), yy2(1:45), 1);
    figure(fig_num+2); subplot(212); plot(t, yy2); xlabel('t (s)'); ylabel('v(t)');
    hold on; plot(t, coef2(1)*t + coef2(2), 'm-.', 'LineWidth', 2); axis([-1 10 -8 2]);
    tau2b = -1/coef2(1);

    G2a = tf(K, [tau2a*tau2b  tau2a+tau2b  1]);
    y2 = lsim(G2a, u, t) + y0;

    figure(fig_num+1); 
    subplot(212); hold on; 
    plot(t, y2, 'm--','LineWidth',2); xlabel('t (s)'); ylabel('y(t)');
    xlabel('t (s)'); ylabel('y(t)');
    
    txt = 'Tau_a estimado (2a ordem): ';
    disp(txt)
    disp(tau2a)
    txt = 'Tau_b estimado (2a ordem): ';
    disp(txt)
    disp(tau2b)
    txt = 'Ganho estimado  (2a ordem): ';
    disp(txt)
    disp(K)

    fig_num = length(findobj('type','figure'));
end