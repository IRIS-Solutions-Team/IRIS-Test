% saveAs=preparser/InterpUnitTest.m

testCase = matlab.unittest.FunctionTestCase.fromFunction(@(x)x);

%% Test Unicode Brackets

    p = parser.Preparser( );
    p.Assigned = struct('A', 1);
    p.Code = ' aaaa « A+1 » ';
    act = parser.Interp.parse(p);
    exp = ' aaaa 2 ';
    assertEqual(testCase, act, exp);
    act = parser.Interp.parse(p, @auto);
    exp = ' aaaa 2 ';
    assertEqual(testCase, act, exp);


%% Test Square Brackets

    p = parser.Preparser( );
    p.Assigned = struct('A', 1);
    p.Code = ' aaaa $[ A+1 ]$ ';
    act = parser.Interp.parse(p);
    exp = ' aaaa 2 ';
    assertEqual(testCase, act, exp);
    act = parser.Interp.parse(p, @auto);
    exp = ' aaaa 2 ';
    assertEqual(testCase, act, exp);


%% Test Angle Brackets

    p = parser.Preparser( );
    p.Assigned = struct('A', 1);
    p.Code = ' aaaa < A+1 > ';
    act = parser.Interp.parse(p);
    exp = ' aaaa 2 ';
    assertEqual(testCase, act, exp);
    act = parser.Interp.parse(p, @auto)
    exp = ' aaaa 2 ';
    assertEqual(testCase, act, exp);


%% Test Angle Brackets External Code

    p = parser.Preparser( );
    p.Assigned = struct('A', 1);
    code = ' aaaa < A+1 > ';
    act = parser.Interp.parse(p, code);
    exp = ' aaaa 2 ';
    assertEqual(testCase, act, exp);
