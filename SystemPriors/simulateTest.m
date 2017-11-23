function tests = simulateTest( )
tests = functiontests( localfunctions( ) );
end


function setupOnce(this)
    this.TestData.Model = readModel( );
end


function testSystemProperty(this)
    m = this.TestData.Model;
    d = sstatedb(m, 1:40);
    d.Ep(5) = 0.01;
    p = simulate(m, d, 1:40, 'SystemProperty=', true);
    p.NumOutputs = 1;
    s = simulate(m, d, 1:40);
    update(p, m, 1);
    eval(p);
    actualSim = p.Outputs{1}(1, :)';
    expectedSim = s.Short(1:40);
    actualProp = sum(actualSim);
    expectedProp = sum(expectedSim);
    this.assertEqual(actualProp, expectedProp, 'AbsTol', 1e-10);
end


function testSystemPropertyUpdate(this)
    m = this.TestData.Model;
    d = sstatedb(m, 1:40);
    d.Ep(5) = 0.01;
    p = simulate(m, d, 1:40, 'SystemProperty=', true);
    p.NumOutputs = 1;
    for xiw = 55 : 5 : 70
        m.xiw = xiw;
        chksstate(m);
        m = solve(m);
        s = simulate(m, d, 1:40);
        update(p, m, 1);
        eval(p);
        actualSim = p.Outputs{1}(1, :)';
        expectedSim = s.Short(1:40);
        actualProp = sum(actualSim);
        expectedProp = sum(expectedSim);
        this.assertEqual(actualProp, expectedProp, 'AbsTol', 1e-10);
    end
end


function testSystemPrior(this)
    m = this.TestData.Model;
    d = sstatedb(m, 1:40);
    d.Ep(5) = 0.01;
    s = simulate(m, d, 1:40);
    p = simulate(m, d, 1:40, 'SystemProperty=', true);
    p.NumOutputs = 1;
    f1 = distribution.Normal.fromMeanStd(40, 5);
    spw = SystemPriorWrapper(m);
    spw.addSystemProperty('Sim', p);
    spw.addSystemPrior('sum(Sim(log_P, :))', f1);
    [actualLogDensity, actualContrib, actualProp] = eval(spw, m);
    expectedProp = sum(log(s.P(1:40)));
    expectedContrib = -f1.logPdf(expectedProp(1));
    expectedLogDensity = sum(expectedContrib);
    this.assertEqual(actualProp, expectedProp, 'AbsTol', 1e-10);
    this.assertEqual(actualContrib, expectedContrib, 'AbsTol', 1e-10);
    this.assertEqual(actualLogDensity, expectedLogDensity,'AbsTol', 1e-10);
end


function testSystemPriorUpdate(this)
    m = this.TestData.Model;
    d = sstatedb(m, 1:40);
    d.Ep(5) = 0.01;
    p = simulate(m, d, 1:40, 'SystemProperty=', true);
    p.NumOutputs = 1;
    f1 = distribution.Normal.fromMeanStd(40, 5);
    spw = SystemPriorWrapper(m);
    spw.addSystemProperty('Sim', p);
    spw.addSystemPrior('sum(Sim(log_P, :))', f1);
    for xiw = 55 : 5 : 70
        m.xiw = xiw;
        chksstate(m);
        m = solve(m);
        s = simulate(m, d, 1:40);
        [actualLogDensity, actualContrib, actualProp] = eval(spw, m);
        expectedProp = sum(log(s.P(1:40)));
        expectedContrib = -f1.logPdf(expectedProp(1));
        expectedLogDensity = sum(expectedContrib);
        this.assertEqual(actualProp, expectedProp, 'AbsTol', 1e-10);
        this.assertEqual(actualContrib, expectedContrib, 'AbsTol', 1e-10);
        this.assertEqual(actualLogDensity, expectedLogDensity,'AbsTol', 1e-10);
    end
end
