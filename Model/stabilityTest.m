
testCase = matlab.unittest.FunctionTestCase.fromFunction(@(x)x);


%% Test

m = Model.fromString([
    "!variables"
    "x"
    "!parameters"
    "a, b"
    "!equations"
    "x = a*x{-1} + b*x{+1};"
], "linear", true);

m = alter(m, 4);
m.a = [0.3, NaN, 1.5, 1.5];
m.b = [0.3, 0.3, 1.5, 0];
[m, exitFlag, info] = solve(m, "warning", false);


assertEqual(testCase, exitFlag(1), solve.StabilityFlag.UNIQUE_STABLE);
assertEqual(testCase, exitFlag(2), solve.StabilityFlag.NAN_SYSTEM);
assertEqual(testCase, exitFlag(3), solve.StabilityFlag.MULTIPLE_STABLE);
assertEqual(testCase, exitFlag(4), solve.StabilityFlag.NO_STABLE);


