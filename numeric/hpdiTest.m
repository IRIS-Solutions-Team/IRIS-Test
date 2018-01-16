function tests = hpdiTest( )
tests = functiontests(localfunctions( ));
end


function setupOnce(this)
    data = nan(20, 100);
    for i = 1 : 20
        data(i, :) = randperm(100);
    end
    x = Series(qq(2000,1), data);
    this.TestData.Numeric = data;
    this.TestData.Series = x;
end


function testPrctile(this)
    data = this.TestData.Numeric;
    x = this.TestData.Series;
    numPeriods = size(data, 1);
    hpdiData = numeric.hpdi(data, 80, 2);
    hpdiX = hpdi(x, 80);
    assertEqual(this, hpdiData, hpdiX.Data, 'AbsTol', 1e-10);
    expected = repmat([1, 80], numPeriods, 1);
    assertEqual(this, hpdiData, expected, 'AbsTol', 1e-10);
end


function testPrctileDim(this)
    data = this.TestData.Numeric;
    x = this.TestData.Series;
    numPeriods = size(data, 1);
    hpdiData = numeric.hpdi(data, 80, 1);
    hpdiX = hpdi(x, 80, 1);
    assertEqual(this, hpdiData, hpdiX, 'AbsTol', 1e-10);
    hpdiData = numeric.hpdi(data, 80, 3);
    hpdiX = hpdi(x, 80, 3);
    assertEqual(this, hpdiData, hpdiX.Data, 'AbsTol', 1e-10);
end
