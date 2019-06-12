
% Set up once

testCase = matlab.unittest.FunctionTestCase.fromFunction(@(x)x);
start = mm(2000,1);
finish = mm(2001,12);
ar = [1.5, -0.6];
order = numel(ar);
numOfPeriods = rnglen(start, finish);
numOfExtendedPeriods = numOfPeriods + order;


%% Test Scalar tseries with Numeric Exogenous

exogenous = 0;
init = rand(order, 1);
x = tseries(start-order:start-1, init);
actual = arf(x, [1, -1*ar], exogenous, start:finish);

expected = zeros(numOfExtendedPeriods, 1);
expected(1:order, 1) = init;
for t = order+1 : numOfExtendedPeriods
    for j = 1 : order
        expected(t) = expected(t) + ar(j)*expected(t-j);
    end
    expected(t) = expected(t) + exogenous;
end

assertEqual(testCase, size(actual.Data), [numOfExtendedPeriods, 1]);
assertEqual(testCase, actual.Data, expected, 'AbsTol', 1e-14);


%% Test Multivariate tseries with Numeric Exogenous

init = rand(order, 3, 2);
exogenous = 0;
x = tseries(start-order:start-1, init);
actual = arf(x, [1, -1*ar], exogenous, start:finish);

expected = zeros(numOfExtendedPeriods, 3, 2);
expected(1:order, :, :) = init;
for t = order+1 : numOfExtendedPeriods
    for j = 1 : order
        expected(t, :) = expected(t, :) + ar(j)*expected(t-j, :);
    end
    expected(t, :) = expected(t, :) + exogenous;
end

assertEqual(testCase, size(actual.Data), [numOfExtendedPeriods, 3, 2]);
assertEqual(testCase, actual.Data, expected, 'AbsTol', 1e-14);


%% Test Multivariate tseries with Exogenous tseries

init = rand(order, 3, 2);
exogenous = tseries(start, rand(numOfPeriods, 3, 2));
x = tseries(start-order:start-1, init);
actual = arf(x, [1, -1*ar], exogenous, start:finish);

expected = zeros(numOfExtendedPeriods, 3, 2);
expected(1:order, :, :) = init;
exogenousData = getData(exogenous, start-order:finish);
for t = order+1 : numOfExtendedPeriods
    for j = 1 : order
        expected(t, :) = expected(t, :) + ar(j)*expected(t-j, :);
    end
    expected(t, :) = expected(t, :) + exogenousData(t, :);
end

assertEqual(testCase, size(actual.Data), [numOfExtendedPeriods, 3, 2]);
assertEqual(testCase, actual.Data, expected, 'AbsTol', 1e-14);

