function tests = movingTest( )
tests = functiontests(localfunctions( ));
end


function setupOnce(this)
    data = randn(20, 2, 3, 5);
    x = Series(qq(2000,1), data);
    this.TestData.Numeric = data;
    this.TestData.Series = x;
end


function testExpsm(this)
    data = this.TestData.Numeric;
    x = this.TestData.Series;
    k = -4;
    data1 = numeric.cumsumk(data, k);
    x1 = cumsumk(x);
    x2 = cumsumk(x, 'K=', k);
    assertEqual(this, data1, x1.Data, 'AbsTol', 1e-10);
    assertEqual(this, data1, x2.Data, 'AbsTol', 1e-10);
    expected = data;;
    numPeriods = size(data, 1);
    for t = 1-k : numPeriods
        expected(t, :) = expected(t, :) + expected(t+k, :);
    end
    assertEqual(this, data1, expected, 'AbsTol', 1e-10);
end


function testExpsmRange(this)
    data = this.TestData.Numeric;
    x = this.TestData.Series;
    k = -4;
    pos = 5:(size(data, 1)-4);
    rangeX = x.Range;
    data1 = numeric.cumsumk(data(pos, :, :, :), k);
    x1 = cumsumk(x, rangeX(pos));
    x2 = cumsumk(x, rangeX(pos), 'K=', k);
    assertEqual(this, data1, x1.Data, 'AbsTol', 1e-10);
    assertEqual(this, data1, x2.Data, 'AbsTol', 1e-10);
end

