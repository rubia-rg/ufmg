clear all; close all; clc;

% Parâmetros do circuito
R = 100;
L = 1e-3;
C = 1e-6;

% Vc(s)/V(s)
H1 = vc_transfer(R, L, C);

% I(s)/V(s)
H2 = i_transfer(R, L, C);

% Ex. 2.10 e 2.11
nat_response(R, L, C);