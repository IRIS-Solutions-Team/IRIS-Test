

testCase = matlab.unittest.FunctionTestCase.fromFunction(@(x)x);
assertRelTol = @(x, y, tol) assertEqual(testCase, x, y, 'relTol', tol);


rng(0);

%% Test Normal

f = logdist.normal(0.5, 0.1);
x = rand(1, 5);
info1 = f(x, 'info');
info2 = -cdiff2(f, x);
assertRelTol(info1, info2, 1e-5);

%% Test Log Normal

f = logdist.lognormal(0.5, 0.1);
x = rand;
info1 = f(x, 'info');
info2 = -cdiff2(f, x);
assertRelTol(info1, info2, 1e-5);

%% Test Beta

f = logdist.beta(0.5, 0.1);
x = rand;
info1 = f(x, 'info');
info2 = -cdiff2(f, x);
assertRelTol(info1, info2, 1e-5);

%% Test Gamma

f = logdist.gamma(0.5, 0.1);
x = rand;
info1 = f(x, 'info');
info2 = -cdiff2(f, x);
assertRelTol(info1, info2, 1e-5);

%% Test Inv Gamma

f = logdist.invgamma(0.5, 0.1);
x = rand;
info1 = f(x, 'info');
info2 = -cdiff2(f, x);
assertRelTol(info1, info2, 1e-5);

%% Test Inv Gamma1

f = logdist.invgamma1(0.5, 0.1);
x = rand;
info1 = f(x, 'info');
info2 = -cdiff2(f, x);
assertRelTol(info1, info2, 1e-5);

%% Test Chi2

f = logdist.chi2(5);
x = rand;
info1 = f(x, 'info');
info2 = -cdiff2(f, x);
assertRelTol(info1, info2, 1e-5);

