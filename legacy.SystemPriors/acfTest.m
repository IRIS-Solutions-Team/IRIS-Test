function tests = acfTest( )
tests = functiontests( localfunctions( ) );
end%


function setupOnce(this)
    this.TestData.Model = readModel( );
end%


function testSystemProperty(this)
    m = this.TestData.Model;
    [expectedC, expectedR] = acf(m);
    p = acf(m, 'SystemProperty', {'C', 'R'});
    update(p, m);
    eval(p, m);
    actualC = p.Outputs{1};
    actualR = p.Outputs{2};
    this.assertEqual(double(actualC), double(expectedC), 'AbsTol', 1e-10);
    this.assertEqual(double(actualR), double(expectedR), 'AbsTol', 1e-10);
end%


function testSystemPropertyUpdate(this)
    m = this.TestData.Model;
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
        this.assertEqual(double(actualC), double(expectedC), 'AbsTol', 1e-10);
        this.assertEqual(double(actualR), double(expectedR), 'AbsTol', 1e-10);
    end
end%


function testSystemPriorOneOutput(this)
    m = this.TestData.Model;
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
    this.assertEqual(actualProp, expectedProp, 'AbsTol', 1e-10);
    this.assertEqual(actualContrib, expectedContrib, 'AbsTol', 1e-10);
    this.assertEqual(actualLogDensity, expectedLogDensity,'AbsTol', 1e-10);
    this.assertEqual(any(strcmp('cov2corr', functionNames)), false);
end%



function testSystemPriorTwoOutputs(this)
    m = this.TestData.Model;
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
    this.assertEqual(actualProp, expectedProp, 'AbsTol', 1e-10);
    this.assertEqual(actualContrib, expectedContrib, 'AbsTol', 1e-10);
    this.assertEqual(actualLogDensity, expectedLogDensity,'AbsTol', 1e-10);
    this.assertEqual(any(strcmp('cov2corr', functionNames)), true);
end%


function testSystemPriorUpdate(this)
    m = this.TestData.Model;
    p = acf(m, 'SystemProperty', {'Cov', 'Corr'});
    spw = SystemPriorWrapper.forModel(m);
    spw.addSystemProperty(p);
    f1 = distribution.Normal.fromMeanStd(10, 5);
    f2 = distribution.Normal.standardized( );
    spw.addSystemPrior('Cov(1, 2, 1)', f1);
    spw.addSystemPrior('Corr(1, 2, 1)', f2);
    for xiw = 55 : 5 : 70
        m.xiw = xiw;
        m = sstate(m, 'Growth', true, 'Display', false);
        m = solve(m);
        [expectedC, expectedR] = acf(m);
        [actualLogDensity, actualContrib, actualProp] = eval(spw, m);
        expectedProp = [expectedC(1, 2, 1), expectedR(1, 2, 1)];
        expectedContrib = -[f1.logPdf(expectedProp(1)), f2.logPdf(expectedProp(2))];
        expectedLogDensity = sum(expectedContrib);
        this.assertEqual(actualProp, expectedProp, 'AbsTol', 1e-10);
        this.assertEqual(actualContrib, expectedContrib, 'AbsTol', 1e-10);
        this.assertEqual(actualLogDensity, expectedLogDensity,'AbsTol', 1e-10);
    end
end%
