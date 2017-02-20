

% Set Up Model

assertEqualTol = @(x, y) assert(maxabs(x, y)<1e-5);

rng(0);

m = model('test_estimate_steady.model', 'Linear=', true);
m.a = 0.7;
m.b = 0.3;
m.c = 10;
m.d = 0.7;
m.std_eps_x = 0.2;
m.std_eps_y = 0.2;
m = solve(m);
m = sstate(m);

range = 1:1000;
d = resample(m, [ ], range, 1); 

est = struct( );
est.a = { 0.5 , 0, 0.95 };
est.c = { 5 };

pEst0 = estimate(m, d, range, est);
pEst0

%% Test Estimate with No Steady State

m1 = m;
m1 = set(m1, 'Linear=', false);
pEst1 = estimate(m1, d, range, est);
pEst1

assertEqualTol(pEst1.c, est.c{1});

%% Test Estimate with Steady State

m2 = m;
m2 = set(m2, 'Linear=', false);
pEst2 = estimate(m2, d, range, est, 'Steady=', true);

assertEqualTol(pEst2.a, pEst0.a);
assertEqualTol(pEst2.c, pEst0.c);
