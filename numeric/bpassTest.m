function tests = bpassTest( )
tests = functiontests(localfunctions( ));
end


function setupOnce(this)
    data = randn(20, 2, 3, 5);
    data = cumsum(data, 1);
    x = Series(qq(2000,1), data);
    this.TestData.Numeric = data;
    this.TestData.Series = x;
end


function testDefaultDetrend(this)
    data = this.TestData.Numeric;
    x = this.TestData.Series;
    data1 = numeric.bpass(data, [2, 40]);
    x1 = bpass(x, [2, 40]);
    assertEqual(this, data1, x1.Data, 'AbsTol', 1e-12)
end 


function testNoDetrend(this)
    data = this.TestData.Numeric;
    x = this.TestData.Series;
    data1 = numeric.bpass(data, [2, 40]);
    x1 = bpass(x, [2, 40]);
    data2 = numeric.bpass(data, [2, 40], 'Detrend=', false);
    x2 = bpass(x, [2, 40], 'Detrend=', false);
    assertEqual(this, data1, x1.Data, 'AbsTol', 1e-12);
    assertEqual(this, data2, x2.Data, 'AbsTol', 1e-12);
    assertGreaterThan(this, maxabs(data1-data2), 1e-5);
end 


function testAddTrend(this)
    data = this.TestData.Numeric;
    x = this.TestData.Series;
    data1 = numeric.bpass(data, [2, 40], 'AddTrend=', true);
    x1 = bpass(x, [2, 40], 'AddTrend=', true);
    assertEqual(this, data1, x1.Data, 'AbsTol', 1e-12);
end 


function testLevelTrend(this)
    data = this.TestData.Numeric;
    x = this.TestData.Series;
    data1 = numeric.bpass(data, [2, 40]);
    x1 = bpass(x, [2, 40]);
    [data2, trendData2] = numeric.bpass(data, [2, 40], 'Detrend=', {'Diff=', false, 'Connect=', false});
    [x2, trendX2] = bpass(x, [2, 40], 'Detrend=', {'Diff=', false, 'Connect=', false});
    assertEqual(this, data1, x1.Data, 'AbsTol', 1e-12);
    assertEqual(this, data2, x2.Data, 'AbsTol', 2e-22);
    assertGreaterThan(this, maxabs(data1-data2), 1e-5);
end 



