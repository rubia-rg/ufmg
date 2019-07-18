function H = i_transfer(R, L, C)
    
    % I(s)/V(s)
    num = [1 0];
    dem = [L*C R*C 1];
    H = tf(num, dem);

    % Diagrama de polos e zeros
    pz = figure;
    pzmap(H)
    saveas(pz, 'h2_pzmap.eps')
    
    % Resposta ao impulso
    im = figure;
    impulse(H)
    xlabel('Tempo')
    ylabel('I(t) (A)')
    title('H2(s): Resposta ao impulso')
    saveas(im, 'h2_impulso.eps')
    
    % Resposta ao degrau
    st = figure;
    step(H)
    xlabel('Tempo')
    ylabel('I(t) (A)')
    title('H2(s): Resposta ao degrau')
    saveas(st, 'h2_degrau.eps')
    
    % Resposta à rampa
    s = tf('s');
    
    rp = figure;
    step(H / s)
    xlabel('Tempo')
    ylabel('I(t) (A)')
    title('H2(s): Resposta à rampa')
    saveas(rp, 'h2_rampa.eps')
    
	% Resposta à entrada u(t) = 170cos(2pi60t)
    syms t
    u = 170*cos(2*pi*60*t);
    U = laplace(u);
    eval(['Us =', char(U)]);
    
	tfinal = 5 * (1/60);
    
    im = figure;
    impulse(Us*H, tfinal)
    xlabel('Tempo')
    ylabel('I(t) (A)')
    title('H2(s): Resposta à entrada u(t)')
    saveas(im, 'h2_ut.eps')
    
    % Diagrama de Bode
    bd = figure;
    bode(H)
    title('H2(s): Resposta em frequência')
    saveas(bd, 'h2_bode.eps')

end