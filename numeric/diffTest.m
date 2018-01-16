function tests = diffTest( )
tests = functiontests(localfunctions( ));
end


function setupOnce(this)
    diffData = randn(20, 2, 3, 5);
    data = cumsum(diffData, 1);
    x = Series(qq(2000,1), data);
    this.TestData.DiffData = diffData;
    this.TestData.Numeric = data;
    this.TestData.Series = x;
end


function testDiff(this)
    diffData0 = this.TestData.DiffData;
    data = this.TestData.Numeric;
    x = this.TestData.Series;
    diffData = numeric.diff(data);
    diffX = diff(x);
    assertEqual(this, diffData(2:end, :), diffX.Data(:, :), 'AbsTol', 1e-15);
    assertEqual(this, diffData0(2:end, :), diffData(2:end, :), 'AbsTol', 1e-15);
end


function testDiffMinus4(this)
    diffData0 = this.TestData.DiffData;
    data = this.TestData.Numeric;
    x = this.TestData.Series;
    diffData = numeric.diff(data, -4);
    diffX = diff(x, -4);
    assertEqual(this, diffData(5:end, :), data(5:end, :)-data(1:end-4,:), 'AbsTol', 1e1-5);
    assertEqual(this, diffData(5:end, :), diffX.Data(:, :), 'AbsTol', 1e-15);
end


function testDiffPlus4(this)
    diffData0 = this.TestData.DiffData;
    data = this.TestData.Numeric;
    x = this.TestData.Series;
    diffData = numeric.diff(data, 4);
    diffX = diff(x, 4);
    assertEqual(this, diffData(1:end-4, :), -data(5:end, :)+data(1:end-4,:), 'AbsTol', 1e1-5);
    assertEqual(this, diffData(1:end-4, :), diffX.Data(:, :), 'AbsTol', 1e-15);
end

