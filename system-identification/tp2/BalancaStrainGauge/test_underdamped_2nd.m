[num, den] = ord2(100,0.1);
tf(num, den);
[y_s, t_s] = step(tf(num, den));
u = [0; ones(length(t_s)-1,1)];
T = t_s(2) - t_s(1);
underdamped_2nd(y_s, 0, u, 0, 0.0031);
hold on
plot(t_s, y_s);