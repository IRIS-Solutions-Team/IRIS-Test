% saveAs=Model/fromStringUnitTest.m

testCase = matlab.unittest.FunctionTestCase.fromFunction(@(x)x);

%% Test plain vanilla

m = Model.fromString([
    "!variables"
    "    x"
    "!shocks"
    "    eps_x"
    "!parameters"
    "    rho_x"
    "!equations"
    "    x = rho_x*x{-1} + eps_x;"
]);

act = access(m, "equations");
exp = "x=rho_x*x{-1}+eps_x;";
assertEqual(testCase, act, exp);
assertEqual(testCase, access(m, "fileName"), ModelSource.FILE_NAME_WHEN_INPUT_STRING);


%% Test options

m = Model.fromString([ "!variables"
    "    x"
    "!shocks"
    "    eps_x"
    "!parameters"
    "    rho_x"
    "!equations"
    "    x = rho_x*x{-1} + eps_x;"
], "linear", true);

act = access(m, "equations");
exp = "x=rho_x*x{-1}+eps_x;";
assertEqual(testCase, act, exp);
assertTrue(testCase, isLinear(m));
