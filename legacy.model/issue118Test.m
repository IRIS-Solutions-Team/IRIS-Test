
% Set Up Once

testCase = matlab.unittest.FunctionTestCase.fromFunction(@(x)x);


%% Test Simulate Issue 118

m = model('issue118Test.model');
m = sstate(m);
m = solve(m);
d = sstatedb(m, 1:20);
d.x(0) = 5;
s = simulate(m, d, 1:20);

xData = s.x(1:20);
yData = s.y(1:20);
dxData = s.x(1:20)-s.x(0:19);
assertEqual(testCase, d.x.RangeAsNumeric, (0:20));
assertEqual(testCase, d.y.RangeAsNumeric, (1:20));
assertEqual(testCase, s.x.RangeAsNumeric, (0:20));
assertEqual(testCase, s.y.RangeAsNumeric, (1:20));
assertEqual(testCase, yData, dxData, 'AbsTol', 1e-12);


