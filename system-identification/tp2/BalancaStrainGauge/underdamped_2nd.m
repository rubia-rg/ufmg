function underdamped_2nd(y, y0, u, u0, T)

    % gain
    K = (mean(y) - y0)/(u(end) - u0);
    
    % eta
    [~, p] = findpeaks(y);
    peak_interval = mean(diff(p));
    N_c = numel(p);
    eta = 0.6/N_c;

    % time between two successive peaks
    P = peak_interval*T;

    % beta
    beta = sqrt(1-eta^2);

    % natural frequency
    wn = 2*pi/(beta*P);

    % transfer function
    num = K*wn^2;
    den = [1 2*eta*wn wn^2];
    sys = tf(num, den);

    [y_s, t_s] = step(sys);

    plot(t_s, y_s)

end