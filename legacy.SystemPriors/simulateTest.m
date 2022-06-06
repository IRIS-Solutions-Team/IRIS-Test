
testCase = matlab.unittest.FunctionTestCase.fromFunction(@(x)x);
testCase.TestData.Model = readModel( );


%% Test system property

    m = testCase.TestData.Model;
    d = sstatedb(m, 1:40);
    d.Ep(5) = 0.01;
    p = simulate(m, d, 1:40, 'SystemProperty', 'S');
    s = simulate(m, d, 1:40);
    update(p, m, 1);
    eval(p, m);
    actualSim = p.Outputs{1}(1, :)';
    expectedSim = s.Short(1:40);
    actualProp = sum(actualSim);
    expectedProp = sum(expectedSim);
    testCase.assertEqual(actualProp, expectedProp, 'AbsTol', 1e-10);



%% Test system property update
    m = testCase.TestData.Model;
    d = sstatedb(m, 1:40);
    d.Ep(5) = 0.01;
    p = simulate(m, d, 1:40, 'SystemProperty', 'S');
    for xiw = 55 : 5 : 70
        m.xiw = xiw;
        checkSteady(m);
        m = solve(m);
        s = simulate(m, d, 1:40);
        update(p, m, 1);
        eval(p, m);
        actualSim = p.Outputs{1}(1, :)';
        expectedSim = s.Short(1:40);
        actualProp = sum(actualSim);
        expectedProp = sum(expectedSim);
        testCase.assertEqual(actualProp, expectedProp, 'AbsTol', 1e-10);
    end


%% Test system prior

    m = testCase.TestData.Model;
    d = sstatedb(m, 1:40);
    d.Ep(5) = 0.01;
    s = simulate(m, d, 1:40);
    p = simulate(m, d, 1:40, 'SystemProperty', 'Sim');
    f1 = distribution.Normal.fromMeanStd(40, 5);
    spw = SystemPriorWrapper.forModel(m);
    spw.addSystemProperty(p);
    spw.addSystemPrior('sum(log(Sim(P, :)))', f1);
    [actualLogDensity, actualContrib, actualProp] = eval(spw, m);
    expectedProp = sum(log(s.P(1:40)));
    expectedContrib = -f1.logPdf(expectedProp(1));
    expectedLogDensity = sum(expectedContrib);
    testCase.assertEqual(actualProp, expectedProp, 'AbsTol', 1e-10);
    testCase.assertEqual(actualContrib, expectedContrib, 'AbsTol', 1e-10);
    testCase.assertEqual(actualLogDensity, expectedLogDensity,'AbsTol', 1e-10);


%% Test system prior update

    m = testCase.TestData.Model;
    d = sstatedb(m, 1:40);
    d.Ep(5) = 0.01;
    p = simulate(m, d, 1:40, 'SystemProperty', 'Sim');
    f1 = distribution.Normal.fromMeanStd(40, 5);
    spw = SystemPriorWrapper.forModel(m);
    spw.addSystemProperty(p);
    spw.addSystemPrior('sum(log(Sim(P, :)))', f1);
    for xiw = 55 : 5 : 70
        m.xiw = xiw;
        checkSteady(m);
        m = solve(m);
        s = simulate(m, d, 1:40);
        [actualLogDensity, actualContrib, actualProp] = eval(spw, m);
        expectedProp = sum(log(s.P(1:40)));
        expectedContrib = -f1.logPdf(expectedProp(1));
        expectedLogDensity = sum(expectedContrib);
        testCase.assertEqual(actualProp, expectedProp, 'AbsTol', 1e-10);
        testCase.assertEqual(actualContrib, expectedContrib, 'AbsTol', 1e-10);
        testCase.assertEqual(actualLogDensity, expectedLogDensity,'AbsTol', 1e-10);
    end

