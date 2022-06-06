
testCase = matlab.unittest.FunctionTestCase.fromFunction(@(x)x);

m = Model.fromFile("exogenousVariablesTest.model", "growth", true, "allowExogenous", true);

m.z1 = 1 + 1i;
m.z2 = 2;

m = steady(m);
m = solve(m);

d = steadydb(m, 1:10);
d.z1 = Series(0:10, @rand);
d.z2 = Series(0:10, @rand);



%% Steady state

assertEqual(testCase, real(m.x), real(m.z1)-imag(m.z1)+real(m.z2), "absTol", 1e-12);
assertEqual(testCase, imag(m.x), imag(m.z1), "absTol", 1e-12);


%% Stacked time

s = simulate( ...
    m, d, 1:10 ...
    , "method", "stacked" ...
    , "startIter", "data" ...
);

assertEqual(testCase, s.x(1:10), d.z1((1:10)-1)+d.z2(1:10)+d.e(1:10), "absTol", 1e-12);


%% Period-by-period


s = simulate( ...
    m, d, 1:10 ...
    , "method", "period" ...
    , "startIter", "data" ...
);

assertEqual(testCase, s.x(1:10), d.z1((1:10)-1)+d.z2(1:10)+d.e(1:10), "absTol", 1e-12);
