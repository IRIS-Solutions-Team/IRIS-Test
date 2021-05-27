
testCase = matlab.unittest.FunctionTestCase.fromFunction(@(x)x);


%% Test True

    m = Model("issue253Test.model", "Assign=", struct('a', 1));
    eq = get(m, 'Equations');
    assertEqual(testCase, string(eq), ["x1=101;"; "x2=102;"]);


%% Test False

    m = Model("issue253Test.model", "Assign=", struct('a', 15));
    eq = get(m, 'Equations');
    assertEqual(testCase, string(eq), ["x1=0;"; "x2=0;"]);

