function tests = xsfTest( )
tests = functiontests( localfunctions( ) );
end


function setupOnce(this)
    this.TestData.Model = readModel( );
    this.TestData.Freq = 0 : 0.01 : pi;
end


function testSystemProperty(this)
    m = this.TestData.Model;
    freq = this.TestData.Freq;
    [expectedS, expectedD] = xsf(m, freq);
    p = xsf(m, freq, 'SystemProperty', {'S', 'D'});
    update(p, m);
    eval(p, m);
    actualS = p.Outputs{1};
    actualD = p.Outputs{2};
    this.assertEqual(double(actualS), double(expectedS), 'AbsTol', 1e-10);
    this.assertEqual(double(actualD), double(expectedD), 'AbsTol', 1e-10);
end


function testSystemPropertyUpdate(this)
    m = this.TestData.Model;
    freq = this.TestData.Freq;
    p = xsf(m, freq, 'SystemProperty', {'S', 'D'});
    for xiw = 55 : 5 : 70
        m.xiw = xiw;
        m = sstate(m, 'Growth', true, 'Display', false);
        m = solve(m);
        [expectedS, expectedD] = xsf(m, freq);
        update(p, m);
        eval(p, m);
        actualS = p.Outputs{1};
        actualD = p.Outputs{2};
        this.assertEqual(double(actualS), double(expectedS), 'AbsTol', 1e-10);
        this.assertEqual(double(actualD), double(expectedD), 'AbsTol', 1e-10);
    end
end


function testSystemPriorOneOutput(this)
    m = this.TestData.Model;
    freq = this.TestData.Freq;
    expectedS = xsf(m, freq);
    p = xsf(m, freq, 'SystemProperty', 'Pws');
    spw = SystemPriorWrapper.forModel(m);
    spw.addSystemProperty(p);
    f1 = distribution.Normal.fromMeanStd(1000, 5);
    spw.addSystemPrior('abs(sum(Pws(1, 2, :)))', f1);
    profile clear;
    profile on;
    [actualLogDensity, actualContrib, actualProp] = eval(spw, m);
    info = profile('info');
    functionNames = {info.FunctionTable.FunctionName};
    expectedProp = abs(sum(expectedS(1, 2, :)));
    expectedContrib = -f1.logPdf(expectedProp(1));
    expectedLogDensity = sum(expectedContrib);
    this.assertEqual(actualProp, expectedProp, 'AbsTol', 1e-10);
    this.assertEqual(actualContrib, expectedContrib, 'AbsTol', 1e-10);
    this.assertEqual(actualLogDensity, expectedLogDensity,'AbsTol', 1e-10);
    this.assertEqual(any(strcmp('psf2sdf', functionNames)), false);
end



function testSystemPriorTwoOutputs(this)
    m = this.TestData.Model;
    freq = this.TestData.Freq;
    [expectedS, expectedD] = xsf(m, freq);
    p = xsf(m, freq, 'SystemProperty', {'Pws', 'Spd'});
    spw = SystemPriorWrapper.forModel(m);
    spw.addSystemProperty(p);
    f1 = distribution.Normal.fromMeanStd(1000, 5);
    f2 = distribution.Normal.fromMeanStd(20, 2);
    spw.addSystemPrior('abs(sum(Pws(1, 2, :)))', f1);
    spw.addSystemPrior('abs(sum(Spd(1, 2, :)))', f2);
    profile clear;
    profile on;
    [actualLogDensity, actualContrib, actualProp] = eval(spw, m);
    info = profile('info');
    functionNames = {info.FunctionTable.FunctionName};
    expectedProp = [abs(sum(expectedS(1, 2, :))), abs(sum(expectedD(1, 2, :)))];
    expectedContrib = -[f1.logPdf(expectedProp(1)), f2.logPdf(expectedProp(2))];
    expectedLogDensity = sum(expectedContrib);
    this.assertEqual(actualProp, expectedProp, 'AbsTol', 1e-10);
    this.assertEqual(actualContrib, expectedContrib, 'AbsTol', 1e-10);
    this.assertEqual(actualLogDensity, expectedLogDensity,'AbsTol', 1e-10);
    this.assertEqual(any(strcmp('psf2sdf', functionNames)), true);
end


function testSystemPriorUpdate(this)
    m = this.TestData.Model;
    freq = this.TestData.Freq;
    p = xsf(m, freq, 'SystemProperty', {'Pws', 'Spd'});
    spw = SystemPriorWrapper.forModel(m);
    spw.addSystemProperty(p);
    f1 = distribution.Normal.fromMeanStd(1000, 5);
    f2 = distribution.Normal.fromMeanStd(20, 2);
    spw.addSystemPrior('abs(sum(Pws(1, 2, :)))', f1);
    spw.addSystemPrior('abs(sum(Spd(1, 2, :)))', f2);
    for xiw = 55 : 5 : 70
        m.xiw = xiw;
        m = sstate(m, 'Growth', true, 'Display', false);
        m = solve(m);
        [expectedS, expectedD] = xsf(m, freq);
        [actualLogDensity, actualContrib, actualProp] = eval(spw, m);
        expectedProp = [abs(sum(expectedS(1, 2, :))), abs(sum(expectedD(1, 2, :)))];
        expectedContrib = -[f1.logPdf(expectedProp(1)), f2.logPdf(expectedProp(2))];
        expectedLogDensity = sum(expectedContrib);
        this.assertEqual(actualProp, expectedProp, 'AbsTol', 1e-10);
        this.assertEqual(actualContrib, expectedContrib, 'AbsTol', 1e-10);
        this.assertEqual(actualLogDensity, expectedLogDensity,'AbsTol', 1e-10);
    end
end
