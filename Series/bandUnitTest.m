
testCase = matlab.unittest.FunctionTestCase.fromFunction(@(x)x);

d.x = Series(qq(2020,1:10), [(1:10)', (11:20)']);
d.lower = -Series(qq(2020, 1:10), @rand);
d.upper = Series(qq(2020, 1:10), @rand);


%% Test

if verLessThan('matlab', '9.6')
    
    warning('Skipping some tests in %s', mfilename('fullpath'));
    
else
    
    figure('visible', 'off');
    [h, info] = band(d.x, d.lower, d.upper);

    assertEqual(testCase, numel(h), 2);
    assertEqual(testCase, get(h(1), 'type'), 'line');
    assertEqual(testCase, get(h(2), 'type'), 'line');

    assertEqual(testCase, numel(info.BandHandles), 2);
    assertEqual(testCase, get(info.BandHandles(1), 'type'), 'patch');
    assertEqual(testCase, get(info.BandHandles(2), 'type'), 'patch');
end
