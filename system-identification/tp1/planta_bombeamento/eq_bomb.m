function xdot = eq_bomb(t,x)
% Simulacao da planta de bombeamento modelada na secao 1.4
% Copyright (c) 1998 por Luis A. Aguirre. Todos os direitos reservados.

% Declaracao de variaveis globais
%global Us
%global k
global TD
global SP1
global SP2

% Area do tanque
A=2.5;

%Incrementa o k, que indica qual o tempo da variavel de entrada.
% if t >= 1
%     k=t;
% else
%     k=1;
% end
	if t < TD
	  Usk = SP1;
	else 
	  Usk = SP2;
	end;

% entrada u em mA
% x(1) eh o nivel
% A seguir codifica-se a equacao (1.39)
xdot = 5.6e-4*sqrt(3554.9+682.8*Usk-1000*x(1)-10300)/A;
xdot = xdot -(3.06e-5+1.25e-5*sqrt(1000*x(1)))*sqrt(1000*x(1))/A;
%
% retirando o off-set de forma a se ter derivada igual a zero para
% nivel zero
xdot=xdot-5.6e-4*sqrt(3554.9+682.8*15.61-10300)/A;

% Ajuste da constante de tempo conforme descrito na secao 1.4.4
xdot=xdot*0.5;

