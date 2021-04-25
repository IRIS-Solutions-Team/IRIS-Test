testCase = matlab.unittest.FunctionTestCase.fromFunction(@(x)x);


%% Test

row = 10;
col = 20;
pag = 4;
data = rand(row, col, pag);
x = tseries(1, data);

x1 = prctile(x, [30, 70], 1);
p1 = numeric.prctile(data, [30, 70], 1);
assertEqual(testCase, x1, p1);
assertClass(testCase, x1, 'double');

x2 = prctile(x, [30, 70], 2);
p2 = numeric.prctile(data, [30, 70], 2);
assertClass(testCase, x2, 'tseries');
assertEqual(testCase, x2.Data, p2);
assertSize(testCase, x2.Comment, [1, 2, pag]);
assertClass(testCase, x2.Comment, "string");

x3 = prctile(x, [30, 70], 3);
p3 = numeric.prctile(data, [30, 70], 3);
assertClass(testCase, x3, 'tseries');
assertEqual(testCase, x3.Data, p3);
assertSize(testCase, x3.Comment, [1, col, 2]);
assertClass(testCase, x3.Comment, "string");
