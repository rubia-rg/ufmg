%% Author: Rubia Guerra
function [tau1, K1, theta1, fig_num] = sundaresan(filename, fig_num)
    data = load(filename);
    t = data(:, 1);
    y = data(:, 2);
    u = [0; ones(length(t)-1,1)];
    y0 = mean(y(1:10));

    figure(fig_num+1);
    plot(t,u)
    
    figure(fig_num+2);
    subplot(2, 1, 1)
    plot(t, y)
    title('Original')
    subplot(2, 1, 2)
    plot(t, medfilt1(y, 3))
    title('Filtrado')
    hold on;
    
    y = medfilt1(y,3);

    % Metodo de Sundaresan:
    K1 = (mean(y(end-10:end)) - mean(y(1:10)))/(u(end) - u(1));
    yn = y - y0;
    yn = yn./K1;

    [~, t35] = min(abs(yn - yn(end) * 0.35));
    [~, t85] = min(abs(yn - yn(end) * 0.85));
    tau1 = 0.682 * (t(t85) - t(t35));
    theta1 = t(t35)-0.431*tau1;

    G1a = tf(K1, [tau1 1], 'ioDelay', theta1);
    y1 = lsim(G1a, u, t) + y0;
    
    figure(fig_num+2);
    subplot(2, 1, 2)
    plot(t, y1, 'm-.', 'LineWidth', 2)
    title('Estimado')
    
    txt = 'Tau estimado (1a ordem): ';
    disp(txt)
    disp(tau1)
    txt = 'Ganho estimado  (1a ordem): ';
    disp(txt)
    disp(K1)
    txt = 'Atraso puro de tempo estimado  (1a ordem): ';
    disp(txt)
    disp(theta1)
    
    fig_num = length(findobj('type','figure'));
end