% saveAs=Series/convertUnitTest.m

testCase = matlab.unittest.FunctionTestCase.fromFunction(@(x)x);

%% Test Business Daily

x1 = Series(dd(2020,1,1):dd(2020,3,"end"), @rand);
x2 = removeWeekends(x1);

y1 = convert(x1, Frequency.MONTHLY);
y2 = convert(x2, Frequency.MONTHLY);
y3 = convert(x1, Frequency.MONTHLY, "removeWeekends", true);
y4 = convert(x2, Frequency.MONTHLY, "method", @(x) mean(x, 'omitNaN'));
y5 = convert(x2, Frequency.MONTHLY, "missing", -100);
y6 = convert(x2, Frequency.MONTHLY, "removeMissing", true);

assertEqual(testCase, size(y1.Data, 1), 3);
assertTrue(testCase, isempty(y2));
assertEqual(testCase, size(y3.Data, 1), 3);
assertNotEqual(testCase, y1.Data, y3.Data);
assertEqual(testCase, y3.Data, y4.Data, "absTol", 1e-12);
assertLessThan(testCase, y5.Data, 0);
assertEqual(testCase, y3.Data, y6.Data, "absTol", 1e-12);
