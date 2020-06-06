% saveAs=Explanatory/regressUnitTest.m

testCase = matlab.unittest.FunctionTestCase.fromFunction(@(x)x);

% Set up Once
    m1 = Explanatory.fromString('x = ? + ?*x{-1} + ?*y');
    m2 = Explanatory.fromString('a = ? + ?*a{-1} + ?*x');
    startDate = qq(2001,1);
    endDate = qq(2010, 4);
    baseRange = startDate:endDate;
    db1 = struct( );
    db1.x = Series(startDate-10:endDate+10, cumsum(randn(60,1)));
    db1.a = Series(startDate-1:endDate, cumsum(randn(41,1)));
    db1.y = Series(startDate:endDate, cumsum(randn(40,1)));
    db2 = struct( );
    db2.x = Series(startDate-1:endDate, cumsum(randn(41,3)));
    db2.a = Series(startDate-1:endDate, cumsum(randn(41,1)));
    db2.y = Series(startDate:endDate, cumsum(randn(40,1)));
    testCase.TestData.Model1 = m1;
    testCase.TestData.Model2 = m2;
    testCase.TestData.Databank1 = db1;
    testCase.TestData.Databank2 = db2;
    testCase.TestData.BaseRange = baseRange;



%% Test ARX
    m1 = testCase.TestData.Model1;
    db1 = testCase.TestData.Databank1;
    baseRange = testCase.TestData.BaseRange;
    [est1, outputDb] = regress(m1, db1, baseRange);
    y = db1.x(baseRange);
    X = [ones(40, 1), db1.x{-1}(baseRange), db1.y(baseRange)];
    exp_parameters = transpose(X\y);
    assertEqual(testCase, est1.Parameters, exp_parameters, 'AbsTol', 1e-12);
    assertEqual(testCase, isfield(outputDb, m1.ResidualName), true);


%% Test Resimulate 
    m1 = testCase.TestData.Model1;
    db1 = testCase.TestData.Databank1;
    baseRange = testCase.TestData.BaseRange;
    [est1, outputDb] = regress(m1, db1, baseRange);
    simDb = simulate(est1, outputDb, baseRange);
    assertEqual(testCase, db1.x(baseRange), simDb.x(baseRange), 'AbsTol', 1e-12);



%% Test Resimulate Prepend
    m1 = testCase.TestData.Model1;
    db1 = testCase.TestData.Databank1;
    baseRange = testCase.TestData.BaseRange;
    [est1, outputDb] = regress(m1, db1, baseRange);
    simDb = simulate(est1, outputDb, baseRange, 'PrependInput=', true);
    startDate = db1.x.Start;
    range = db1.x.Start : baseRange(end);
    assertEqual(testCase, db1.x(range), simDb.x(range), 'AbsTol', 1e-12);


%% Test Resimulate Append
    m1 = testCase.TestData.Model1;
    db1 = testCase.TestData.Databank1;
    baseRange = testCase.TestData.BaseRange;
    [est1, outputDb] = regress(m1, db1, baseRange);
    simDb = simulate(est1, outputDb, baseRange, 'AppendInput=', true);
    range = baseRange(1)-1 : db1.x.End;
    assertEqual(testCase, db1.x(range), simDb.x(range), 'AbsTol', 1e-12);


%% Test ARX System
    m1 = testCase.TestData.Model1;
    m2 = testCase.TestData.Model2;
    m = [m1, m2];
    db1 = testCase.TestData.Databank1;
    baseRange = testCase.TestData.BaseRange;
    [est, outputDb] = regress(m, db1, baseRange);
    y = db1.x(baseRange);
    X = [ones(40, 1), db1.x{-1}(baseRange), db1.y(baseRange)];
    exp_parameters = transpose(X\y);
    assertEqual(testCase, est(1).Parameters, exp_parameters, 'AbsTol', 1e-12);
    y = db1.a(baseRange);
    X = [ones(40, 1), db1.a{-1}(baseRange), db1.x(baseRange)];
    exp_parameters = transpose(X\y);
    assertEqual(testCase, est(2).Parameters, exp_parameters, 'AbsTol', 1e-12);
    assertEqual(testCase, isfield(outputDb, m1.ResidualName), true);
    assertEqual(testCase, isfield(outputDb, m2.ResidualName), true);


%% Test ARX System Variants
    m1 = testCase.TestData.Model1;
    m2 = testCase.TestData.Model2;
    m = [m1, m2];
    db2 = testCase.TestData.Databank2;
    baseRange = testCase.TestData.BaseRange;

    [est, outputDb] = regress(m, db2, baseRange);

    exp_parameters = nan(1, 3, 3);
    for i = 1 : 3
        y = db2.x(baseRange, i);
        X = [ones(40, 1), db2.x{-1}(baseRange, i), db2.y(baseRange)];
        exp_parameters(:, :, i) = transpose(X\y);
    end
    assertEqual(testCase, est(1).Parameters, exp_parameters, 'AbsTol', 1e-12);

    exp_parameters = nan(1, 3, 3);
    for i = 1 : 3
        y = db2.a(baseRange);
        X = [ones(40, 1), db2.a{-1}(baseRange), db2.x(baseRange, i)];
        exp_parameters(:, :, i) = transpose(X\y);
    end
    assertEqual(testCase, est(2).Parameters, exp_parameters, 'AbsTol', 1e-12);
