function tests = movingTest( )
tests = functiontests(localfunctions( ));
end


function setupOnce(this)
    data = randn(20, 2, 3, 5);
    data = cumsum(data, 1);
    x = Series(qq(2000,1), data);
    this.TestData.QNumeric = data;
    this.TestData.QSeries = x;
    data = randn(60, 2, 3, 5);
    data = cumsum(data, 1);
    x = Series(mm(2000,1), data);
    this.TestData.MNumeric = data;
    this.TestData.MSeries = x;
end


function testMovingMean(this)
    data = this.TestData.QNumeric;
    x = this.TestData.QSeries;
    movingData = numeric.moving(data, -3:0);
    movingX = moving(x);
    t = 4 : size(data, 1);
    assertEqual(this, movingData(t, :), movingX.Data(:, :), 'AbsTol', 1e-10);
    expected = data(t, :);
    for k = 1:3
        expected = expected + data(t-k,:);
    end
    expected = expected/4;
    assertEqual(this, expected, movingData(t,:), 'AbsTol', 1e-10);
    data = this.TestData.MNumeric;
    x = this.TestData.MSeries;
    movingData = numeric.moving(data, -11:0);
    movingX = moving(x);
    t = 12 : size(data, 1);
    assertEqual(this, movingData(t, :), movingX.Data(:, :), 'AbsTol', 1e-10);
    expected = data(t, :);
    for k = 1:11
        expected = expected + data(t-k,:);
    end
    expected = expected/12;
    assertEqual(this, expected, movingData(t,:), 'AbsTol', 1e-10);
end


function testMovingSum(this)
    data = this.TestData.QNumeric;
    x = this.TestData.QSeries;
    movingData = numeric.moving(data, -3:0, @sum);
    movingX = moving(x, 'Function=', @sum);
    t = 4 : size(data, 1);
    assertEqual(this, movingData(t, :), movingX.Data(:, :), 'AbsTol', 1e-10);
    expected = data(t, :);
    for k = 1:3
        expected = expected + data(t-k,:);
    end
    expected = expected;
    assertEqual(this, expected, movingData(t,:), 'AbsTol', 1e-10);
    data = this.TestData.MNumeric;
    x = this.TestData.MSeries;
    movingData = numeric.moving(data, -11:0, @sum);
    movingX = moving(x, 'Function=', @sum);
    t = 12 : size(data, 1);
    assertEqual(this, movingData(t, :), movingX.Data(:, :), 'AbsTol', 1e-10);
    expected = data(t, :);
    for k = 1:11
        expected = expected + data(t-k,:);
    end
    expected = expected;
    assertEqual(this, expected, movingData(t,:), 'AbsTol', 1e-10);
end


function testMovingWindow(this)
    % Quarterly
    data = this.TestData.QNumeric;
    x = this.TestData.QSeries;
    numPeriods = size(data, 1);
    movingData = numeric.moving(data, 0:5, @sum);
    movingX = moving(x, 'Window=', 0:5, 'Function=', @sum);
    t = 1 : numPeriods-5;
    assertEqual(this, movingData(t, :), movingX.Data(:, :), 'AbsTol', 1e-10);
    expected = data(t, :);
    for k = 1:5
        expected = expected + data(t+k,:);
    end
    expected = expected;
    assertEqual(this, expected, movingData(t,:), 'AbsTol', 1e-10);
    % Monthly
    data = this.TestData.MNumeric;
    x = this.TestData.MSeries;
    numPeriods = size(data, 1);
    movingData = numeric.moving(data, -4:4, @sum);
    movingX = moving(x, 'Window=', -4:4, 'Function=', @sum);
    t = 5 : numPeriods-4;
    assertEqual(this, movingData(t, :), movingX.Data(:, :), 'AbsTol', 1e-10);
    expected = data(t, :);
    for k = 1:4
        expected = expected + data(t-k,:) + data(t+k,:);
    end
    expected = expected;
    assertEqual(this, expected, movingData(t,:), 'AbsTol', 1e-10);
end


