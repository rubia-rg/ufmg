function H = vc_transfer(R, L, C)
    
    % Vc(s)/V(s)
    num = [1];
    dem = [L*C R*C 1];
    H = tf(num, dem);
    
    % Diagrama de polos e zeros
    pz = figure;
    pzmap(H)
    saveas(pz, 'h1_pzmap.eps')
    
    % Resposta ao impulso
    im = figure;
    impulse(H)
    xlabel('Tempo')
    ylabel('Vc(t) (V)')
    title('H1(s): Resposta ao impulso')
    saveas(im, 'h1_impulso.eps')
    
    % Resposta ao degrau
    st = figure;
    step(H)
    xlabel('Tempo')
    ylabel('Vc(t) (V)')
    title('H1(s): Resposta ao degrau')
    saveas(st, 'h1_degrau.eps')
    
    % Resposta à rampa
    s = tf('s');
    
    rp = figure;
    step(H / s)
    xlabel('Tempo')
    ylabel('Vc(t) (V)')
    title('H1(s): Resposta à rampa')
    saveas(rp, 'h1_rampa.eps')
    
    % Resposta à entrada u(t) = 170cos(2pi60t)
    syms t
    u = 170*cos(2*pi*60*t);
    U = laplace(u);
    eval(['Us =', char(U)]);
    
    tfinal = 5 * (1/60);
    
    ut = figure;
    impulse(Us*H, tfinal)
    xlabel('Tempo')
    ylabel('Vc(t) (V)')
    title('H1(s): Resposta à entrada u(t)')
    saveas(ut, 'h1_ut.eps')
    
    % Diagrama de Bode
    bd = figure;
    bode(H)
    title('H1(s): Resposta em frequência')
    saveas(bd, 'h1_bode.eps')

end