

testCase = matlab.unittest.FunctionTestCase.fromFunction(@(x)x);

% setupOnce %#ok<*DEFNU>

    x = randn(400, 1);
    testCase.TestData.Yearly = Series(yy(2000), x);
    testCase.TestData.HalfYearly = Series(hh(2000), x);
    testCase.TestData.Quarterly = Series(qq(2000), x);
    testCase.TestData.Monthly = Series(qq(2000), x);
    testCase.TestData.Weekly = Series(ww(2000), x);
    testCase.TestData.Daily = Series(dd(2000), x);
%

%% Test Vanilla

h = gobjects(1, 0);
for n = textual.fields(testCase.TestData)
    x = testCase.TestData.(n);
    figure('visible', 'off');
    h(end+1) = histogram(x);
end

for i = 2 : numel(h)
    assertEqual(testCase, get(h(1), "BinCounts"), get(h(i), "BinCounts"));
end

close all
