
% Set Up Once
testCase = matlab.unittest.FunctionTestCase.fromFunction(@(expected)expected);


%% Test char2file and file2char

expected = 'abcdeěščřž';

char2file(expected, 'test1.txt');
actual1 = file2char('test1.txt');
assertEqual(testCase, actual1, expected);

char2file(expected, 'test2.txt', 'char', 'Encoding=', 'UTF-8');
actual2 = file2char('test2.txt', 'char', 'Encoding=', 'UTF-8');
assertEqual(testCase, actual2, expected);

char2file(expected, 'test3.txt', 'char', 'Encoding=', 'US-ASCII');
actual3 = file2char('test3.txt', 'char', 'Encoding=', 'US-ASCII');
assertEqual(testCase, actual3(1:5), expected(1:5));

