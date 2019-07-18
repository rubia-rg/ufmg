function planta(filename)
    data = load(filename);
    t = data(:,1);
    y = data(:,2);
    y0 = y(1);
    u0 = 0;
    Ts = mean(diff(t));

    u = [0; ones(length(t)-1,1)] + u0;

    plot(t,y)
    hold on
    plot(t,medfilt1(y,3))
    legend('original','filtrado')

    y = medfilt1(y,3);

    % Metodo de Sundaresan:
    K1 = (mean(y(end-20:end)) - mean(y(1:20)))/(u(end)-u(1));
    yn = y - y0;
    yn = yn./K1;

    [~, t35] = min(abs(yn-yn(end)*0.35));
    [~, t85] = min(abs(yn-yn(end)*0.85));
    tau1 = 0.682*(t(t85)-t(t35));
    theta1 = t(t35)-0.431*tau1;

    G1a = tf(K1, [tau1 1], 'ioDelay', theta1);
    y1 = lsim(G1a, u, t) + y0;
    plot(t,y1)
	legend('original','filtrado','estimado')
    hold off

end