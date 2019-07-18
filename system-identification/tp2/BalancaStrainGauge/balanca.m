function balanca(filename)
    data = load(filename, '-ascii');
    t = data(:,1);
    y = data(:,2);
    
    y = y(t>=0);
    t = t(t>=0);
    u = [0; ones(length(t)-1,1)];

    y0 = 0;
    u0 = u(1);
    T = 0.005;
    
    ynorm = (y - min(y))./(max(y)-min(y));

    underdamped_2nd(ynorm, y0, u, u0, T);
    hold on
    plot(t,ynorm)
end