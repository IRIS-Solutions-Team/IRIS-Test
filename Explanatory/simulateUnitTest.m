% saveAs=Explanatory/simulateUnitTest.m

testCase = matlab.unittest.FunctionTestCase.fromFunction(@(x)x);

% Set up once
    m1 = Explanatory.fromString("x = 0.8*x{-1} + (1-0.8)*c");
    m2 = Explanatory.fromString("a = b + @*(a{-1} - b) + @");
    m3 = Explanatory.fromString("z = x + a{-1}");
    m4 = Explanatory.fromString("difflog(w) = 0.3*log(5/w{-1})");
    m5 = Explanatory.fromString("c = y");
    startDate = numeric.qq(2001,1);
    endDate = numeric.qq(2010, 4);
    range = dater.colon(startDate, endDate);
    db = struct( );
    db.x = Series(dater.plus(startDate, -1), 0);
    db.y = Series(range, @rand)*0.5 + 5;
    db.c = db.y;
    db.a = Series(dater.plus(startDate, -1), 0);
    db.b = Series(range, @rand)*0.5 + 5;
    db.w = Series(dater.plus(startDate, -1), 0.5+rand(1, 3)*10);
    testCase.TestData.Model1 = m1;
    testCase.TestData.Model2 = m2;
    testCase.TestData.Model3 = m3;
    testCase.TestData.Model4 = m4;
    testCase.TestData.Model5 = m5;
    testCase.TestData.Range = range;
    testCase.TestData.Databank = db;


%% Test ARX
    m1 = testCase.TestData.Model1;
    db = testCase.TestData.Databank;
    range = testCase.TestData.Range;
    s = simulate(m1, db, range);
    exd = db.x;
    for t = range
        exd(t) = 0.8*exd(t-1) + (1-0.8)*db.y(t);
    end
    assertEqual(testCase, s.x.Data, exd.Data, 'absTol', 1e-12);
    assertEqual(testCase, sort(fieldnames(db)), sort(setdiff(fieldnames(s), 'res_x')));
    assertEqual(testCase, s.w.Data, db.w.Data);


%% Test Transform
    m4 = testCase.TestData.Model4;
    db = testCase.TestData.Databank;
    range = testCase.TestData.Range;
    s = simulate(m4, db, range);
    for i = 1 : 3
        exp_w = db.w{:, i};
        for t = range
            temp = 0.3*log(5/exp_w(t-1));
            exp_w(t) = exp_w(t-1)*exp(temp);
        end
        assertEqual(testCase, s.w.Data(:, i), exp_w.Data, 'absTol', 1e-12);
    end


%% Test ARX Variants
    m2 = testCase.TestData.Model2;
    m2 = alter(m2, 3);
    rho = rand(1, 1, 3);
    m2.Parameters = [rho, zeros(1, 1, 3), ones(1, 1, 3)];
    db = testCase.TestData.Databank;
    db.a = [db.a, db.a+1, db.a+2];
    range = testCase.TestData.Range;
    s = simulate(m2, db, range);
    for i = 1 : 3
        exd = db.a{:, i};
        for t = range
            exd(t) = rho(i)*exd(t-1) + (1-rho(i))*db.b(t);
        end
        assertEqual(testCase, s.a.Data(:, i), exd.Data, 'absTol', 1e-12);
    end


%% Test ARX with Residuals
    m1 = testCase.TestData.Model1;
    db = testCase.TestData.Databank;
    range = testCase.TestData.Range;
    db.res_x = Series(range(3:end-3), @randn)/10;
    s = simulate(m1, db, range);
    exd = db.x;
    for t = range
        exd(t) = 0.8*exd(t-1) + (1-0.8)*db.y(t);
        res_x = db.res_x(t);
        if isfinite(res_x)
            exd(t) = exd(t) + res_x;
        end
    end
    assertEqual(testCase, s.x.Data, exd.Data, 'absTol', 1e-12);


%% Test ARX Parameters
    m2 = testCase.TestData.Model2;
    rho = rand(1);
    temp = getp(m2, 'Parameters');
    temp(1:2) = [rho, 0];
    m2 = setp(m2, 'Parameters', temp);
    db = testCase.TestData.Databank;
    range = testCase.TestData.Range;
    s = simulate(m2, db, range);
    exp_a = db.a;
    for t = range
        exp_a(t) = rho*exp_a(t-1) + (1-rho)*db.b(t);
    end
    assertEqual(testCase, s.a.Data, exp_a.Data, 'absTol', 1e-12);


%% Test ARX System
    m = [ testCase.TestData.Model1
          testCase.TestData.Model2
          testCase.TestData.Model3 ];
    rho = rand(1);
    temp = getp(m(2), 'Parameters');
    temp(1:2) = [rho, 0];
    m(2) = setp(m(2), 'Parameters', temp);
    db = testCase.TestData.Databank;
    range = testCase.TestData.Range;
    s = simulate(m, db, range);
    exp_z = s.x{range} + s.a{-1}{range};
    assertEqual(testCase, s.z.Data, exp_z.Data, 'absTol', 1e-12);


%% Test ARX System Variants
    % m2 = Explanatory.fromString("a = b + @*(a{-1} - b) + @");
    m = [ testCase.TestData.Model1
          testCase.TestData.Model2
          testCase.TestData.Model3 ];
    nv = 3;
    m = alter(m, nv);
    rho = rand(1, 1, nv);
    m(2).Parameters = [rho, zeros(1, 1, nv), ones(1, 1, nv)];
    db = testCase.TestData.Databank;
    range = testCase.TestData.Range;
    db.res_a = Series(range, randn(numel(range), nv));
    s = simulate(m, db, range);
    nb = size(s.b, 2);
    for v = 1 : nv
        exp_res_a = s.a{:,v} - (s.b{:,min(v,nb)} + rho(v)*(s.a{-1}{:,v} - s.b{:,min(v,nb)}) - 0);
        assertEqual(testCase, exp_res_a(range), s.res_a(range, v), 'absTol', 1e-12);
    end
    exp_z = s.x{range} + s.a{-1}{range};
    assertEqual(testCase, s.z.Data, exp_z.Data, 'absTol', 1e-12);


%% Test ARX System with Prepend
    m = [ testCase.TestData.Model1
          testCase.TestData.Model2
          testCase.TestData.Model3 ];
    rho = rand(1);
    m(2).Parameters = [rho, 0, 1];
    range = testCase.TestData.Range;
    db = testCase.TestData.Databank;
    db.x(range(1)+(-10:-2)) = rand(9, 1);
    s = simulate(m, db, range, 'PrependInput', true);
    exp_z = s.x{range} + s.a{-1}{range};
    assertEqual(testCase, s.z.Data, exp_z.Data, 'absTol', 1e-12);
    assertEqual(testCase, double(s.x.Start), range(1)-10);
    assertEqual(testCase, s.x(range(1)+(-10:-2)), db.x(range(1)+(-10:-2)));

%% Test ARX System Variants
    % m2 = Explanatory.fromString("a = b + @*(a{-1} - b) + @");
    m = [ testCase.TestData.Model1
          testCase.TestData.Model2
          testCase.TestData.Model3 ];
    nv = 3;
    m = alter(m, nv);
    rho = rand(1, 1, nv);
    m(2).Parameters = [rho, zeros(1, 1, nv), ones(1, 1, nv)];
    db = testCase.TestData.Databank;
    range = testCase.TestData.Range;
    db.res_a = Series(range, randn(numel(range), nv));
    s = simulate(m, db, range);
    nb = size(s.b, 2);
    for v = 1 : nv
        exp_res_a = s.a{:,v} - (s.b{:,min(v,nb)} + rho(v)*(s.a{-1}{:,v} - s.b{:,min(v,nb)}) - 0);
        assertEqual(testCase, exp_res_a(range), s.res_a(range, v), 'absTol', 1e-12);
    end
    exp_z = s.x{range} + s.a{-1}{range};
    assertEqual(testCase, s.z.Data, exp_z.Data, 'absTol', 1e-12);


%% Test Blazer
    xq = Explanatory.fromString([
        "x = 0.8*y{-1} + 0.8*z{-1}"
        "y = 0.8*x{-1}"
        "a = 0.8*b{-1} + 0.8*a{-2}"
        "b = 0.8*a{-1} + 0.8*b{-2}"
        "z = a"
    ]);
    db = struct( );
    db.a = Series(-1:1000, @rand);
    db.b = Series(-1:1000, @rand);
    db.x = Series(0, rand);
    db.y = Series(0, rand);
    db.z = Series(0, rand);
    simRange = 1:1000;
    [simDb1, info1] = simulate(xq, db, simRange);
    [simDb2, info2] = simulate(xq, db, simRange, 'blazer', {'reorder', false, 'period', true});
    [simDb3, info3] = simulate(xq([1,3,4,5,2]), db, simRange);
    for i = reshape(string(fieldnames(simDb1)), 1, [ ]);
        assertEqual(testCase, simDb1.(i).Data, simDb2.(i).Data, 'absTol', 1e-12);
        assertEqual(testCase, simDb1.(i).Data, simDb3.(i).Data, 'absTol', 1e-12);
    end


%% Test All ExogenizeWhenData
    xq = Explanatory.fromString([
        "a = b{-1}"
        "b = c{-1}"
        "c = d{-1}"
    ]);
    db = struct( );
    db.d = Series(0:10, 0:10);
    db.c = Series(0:8, 0:10:80);
    db.b = Series(0:6, 0:100:600);
    simDb1 = simulate(xq, db, 1:10);
    %
    p2 = Plan.forExplanatory(xq, 1:10);
    p2 = exogenizeWhenData(p2, 1:10, @all);
    simDb2 = simulate(xq, db, 1:10, 'Plan', p2);
    %
    assertEqual(testCase, simDb1.c(1:10), db.d{-1}(1:10), 'absTol', 1e-14);
    assertEqual(testCase, simDb2.c(1:8), db.c(1:8), 'absTol', 1e-14);
    assertEqual(testCase, simDb2.c(9:10), db.d{-1}(9:10), 'absTol', 1e-14);
    %
    assertEqual(testCase, simDb1.b(1:10), simDb1.c{-1}(1:10), 'absTol', 1e-14);
    assertEqual(testCase, simDb2.b(1:6), db.b(1:6), 'absTol', 1e-14);
    assertEqual(testCase, simDb2.b(7:10), simDb2.c{-1}(7:10), 'absTol', 1e-14);
    %
    assertEqual(testCase, simDb1.a(1:10), simDb1.b{-1}(1:10), 'absTol', 1e-14);
    assertEqual(testCase, simDb2.a(1:10), simDb2.b{-1}(1:10), 'absTol', 1e-14);


%% Test Some ExogenizeWhenData
    xq = Explanatory.fromString([
        "a = b{-1};"
        ":exogenous b = c{-1};"
        "c = d{-1};"
    ]);
    db = struct( );
    db.d = Series(0:10, 0:10);
    db.c = Series(0:8, 0:10:80);
    db.b = Series(0:6, 0:100:600);
    simDb1 = simulate(xq, db, 1:10);
    %
    [~, ~, listExogenous] = lookup(xq, ':exogenous');
    p2 = Plan.forExplanatory(xq, 1:10);
    p2 = exogenizeWhenData(p2, 1:10, listExogenous);
    simDb2 = simulate(xq, db, 1:10, 'Plan', p2);
    %
    assertEqual(testCase, simDb1.c(1:10), db.d{-1}(1:10), 'absTol', 1e-14);
    assertEqual(testCase, simDb2.c(1:10), db.d{-1}(1:10), 'absTol', 1e-14);
    %
    assertEqual(testCase, simDb1.b(1:10), simDb1.c{-1}(1:10), 'absTol', 1e-14);
    assertEqual(testCase, simDb2.b(1:6), db.b(1:6), 'absTol', 1e-14);
    assertEqual(testCase, simDb2.b(7:10), simDb2.c{-1}(7:10), 'absTol', 1e-14);
    %
    assertEqual(testCase, simDb1.a(1:10), simDb1.b{-1}(1:10), 'absTol', 1e-14);
    assertEqual(testCase, simDb2.a(1:10), simDb2.b{-1}(1:10), 'absTol', 1e-14);
    %
    simDb3 = simulate(xq, simDb2, 1:10);
    assertEqual(testCase, simDb2.b(1:10), simDb3.b(1:10), 'absTol', 1e-14);


%% Test Runtime If
    xq = Explanatory.fromString([
        "a = a{-1} + if(a{-1}>20, 1, 5);"
        "b = b{-1} + if(b{-1}<0, 1, 0);"
    ]);
    db = struct( );
    db.a = Series(qq(2000,4), 10);
    db.b = Series(qq(2000,4), -3);
    simDb = simulate(xq, db, qq(2001,1):qq(2004,4));
    exp_a = Series(qq(2000,4):qq(2004,4), [10:5:25, 26:38]');
    assertEqual(testCase, simDb.a(:), exp_a(:), 'absTol', 1e-14);
    exp_b = Series(qq(2000,4):qq(2004,4), 0);
    exp_b(qq(2000,4):qq(2001,2)) = [-3;-2;-1];
    assertEqual(testCase, simDb.b(:), exp_b(:), 'absTol', 1e-14);


%% Test Runtime Ifnan
    xq = Explanatory.fromString([
        "b = ifnan(0.8*c{-1}, z);"
    ], "ControlNames", "z");
    db = struct( );
    db.c = Series(qq(2000,4), rand(20,1));
    db.c(qq(2001,4))=NaN;
    db.c(qq(2003,1:2))=NaN;
    db.z = 100;
    simDb = simulate(xq, db, qq(2001,1):qq(2004,4));
    assertEqual(testCase, simDb.b(qq(2001,4)+1), db.z);
    assertEqual(testCase, simDb.b(qq(2003,1:2)+1), repmat(db.z, 2, 1));
    assertEqual(testCase, simDb.b(qq(2001,1:4)), 0.8*simDb.c(qq(2001,1:4)-1), "absTol", 1e-14);
    assertEqual(testCase, simDb.b(qq(2003,4):qq(2004,4)), 0.8*simDb.c((qq(2003,4):qq(2004,4))-1), "absTol", 1e-14);


%% Test Identity
    xq = Explanatory.fromString([
        "x === a + sin(b)"
        "y = a + sin(b)"
    ]);
    db = struct( );
    db.a = Series(1:10, randn(10, 2));
    db.b = Series(1:10, randn(10, 2));
    simDb1 = simulate(xq, db, 1:10);
    assertFalse(testCase, isfield(simDb1, "res_x"));
    assertTrue(testCase, isfield(simDb1, "res_y"));
    assertEqual(testCase, simDb1.x(1:10), db.a(1:10)+sin(db.b(1:10)), "absTol", 1e-14);
    assertEqual(testCase, simDb1.y(1:10), db.a(1:10)+sin(db.b(1:10)), "absTol", 1e-14);
    assertEqual(testCase, simDb1.res_y(1:10), zeros(10, 2));

    db.res_x = Series(1:10, randn(10, 2)); 
    db.res_y = Series(1:10, randn(10, 2)); 
    simDb2 = simulate(xq, db, 1:10);
    assertTrue(testCase, isfield(simDb2, "res_x")); % [^1] 
    assertTrue(testCase, isfield(simDb2, "res_y"));
    assertEqual(testCase, simDb2.x(1:10), db.a(1:10)+sin(db.b(1:10)), "absTol", 1e-14);
    assertEqual(testCase, simDb2.y(1:10), db.a(1:10)+sin(db.b(1:10))+db.res_y(1:10), "absTol", 1e-14);
    assertEqual(testCase, simDb2.res_y(1:10), db.res_y(1:10));
    % [^1]: res_x is carried over from the input db but unused
