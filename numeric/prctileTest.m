function tests = prctileTest( )
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
    prctileData = series.prctile(data, [10, 50, 90], 2);
    prctileX = prctile(x, [10, 50, 90]);
    assertEqual(this, prctileData, prctileX.Data, 'AbsTol', 1e-10);
    expected = repmat([10.5, 50.5, 90.5], numPeriods, 1);
    assertEqual(this, prctileData, expected, 'AbsTol', 1e-10);
end

