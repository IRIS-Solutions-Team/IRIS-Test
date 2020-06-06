% saveAs=dates/isfreqUnitTest.m

testCase = matlab.unittest.FunctionTestCase.fromFunction(@(x)x);


%% Test DateWrapper
    i = ii(100);
    y = yy(2000);
    h = hh(2000);
    q = qq(2000);
    m = mm(2000);
    w = ww(2000);
    d = dd(2000);
    x = [i, y, h, q, m, w, d];
    assertEqual(testCase, isfreq(x, Frequency.INTEGER), logical([1, 0, 0, 0, 0, 0, 0]));
    assertEqual(testCase, isfreq(x, Frequency.YEARLY), logical([0, 1, 0, 0, 0, 0, 0]));
    assertEqual(testCase, isfreq(x, Frequency.HALFYEARLY), logical([0, 0, 1, 0, 0, 0, 0]));
    assertEqual(testCase, isfreq(x, Frequency.QUARTERLY), logical([0, 0, 0, 1, 0, 0, 0]));
    assertEqual(testCase, isfreq(x, Frequency.MONTHLY), logical([0, 0, 0, 0, 1, 0, 0]));
    assertEqual(testCase, isfreq(x, Frequency.WEEKLY), logical([0, 0, 0, 0, 0, 1, 0]));
    assertEqual(testCase, isfreq(x, Frequency.DAILY), logical([0, 0, 0, 0, 0, 0, 1]));



%% Test Numeric
    i = 100;
    y = numeric.yy(2000);
    h = numeric.hh(2000);
    q = numeric.qq(2000);
    m = numeric.mm(2000);
    w = numeric.ww(2000);
    d = numeric.dd(2000);
    x = [i, y, h, q, m, w, d];
    assertEqual(testCase, isfreq(x, 0), logical([1, 0, 0, 0, 0, 0, 0]));
    assertEqual(testCase, isfreq(x, 1), logical([0, 1, 0, 0, 0, 0, 0]));
    assertEqual(testCase, isfreq(x, 2), logical([0, 0, 1, 0, 0, 0, 0]));
    assertEqual(testCase, isfreq(x, 4), logical([0, 0, 0, 1, 0, 0, 0]));
    assertEqual(testCase, isfreq(x, 12), logical([0, 0, 0, 0, 1, 0, 0]));
    assertEqual(testCase, isfreq(x, 52), logical([0, 0, 0, 0, 0, 1, 0]));
    assertEqual(testCase, isfreq(x, 365), logical([0, 0, 0, 0, 0, 0, 1]));
