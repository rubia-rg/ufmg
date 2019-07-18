function nat_response(R, L, C)
    
    % Equação de Espaço de Estados
    A = [-R/L -1/L; 1/C 0];
    B = [1/L;0];
    C = eye(2);
    D = 0;
    sys = ss(A, B, C, D);
    
    tfinal = 1e-3;
    dt = 0.001e-3;
    tspan = 0:dt:tfinal;
    u = zeros(length(tspan), 1);
    
    % Condições Iniciais
    x0 = [0 1; 1 0]; 
    
    % Resposta Natural do circuito RCL com I(0) = 0A, Vc(0) = 1V 
    % Vc = 1V
    [y1, t1, ] = lsim(sys, u, tspan, x0(1,:));
    
    % Resposta Natural do circuito RCL com I(0) = 1A, Vc(0) = 0V
    [y2, t2, ] = lsim(sys, u, tspan, x0(2,:));

    vc = figure;
    plot(t1, y1(:,1), t1, y1(:,2))
    title('Resposta Natural: I(0) = 0A e Vc(0) = 1V')
    legend('I(t)','Vc(t)')
    xlabel('Tempo')
    ylabel('Amplitude')
    saveas(vc, 'resp_nat_vc.eps', 'epsc')

    it = figure;
    plot(t2, y2(:,1), t2, y2(:,2))
    title('Resposta Natural: I(0) = 1A e Vc(0) = 0V')
    legend('I(t)','Vc(t)')
    xlabel('Tempo')
    ylabel('Amplitude')
	saveas(it, 'resp_nat_it.eps', 'epsc')
    
end