
testCase = matlab.unittest.FunctionTestCase.fromFunction(@(x)x);
testCase.TestData.Model = Model('legacyKeywordsTest.model');


%% Test Variables

m = testCase.TestData.Model;

act = get(m, 'XNames');
exp = {'a', 'b', 'c'};
assertEqual(testCase, act, exp);

act = get(m, 'YNames');
exp = {'d'};
assertEqual(testCase, act, exp);


%% Test Log Variables

m = testCase.TestData.Model;

act = get(m, 'log');
assertEqual(testCase,  act.a, false);
assertEqual(testCase,  act.b, false);
assertEqual(testCase,  act.c, true);
assertEqual(testCase,  act.d, false);


%% Test Equations

m = testCase.TestData.Model;

act = get(m, 'XEqtn');
exp = transpose({'a=1;', 'b=2;', 'c=3;'});
assertEqual(testCase, act, exp);

act = get(m, 'YEqtn');
exp = transpose({'d=4;'});
assertEqual(testCase, act, exp);


%% Test Reporting

m = testCase.TestData.Model;

act = get(m, 'REqtn');
exp = transpose({'x=a+b+c+d', 'y=a-b', 'z=c-d'});
assertEqual(testCase, act, exp);

