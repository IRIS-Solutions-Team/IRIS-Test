
testCase = matlab.unittest.FunctionTestCase.fromFunction(@(x)x);

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


%% Test Moving Mean   

data = this.TestData.QNumeric;
x = this.TestData.QSeries;
movingData = series.moving(data, 4);
movingX = moving(x);
t = 4 : size(data, 1);
assertEqual(testCase, movingData(t, :), movingX.Data(:, :), "absTol", 1e-10);
expected = data(t, :);
for k = 1:3
    expected = expected + data(t-k,:);
end
expected = expected/4;
assertEqual(testCase, expected, movingData(t,:), "absTol", 1e-10);
data = this.TestData.MNumeric;
x = this.TestData.MSeries;
movingData = series.moving(data, 12, -11:0);
movingX = moving(x);
t = 12 : size(data, 1);
assertEqual(testCase, movingData(t, :), movingX.Data(:, :), "absTol", 1e-10);
expected = data(t, :);
for k = 1:11
    expected = expected + data(t-k,:);
end
expected = expected/12;
assertEqual(testCase, expected, movingData(t,:), "absTol", 1e-10);


%% Test Moving Sum   

data = this.TestData.QNumeric;
x = this.TestData.QSeries;
movingData = series.moving(data, 4, @auto, @sum);
movingX = moving(x, 'Function', @sum);
t = 4 : size(data, 1);
assertEqual(testCase, movingData(t, :), movingX.Data(:, :), "absTol", 1e-10);
expected = data(t, :);
for k = 1:3
    expected = expected + data(t-k,:);
end
assertEqual(testCase, expected, movingData(t,:), "absTol", 1e-10);
data = this.TestData.MNumeric;
x = this.TestData.MSeries;
movingData = series.moving(data, 12, @auto, @sum);
movingX = moving(x, 'Function', @sum);
t = 12 : size(data, 1);
assertEqual(testCase, movingData(t, :), movingX.Data(:, :), "absTol", 1e-10);
expected = data(t, :);
for k = 1:11
    expected = expected + data(t-k,:);
end
assertEqual(testCase, expected, movingData(t,:), "absTol", 1e-10);


%% Test Moving Window   

% Quarterly
data = this.TestData.QNumeric;
x = this.TestData.QSeries;
numPeriods = size(data, 1);
movingData = series.moving(data, 4, 0:5, @sum);
movingX = moving(x, 'Window', 0:5, 'Function', @sum);
t = 1 : numPeriods-5;
assertEqual(testCase, movingData(t, :), movingX.Data(:, :), "absTol", 1e-10);
expected = data(t, :);
for k = 1:5
    expected = expected + data(t+k,:);
end
assertEqual(testCase, expected, movingData(t,:), "absTol", 1e-10);
% Monthly
data = this.TestData.MNumeric;
x = this.TestData.MSeries;
numPeriods = size(data, 1);
movingData = series.moving(data, 12, -4:4, @sum);
movingX = moving(x, 'Window', -4:4, 'Function', @sum);
t = 5 : numPeriods-4;
assertEqual(testCase, movingData(t, :), movingX.Data(:, :), "absTol", 1e-10);
expected = data(t, :);
for k = 1:4
    expected = expected + data(t-k,:) + data(t+k,:);
end
assertEqual(testCase, expected, movingData(t,:), "absTol", 1e-10);


%% Test Integer Frequency   

data = rand(20, 1, 2, 3);
x = Series(ii(1), data);
errorID = '';
try
    moving(x);
catch err
    errorID = err.identifier;
end
assertNotEmpty(testCase, errorID);

y = moving(x, 'Window', -1:0);
range = x.Range(2:end);
expected = mean( [x(range-1), x(range)], 2 );
assertEqual(testCase, y(range), expected);


