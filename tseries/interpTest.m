
testCase = matlab.unittest.FunctionTestCase.fromFunction(@(x)x);

% Set up

T = 40;
data = rand(T, 1);
indexOfData = true(T, 1);
indexOfData([11:15, 22:26]') = false;
data(~indexOfData) = NaN;
pchip = griddedInterpolant(find(indexOfData), data(indexOfData), 'pchip');
linear = griddedInterpolant(find(indexOfData), data(indexOfData), 'linear');
nearest = griddedInterpolant(find(indexOfData), data(indexOfData), 'nearest');
expectedDataPchip = pchip( (1:T)' );
expectedDataLinear = linear( (1:T)' );
expectedDataNearest = nearest( (1:T)' );


%% Integer Frequency

x = Series(1, data);

xi = interp(x);
actualData = xi(:);
assertEqual(testCase, expectedDataPchip, actualData, "absTol", 1e-12);

xi = interp(x, 'Method', 'pchip');
actualData = xi(:);
assertEqual(testCase, expectedDataPchip, actualData, "absTol", 1e-12);

xi = interp(x, 'Method', 'linear');
actualData = xi(:);
assertEqual(testCase, expectedDataLinear, actualData, "absTol", 1e-12);

xi = interp(x, 'Method', 'nearest');
actualData = xi(:);
assertEqual(testCase, expectedDataNearest, actualData, "absTol", 1e-12);


%% Quarterly Frequency

x = Series(qq(2000, 1), data);

xi = interp(x);
actualData = xi(:);
assertEqual(testCase, expectedDataPchip, actualData, "absTol", 1e-12);

xi = interp(x, 'Method', 'pchip');
actualData = xi(:);
assertEqual(testCase, expectedDataPchip, actualData, "absTol", 1e-12);

xi = interp(x, 'Method', 'linear');
actualData = xi(:);
assertEqual(testCase, expectedDataLinear, actualData, "absTol", 1e-12);

xi = interp(x, 'Method', 'nearest');
actualData = xi(:);
assertEqual(testCase, expectedDataNearest, actualData, "absTol", 1e-12);


%% Daily Frequency

x = Series(dd(2000, 1, 1), data);

xi = interp(x);
actualData = xi(:);
assertEqual(testCase, expectedDataPchip, actualData, "absTol", 1e-12);

xi = interp(x, 'Method', 'pchip');
actualData = xi(:);
assertEqual(testCase, expectedDataPchip, actualData, "absTol", 1e-12);

xi = interp(x, 'Method', 'linear');
actualData = xi(:);
assertEqual(testCase, expectedDataLinear, actualData, "absTol", 1e-12);

xi = interp(x, 'Method', 'nearest');
actualData = xi(:);
assertEqual(testCase, expectedDataNearest, actualData, "absTol", 1e-12);


