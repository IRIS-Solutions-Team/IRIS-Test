% saveAs=textual/locateUnitTest.m

testCase = matlab.unittest.FunctionTestCase.fromFunction(@(x)x);


%% Test String
    items = ["aa", "BB", "C_"];
    list = ["BB", "x", "y", "zz", "C_", "C_"];
    pos = textual.locate(items, list);
    assertEqual(testCase, pos, [NaN, 1, 5]);


%% Test String First 
    items = ["aa", "BB", "C_"];
    list = ["BB", "x", "y", "zz", "C_", "C_"];
    pos = textual.locate(items, list, 'first');
    assertEqual(testCase, pos, [NaN, 1, 5]);



%% Test String Last
    items = ["aa", "BB", "C_"];
    list = ["BB", "x", "y", "zz", "C_", "C_"];
    pos = textual.locate(items, list, 'last');
    assertEqual(testCase, pos, [NaN, 1, 6]);



%% Test Cellstr
    items = {'aa', 'BB', 'C_'};
    list = {'BB', 'x', 'y', 'zz', 'C_', 'C_'};
    pos = textual.locate(items, list);
    assertEqual(testCase, pos, [NaN, 1, 5]);

