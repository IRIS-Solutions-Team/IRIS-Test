
testCase = matlab.unittest.FunctionTestCase.fromFunction(@(x)x);

m1 = Model('ffrfUnitRootTest1.model', 'linear', true);
m2 = Model('ffrfUnitRootTest2.model', 'linear', true);
m3 = Model('ffrfUnitRootTest3.model', 'linear', true);

[m1, ~, info1] = solve(m1);
[m2, ~, info2] = solve(m2);
[m3, ~, info3] = solve(m3);

testCase.TestData.Model1 = m1;
testCase.TestData.Model2 = m2;
testCase.TestData.Model3 = m3;


%% Test XSF

m1 = testCase.TestData.Model1;
m2 = testCase.TestData.Model2;
m3 = testCase.TestData.Model3;

freq = 0.01 : 0.01 : pi;
x1 = xsf(m1, freq);
x2 = xsf(m2, freq);
x3 = xsf(m3, freq);

x1 = double(x1('trend', 'x'));
x2 = double(x2('trend', 'x'));
x3 = double(x3('trend', 'x'));

assertEqual(testCase, x1, x2, 'RelTol', 1e-8);
assertEqual(testCase, x1, x3, 'RelTol', 1e-8);


%% Test XSF

m1 = testCase.TestData.Model1;
m2 = testCase.TestData.Model2;
m3 = testCase.TestData.Model3;

freq = 0.01 : 0.01 : pi;
x1 = ffrf(m1, freq);
x2 = ffrf(m2, freq);
x3 = ffrf(m3, freq);

x1 = double(x1('trend', 'x'));
x2 = double(x2('trend', 'x'));
x3 = double(x3('trend', 'x'));

assertEqual(testCase, x1, x2, 'RelTol', 1e-8);
assertEqual(testCase, x1, x3, 'RelTol', 1e-8);

