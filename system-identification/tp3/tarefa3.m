%%Tarefa 3
%autores:João Pedro Campos / Rúbia Reis Guerra
clear all
clc

%parametros
Jm = 0.0013;
mp = 0.8;
bp = 0;
bm = 0;
R = 0.10;
L = 0.40;
d = 0.05;
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
dot_H_th=simplify(diff(H_th,th));

th=(-0.01:0.0001:1.01)*2*pi;
Th_in=th;
H_th_out=double(subs(H_th,th));
dot_H_th_out=double(subs(dot_H_th,th));

diagrama = 'Crank_and_rod_POG_mdl';
sim([diagrama], Tfin);
