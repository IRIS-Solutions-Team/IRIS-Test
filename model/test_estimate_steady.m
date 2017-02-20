% Set Up Model

assertEqual = @(x, y) assert(isequal(x, y));
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

pEst0 = estimate(m, d, range, est, 'Display=', 'off');

%% Test Linear Estimate with Steady State

m3 = m;
profile clear;
profile on;
pEst3 = estimate(m3, d, range, est, 'Steady=', true, 'Display=', 'off');
stats = profile('info');

assertEqual( any(strcmp({stats.FunctionTable.FunctionName}, ...
    'model.steadyLinear')), true );
assertEqual( any(strcmp({stats.FunctionTable.FunctionName}, ...
    'model.steadyNonlinear')), false );

%% Test Nonlinear Estimate with No Steady State

m1 = m;
m1 = set(m1, 'Linear=', false);
profile clear;
profile on;
pEst1 = estimate(m1, d, range, est, 'Display=', 'off');
stats = profile('info');

assertEqual( any(strcmp({stats.FunctionTable.FunctionName}, ...
    'model.steadyLinear')), false );
assertEqual( any(strcmp({stats.FunctionTable.FunctionName}, ...
    'model.steadyNonlinear')), false );

assertEqualTol(pEst1.c, est.c{1});

%% Test Nonlinear Estimate with Steady State

m2 = m;
m2 = set(m2, 'Linear=', false);
profile clear;
profile on;
pEst2 = estimate(m2, d, range, est, 'Steady=', true, 'Display=', 'off');
stats = profile('info');

assertEqual( any(strcmp({stats.FunctionTable.FunctionName}, ...
    'model.steadyLinear')), false );
assertEqual( any(strcmp({stats.FunctionTable.FunctionName}, ...
    'model.steadyNonlinear')), true );

assertEqualTol(pEst2.a, pEst0.a);
assertEqualTol(pEst2.c, pEst0.c);
