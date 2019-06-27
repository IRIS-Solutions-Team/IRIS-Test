
% Set Up Once

testCase = matlab.unittest.FunctionTestCase.fromFunction(@(x)x);


%% Test Find Incidence

m = model('findIncidenceTest.model');
incidence = get(m, 'Incidence');
actual = struct( );
actual.Dynamic = incidence.Dynamic.FullMatrix;
actual.Steady = incidence.Steady.FullMatrix;
expected = struct( );
expected.Dynamic = cat(3, false(9, 10), logical(eye(9, 10)), false(9, 10));
expected.Steady = cat(3, false(9, 10), logical(eye(9, 10)), false(9, 10));
expected.Steady(7:end, 7:end, 2) = false;
assertEqual(testCase, actual, expected);

