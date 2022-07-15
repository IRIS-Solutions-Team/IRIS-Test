
testCase = matlab.unittest.FunctionTestCase.fromFunction(@(x)x);

m = Model.fromFile("steadyWithLinksTest.model");

m.x = 1;
m.y = 2;

m = steady(m, "exogenize", ["x", "y"], "endogenize", ["a", "b"], "blocks", false);


