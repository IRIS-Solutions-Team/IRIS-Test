

drawnow
close all
clear

testCase = matlab.unittest.FunctionTestCase.fromFunction(@(x)x);
rng(0);


%% Test exclude from objective function

m = Model.fromFile("excludeFromObjFuncTest.model", "linear", true);

m.rho_x = 0.8;
m.rho_y = 0.8;
m.std_shk_x = 0.1;
m.std_shk_y = 0.1;

m = solve(m);
m = steady(m);

d = databank.forModel(m, 1:100, "deviation", false, "shockFunc", @randn);
s = simulate(m, d, 1:100);

[f0, ~, info0] = kalmanFilter(m, s, 1:100);
[f1, ~, info1] = kalmanFilter(m, s, 1:100, "excludeFromObjFunc", "obs_y");
[f2, ~, info2] = kalmanFilter(m, s, 1:100, "excludeFromObjFunc", "obs_x");

assertEqual(testCase, info0.MinusLogLik, info1.MinusLogLik+info2.MinusLogLik, "absTol", 1e-12);

