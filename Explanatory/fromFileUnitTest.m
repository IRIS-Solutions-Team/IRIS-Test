% saveAs=Explanatory/fromFileUnitTest.m

testCase = matlab.unittest.FunctionTestCase.fromFunction(@(x)x);

%% Test Single Source File
    f = ModelSource( );
    f.FileName = 'test.model';
    f.Code = join([
        "%% Model"
        "!for ? = $[ list ]$ !do"
        "  % Country specific equation"
        "  x_? = @ + @*x_?{-1} - @*y + y*z;"
        "!end"
    ], newline);
    control = struct( );
    control.list = ["AA", "BB", "CC"];
    act = Explanatory.fromFile(f, 'Preparser', {'Assign', control});
    for i = 1 : numel(control.list)
        exd = Explanatory( );
        s = control.list(i);
        exd = setp(exd, "LinearStatus", true);
        exd = setp(exd, 'VariableNames', ["x_"+s, "y", "z"]);
        exd = setp(exd, 'FileName', string(f.FileName));
        exd = setp(exd, 'InputString', "x_"+s+"=@+@*x_"+s+"{-1}-@*y+y*z;");
        exd = setp(exd, 'Comment', "Model");
        exd = defineDependentTerm(exd, "x_"+s);
        exd = addExplanatoryTerm(exd, NaN, "1");
        exd = addExplanatoryTerm(exd, NaN, "x_"+s+"{-1}");
        exd = addExplanatoryTerm(exd, NaN, "-y");
        exd = addExplanatoryTerm(exd, 1, "y*z");
        exd = seal(exd);
        %
        assertEqual(testCase, act(i).ExplanatoryTerms, exd.ExplanatoryTerms);
        %
        state = warning('query');
        warning('off', 'MATLAB:structOnObject');
        exd_struct = struct(exd);
        act_struct = struct(act(i));
        warning(state);
        assertEqual(testCase, sort(fieldnames(exd_struct)), sort(fieldnames(act_struct)));
        for n = keys(exd_struct)
            if isa(exd_struct.(n), 'function_handle')
                assertEqual(testCase, char(exd_struct.(n)), char(act_struct.(n)));
            else
                assertEqual(testCase, exd_struct.(n), act_struct.(n));
            end
        end
    end


%% Test Source File with Comments
    f = ModelSource( );
    f.FileName = 'test.model';
    f.Code = join([
        " 'aaa' a = a{-1};"
        " 'bbb' b = b{-1};"
        " c = c{-1};"
        " 'ddd' d = d{-1};"
    ], newline);
    act = Explanatory.fromFile(f);
    exp_LhsName = ["a", "b", "c", "d"];
    assertEqual(testCase, [act.LhsName], exp_LhsName);
    exp_Label = ["aaa", "bbb", "", "ddd"];
    assertEqual(testCase, [act.Label], exp_Label);


%% Test Source File with Empty Equations
    f = ModelSource( );
    f.FileName = 'test.model';
    f.Code = join([
        " 'aaa' a = a{-1};"
        "'bbb' b = b{-1}; :empty;"
        " c = c{-1};"
        " 'ddd' d = d{-1}; ; :xxx"
    ], newline);
    %
    state = warning('query');
    warning('off');
    act = Explanatory.fromFile(f);
    warning(state);
    %
    exp_LhsName = ["a", "b", "c", "d"];
    assertEqual(testCase, [act.LhsName], exp_LhsName);
    exp_Label = ["aaa", "bbb", "", "ddd"];
    assertEqual(testCase, [act.Label], exp_Label);
    for i = 1 : numel(act)
        assertEqual(testCase, act(i).Attributes, string.empty(1, 0));
    end



%% Test Source File with Attributes
    f = ModelSource( );
    f.FileName = 'test.model';
    f.Code = join([
        ":first 'aaa' a = a{-1};"
        "'bbb' b = b{-1};"
        ":second :first c = c{-1};"
        ":first :last 'ddd' d = d{-1};"
    ], newline);
    act = Explanatory.fromFile(f);
    exp_Attributes = {
        ":first"
        string.empty(1, 0)
        [":second" ":first"]
        [":first" ":last"]
    };
    for i = 1 : 4
        assertEqual(testCase, act(i).Attributes, exp_Attributes{i});
    end


%% Test Preparser For If
    f1 = ModelSource( );
    f1.FileName = 'test.model';
    f1.Code = join([
        "!for ?c = $[ list ]$ !do"
        "    x_?c = "
        "    !for ?w = $[ list ]$ !do"
        "        !if ""?w""~=""?c"" "
        "            + w_?c_?w*x_?w"
        "        !end"
        "    !end"
        "    ;"
        "!end"
    ], newline);
    f2 = ModelSource( );
    f2.FileName = 'test.model';
    f2.Code = join([
        "!for ?c = $[ list ]$ !do"
        "    x_?c = "
        "    !for ?w = $[ setdiff(list, ""?c"") ]$ !do"
        "        !if ""?w""~=""?c"" "
        "            + w_?c_?w*x_?w"
        "        !end"
        "    !end"
        "    ;"
        "!end"
    ], newline);
    control = struct( );
    control.list = ["AA", "BB", "CC"];
    act1 = Explanatory.fromFile(f1, 'Preparser', {'Assign', control});
    act2 = Explanatory.fromFile(f2, 'Preparser', {'Assign', control});
    for i = 1 : numel(control.list)
        assertEqual(testCase, act1(i).LhsName, "x_"+control.list(i));
    end
    assertEqual( ...
        testCase, ...
        func2str(act1(1).ExplanatoryTerms.Expression), ...
        '@(x,e,p,t,v,controls__)x(2,t,v).*x(3,t,v)+x(4,t,v).*x(5,t,v)' ...
    );
    %
    state = warning('query');
    warning('off', 'MATLAB:structOnObject');
    act1_struct = struct(act1);
    act2_struct = struct(act2);
    warning(state);
    assertEqual(testCase, sort(fieldnames(act1_struct)), sort(fieldnames(act2_struct)));
    for n = keys(act1_struct)
        if isa(act1_struct.(n), 'function_handle')
            assertEqual(testCase, char(act1_struct.(n)), char(act2_struct.(n)));
        else
            assertEqual(testCase, act1_struct.(n), act2_struct.(n));
        end
    end


%% Test Preparser Switch
    f1 = ModelSource( );
    f1.FileName = 'test.model';
    f1.Code = join([
        "!switch country"
        "   !case ""AA"" "
        "       x = 0.8*x{-1};"
        "   !case ""BB"" "
        "       x = sqrt(y);"
        "    !case ""CC"" "
        "       x = a + b;"
        "   !otherwise"
        "       x = 0;"
        "!end"
    ], newline);
    exp_Expression = {
        '@(x,e,p,t,v,controls__)0.8.*x(1,t-1,v)'
        '@(x,e,p,t,v,controls__)sqrt(x(2,t,v))'
        '@(x,e,p,t,v,controls__)x(2,t,v)+x(3,t,v)'
        '@(x,e,p,t,v,controls__)0'
    };
    list = ["AA", "BB", "CC", "DD"];
    for i = 1 : numel(list)
        control.country = list(i);
        act = Explanatory.fromFile(f1, 'Preparser', {'Assign', control});
        assertEqual(testCase, func2str(act.ExplanatoryTerms.Expression), exp_Expression{i});
    end


%% Test Equations with Attributes
    f = ModelSource( );
    f.FileName = "test.eqtn";
    f.Code = join([
        "!equations(:aa, :bb)"
        ":1 a=a{-1}; :2 b=b{-1};"
        ":3 c=c{-1};"
        "!equations :4 d=d{-1};"
        "!equations   (:cc)"
        ":5 e=e{-1};"
    ], newline);
    act = Explanatory.fromFile(f);
    exp_Attributes = {
        [":aa", ":bb", ":1"]
        [":aa", ":bb", ":2"]
        [":aa", ":bb", ":3"]
        [":4"]
        [":cc", ":5"]
    };
    assertEqual(testCase, reshape({act.Attributes}, [ ], 1), exp_Attributes);
