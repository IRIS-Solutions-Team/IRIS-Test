
% Set Up Once

testCase = matlab.unittest.FunctionTestCase.fromFunction(@(x)x);

%{
Model>>>>>
!variables
    a, b, c, d
!equations
    a = 0;
    b = 0;
    c = 0;
    d = 0;
!log-variables
    !all-but a
% Legacy keywords
!log_variables
    !all_but b
<<<<<Model
%}

fileName = 'allbutTest.model';
parser.grabTextFromCaller('Model', fileName);
m = model(fileName);
exp = struct('a', false, 'b', false, 'c', true, 'd', true);
act = get(m, 'Log');
assertEqual(testCase, act.a, exp.a);
assertEqual(testCase, act.b, exp.b);
assertEqual(testCase, act.c, exp.c);
assertEqual(testCase, act.d, exp.d);

