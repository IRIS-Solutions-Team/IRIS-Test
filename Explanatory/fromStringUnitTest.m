% saveAs=Explanatory/fromStringUnitTest.m

testCase = matlab.unittest.FunctionTestCase.fromFunction(@(x)x);

%% Test Plain Vanilla
    input = "x = @*a + b*x{-1} + @*log(c);";
    act = Explanatory.fromString(input);
    exp = Explanatory( );
    exp = setp(exp, "LinearStatus", true);
    exp = setp(exp, 'VariableNames', ["x", "a", "b", "c"]);
    exp = setp(exp, 'InputString', regexprep(input, "\s+", ""));
    exp = defineDependentTerm(exp, "x");
    exp = addExplanatoryTerm(exp, NaN, "a");
    exp = addExplanatoryTerm(exp, NaN, "log(c)");
    exp = addExplanatoryTerm(exp, 1, "b*x{-1}");
    exp = seal(exp);
    %
    state = warning('query'); 
    warning('off', 'MATLAB:structOnObject');
    exp_struct = struct(exp);
    act_struct = struct(act);
    warning(state);
    assertEqual(testCase, sort(fieldnames(exp_struct)), sort(fieldnames(act_struct)));
    for n = keys(exp_struct)
        if isa(exp_struct.(n), 'function_handle')
            assertEqual(testCase, char(exp_struct.(n)), char(act_struct.(n)));
        else
            assertEqual(testCase, exp_struct.(n), act_struct.(n));
        end
    end
    %
    assertEqual(testCase, act.RhsContainsLhsName, true);


%% Test Exogenous
    input = "x = @*a + b*z{-1} + @*log(c);";
    act = Explanatory.fromString(input);
    exp = Explanatory( );
    exp = setp(exp, "LinearStatus", true);
    exp = setp(exp, 'VariableNames', ["x", "a", "b", "z", "c"]);
    exp = setp(exp, 'InputString', regexprep(input, "\s+", ""));
    exp = defineDependentTerm(exp, "x");
    exp = addExplanatoryTerm(exp, NaN, "a");
    exp = addExplanatoryTerm(exp, NaN, "log(c)");
    exp = addExplanatoryTerm(exp, 1, "b*z{-1}");
    exp = seal(exp);
    %
    state = warning('query'); 
    warning('off', 'MATLAB:structOnObject');
    exp_struct = struct(exp);
    act_struct = struct(act);
    warning(state);
    assertEqual(testCase, sort(fieldnames(exp_struct)), sort(fieldnames(act_struct)));
    for n = keys(exp_struct)
        if isa(exp_struct.(n), 'function_handle')
            assertEqual(testCase, char(exp_struct.(n)), char(act_struct.(n)));
        else
            assertEqual(testCase, exp_struct.(n), act_struct.(n));
        end
    end
    %
    assertEqual(testCase, act.RhsContainsLhsName, false);


%% Test Legacy String
    input = "x = @*a + b*x{-1} + @*log(c);";
    legacyInput = replace(input, "@", "?");
    act = Explanatory.fromString(legacyInput);
    act = setp(act, 'InputString', replace(getp(act, 'InputString'), "?", "@"));
    exp = Explanatory.fromString(input);
    %
    state = warning('query'); 
    warning('off', 'MATLAB:structOnObject');
    exp_struct = struct(exp);
    act_struct = struct(act);
    warning(state);
    assertEqual(testCase, sort(fieldnames(exp_struct)), sort(fieldnames(act_struct)));
    for n = keys(exp_struct)
        if isa(exp_struct.(n), 'function_handle')
            assertEqual(testCase, char(exp_struct.(n)), char(act_struct.(n)));
        else
            assertEqual(testCase, exp_struct.(n), act_struct.(n));
        end
    end
    %
    assertEqual(testCase, act.RhsContainsLhsName, true);


%% Test Lower
    act = Explanatory.fromString( ...
        ["xa = Xa{-1} + xA{-2} + xb", "XB = xA{-1}"], ...
        'EnforceCase', @lower ...
    );
    exp = Explanatory.fromString( ...
        ["xa = xa{-1} + xa{-2} + xb", "xb = xa{-1}"] ...
    );
    %
    state = warning('query'); 
    warning('off', 'MATLAB:structOnObject');
    exp_struct = struct(exp);
    act_struct = struct(act);
    warning(state);
    assertEqual(testCase, sort(fieldnames(exp_struct)), sort(fieldnames(act_struct)));
    for n = keys(exp_struct)
        if n=="InputString"
            continue
        end
        if isa(exp_struct.(n), 'function_handle')
            assertEqual(testCase, char(exp_struct.(n)), char(act_struct.(n)));
        else
            assertEqual(testCase, exp_struct.(n), act_struct.(n));
        end
    end


%% Test Upper
    act = Explanatory.fromString( ...
        ["xa = Xa{-1} + xA{-2} + xb", "XB = xA{-1}"], ...
        'EnforceCase', @upper ...
    );
    exp = Explanatory.fromString( ...
        ["XA = XA{-1} + XA{-2} + XB", "XB = XA{-1}"] ...
    );
    for i = 1 : numel(exp)
        exp(i) = setp(exp(i), 'ResidualNamePattern', upper(getp(exp(i), 'ResidualNamePattern')));
        exp(i) = setp(exp(i), 'FittedNamePattern', upper(getp(exp(i), 'FittedNamePattern')));
    end
    %
    state = warning('query'); 
    warning('off', 'MATLAB:structOnObject');
    exp_struct = struct(exp);
    act_struct = struct(act);
    warning(state);
    assertEqual(testCase, sort(fieldnames(exp_struct)), sort(fieldnames(act_struct)));
    for n = keys(exp_struct)
        if n=="InputString"
            continue
        end
        if isa(exp_struct.(n), 'function_handle')
            assertEqual(testCase, char(exp_struct.(n)), char(act_struct.(n)));
        else
            assertEqual(testCase, exp_struct.(n), act_struct.(n));
        end
    end


%% Test Static If
    q = Explanatory.fromString("x = z + if(w<0, -10, 10)");
    inputDb = struct( );
    inputDb.x = Series(0, 0);
    inputDb.z = Series(1:10, @rand);
    inputDb.w = -1;
    simDb1 = simulate(q, inputDb, 1:10);
    assertEqual(testCase, simDb1.x(1:10), inputDb.z(1:10)-10);
    inputDb = struct( );
    inputDb.x = Series(yy(0), 0);
    inputDb.z = Series(yy(1:10), @rand);
    inputDb.w = 1;
    [simDb2, info2] = simulate(q, inputDb, yy(1:10));
    assertEqual(testCase, simDb2.x(yy(1:10)), inputDb.z(yy(1:10))+10);


%% Test Compare Period=true and Period=false If
    q = Explanatory.fromString([
        "x = x{-1} + if(w<0, dummy1, dummy0)"
        "y = 1 + if(w, dummy1, dummy0)"
    ]);
    inputDb = struct( );
    inputDb.x = Series(yy(0:9), 1);
    inputDb.w = -1;
    inputDb.dummy1 = Series(yy(1:10), @rand);
    inputDb.dummy0 = -Series(yy(1:10), @rand);
    simDb = simulate(q, inputDb, yy(1:10), "blazer", {"period", false});
    temp = 1 + inputDb.dummy1;
    assertEqual(testCase, simDb.x(yy(1:10)), temp(yy(1:10)), "AbsTol", 1e-14);
    assertEqual(testCase, simDb.y(yy(1:10)), temp(yy(1:10)), "AbsTol", 1e-14);
    inputDb.w = Series();
    inputDb.w(yy(1:10)) = -1;
    inputDb.w(yy(6:10)) = 1;
    simDb = simulate(q, inputDb, yy(1:10));
    assertEqual(testCase, simDb.y(yy(1:10)), temp(yy(1:10)), "AbsTol", 1e-14);
    temp = inputDb.x{yy(0)};
    for t = yy(1:10)
        if inputDb.w(t)<0
            temp(t) = temp(t-1) + inputDb.dummy1(t);
        else
            temp(t) = temp(t-1) + inputDb.dummy0(t);
        end
    end
    assertEqual(testCase, simDb.x(yy(1:10)), temp(yy(1:10)), "AbsTol", 1e-14);


%% Test Switch Variable
    q = Explanatory.fromString([
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
    q = Explanatory.fromString([
        "x = x{-1}"
        "y = y{-1}"
    ], 'ResidualNamePattern', ["", "_ma"]);
    assertEqual(testCase, [q.LhsName], ["x", "y"]);
    assertEqual(testCase, [q.ResidualName], ["x_ma", "y_ma"]);
    q = Explanatory.fromString([
        "x = x{-1}"
        "y = y{-1}"
    ], 'ResidualNamePattern', ["", "_ma"], 'EnforceCase', @upper);
    assertEqual(testCase, [q.LhsName], ["X", "Y"]);
    assertEqual(testCase, [q.ResidualName], ["X_MA", "Y_MA"]);


%% Test Fitted name
    q = Explanatory.fromString([
        "x = x{-1}"
        "y = y{-1}"
    ], 'FittedNamePattern', ["", "_fitted"]);
    assertEqual(testCase, [q.LhsName], ["x", "y"]);
    assertEqual(testCase, [q.FittedName], ["x_fitted", "y_fitted"]);
    q = Explanatory.fromString([
        "x = x{-1}"
        "y = y{-1}"
    ], 'FittedNamePattern', ["", "_fitted"], 'EnforceCase', @upper);
    assertEqual(testCase, [q.LhsName], ["X", "Y"]);
    assertEqual(testCase, [q.FittedName], ["X_FITTED", "Y_FITTED"]);
