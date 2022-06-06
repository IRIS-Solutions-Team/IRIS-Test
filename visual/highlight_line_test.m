


testCase = matlab.unittest.FunctionTestCase.fromFunction(@(x)x);


close all

f = figure('Visible', 'Off');
ax = gobjects(1, 0);
for i = 1 : 4
    ax(end+1) = subplot(2, 2, i);
    plot(rand(10)-0.5);
    visual.hline(ax(i), -2, 'HandleVisibility', 'On');
    visual.highlight(2:4, 'HandleVisibility', 'On');
    v = visual.vline(4, 'Text', 'This is 4', 'HandleVisibility', 'On');
    visual.zeroline('HandleVisibility', 'On');
end


%% Test Highlight 

h = findobj(f, 'Tag', 'highlight');
assertEqual(testCase, numel(h), 4);


%% Test VLine 

v = findobj(f, 'Tag', 'vline');
assertEqual(testCase, numel(v), 4);


%% Test VLine-Caption 

c = findobj(f, 'Tag', 'vline-caption');
assertEqual(testCase, numel(c), 4);


%% Test ZeroLine 

z = findobj(f, 'Tag', 'zeroline');
assertEqual(testCase, numel(z), 4);


%% Test HLine 

o = findobj(f, 'Tag', 'hline');
assertEqual(testCase, numel(o), 4);

