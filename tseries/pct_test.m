
testCase = matlab.unittest.FunctionTestCase.fromFunction(@(x)x);


% Set up Once
    data = rand(20, 2);
    x = tseries(qq(2000, 1), data);
    range = x.Range;
    testCase.TestData = struct( ...
        'Data', data, ...
        'TimeSeries', x, ...
        'Range', range ...
    );


%% Test Percent Change on Quarterly Series
    data = testCase.TestData.Data;
    x = testCase.TestData.TimeSeries;
    range = testCase.TestData.Range;
    y = pct(x);
    assertEqual(testCase, double(y.Range), double(range(2:end)));
    assertEqual(testCase, y.Data, 100*(data(2:end, :)./data(1:end-1, :) - 1));


%% Test Four-Period Percent Change on Quarterly Series
    data = testCase.TestData.Data;
    x = testCase.TestData.TimeSeries;
    range = testCase.TestData.Range;
    y = pct(x, -4);
    assertEqual(testCase, double(y.Range), double(range(5:end)));
    assertEqual(testCase, y.Data, 100*(data(5:end, :)./data(1:end-4, :) - 1));


%% Test Percent Change on Quarterly Series Annualized
    data = rand(20, 2);
    x = tseries(qq(2000, 1), data);
    range = testCase.TestData.Range;
    y = pct(x, -1, 'Annualize', true);
    assertEqual(testCase, double(y.Range), double(range(2:end)));
    assertEqual(testCase, y.Data, 100*((data(2:end, :)./data(1:end-1, :)).^4 - 1));

