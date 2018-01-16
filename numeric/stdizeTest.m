function tests = stdizeTest( )
tests = functiontests(localfunctions( ));
end


function setupOnce(this)
    data = randn(20, 2, 3, 5);
    data = cumsum(data, 1);
    x = Series(qq(2000,1), data);
    this.TestData.Numeric = data;
    this.TestData.Series = x;
end


function testStdize(this)
    data = this.TestData.Numeric;
    x = this.TestData.Series;
    [stdizeData, meanData, stdData] = numeric.stdize(data);
    [stdizeX, meanX, stdX] = stdize(x);
    assertEqual(this, stdizeData, stdizeX.Data, 'AbsTol', 1e-10);
    data1 = numeric.destdize(stdizeData, meanData, stdData);
    x1 = destdize(stdizeX, meanX, stdX);
    assertEqual(this, data, data1, 'AbsTol', 1e-10);
    assertEqual(this, data1, x1.Data, 'AbsTol', 1e-10);
end


function testStdizeFlag(this)
    data = this.TestData.Numeric;
    x = this.TestData.Series;
    [stdizeData, meanData, stdData] = numeric.stdize(data, 1);
    [stdizeX, meanX, stdX] = stdize(x, 1);
    assertEqual(this, stdizeData, stdizeX.Data, 'AbsTol', 1e-10);
    data1 = numeric.destdize(stdizeData, meanData, stdData);
    x1 = destdize(stdizeX, meanX, stdX);
    assertEqual(this, data, data1, 'AbsTol', 1e-10);
    assertEqual(this, data1, x1.Data, 'AbsTol', 1e-10);
end




