% saveAs=Explanatory/lookupUnitTest.m

testCase = matlab.unittest.FunctionTestCase.fromFunction(@(x)x);

% Set up once
testCase.TestData.Object = Explanatory.fromString([
        ":a :b :c x = 0"
        ":b :c :d y = 0"
        ":c :d :e z = 0"
        ":0 u = 0"
        ":1 v = 0"
]);


%% Test LHS Names
    q = testCase.TestData.Object;
    [inx, qq, lhsNames] = lookup(q, "x", "z");
    assertEqual(testCase, inx, [true; false; true; false; false]);
    assertEqual(testCase, qq, q([1; 3]));
    assertEqual(testCase, lhsNames, ["x", "z"]);


%% Test Attributes
    q = testCase.TestData.Object;
    [inx, qq, lhsNames] = lookup(q, ":a", ":e");
    assertEqual(testCase, inx, [true; false; true; false; false]);
    assertEqual(testCase, qq, q([1; 3]));
    assertEqual(testCase, lhsNames, ["x", "z"]);


%% Test Combined
    q = testCase.TestData.Object;
    [inx, qq, lhsNames] = lookup(q, ":a", "z");
    assertEqual(testCase, inx, [true; false; true; false; false]);
    assertEqual(testCase, qq, q([1; 3]));
    assertEqual(testCase, lhsNames, ["x", "z"]);