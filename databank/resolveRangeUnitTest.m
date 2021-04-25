% saveAs=databank/resolveRangeUnitTest.m

testCase = matlab.unittest.FunctionTestCase.fromFunction(@(x)x);

% Set up Once
    d = struct( );
    d.a = Series(qq(2001,1):qq(2010,4), 1);
    d.b = Series(qq(2002,1):qq(2011,4), 1);
    d.c = Series(mm(2001,1), 1);


%% Test Names All Inf
    [from, to] = databank.backend.resolveRange(d, "a", -Inf, Inf);
    assertEqual(testCase, [from, to], [dater.qq(2001,1), dater.qq(2010,4)]);
    %
    [from, to] = databank.backend.resolveRange(d, ["a", "b"], -Inf, Inf);
    assertEqual(testCase, [from, to], [dater.qq(2001,1), dater.qq(2011,4)]);


%% Test Names Explicit Start
    [from, to] = databank.backend.resolveRange(d, ["a", "b"], qq(2005,1), Inf);
    assertEqual(testCase, [from, to], [dater.qq(2005,1), dater.qq(2011,4)]);


%% Test Names Explicit End
    [from, to] = databank.backend.resolveRange(d, ["a", "b"], -Inf, qq(2005,1));
    assertEqual(testCase, [from, to], [dater.qq(2001,1), dater.qq(2005,1)]);
