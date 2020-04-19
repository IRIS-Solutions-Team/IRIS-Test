
testCase = matlab.unittest.FunctionTestCase.fromFunction(@(x)x);

%% Test Plain Vanilla
    input = "x = @*a + b*x{-1} + @*log(c);";
    act = ExplanatoryTest.fromString(input);
    exp = ExplanatoryTest( );
    exp = setp(exp, 'VariableNames', ["x", "a", "b", "c"]);
    exp = setp(exp, 'InputString', regexprep(input, "\s+", ""));
    exp = defineDependentTerm(exp, 1);
    exp = addExplanatoryTerm(exp, 2);
    exp = addExplanatoryTerm(exp, 4, "Transform=", "log");
    exp = addExplanatoryTerm(exp, "b*x{-1}", "Fixed=", 1);
    assertEqual(testCase, act, exp);
    assertEqual(testCase, act.RhsContainsLhsName, true);


%% Test Exogenous
    input = "x = @*a + b*z{-1} + @*log(c);";
    act = ExplanatoryTest.fromString(input);
    exp = ExplanatoryTest( );
    exp = setp(exp, 'VariableNames', ["x", "a", "b", "z", "c"]);
    exp = setp(exp, 'InputString', regexprep(input, "\s+", ""));
    exp = defineDependentTerm(exp, 1);
    exp = addExplanatoryTerm(exp, 2);
    exp = addExplanatoryTerm(exp, 5, "Transform=", "log");
    exp = addExplanatoryTerm(exp, "b*z{-1}", "Fixed=", 1);
    assertEqual(testCase, act, exp);
    assertEqual(testCase, act.RhsContainsLhsName, false);


%% Test Legacy String
    input = "x = @*a + b*x{-1} + @*log(c);";
    legacyInput = replace(input, "@", "?");
    act = ExplanatoryTest.fromString(legacyInput);
    act = setp(act, 'InputString', replace(getp(act, 'InputString'), "?", "@"));
    exp = ExplanatoryTest.fromString(input);
    assertEqual(testCase, act, exp);
    assertEqual(testCase, act.RhsContainsLhsName, true);


%% Test Sum
    act = ExplanatoryTest.fromString("x = y{-1} + x{-2};");
    exp_ExplanatoryTerm = regression.Term( );
    exp_ExplanatoryTerm.Position = NaN;
    exp_ExplanatoryTerm.Shift = 0;
    exp_ExplanatoryTerm.Incidence = sort([complex(2, -1), complex(1, -2)]); 
    exp_ExplanatoryTerm.Transform = "";
    exp_ExplanatoryTerm.Expression = @(x,t,date__,controls__)x(2,t-1,:)+x(1,t-2,:);
    exp_ExplanatoryTerm.Fixed = 1;
    exp_ExplanatoryTerm.ContainsLhsName = true;
    exp_ExplanatoryTerm.MinShift = -2;
    exp_ExplanatoryTerm.MaxShift = 0;
    temp = getp(act, 'ExplanatoryTerms');
    temp.Incidence = sort(temp.Incidence);
    act = setp(act, 'ExplanatoryTerms', temp);
    assertEqual(testCase, getp(act, 'ExplanatoryTerms'), exp_ExplanatoryTerm);
    assertEqual(testCase, act.RhsContainsLhsName, true);


%% Test Exogenous Sum
    act = ExplanatoryTest.fromString("x = y{-1} + z{-2};");
    exp_ExplanatoryTerm = regression.Term( );
    exp_ExplanatoryTerm.Position = NaN;
    exp_ExplanatoryTerm.Shift = 0;
    exp_ExplanatoryTerm.Incidence = sort([complex(2, -1), complex(3, -2)]); 
    exp_ExplanatoryTerm.Transform = "";
    exp_ExplanatoryTerm.Expression = @(x,t,date__,controls__)x(2,t-1,:)+x(3,t-2,:);
    exp_ExplanatoryTerm.Fixed = 1;
    exp_ExplanatoryTerm.ContainsLhsName = false;
    exp_ExplanatoryTerm.MinShift = -2;
    exp_ExplanatoryTerm.MaxShift = 0;
    temp = getp(act, 'ExplanatoryTerms');
    temp.Incidence = sort(temp.Incidence);
    act = setp(act, 'ExplanatoryTerms', temp);
    assertEqual(testCase, getp(act, 'ExplanatoryTerms'), exp_ExplanatoryTerm);
    assertEqual(testCase, act.RhsContainsLhsName, false);


%% Test Lower
    act = ExplanatoryTest.fromString( ...
        ["xa = Xa{-1} + xA{-2} + xb", "XB = xA{-1}"], ...
        'EnforceCase=', @lower ...
    );
    exp = ExplanatoryTest.fromString( ...
        ["xa = xa{-1} + xa{-2} + xb", "xb = xa{-1}"] ...
    );
    assertEqual(testCase, act, exp);


%% Test Upper
    act = ExplanatoryTest.fromString( ...
        ["xa = Xa{-1} + xA{-2} + xb", "XB = xA{-1}"], ...
        'EnforceCase=', @upper ...
    );
    exp = ExplanatoryTest.fromString( ...
        ["XA = XA{-1} + XA{-2} + XB", "XB = XA{-1}"] ...
    );
    for i = 1 : numel(exp)
        exp(i) = setp(exp(i), 'ResidualNamePattern', upper(getp(exp(i), 'ResidualNamePattern')));
        exp(i) = setp(exp(i), 'FittedNamePattern', upper(getp(exp(i), 'FittedNamePattern')));
        exp(i) = setp(exp(i), 'DateReference', upper(getp(exp(i), 'DateReference')));
    end
    assertEqual(testCase, act, exp);


%% Test Static If
    q = ExplanatoryTest.fromString("x = z + if(isfreq(date__, 1) & date__<yy(5), -10, 10)");
    inputDb = struct( );
    inputDb.x = Series(0, 0);
    inputDb.z = Series(1:10, @rand);
    simDb1 = simulate(q, inputDb, 1:10);
    assertEqual(testCase, simDb1.x(1:10), inputDb.z(1:10)+10);
    inputDb = struct( );
    inputDb.x = Series(yy(0), 0);
    inputDb.z = Series(yy(1:10), @rand);
    [simDb2, info2] = simulate(q, inputDb, yy(1:10));
    add = [-10; -10; -10; -10; 10; 10; 10; 10; 10; 10];
    assertEqual(testCase, simDb2.x(yy(1:10)), inputDb.z(yy(1:10))+add, 'AbsTol', 1e-14);
    assertEqual(testCase, info2.DynamicStatus, false);
    [simDb3, info3] = simulate(q, inputDb, yy(1:10), 'Blazer=', {'Dynamic=', true});
    add = [-10; -10; -10; -10; 10; 10; 10; 10; 10; 10];
    assertEqual(testCase, simDb3.x(yy(1:10)), inputDb.z(yy(1:10))+add, 'AbsTol', 1e-14);
    assertEqual(testCase, info3.DynamicStatus, true);


%% Test Dynamic If
    q = ExplanatoryTest.fromString("x = x{-1} + if(isfreq(date__, 1) & date__<yy(5), dummy1, dummy0)");
    inputDb = struct( );
    inputDb.x = Series(0, 0);
    inputDb.dummy1 = Series(1:10, @rand);
    inputDb.dummy0 = -Series(1:10, @rand);
    simDb1 = simulate(q, inputDb, 1:10);
    assertEqual(testCase, simDb1.x(1:10), cumsum(inputDb.dummy0(1:10)), 'AbsTol', 1e-14);
    inputDb = struct( );
    inputDb.x = Series(yy(0), 0);
    inputDb.dummy1 = Series(yy(1:10), @rand);
    inputDb.dummy0 = -Series(yy(1:10), @rand);
    simDb2 = simulate(q, inputDb, yy(1:10));
    temp = [inputDb.dummy1(yy(1:4)); inputDb.dummy0(yy(5:10))];
    assertEqual(testCase, simDb2.x(yy(1:10)), cumsum(temp), 'AbsTol', 1e-14);


%% Test Compare Dynamic Static
    q = ExplanatoryTest.fromString([
        "x = x{-1} + if(isfreq(date__, 1) & date__<yy(5), dummy1, dummy0)"
        "y = 1 + if(isfreq(date__, 1) & date__<yy(5), dummy1, dummy0)"
    ]);
    inputDb = struct( );
    inputDb.x = Series(yy(0:9), 1);
    inputDb.dummy1 = Series(yy(1:10), @rand);
    inputDb.dummy0 = -Series(yy(1:10), @rand);
    simDb = simulate(q, inputDb, yy(1:10), 'Blazer=', {'Dynamic=', false});
    temp = 1 + [inputDb.dummy1(yy(1:4)); inputDb.dummy0(yy(5:10))];
    assertEqual(testCase, simDb.x(yy(1:10)), temp, 'AbsTol', 1e-14);
    assertEqual(testCase, simDb.y(yy(1:10)), temp, 'AbsTol', 1e-14);


%% Test Switch Variable
    q = ExplanatoryTest.fromString([
        "x = if(switch__, dummy1, dummy0)"
    ]);
    inputDb = struct( );
    inputDb.x = Series(yy(0:9), 1);
    inputDb.dummy1 = Series(yy(1:10), @rand);
    inputDb.dummy0 = -Series(yy(1:10), @rand);
    inputDb.switch__ = false;
    simDb1 = simulate(q, inputDb, yy(1:10));
    assertEqual(testCase, simDb1.x(yy(1:10)), inputDb.dummy0(yy(1:10)));
    inputDb.switch__ = true;
    simDb2 = simulate(q, inputDb, yy(1:10));
    assertEqual(testCase, simDb2.x(yy(1:10)), inputDb.dummy1(yy(1:10)));


%% Test Residual Name
    q = ExplanatoryTest.fromString([
        "x = x{-1}"
        "y = y{-1}"
    ], 'ResidualNamePattern=', ["", "_ma"]);
    assertEqual(testCase, [q.LhsName], ["x", "y"]);
    assertEqual(testCase, [q.ResidualName], ["x_ma", "y_ma"]);
    q = ExplanatoryTest.fromString([
        "x = x{-1}"
        "y = y{-1}"
    ], 'ResidualNamePattern=', ["", "_ma"], 'EnforceCase=', @upper);
    assertEqual(testCase, [q.LhsName], ["X", "Y"]);
    assertEqual(testCase, [q.ResidualName], ["X_MA", "Y_MA"]);


%% Test Fitted name
    q = ExplanatoryTest.fromString([
        "x = x{-1}"
        "y = y{-1}"
    ], 'FittedNamePattern=', ["", "_fitted"]);
    assertEqual(testCase, [q.LhsName], ["x", "y"]);
    assertEqual(testCase, [q.FittedName], ["x_fitted", "y_fitted"]);
    q = ExplanatoryTest.fromString([
        "x = x{-1}"
        "y = y{-1}"
    ], 'FittedNamePattern=', ["", "_fitted"], 'EnforceCase=', @upper);
    assertEqual(testCase, [q.LhsName], ["X", "Y"]);
    assertEqual(testCase, [q.FittedName], ["X_FITTED", "Y_FITTED"]);

