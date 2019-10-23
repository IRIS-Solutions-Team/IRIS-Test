function [Q, Omega, Q1] = identifyTest( )

%rng(0);
T = 100;
u = randn(6, T);
Omega = u*transpose(u)/T;
P = transpose(chol(Omega));

inxTril = true(size(P));
inxTril = tril(inxTril);

X = nan(size(P));
X(~inxTril) = 0;
pos = find(isnan(X));

inxDiag = eye(size(Omega))==1;
posDiag = find(inxDiag);

n = size(Omega, 1);
numFree = n*(n+1)/2
numZero = n*n - numFree;
pos = [ ];
QQ = 0;

pos = find(isnan(X));
pos = [1,2,3,4,6, 7,8,9,12, 15,18, 21,22,23,24, 27,28,29,30, 33,34,36];
pos = unique(randi(n*n, numFree-2, 1));

q0 = randn(size(pos));
%q0 = P(inxTril);

%{
oo = solver.Options('IRIS-Newton');
q = solver.algorithm.qnsd(@objective, q0, oo);
%}

oo = optimoptions('fminunc', 'FunctionTolerance', 1e-12, 'StepTolerance', 1e-12, 'Display', 'iter', 'OptimalityTolerance', 1e-12, 'MaxFunctionEvaluations', 1e6, 'MaxIterations', 1e6);
q = fminunc(@objective, q0, oo);

oo1 = optimset('MaxFunEvals', 1e6, 'MaxIter', 1e6, 'Display', 'iter');
q1 = fminsearch(@objective, q0, oo1);

pos'
[y, Q] = objective(q);
[y1, Q1] = objective(q);
maxabs(Q*Q'-Omega)
maxabs(Q1*Q1'-Omega)

function [y, Q] = objective(q)
    Q = zeros(size(P));
    Q(pos) = q;
    Sigma = Q*Q';
    %y = log( det(Q)^2 ) + trace( Qt\ (Q*Omega) );
    y = log(det(Sigma)) + trace( (Sigma)\Omega );
end%

end

