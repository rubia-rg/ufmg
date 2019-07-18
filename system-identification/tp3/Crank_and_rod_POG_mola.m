%%Tarefa 3
%autores:João Pedro Campos / Rúbia Reis Guerra
%% based on material from System and Control Theory, by Prof. Roberto Zanasi: 
%% http://www.dii.unimo.it/~zanasi/didattica/Teoria_dei_Sistemi/System_and_Control_Theory_2017.htm
clear
close all
clc

%parametros
Jm = 0.0013;
mp = 0.8;
bp = 0;
bm = 0;
R = 0.10;
L = 0.40;
d = 0.0;
k = 10;

%valores iniciais
Wm_0 = 20.944; %200 rpm
Thm_0 = 0;

%sinais exogenos
Tm = 0;
Fp = 0;

%parametros de simulacao
Tfin=10;
Tc=Tfin/4000;

%variaveis de estado
syms th x

x_th = R*cos(th)+ sqrt(L^2-(R*sin(th)-d)^2);

H_th=simplify(diff(x_th,th));
% pretty(H_th)
dot_H_th=simplify(diff(H_th,th));
% pretty(dot_H_th)

th=(-0.01:0.0001:1.01)*2*pi;
Th_in=th;
H_th_out=double(subs(H_th,th));
dot_H_th_out=double(subs(dot_H_th,th));

MainString = 'Crank_and_rod_POG_mdl';
sim([MainString], Tfin);

% Plot 
Lw = 2;
print_flag = 1;

figure(2)
clf
subplot(211)
plot(Wm,'LineWidth',Lw)
grid on
ylabel('Wm [rpm]')
%
subplot(212)
plot(dot_x,'LineWidth',Lw)
grid on
ylabel('dotx [m/s]')
xlabel('t [sec]')
if print_flag;    eval(['print -depsc ' MainString '_' double(gcf)]); end


figure(3)
clf
subplot(211)
Em=0.5*Wm.^2.*J_th;
plot(t,Em,'LineWidth',Lw)
ylim([0.99 1.01]*mean(Em))
grid on
ylabel('Em [J]')
xlabel('t [sec]')
if Stampa;    eval(['print -depsc ' MainString '_' double(gcf)]); end

return

