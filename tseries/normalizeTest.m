
this = matlab.unittest.FunctionTestCase.fromFunction(@(x)x);

% Set up Once
    range = qq(2000, 1:40);
    x1 = tseries(range, @rand);
    x2 = tseries(range, rand(40, 3));
    x3 = tseries(range, rand(40, 2, 3));
    this.TestData.range = range;
    this.TestData.x1 = x1;
    this.TestData.x2 = x2;
    this.TestData.x3 = x3;


%% Test Plain Vanilla
    x1 = this.TestData.x1;
    x2 = this.TestData.x2;
    x3 = this.TestData.x3;
    n1 = normalize(x1, x1.Start);
    n2 = normalize(x2, x2.Start);
    n3 = normalize(x3, x3.Start);
    assertEqual(this, n1.Data, bsxfun(@rdivide, x1.Data, x1.Data(1, :)), 'AbsTol', 1e-14);
    assertEqual(this, n2.Data, bsxfun(@rdivide, x2.Data, x2.Data(1, :)), 'AbsTol', 1e-14);
    assertEqual(this, n3.Data, bsxfun(@rdivide, x3.Data, x3.Data(1, :, :)), 'AbsTol', 1e-14);


%% Test Start Add
    x1 = this.TestData.x1;
    x2 = this.TestData.x2;
    x3 = this.TestData.x3;
    n1 = normalize(x1, x1.Start, 'Mode', 'Add');
    n2 = normalize(x2, x2.Start, 'Mode', 'Add');
    n3 = normalize(x3, x3.Start, 'Mode', 'Add');
    assertEqual(this, n1.Data, bsxfun(@minus, x1.Data, x1.Data(1, :)), 'AbsTol', 1e-14);
    assertEqual(this, n2.Data, bsxfun(@minus, x2.Data, x2.Data(1, :)), 'AbsTol', 1e-14);
    assertEqual(this, n3.Data, bsxfun(@minus, x3.Data, x3.Data(1, :, :)), 'AbsTol', 1e-14);


%% Test End
    x1 = this.TestData.x1;
    x2 = this.TestData.x2;
    x3 = this.TestData.x3;
    n1 = normalize(x1, x1.End);
    n2 = normalize(x2, x2.End);
    n3 = normalize(x3, x3.End);
    assertEqual(this, n1.Data, bsxfun(@rdivide, x1.Data, x1.Data(end, :)), 'AbsTol', 1e-14);
    assertEqual(this, n2.Data, bsxfun(@rdivide, x2.Data, x2.Data(end, :)), 'AbsTol', 1e-14);
    assertEqual(this, n3.Data, bsxfun(@rdivide, x3.Data, x3.Data(end, :, :)), 'AbsTol', 1e-14);


% Test Date
    x1 = this.TestData.x1;
    x2 = this.TestData.x2;
    x3 = this.TestData.x3;
    n1 = normalize(x1, qq(2001,1));
    n2 = normalize(x2, qq(2001,1));
    n3 = normalize(x3, qq(2001,1));
    assertEqual(this, n1.Data, bsxfun(@rdivide, x1.Data, x1.Data(5, :)), 'AbsTol', 1e-14);
    assertEqual(this, n2.Data, bsxfun(@rdivide, x2.Data, x2.Data(5, :)), 'AbsTol', 1e-14);
    assertEqual(this, n3.Data, bsxfun(@rdivide, x3.Data, x3.Data(5, :, :)), 'AbsTol', 1e-14);


