% saveAs=preparser/InterpUnitTest.m

testCase = matlab.unittest.FunctionTestCase.fromFunction(@(x)x);


%% Test Unicode Brackets 

if ~verLessThan('matlab', '9.9')
    open = string(parser.Interp.OPEN);
    open = string(parser.Interp.OPEN);
    close = string(parser.Interp.CLOSE);
    p = parser.Preparser( );
    p.Assigned = struct('A', 1, 'B', [3, 4]);
    p.Code = " aaaa " + open + " A+1 " + close + " " + open + " B+2 " + close + " ";
    [act, actClear, actTokens] = parser.Interp.parse(p);
    exp = " aaaa 2 5, 6 ";
    expTokens = string([2, 5, 6]);
    assertEqual(testCase, act, exp);
    act = parser.Interp.parse(p, p.Code);
    assertEqual(testCase, act, exp);
    assertEqual(testCase, actClear, join([" aaaa ", " ", " ", " ", " "], ""));
    assertEqual(testCase, actTokens, string([2, 5, 6]));
end


%% Test Square Brackets 

    p = parser.Preparser( );
    p.Assigned = struct('A', 1, 'B', [3, 4]);
    p.Code = " aaaa $[ A+1 ]$ $[ B+2 ]$ ";
    act = parser.Interp.parse(p);
    exp = " aaaa 2 5, 6 ";
    assertEqual(testCase, act, exp);
    act = parser.Interp.parse(p, p.Code);
    assertEqual(testCase, act, exp);


%% Test Angle Brackets 

    p = parser.Preparser( );
    p.Assigned = struct('A', 1, 'B', [3, 4]);
    p.Code = " aaaa < A+1 > < B + 2 > ";
    act = parser.Interp.parse(p);
    exp = " aaaa 2 5, 6 ";
    assertEqual(testCase, act, exp);
    act = parser.Interp.parse(p, p.Code);
    assertEqual(testCase, act, exp);


%% Test Angle Brackets when AngleBrackets=false

    p = parser.Preparser( );
    p.Assigned = struct('A', 1);
    p.AngleBrackets = false;
    p.Code = " aaaa < A+1 > < B + 2 > ";
    act = parser.Interp.parse(p);
    exp = string(p.Code);
    assertEqual(testCase, act, exp);
