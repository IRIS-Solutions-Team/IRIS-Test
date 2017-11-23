function tests = ffrfTest( )
tests = functiontests( localfunctions( ) );
end


function setupOnce(this)
    this.TestData.Model = readModel( );
    this.TestData.Freq = 0 : 0.01 : pi;
end


function testSystemProperty(this)
    m = this.TestData.Model;
    freq = this.TestData.Freq;
    expectedF = ffrf(m, freq);
    p = ffrf(m, freq, 'SystemProperty=', true);
    p.NumOutputs = 1;
    update(p, m);
    eval(p);
    actualF = p.Outputs{1};
    this.assertEqual(double(actualF), double(expectedF), 'AbsTol', 1e-10);
end


function testSystemPropertyUpdate(this)
    m = this.TestData.Model;
    freq = this.TestData.Freq;
    p = ffrf(m, freq, 'SystemProperty=', true);
    p.NumOutputs = 1;
    for xiw = 55 : 5 : 70
        m.xiw = xiw;
        m = sstate(m, 'Growth=', true, 'Display=', false);
        m = solve(m);
        expectedF = ffrf(m, freq);
        update(p, m);
        eval(p);
        actualF = p.Outputs{1};
        this.assertEqual(double(actualF), double(expectedF), 'AbsTol', 1e-10);
    end
end


function testSystemPrior(this)
    m = this.TestData.Model;
    freq = this.TestData.Freq;
    expectedF = ffrf(m, freq);
    p = ffrf(m, freq, 'SystemProperty=', true);
    p.NumOutputs = 1;
    spw = SystemPriorWrapper(m);
    spw.addSystemProperty('F', p);
    f1 = distribution.Normal.fromMeanStd(0, 2);
    spw.addSystemPrior('abs(sum(F(12, 3, :)))', f1);
    [actualLogDensity, actualContrib, actualProp] = eval(spw, m);
    expectedProp = abs(sum(expectedF(12, 3, :)));
    expectedContrib = -f1.logPdf(expectedProp(1));
    expectedLogDensity = sum(expectedContrib);
    this.assertEqual(actualProp, expectedProp, 'AbsTol', 1e-10);
    this.assertEqual(actualContrib, expectedContrib, 'AbsTol', 1e-10);
    this.assertEqual(actualLogDensity, expectedLogDensity,'AbsTol', 1e-10);
end


function testSystemPriorUpdate(this)
    m = this.TestData.Model;
    freq = this.TestData.Freq;
    p = ffrf(m, freq, 'SystemProperty=', true);
    spw = SystemPriorWrapper(m);
    spw.addSystemProperty('F', p);
    f1 = distribution.Normal.fromMeanStd(0, 2);
    spw.addSystemPrior('abs(sum(F(12, 3, :)))', f1);
    for xiw = 55 : 5 : 70
        m.xiw = xiw;
        m = sstate(m, 'Growth=', true, 'Display=', false);
        m = solve(m);
        expectedF = ffrf(m, freq);
        [actualLogDensity, actualContrib, actualProp] = eval(spw, m);
        expectedProp = abs(sum(expectedF(12, 3, :)));
        expectedContrib = -f1.logPdf(expectedProp(1));
        expectedLogDensity = sum(expectedContrib);
        this.assertEqual(actualProp, expectedProp, 'AbsTol', 1e-10);
        this.assertEqual(actualContrib, expectedContrib, 'AbsTol', 1e-10);
        this.assertEqual(actualLogDensity, expectedLogDensity,'AbsTol', 1e-10);
    end
end
