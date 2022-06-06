
testCase = matlab.unittest.FunctionTestCase.fromFunction(@(x)x);
assertRelTol = @(x, y, tol) assertEqual(testCase, x, y, 'relTol', tol);


%% Test Regular Case

m = 1;
s = 0.2;
f = logdist.invgamma1(m, s);
a = f([ ], 'a');
b = f([ ], 'b');

f1 = logdist.invgamma1(NaN, NaN, a, b);
m1 = f1([ ], 'mean');
s1 = f1([ ], 'std');

assertRelTol(m, m1, 1e-8);
assertRelTol(s, s1, 1e-8);
