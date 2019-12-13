
testCase = matlab.unittest.FunctionTestCase.fromFunction(@(x)x);

%% Test Redundant Semicolons

m = Model('semicolonsTest.model');

act = get(m, 'XNames');
exp = {'a', 'b', 'c', 'd'};
assertEqual(testCase, act, exp);

act = get(m, 'XEqtn');
exp = transpose({'a=1;', 'b=2;', 'c=3;', 'd=4;'});
assertEqual(testCase, act, exp);

