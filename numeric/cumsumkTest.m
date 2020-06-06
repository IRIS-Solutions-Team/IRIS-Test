function tests = cumsumkTest( )
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
    range = x.Range;
    k = -4;
    data1 = series.cumsumk(data, k);
    x1 = cumsumk(x, range(5:end));
    x2 = cumsumk(x, range(5:end), 'K=', k);
    assertEqual(this, data1, x1.Data, 'AbsTol', 1e-10);
    assertEqual(this, data1, x2.Data, 'AbsTol', 1e-10);
    expected = data;
    numPeriods = size(data, 1);
    for t = 1-k : numPeriods
        expected(t, :) = expected(t, :) + expected(t+k, :);
    end
    expected = expected(1-k:end, :, :, :);
    assertEqual(this, data1, expected, 'AbsTol', 1e-10);
end

