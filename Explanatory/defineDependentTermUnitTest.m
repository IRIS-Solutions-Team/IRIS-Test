% saveAs=Explanatory/defineDependentTermUnitTest.m

testCase = matlab.unittest.FunctionTestCase.fromFunction(@(x)x);

% Set up once
    expy = Explanatory( );
    expy = setp(expy, 'VariableNames', ["x", "y", "z"]);
    testCase.TestData.Model = expy;


%% Test Name
    expy = testCase.TestData.Model;
    expy = defineDependentTerm(expy, "z");
    act = getp(expy, 'DependentTerm');
    assertEqual(testCase, act.Position, 3);
    assertEqual(testCase, act.Shift, 0);
    assertEqual(testCase, string(act.Expression), "x(3,t,v)");


%% Test Transform
    expy = testCase.TestData.Model;
    expy = defineDependentTerm(expy, "difflog(z,-4)");
    act = getp(expy, 'DependentTerm');
    assertEqual(testCase, string(act.Expression), "(log(x(3,t,v))-log(x(3,t-4,v)))");

%% Test Invalid Shift
    expy = testCase.TestData.Model;
    thrownError = false;
    try
        expy = defineDependentTerm(expy, "log(z{-1})");
    catch exc
        thrownError = true;
    end
    assertEqual(testCase, thrownError, true);
