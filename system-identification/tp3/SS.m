%%Tarefa 3
%autores:João Pedro Campos / Rúbia Reis Guerra
%% based on material from System and Control Theory, by Prof. Roberto Zanasi: 
%% http://www.dii.unimo.it/~zanasi/didattica/Teoria_dei_Sistemi/System_and_Control_Theory_2017.htm
%simulação por espaço de estados
clc
clear all

m = 0.8;
k = 3;
c = 4;
r = 0.1;
l = 0.4;

th=(0.0:0.001:1.0)*pi/2;
th = [th fliplr(th)];
alfa = asin(r/l * sin(th));
alfa = [alfa alfa alfa alfa alfa];
t = 0.01 * [1:length(alfa)];
A = [0,1;-k/m,-c/m];
B = [0;1/m];
C = [1,0];
D = 0;

SYS = ss(A,B,C,D);
f = 2*ones(length(t));
x = lsim(SYS, 8*cos(alfa), t,[2.5 0]);
dotx = diff(x,1);
plot(t,x);


