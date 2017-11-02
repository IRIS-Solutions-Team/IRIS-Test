
close all

f = figure('Visible', 'off');
ax = gobjects(1, 0);
for i = 1 : 4
    ax(end+1) = subplot(2, 2, i);
    yyaxis left
    plot(rand(10)-0.5);
    visual.hline(ax(i), -2);
    visual.highlight(2:4);
    visual.vline(4);
    visual.zeroline( );

    yyaxis right
    plot((1:10)-5, 'LineWidth' , 3);
end
visual.vline(ax, 6, 'Text', 'This is 6');
visual.highlight(ax, 6:8);
visual.zeroline(ax);
visual.hline(ax, 2);

%% Test Highlight 

h = findobj(f, 'Tag', 'highlight');
assert(numel(h)==8);

%% Test VLine 

v = findobj(f, 'Tag', 'vline');
assert(numel(v)==8);

%% Test VLine-Caption 

c = findobj(f, 'Tag', 'vline-caption');
assert(numel(c)==4);

%% Test ZeroLine 

z = findobj(f, 'Tag', 'zeroline');
assert(numel(z)==8);

%% Test HLine 

o = findobj(f, 'Tag', 'hline');
assert(numel(o)==8);


