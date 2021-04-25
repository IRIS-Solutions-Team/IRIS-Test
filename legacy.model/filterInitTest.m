
% Setup once

testCase = matlab.unittest.FunctionTestCase.fromFunction(@(x)x);

m = model('filterInitTest.model', 'Linear', true);
m = solve(m);
m = sstate(m);
filterRange = 1:20;


%% Test User Supplied Initial Conditions Databank

d = sstatedb(m, filterRange);
d.x_obs = d.x_obs + Series(filterRange, randn(numel(filterRange),1));
d.y_obs = d.y_obs + Series(filterRange, randn(numel(filterRange),1));
d.x_bar(0) = 0.5;
d.y_bar(0) = -0.5;

[~, f1] = filter(m, d, filterRange, 'InitCond', d, 'MeanOnly', true);

assertEqual(testCase, d.x_bar(0), f1.x_bar(0), 'AbsTol', 1e-10);
assertEqual(testCase, d.y_bar(0), f1.y_bar(0), 'AbsTol', 1e-10);

assertEqual(testCase, d.x_obs(filterRange), f1.x(filterRange), 'AbsTol', 1e-10);
assertEqual(testCase, d.y_obs(filterRange), f1.y(filterRange), 'AbsTol', 1e-10);

