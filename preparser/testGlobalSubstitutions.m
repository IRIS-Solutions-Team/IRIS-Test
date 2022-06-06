
testCase = matlab.unittest.FunctionTestCase.fromFunction(@(x)x);

%% Test

m = Model.fromFile([
    "testGlobalSubstitutions1.model"
    "testGlobalSubstitutions2.model"
]);

x = access(m, "equations");
assertEqual(testCase, x, ["a=-11;", "b=200;", "c=0.1;"]);

x = access(m, "preprocessor");
assertEqual(testCase, collectLhsNames(x), "eq_b");

x = access(m, "postprocessor");
assertEqual(testCase, collectLhsNames(x), "eq_c");

