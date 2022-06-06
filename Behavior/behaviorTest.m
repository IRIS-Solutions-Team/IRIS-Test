

testCase = matlab.unittest.FunctionTestCase.fromFunction(@(x)x);
testCase.TestData.Model = Model.fromFile('behaviorTest.model');


%% Test Log Style In Solution Vectors

    m = testCase.TestData.Model;
    actualVector = get(m, 'XVector');
    expectedVector = {'log_x'; 'log_y'; 'z'};
    testCase.assertEqual(actualVector, expectedVector);
    m = set(m, 'Behavior:LogStyleInSolutionVectors', 'log()');
    actualVector = get(m, 'XVector');
    expectedVector = {'log(x)'; 'log(y)'; 'z'};
    testCase.assertEqual(actualVector, expectedVector);
    m = set(m, 'Behavior:LogStyleInSolutionVectors', 'log_');
    actualVector = get(m, 'XVector');
    expectedVector = {'log_x'; 'log_y'; 'z'};
    testCase.assertEqual(actualVector, expectedVector);

