% saveAs=Explanatory/checkUniqueLhsUnitTest.m

testCase = matlab.unittest.FunctionTestCase.fromFunction(@(x)x);

% Set up Once
    testCase.TestData.Object = ...
        Explanatory.fromString(["x=x{-1}", "diff(y)=z", "diff(x)=z"]);


%% Test Non Unique Error
    q = testCase.TestData.Object;
    errorThrown = false;
    try
        checkUniqueLhs(q);
    catch
        errorThrown = true;
    end
    assertEqual(testCase, errorThrown, true);
    errorThrown = false;
    try
        checkUniqueLhs(q, 'ThrowAs', 'Error');
    catch
        errorThrown = true;
    end
    assertEqual(testCase, errorThrown, true);


%% Test Unique
    q = testCase.TestData.Object;
    errorThrown = false;
    try
        checkUniqueLhs(q([1, 2]));
    catch
        errorThrown = true;
    end
    assertEqual(testCase, errorThrown, false);


%% Test Non Unique Warning
    q = testCase.TestData.Object;
    errorThrown = false;
    lastwarn('');
    try
        checkUniqueLhs(q, 'ThrowAs', 'Warning');
    catch
        errorThrown = true;
    end
    assertEqual(testCase, errorThrown, false);
    assertNotEmpty(testCase, lastwarn( ));
