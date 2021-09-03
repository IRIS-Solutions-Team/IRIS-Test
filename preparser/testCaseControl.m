
this = matlab.unittest.FunctionTestCase.fromFunction(@(x)x);

m = Model.fromFile("testCaseControl.model");

x = access(m, "transition-variables");
assertEqual(this, x, ["AA", "BB", "CC"]);

x = access(m, "transition-shocks");
assertEqual(this, x, ["aa", "bb", "cc"]);

