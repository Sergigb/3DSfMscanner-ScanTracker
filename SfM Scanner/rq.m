function [K,R] = rq(A)

% function [K,R] = RQ(A)
% RQ decomposition of 3x3 A matrix into a rotative matrix R and a triangular 
%matrix K as follows:
% 
%       a11 a12 a13                   a b c
% A =   a21 a22 a23  = K * R ==> K =  0 d e ; R = R1 R2 R3
%       a31 a32 a33                   0 0 f
% 

% Init
K = eye(3);
R = ones(3,3);
A1 = A(1,:);
A2 = A(2,:);
A3 = A(3,:);

% Decomp
% f And R3
f = norm(A3);
R3 = 1/f * A3;

% e
e = A2 * R3';

% d and R2
aux = A2 - e * R3;
d = norm(aux);
R2 = 1/d * aux;

% b and c
b = A1 * R2';
c = A1 * R3';

% a and R1
aux = A1 - b*R2 - c*R3;
a = norm(aux);
R1 = 1/a * aux;

R = [R1;R2;R3];
K = [a b c; 0 d e; 0 0 f];






