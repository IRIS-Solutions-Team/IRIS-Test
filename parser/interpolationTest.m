
% Set Up Once

testCase = matlab.unittest.FunctionTestCase.fromFunction(@(x)x);


%% Test Interpolation in For

m = model('interpolationTest.model');
assertEqual(testCase, get(m, 'Names'), {'x_s', 'x_f', 'ttrend'});

