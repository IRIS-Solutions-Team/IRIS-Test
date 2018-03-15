
close all

f = figure('Visible', 'Off');
ax = gobjects(1, 0);
for i = 1 : 4
    ax(end+1) = subplot(2, 2, i);
    plot(rand(10)-0.5);
    visual.hline(ax(i), -2, 'HandleVisibility=', 'On');
    visual.highlight(2:4, 'HandleVisibility=', 'On');
    v = visual.vline(4, 'Text=', 'This is 4', 'HandleVisibility=', 'On');
    visual.zeroline('HandleVisibility=', 'On');
end

%% Test Highlight 

h = findobj(f, 'Tag', 'highlight');
assert(numel(h)==4);

%% Test VLine 

v = findobj(f, 'Tag', 'vline');
assert(numel(v)==4);

%% Test VLine-Caption 

c = findobj(f, 'Tag', 'vline-caption');
assert(numel(c)==4);

%% Test ZeroLine 

z = findobj(f, 'Tag', 'zeroline');
assert(numel(z)==4);

%% Test HLine 

o = findobj(f, 'Tag', 'hline');
assert(numel(o)==4);


