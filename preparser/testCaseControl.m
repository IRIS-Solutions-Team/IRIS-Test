
testCase = matlab.unittest.FunctionTestCase.fromFunction(@(x)x);


%% Test case control

m = Model.fromFile("testCaseControl.model");

x = access(m, "transition-variables");
assertEqual(testCase, x, ["AA", "BB", "CC"]);

x = access(m, "transition-shocks");
assertEqual(testCase, x, ["aa", "bb", "cc"]);

