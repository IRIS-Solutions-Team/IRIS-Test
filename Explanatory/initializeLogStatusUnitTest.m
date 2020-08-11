% saveAs=Explanatory/initializeLogStatusUnitTest.m

testCase = matlab.unittest.FunctionTestCase.fromFunction(@(x)x);
expy = Explanatory.fromString(["a=x", "b=y", "c=z"]);


%% Test Default True

    log = ["a", "c"];
    expy = initializeLogStatus(expy, log);
    assertEqual(testCase, collectLogStatus(expy), [true, false, true]);


%% Test Default False

    log = Except(["a", "b"]);
    expy = initializeLogStatus(expy, log);
    assertEqual(testCase, collectLogStatus(expy), [false, false, true]);
