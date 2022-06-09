
testCase = matlab.unittest.FunctionTestCase.fromFunction(@(x)x);

data = randn(20, 2, 3, 5);
data = cumsum(data, 1);
x = Series(qq(2000,1), data);
this.TestData.Numeric = data;
this.TestData.Series = x;


%% Test Vanilla
    data = this.TestData.Numeric;
    x = this.TestData.Series;
    beta = 0.75;
    data1 = series.expsm(data, beta, []);
    x1 = expsm(x, beta);
    assertEqual(testCase, data1, x1.Data, 'AbsTol', 1e-10);
    expected = data;
    numPeriods = size(data, 1);
    for t = 2 : numPeriods
        expected(t, :) = beta*expected(t-1, :) + (1-beta)*expected(t, :);
    end
    assertEqual(testCase, data1, expected, 'AbsTol', 1e-10);


%% Test Init
    data = this.TestData.Numeric;
    x = this.TestData.Series;
    sizeData = size(data);
    beta = 0.75;
    data1 = series.expsm(data, beta, 0);
    x1 = expsm(x, beta, 'Init', 0);
    assertEqual(testCase, data1, x1.Data, 'AbsTol', 1e-10);
    expected = flipud(data);
    expected(end+1, 1) = 0;
    expected = flipud(expected);
    for t = 2 : size(expected, 1)
        expected(t, :) = beta*expected(t-1, :) + (1-beta)*expected(t, :);
    end
    expected = reshape(expected(2:end, :), sizeData);
    assertEqual(testCase, data1, expected, 'AbsTol', 1e-10);



%% Test Range
    data = this.TestData.Numeric;
    x = this.TestData.Series;
    beta = 0.75;
    pos = 5:(size(data, 1)-4);
    rangeX = x.Range;
    data1 = series.expsm(data(pos, :, :, :), beta, []);
    x1 = expsm(x, beta, 'range', rangeX(pos));
    assertEqual(testCase, data1, x1.Data, 'AbsTol', 1e-10);
    expected = data(pos, :, :, :);
    numPeriods = size(expected, 1);
    for t = 2 : numPeriods
        expected(t, :) = beta*expected(t-1, :) + (1-beta)*expected(t, :);
    end
    assertEqual(testCase, data1, expected, 'AbsTol', 1e-10);


