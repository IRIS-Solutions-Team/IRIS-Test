% saveAs=Series/initUnitTest.m

testCase = matlab.unittest.FunctionTestCase.fromFunction(@(x)x);

function trimLeadingTest(this)
    data = [NaN NaN;2 NaN;3 4;NaN 5];
    x = Series(qq(2001,1):qq(2001,4), data);
    assertEqual(this, x.Data, data(2:end, :));
end%


function trimTrailingTest(this)
    data = [1 NaN;2 NaN;3 4; NaN NaN];
    x = Series(qq(2001,1):qq(2001,4), data);
    assertEqual(this, x.Data, data(1:3, :));
end%


function trimLeadingTrailingTest(this)
    data = [NaN NaN;2 NaN;3 4; NaN NaN];
    x = Series(qq(2001,1):qq(2001,4), data);
    assertEqual(this, x.Data, data(2:3, :));
end%
