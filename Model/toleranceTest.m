
% Set Up Once

testCase = matlab.unittest.FunctionTestCase.fromFunction(@(x)x);


%% Steady Tolerance Issue #211 

m = Model.fromFile('toleranceTest.model');
m = tolerance(m, 'Steady', 1e-1);

tol = tolerance(m, 'Steady');

assertEqual(testCase, tol, 1e-1);

m = steady(m, 'Solver', {@auto, 'FunctionTolerance', 1e-1, 'StepTolerance', 1e-1});
checkSteady(m);

