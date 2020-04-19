
testCase = matlab.unittest.FunctionTestCase.fromFunction(@(x)x);


%% Test Single Source File
    f = model.File( );
    f.FileName = 'test.model';
    f.Code = [
        "%% Model"
        "!for ? = $[ list ]$ !do"
        "  % Country specific equation"
        "  x_? = @ + @*x_?{-1} - @*y + y*z;"
        "!end"
    ];
    control = struct( );
    control.list = ["AA", "BB", "CC"];
    act = ExplanatoryTest.fromFile(f, 'Preparser=', {'Assign=', control});
    for i = 1 : numel(control.list)
        exd = ExplanatoryTest( );
        s = control.list(i);
        exd = setp(exd, 'VariableNames', ["x_"+s, "y", "z"]);
        exd = setp(exd, 'FileName', string(f.FileName));
        exd = setp(exd, 'InputString', "x_"+s+"=@+@*x_"+s+"{-1}-@*y+y*z;");
        exd = setp(exd, 'Comment', "Model"); 
        exd = defineDependentTerm(exd, 1);
        exd = addExplanatoryTerm(exd, "1");
        exd = addExplanatoryTerm(exd, 1, "Shift=", -1);
        exd = addExplanatoryTerm(exd, "-y");
        exd = addExplanatoryTerm(exd, "y*z", "Fixed=", 1);
        assertEqual(testCase, act(i).ExplanatoryTerms, exd.ExplanatoryTerms);
        assertEqual(testCase, act(i), exd);
    end


%% Test Source File with Comments
    f = model.File( );
    f.FileName = 'test.model';
    f.Code = [
        " 'aaa' a = a{-1};"
        " 'bbb' b = b{-1};"
        " c = c{-1};"
        " 'ddd' d = d{-1};"
    ];
    act = ExplanatoryTest.fromFile(f);
    exp_LhsName = ["a", "b", "c", "d"];
    assertEqual(testCase, [act.LhsName], exp_LhsName);
    exp_Label = ["aaa", "bbb", "", "ddd"];
    assertEqual(testCase, [act.Label], exp_Label);


%% Test Source File with Empty Equations
    f = model.File( );
    f.FileName = 'test.model';
    f.Code = [
        " 'aaa' a = a{-1};"
        "'bbb' b = b{-1}; :empty;"
        " c = c{-1};"
        " 'ddd' d = d{-1}; ; :xxx"
    ];

    state = warning('query');
    warning('off');
    act = ExplanatoryTest.fromFile(f);
    warning(state);

    exp_LhsName = ["a", "b", "c", "d"];
    assertEqual(testCase, [act.LhsName], exp_LhsName);
    exp_Label = ["aaa", "bbb", "", "ddd"];
    assertEqual(testCase, [act.Label], exp_Label);
    for i = 1 : numel(act)
        assertEqual(testCase, act(i).Attributes, string.empty(1, 0));
    end



%% Test Source File with Attributes
    f = model.File( );
    f.FileName = 'test.model';
    f.Code = [
        ":first 'aaa' a = a{-1};"
        "'bbb' b = b{-1};"
        ":second :first c = c{-1};"
        ":first :last 'ddd' d = d{-1};"
    ];
    act = ExplanatoryTest.fromFile(f);
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
    f1 = model.File( );
    f1.FileName = 'test.model';
    f1.Code = [
        "!for ?c = $[ list ]$ !do"
        "    x_?c = "
        "    !for ?w = $[ list ]$ !do"
        "        !if ""?w""~=""?c"" "
        "            + w_?c_?w*x_?w"
        "        !end"
        "    !end"
        "    ;"
        "!end"
    ];
    f2 = model.File( );
    f2.FileName = 'test.model';
    f2.Code = [
        "!for ?c = $[ list ]$ !do"
        "    x_?c = "
        "    !for ?w = $[ setdiff(list, ""?c"") ]$ !do"
        "        !if ""?w""~=""?c"" "
        "            + w_?c_?w*x_?w"
        "        !end"
        "    !end"
        "    ;"
        "!end"
    ];
    control = struct( );
    control.list = ["AA", "BB", "CC"];
    act1 = ExplanatoryTest.fromFile(f1, 'Preparser=', {'Assign=', control});
    act2 = ExplanatoryTest.fromFile(f2, 'Preparser=', {'Assign=', control});
    for i = 1 : numel(control.list)
        assertEqual(testCase, act1(i).LhsName, "x_"+control.list(i));
    end
    assertEqual( ...
        testCase, ...
        func2str(act1(1).ExplanatoryTerms.Expression), ...
        '@(x,t,date__,controls__)x(2,t,:).*x(3,t,:)+x(4,t,:).*x(5,t,:)' ...
    );
    assertEqual(testCase, act1, act2);


%% Test Preparser Switch
    f1 = model.File( );
    f1.FileName = 'test.model';
    f1.Code = [
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
    ];
    exp_Expression = {
        '@(x,t,date__,controls__)0.8.*x(1,t-1,:)'
        '@(x,t,date__,controls__)sqrt(x(2,t,:))'
        '@(x,t,date__,controls__)x(2,t,:)+x(3,t,:)'
        '@(x,t,date__,controls__)0'
    };
    list = ["AA", "BB", "CC", "DD"];
    for i = 1 : numel(list)
        control.country = list(i);
        act = ExplanatoryTest.fromFile(f1, 'Preparser=', {'Assign=', control});
        assertEqual(testCase, func2str(act.ExplanatoryTerms.Expression), exp_Expression{i});
    end


%% Test Equations with Attributes
    f = model.File( );
    f.FileName = "test.eqtn";
    f.Code = [
        "!equations(:aa, :bb)"
        ":1 a=a{-1}; :2 b=b{-1};"
        ":3 c=c{-1};"
        "!equations :4 d=d{-1};"
        "!equations(:cc)"
        ":5 e=e{-1};"
    ];
    act = ExplanatoryTest.fromFile(f);
    exp_Attributes = {
        [":aa", ":bb", ":1"]
        [":aa", ":bb", ":2"]
        [":aa", ":bb", ":3"]
        [":4"]
        [":cc", ":5"]
    };
    assertEqual(testCase, reshape({act.Attributes}, [ ], 1), exp_Attributes);
