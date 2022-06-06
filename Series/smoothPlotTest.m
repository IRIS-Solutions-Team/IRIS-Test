
% Set Up Once

testCase = matlab.unittest.FunctionTestCase.fromFunction(@(x)x);
close all


%% Test Smooth Bands

x = Series(qq(2001,1):qq(2005,4), @randn);
b = Series(x.Range, [-2, -0.8, 0.8, 2]);

figure('Visible', false);
hold on
bands(x + b, 'Whitening', [0.8, 0.7]);
a1 = plot(x);
grid on

figure('Visible', false);
hold on
bands(x + b, 'Smooth', true, 'Whitening', [0.8, 0.7]);
a2 = plot(x, 'Smooth', true);
grid on

assertEqual(testCase, numel(a1.XData), 20);
assertEqual(testCase, numel(a2.XData), 10*numel(a1.XData)-1);
close all
