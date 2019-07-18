close all
clear all
clc

x = linspace(-pi/2, 3*pi/2, 100);
x(100) = 4.712;

y = cos(x);

fis = readfis("sugeno_cos.fis");
yhat = evalfis(x, fis);

err = y' - yhat;
mse = sum(err.^2)/length(x);


plot(x, yhat)
hold on
plot(x, y)

legend("Sugeno","cos(x)")