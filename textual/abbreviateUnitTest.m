% saveAs=textual/abbreviateUnitTest.m

testCase = matlab.unittest.FunctionTestCase.fromFunction(@(x)x);


%% Test Char
    act = textual.abbreviate('abcdefg', 'MaxLength=', 5);
    exp = ['abcd', char(8230)];
    assertEqual(testCase, act, exp);


%% Test String
    act = textual.abbreviate("abcdefg", "MaxLength=", 5);
    exp = "abcd" + string(char(8230));
    assertEqual(testCase, act, exp);


%% Test Short String
    exp = "abcdefg";
    act = textual.abbreviate(exp);
    assertEqual(testCase, act, exp);
