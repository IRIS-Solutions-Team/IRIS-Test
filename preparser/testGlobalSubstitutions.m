
this = matlab.unittest.FunctionTestCase.fromFunction(@(x)x);

m = Model.fromFile([
    "testGlobalSubstitutions1.model"
    "testGlobalSubstitutions2.model"
]);

x = access(m, "equations");
assertEqual(this, x, ["a=-11;", "b=200;", "c=0.1;"]);

x = access(m, "preprocessor");
assertEqual(this, collectLhsNames(x), "eq_b");

x = access(m, "postprocessor");
assertEqual(this, collectLhsNames(x), "eq_c");

