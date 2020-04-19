
testCase = matlab.unittest.FunctionTestCase.fromFunction(@(x)x);

%% Test with Explanatory

expy = Explanatory.fromString(["x=x{-1}", "y=x+y{-1}"]);
p = Plan.forExplanatory(expy, 1:5);
p = exogenize(p, 1:2, "x");
p = exogenizeWhenData(p, 3:5, "x");
p = exogenizeWhenData(p, 1:5, "y");
exd = false(2, 5);
exd(1, 3:5) = true;
exd(2, 1:5) = true;
exd = [false(2, 1), exd];
assertEqual(testCase, p.InxToKeepEndogenousNaN, exd);

