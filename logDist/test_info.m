
assertEqualTol = @(x, y) assert(abs(x/y-1)<1e-5);

%% Test Normal

f = logdist.normal(0.5, 0.1);
x = rand(1, 5);
info1 = f(x, 'info');
info2 = -cdiff2(f, x);
assertEqualTol(info1, info2);

%% Test Log Normal

f = logdist.lognormal(0.5, 0.1);
x = rand;
info1 = f(x, 'info');
info2 = -cdiff2(f, x);
assertEqualTol(info1, info2);

%% Test Beta

f = logdist.beta(0.5, 0.1);
x = rand;
info1 = f(x, 'info');
info2 = -cdiff2(f, x);
assertEqualTol(info1, info2);

%% Test Gamma

f = logdist.gamma(0.5, 0.1);
x = rand;
info1 = f(x, 'info');
info2 = -cdiff2(f, x);
assertEqualTol(info1, info2);

%% Test Inv Gamma

f = logdist.invgamma(0.5, 0.1);
x = rand;
info1 = f(x, 'info');
info2 = -cdiff2(f, x);
assertEqualTol(info1, info2);

%% Test Chi2

f = logdist.chi2(5);
x = rand;
info1 = f(x, 'info');
info2 = -cdiff2(f, x);
assertEqualTol(info1, info2);

