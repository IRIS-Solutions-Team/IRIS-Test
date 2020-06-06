% saveAs=parser/EquationUnitTest.m

testCase = matlab.unittest.FunctionTestCase.fromFunction(@(x)x);

% Set up Once
    obj = parser.theparser.Equation( );
    obj.Type = 2;
    code = [
        "a = a{-1} :!! a = 0;"
        "b = b{-1} !!: b = 0;"
        "c = c{-1} !! c = 0;"
        "d = d{-1};"
    ];
    code = char(join(code, " "));
    testCase.TestData.Obj = obj;
    testCase.TestData.Code = code;


%% Test Equation Switch Auto
    obj = testCase.TestData.Obj;
    code = testCase.TestData.Code;
    eqn = model.component.Equation( );
    eun = parser.EquationUnderConstruction( );
    opt = struct( );
    opt.EquationSwitch = @auto;
    [~, eqn] = parse(obj, [ ], code, [ ], eqn, eun, [ ], opt);
    exp_Input = {'a=a{-1}', 'b=0', 'c=c{-1}!!c=0', 'd=d{-1}'};
    assertEqual(testCase, eqn.Input, exp_Input);
    assertEqual(testCase, cellfun('isempty', eun.LhsSteady), [true, true, false, true]);


%% Test Equation Switch Dynamic
    obj = testCase.TestData.Obj;
    code = testCase.TestData.Code;
    eqn = model.component.Equation( );
    eun = parser.EquationUnderConstruction( );
    opt.EquationSwitch = 'Dynamic';
    [~, eqn] = parse(obj, [ ], code, [ ], eqn, eun, [ ], opt);
    exp_Input = {'a=a{-1}', 'b=b{-1}', 'c=c{-1}', 'd=d{-1}'};
    assertEqual(testCase, eqn.Input, exp_Input);
    assertEqual(testCase, cellfun('isempty', eun.LhsSteady), true(1, 4));



%% Test Equation Switch Steady
    obj = testCase.TestData.Obj;
    code = testCase.TestData.Code;
    eqn = model.component.Equation( );
    eun = parser.EquationUnderConstruction( );
    opt.EquationSwitch = 'Steady';
    [~, eqn] = parse(obj, [ ], code, [ ], eqn, eun, [ ], opt);
    exp_Input = {'a=0', 'b=0', 'c=0', 'd=d{-1}'};
    assertEqual(testCase, eqn.Input, exp_Input);
    assertEqual(testCase, cellfun('isempty', eun.LhsSteady), true(1, 4));
