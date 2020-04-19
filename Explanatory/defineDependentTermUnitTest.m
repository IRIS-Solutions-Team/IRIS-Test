
testCase = matlab.unittest.FunctionTestCase.fromFunction(@(x)x);

% Set up once
    expy = ExplanatoryTest( );
    expy = setp(expy, 'VariableNames', ["x", "y", "z"]);
    testCase.TestData.Model = expy;


%% Test Pointer
    expy = testCase.TestData.Model;
    expy = defineDependentTerm(expy, 3, "Transform=", "log");
    act = getp(expy, 'DependentTerm');
    exp = regression.Term(expy, 3, "Transform", "log");
    exp.Fixed = 1;
    exp.ContainsLhsName = true;
    assertEqual(testCase, act, exp);
    act = expy.LhsName;
    exp = "z";
    assertEqual(testCase, act, exp);


%% Test Name
    expy = testCase.TestData.Model;
    expy = defineDependentTerm(expy, "z", "Transform=", "log");
    act = getp(expy, 'DependentTerm');
    exp = regression.Term(expy, 3, "Transform", "log");
    exp.Fixed = 1;
    exp.ContainsLhsName = true;
    assertEqual(testCase, act, exp);
    act = expy.LhsName;
    exp = "z";
    assertEqual(testCase, act, exp);


%% Test Transform
    expy = testCase.TestData.Model;
    expy = defineDependentTerm(expy, "log(z)");
    act = getp(expy, 'DependentTerm');
    exp = regression.Term(expy, 3, "Transform", "log");
    exp.Fixed = 1;
    exp.ContainsLhsName = true;
    assertEqual(testCase, act, exp);
    act = expy.LhsName;
    exp = "z";
    assertEqual(testCase, act, exp);


%% Test Invalid Shift
    expy = testCase.TestData.Model;
    thrownError = false;
    try
        expy = defineDependentTerm(expy, "z", "Transform=", "log", "Shift=", -1);
    catch exc
        thrownError = true;
    end
    assertEqual(testCase, thrownError, true);

