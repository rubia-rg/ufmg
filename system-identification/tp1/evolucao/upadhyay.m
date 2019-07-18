function dydt = upadhyay(t, y)

    A = 0.311;
    E = 0.161; 
    B = 0.518;
    F = 4.599;
    C = 1.036;
    G = 2.469;
    D = 0.311;
    H = 0.322;

    dydt = zeros(3,1);
    dydt(1) = y(1) * (1 - y(1)) - (y(1) * y(2))/(y(1) + A);
    dydt(2) = -B * y(2) + (C * y(1) * y(2))/(y(1) + D) ...
              - (y(2) * y(3))/(y(2) + E);
    dydt(3) = F * (y(3)^2) - (G * y(3)^2)/(y(2) + H);

end