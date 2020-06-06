
testCase = matlab.unittest.FunctionTestCase.fromFunction(@(x)x);

%% Yearly

d1 = double(yy(2010));
d2 = double(yy(2010, 1));
d3 = numeric.datecode(1, 2010);
d4 = numeric.datecode(1, 2010, 1);
assertEqual(testCase, d1, d2);
assertEqual(testCase, d1, d3);
assertEqual(testCase, d1, d4);

%% Half-Yearly

d1 = double(hh(2010));
d2 = double(hh(2010, 1));
d3 = numeric.datecode(2, 2010);
d4 = numeric.datecode(2, 2010, 1);
assertEqual(testCase, d1, d2);
assertEqual(testCase, d1, d3);
assertEqual(testCase, d1, d4);

d1 = double(hh(2010, 2));
d2 = numeric.datecode(2, 2010, 2);
assertEqual(testCase, d1, d2);

%% Quarterly

d1 = double(qq(2010));
d2 = double(qq(2010, 1));
d3 = numeric.datecode(4, 2010);
d4 = numeric.datecode(4, 2010, 1);
assertEqual(testCase, d1, d2);
assertEqual(testCase, d1, d3);
assertEqual(testCase, d1, d4);

d1 = double(qq(2010, 3));
d2 = numeric.datecode(4, 2010, 3);
assertEqual(testCase, d1, d2);

%% Monthly

d1 = double(mm(2010));
d2 = double(mm(2010, 1));
d3 = numeric.datecode(12, 2010);
d4 = numeric.datecode(12, 2010, 1);
assertEqual(testCase, d1, d2);
assertEqual(testCase, d1, d3);
assertEqual(testCase, d1, d4);

d1 = double(mm(2010, 11));
d2 = numeric.datecode(12, 2010, 11);
assertEqual(testCase, d1, d2);

%% Weekly

d1 = double(ww(2010));
d2 = double(ww(2010, 1));
d3 = numeric.datecode(52, 2010);
d4 = numeric.datecode(52, 2010, 1);
assertEqual(testCase, d1, d2);
assertEqual(testCase, d1, d3);
assertEqual(testCase, d1, d4);

d1 = double(ww(2010, 51));
d2 = numeric.datecode(52, 2010, 51);
assertEqual(testCase, d1, d2);

