% saveAs=series.x13/seasonUnitTest.m

testCase = matlab.unittest.FunctionTestCase.fromFunction(@(x)x);

%% Test Vanilla

data = randn(40, 1);
data = series.cumsumk(data, 4);
