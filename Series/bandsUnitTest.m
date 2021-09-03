
testCase = matlab.unittest.FunctionTestCase.fromFunction(@(x)x);

d.x = Series(qq(2020,1:10), [(1:10)', (11:20)']);
d.lower = -Series(qq(2020, 1:10), @rand);
d.upper = Series(qq(2020, 1:10), @rand);

figure('visible', 'off');
[h, b] = bands(d.x, d.lower, d.upper);

assertEqual(testCase, numel(h), 2);
assertEqual(testCase, get(h(1), 'type'), 'line');
assertEqual(testCase, get(h(2), 'type'), 'line');

assertEqual(testCase, numel(b), 2);
assertEqual(testCase, get(b(1), 'type'), 'patch');
assertEqual(testCase, get(b(2), 'type'), 'patch');

