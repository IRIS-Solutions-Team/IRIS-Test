function tests = normalizeTest( )
tests = functiontests(localfunctions);
end%


function setupOnce(this) %#ok<*DEFNU>
    range = qq(2000, 1:40);
    x1 = tseries(range, @rand);
    x2 = tseries(range, rand(40, 3));
    x3 = tseries(range, rand(40, 2, 3));
    this.TestData.range = range;
    this.TestData.x1 = x1;
    this.TestData.x2 = x2;
    this.TestData.x3 = x3;
end%


function testPlain(this)
    x1 = this.TestData.x1;
    x2 = this.TestData.x2;
    x3 = this.TestData.x3;
    n1 = normalize(x1);
    n2 = normalize(x2);
    n3 = normalize(x3);
    assertEqual(this, n1.Data, bsxfun(@rdivide, x1.Data, x1.Data(1, :)), 'AbsTol', 1e-14);
    assertEqual(this, n2.Data, bsxfun(@rdivide, x2.Data, x2.Data(1, :)), 'AbsTol', 1e-14);
    assertEqual(this, n3.Data, bsxfun(@rdivide, x3.Data, x3.Data(1, :, :)), 'AbsTol', 1e-14);
end%


function testStartAdd(this)
    x1 = this.TestData.x1;
    x2 = this.TestData.x2;
    x3 = this.TestData.x3;
    n1 = normalize(x1, 'Mode', 'Add');
    n2 = normalize(x2, 'Mode', 'Add');
    n3 = normalize(x3, 'Mode', 'Add');
    assertEqual(this, n1.Data, bsxfun(@minus, x1.Data, x1.Data(1, :)), 'AbsTol', 1e-14);
    assertEqual(this, n2.Data, bsxfun(@minus, x2.Data, x2.Data(1, :)), 'AbsTol', 1e-14);
    assertEqual(this, n3.Data, bsxfun(@minus, x3.Data, x3.Data(1, :, :)), 'AbsTol', 1e-14);
end%


function testEnd(this)
    x1 = this.TestData.x1;
    x2 = this.TestData.x2;
    x3 = this.TestData.x3;
    n1 = normalize(x1, 'End');
    n2 = normalize(x2, 'End');
    n3 = normalize(x3, 'End');
    assertEqual(this, n1.Data, bsxfun(@rdivide, x1.Data, x1.Data(end, :)), 'AbsTol', 1e-14);
    assertEqual(this, n2.Data, bsxfun(@rdivide, x2.Data, x2.Data(end, :)), 'AbsTol', 1e-14);
    assertEqual(this, n3.Data, bsxfun(@rdivide, x3.Data, x3.Data(end, :, :)), 'AbsTol', 1e-14);
end%


function testDate(this)
    x1 = this.TestData.x1;
    x2 = this.TestData.x2;
    x3 = this.TestData.x3;
    n1 = normalize(x1, qq(2001,1));
    n2 = normalize(x2, qq(2001,1));
    n3 = normalize(x3, qq(2001,1));
    assertEqual(this, n1.Data, bsxfun(@rdivide, x1.Data, x1.Data(5, :)), 'AbsTol', 1e-14);
    assertEqual(this, n2.Data, bsxfun(@rdivide, x2.Data, x2.Data(5, :)), 'AbsTol', 1e-14);
    assertEqual(this, n3.Data, bsxfun(@rdivide, x3.Data, x3.Data(5, :, :)), 'AbsTol', 1e-14);
end%


function testNaNStart(this)
    x2 = this.TestData.x2;
    x3 = this.TestData.x3;
    x2(qq(2000,1),2) = NaN;
    x3(qq(2000,1),2,2) = NaN;
    n2 = normalize(x2, 'NaNStart');
    n3 = normalize(x3, 'NaNStart');
    assertEqual(this, n2.Data, bsxfun(@rdivide, x2.Data, x2.Data(2, :)), 'AbsTol', 1e-14);
    assertEqual(this, n3.Data, bsxfun(@rdivide, x3.Data, x3.Data(2, :, :)), 'AbsTol', 1e-14);
end%


