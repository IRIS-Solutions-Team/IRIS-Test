 
testCase = matlab.unittest.FunctionTestCase.fromFunction(@(x)x);


%% Test Vanilla

m = Model('issue255Test.model');
m = steady(m);
assertEqual(testCase, m.x, 0.7, 'AbsTol', 1e-10);
assertEqual(testCase, m.std_e, 1, 'AbsTol', 1e-10);
assertEqual(testCase, m.std_f, 2, 'AbsTol', 1e-10);
assertEqual(testCase, m.corr_e__f, 0.7, 'AbsTol', 1e-10);
assertEqual(testCase, m.y, 10.7, 'AbsTol', 1e-10);


%% Test Exogenize

m = Model('issue255Test.model');
m.x = 0.9;
m = deactivateLink(m, 'a');
m = steady(m, 'Exogenize', 'x', 'Endogenize', 'a');
assertEqual(testCase, m.x, 0.9, 'AbsTol', 1e-10);
assertEqual(testCase, m.std_e, 1, 'AbsTol', 1e-10);
assertEqual(testCase, m.std_f, 2, 'AbsTol', 1e-10);
assertEqual(testCase, m.corr_e__f, 0.9, 'AbsTol', 1e-10);
assertEqual(testCase, m.y, 10.9, 'AbsTol', 1e-10);

