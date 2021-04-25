
testCase = matlab.unittest.FunctionTestCase.fromFunction(@(x)x);

% Set Up Once
m = readModel( );


%{
%% Test System Property
    [expectedC, expectedR] = acf(m);
    p = acf(m, 'SystemProperty', {'C', 'R'});
    update(p, m);
    eval(p, m);
    actualC = p.Outputs{1};
    actualR = p.Outputs{2};
    testCase.assertEqual(double(actualC), double(expectedC), 'AbsTol', 1e-10);
    testCase.assertEqual(double(actualR), double(expectedR), 'AbsTol', 1e-10);


%% Test System Property Update
    p = acf(m, 'SystemProperty', {'C', 'R'});
    for xiw = 55 : 5 : 70
        m.xiw = xiw;
        m = sstate(m, 'Growth', true, 'Display', false);
        m = solve(m);
        [expectedC, expectedR] = acf(m);
        update(p, m);
        eval(p, m);
        actualC = p.Outputs{1};
        actualR = p.Outputs{2};
        testCase.assertEqual(double(actualC), double(expectedC), 'AbsTol', 1e-10);
        testCase.assertEqual(double(actualR), double(expectedR), 'AbsTol', 1e-10);
    end


%% Test System Prior One Output
    expectedC = acf(m);
    p = acf(m, 'SystemProperty', 'Cov');
    spw = SystemPriorWrapper.forModel(m);
    spw.addSystemProperty(p);
    f1 = distribution.Normal.fromMeanStd(10, 5);
    f2 = distribution.Normal.standardized( );
    spw.addSystemPrior('Cov(1, 2, 1)', f1);
    profile clear;
    profile on;
    [actualLogDensity, actualContrib, actualProp] = eval(spw, m);
    info = profile('info');
    functionNames = {info.FunctionTable.FunctionName};
    expectedProp = expectedC(1, 2, 1);
    expectedContrib = -f1.logPdf(expectedProp(1));
    expectedLogDensity = sum(expectedContrib);
    testCase.assertEqual(actualProp, expectedProp, 'AbsTol', 1e-10);
    testCase.assertEqual(actualContrib, expectedContrib, 'AbsTol', 1e-10);
    testCase.assertEqual(actualLogDensity, expectedLogDensity,'AbsTol', 1e-10);
    testCase.assertEqual(any(strcmp('cov2corr', functionNames)), false);



%% Test System Prior Two Outputs
    [expectedC, expectedR] = acf(m);
    p = acf(m, 'SystemProperty', {'Cov', 'Corr'});
    spw = SystemPriorWrapper.forModel(m);
    spw.addSystemProperty(p);
    f1 = distribution.Normal.fromMeanStd(10, 5);
    f2 = distribution.Normal.standardized( );
    spw.addSystemPrior('Cov(1, 2, 1)', f1);
    spw.addSystemPrior('Corr(1, 2, 1)', f2);
    profile clear;
    profile on;
    [actualLogDensity, actualContrib, actualProp] = eval(spw, m);
    info = profile('info');
    functionNames = {info.FunctionTable.FunctionName};
    expectedProp = [expectedC(1, 2, 1), expectedR(1, 2, 1)];
    expectedContrib = -[f1.logPdf(expectedProp(1)), f2.logPdf(expectedProp(2))];
    expectedLogDensity = sum(expectedContrib);
    testCase.assertEqual(actualProp, expectedProp, 'AbsTol', 1e-10);
    testCase.assertEqual(actualContrib, expectedContrib, 'AbsTol', 1e-10);
    testCase.assertEqual(actualLogDensity, expectedLogDensity,'AbsTol', 1e-10);
    testCase.assertEqual(any(strcmp('cov2corr', functionNames)), true);


%% Test System Prior Update
    p = acf(m, 'SystemProperty', {'Cov', 'Corr'});
    spw = SystemPriorWrapper.forModel(m);
    spw.addSystemProperty(p);
    f1 = distribution.Normal.fromMeanStd(10, 5);
    f2 = distribution.Normal.standardized( );
    spw.addSystemPrior('Cov(1, 2, 1)', f1);
    spw.addSystemPrior('Corr(1, 2, 1)', f2);
    spw.addSystemPrior('Cov(Short, Infl, 1)', f1);
    spw.addSystemPrior('Corr(Short, Infl, 1)', f2);
    for xiw = 55 : 5 : 70
        m.xiw = xiw;
        m = sstate(m, 'Growth', true, 'Display', false);
        m = solve(m);
        [expectedC, expectedR] = acf(m);
        [actualLogDensity, actualContrib, actualProp] = eval(spw, m);
        expectedProp = [expectedC(1, 2, 1), expectedR(1, 2, 1)];
        expectedContrib = -[f1.logPdf(expectedProp(1)), f2.logPdf(expectedProp(2))];
        expectedLogDensity = sum(repmat(expectedContrib, 1, 2));
        testCase.assertEqual(actualProp, repmat(expectedProp, 1, 2), 'AbsTol', 1e-10);
        testCase.assertEqual(actualContrib, repmat(expectedContrib, 1, 2), 'AbsTol', 1e-10);
        testCase.assertEqual(actualLogDensity, expectedLogDensity,'AbsTol', 1e-10);
    end
%}


%% Test System Prior Autocorrelation
    p = acf(m, 'Order', 2, 'SystemProperty', ["Cov", "Corr"]);
    spw = SystemPriorWrapper.forModel(m);
    spw.addSystemProperty(p);
    f = distribution.Normal.fromMeanStd(0.5, 0.1);
    spw.addSystemPrior('Corr(log_R, log_R, 2)', f);
    for xiw = 55 : 5 : 70
        m.xiw = xiw;
        m = sstate(m, 'Growth', true, 'Display', false);
        m = solve(m);
        [expectedC, expectedR] = acf(m, 'Order', 2);
        [actualLogDensity, actualContrib, actualProp] = eval(spw, m);
        expectedProp = [expectedR('log_R', 'log_R', 2)];
        expectedContrib = -[f.logPdf(expectedProp(1))];
        expectedLogDensity = sum(expectedContrib);
        testCase.assertEqual(actualProp, expectedProp, 'AbsTol', 1e-10);
        testCase.assertEqual(actualContrib, expectedContrib, 'AbsTol', 1e-10);
        testCase.assertEqual(actualLogDensity, expectedLogDensity,'AbsTol', 1e-10);
    end

