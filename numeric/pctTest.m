function tests = pctTest( )
tests = functiontests(localfunctions( ));
end


function setupOnce(this)
    pctData = exp(randn(20, 2, 3, 5)/100);
    data = cumprod(pctData, 1);
    x = Series(qq(2000,1), data);
    this.TestData.PctData = pctData;
    this.TestData.Numeric = data;
    this.TestData.Series = x;
end


function testPct(this)
    data = this.TestData.Numeric;
    data0 = data;
    x = this.TestData.Series;
    pctData = numeric.pct(data);
    pctX = pct(x);
    assertEqual(this, pctData(2:end, :), pctX.Data(:, :), 'AbsTol', 1e-15);
    assertEqual(this, 100*(data(2:end,:)./data(1:end-1,:)-1), pctData(2:end,:), 'AbsTol', 1e1-5);
end


function testPctMinus4(this)
    pctData0 = this.TestData.PctData;
    data = this.TestData.Numeric;
    x = this.TestData.Series;
    pctData = numeric.pct(data, -4);
    pctX = pct(x, -4);
    assertEqual(this, pctData(5:end, :), 100*(data(5:end, :)./data(1:end-4,:)-1), 'AbsTol', 1e1-5);
    assertEqual(this, pctData(5:end, :), pctX.Data(:, :), 'AbsTol', 1e-15);
end


function testPctPlus4(this)
    pctData0 = this.TestData.PctData;
    data = this.TestData.Numeric;
    x = this.TestData.Series;
    pctData = numeric.pct(data, 4);
    pctX = pct(x, 4);
    assertEqual(this, pctData(1:end-4, :), 100*(data(1:end-4,:)./data(5:end, :)-1), 'AbsTol', 1e1-5);
    assertEqual(this, pctData(1:end-4, :), pctX.Data(:, :), 'AbsTol', 1e-15);
end

