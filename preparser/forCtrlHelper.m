function forCtrlHelper(inpCode, expCode, assign)
    import parser.Preparser
    testCase = matlab.unittest.FunctionTestCase.fromFunction(@(x)x);
    if nargin<3
        assign = struct( ); 
    end
    actCode = Preparser.parse([ ], inpCode, 'assigned=', assign);
    actCode = Preparser.removeInsignificantWhs(actCode);
    expCode = Preparser.removeInsignificantWhs(expCode);
    assertEqual(testCase, actCode, expCode);
end
