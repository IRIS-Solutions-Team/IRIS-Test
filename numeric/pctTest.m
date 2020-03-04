function tests = pctTest( )
tests = functiontests(localfunctions( ));
end


function setupOnce(this)
    rocData = exp(randn(20, 2, 3, 5)/100);
    data = cumprod(rocData, 1);
    x = Series(qq(2000,1), data);
    this.TestData.RocData = rocData;
    this.TestData.Numeric = data;
    this.TestData.Series = x;
end


function testPct(this)
    data = this.TestData.Numeric;
    x = this.TestData.Series;
    rocData = series.change(data, @rdivide);
    rocX = roc(x);
    assertEqual(this, rocData(2:end, :), rocX.Data(:, :), 'AbsTol', 1e-15);
    assertEqual(this, data(2:end,:)./data(1:end-1,:), rocData(2:end,:), 'AbsTol', 1e1-7);
end


function testPctMinus4(this)
    data = this.TestData.Numeric;
    x = this.TestData.Series;
    rocData = series.change(data, @rdivide, -4);
    rocX = roc(x, -4);
    assertEqual(this, rocData(5:end, :), data(5:end, :)./data(1:end-4,:), 'AbsTol', 1e1-7);
    assertEqual(this, rocData(5:end, :), rocX.Data(:, :), 'AbsTol', 1e-15);
end


function testPctPlus4(this)
    data = this.TestData.Numeric;
    x = this.TestData.Series;
    rocData = series.change(data, @rdivide, 4);
    rocX = roc(x, 4);
    assertEqual(this, rocData(1:end-4, :), data(1:end-4,:)./data(5:end, :), 'AbsTol', 1e1-7);
    assertEqual(this, rocData(1:end-4, :), rocX.Data(:, :), 'AbsTol', 1e-15);
end

