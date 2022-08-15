
% Set up once

testCase = matlab.unittest.FunctionTestCase.fromFunction(@(x)x);
drawnow();
close all
data = rand(40, 10);
n = numel(data);
pos = randi(n, 1, ceil(n/10));
data(pos) = NaN;
figureVisible = 'Off';


%% Test spy on All Frequencies

freq = enumeration('Frequency');
freq = freq(~isnan(freq) & freq<=365);
for i = 1 : numel(freq)
    start = numeric.datecode(freq(i), 2000);
    x = tseries(start, data);
    figure('Visible', figureVisible);
    spy(x);
end
drawnow();
close all


%% Test Interpreter Option

start = qq(2001,1);
x = tseries(start, data);
names = arrayfun(@(x) sprintf('a_%g', x), 1:size(data, 2), 'UniformOutput', false);
figure( );
spy(x, 'Names', names, 'Interpreter', 'None');
try
    axesHandle = gca( );
    interpreter = get(axesHandle, 'TickLabelInterpreter');
catch
    interpreter = '';
end
if ~isempty(interpreter)
    assertEqual(testCase, lower(char(interpreter)), 'none');
end
drawnow();
close all

